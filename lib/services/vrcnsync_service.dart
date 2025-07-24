import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:nsd/nsd.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vrchat/models/vrcnsync_models.dart';
import 'package:vrchat/services/photo_save_service.dart';

final vrcnSyncServiceProvider = Provider<VrcnSyncService>((ref) {
  return VrcnSyncService();
});

@pragma('vm:entry-point')
class VrcnSyncService {
  HttpServer? _server;
  Registration? _bonjourService;
  final StreamController<List<DeviceInfo>> _devicesController =
      StreamController.broadcast();
  var _isServerRunning = false;
  String? _myIPAddress;
  int? _serverPort;

  Stream<List<DeviceInfo>> get devicesStream => _devicesController.stream;
  bool get isServerRunning => _isServerRunning;
  String? get serverIPAddress => _myIPAddress;
  int? get serverPort => _serverPort;

  // 初期化
  @pragma('vm:entry-point')
  Future<void> initialize() async {
    // 初期化時にIPアドレスを取得
    await _getMyIPAddress();
    debugPrint(
      '初期化完了: IP=$_myIPAddress, Port=$_serverPort, Running=$_isServerRunning',
    );
  }

  // 現在のサーバー情報を取得（デバッグ用）
  @pragma('vm:entry-point')
  Map<String, dynamic> getCurrentServerInfo() {
    return {
      'server_ip': _myIPAddress,
      'server_port': _serverPort,
      'server_running': _isServerRunning,
    };
  }

  // サーバー情報を更新（外部から呼び出し可能）
  @pragma('vm:entry-point')
  Future<void> updateServerInfo() async {
    await _getMyIPAddress();
    debugPrint('サーバー情報更新完了: IP=$_myIPAddress, Port=$_serverPort');
  }

  // 権限のリクエスト
  Future<bool> requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        final permissions = <Permission>[];
        permissions.addAll([Permission.storage]);

        // Android 13以降では写真権限を使用
        if (Platform.version.contains('API 33') ||
            Platform.version.contains('API 34')) {
          permissions.add(Permission.photos);
        }

        final statuses = await permissions.request();
        return statuses.values.every(
          (status) => status.isGranted || status.isLimited,
        );
      } else if (Platform.isIOS) {
        final permissions = [Permission.photosAddOnly];
        final statuses = await permissions.request();
        return statuses.values.every(
          (status) => status.isGranted || status.isLimited,
        );
      }
      return true;
    } catch (e) {
      debugPrint('権限リクエストエラー: $e');
      return true;
    }
  }

  // HTTPサーバーの開始（バックグラウンド専用）
  Future<bool> startServer({Function(File, bool)? onPhotoReceived}) async {
    try {
      if (_server != null) {
        await stopServer();
      }

      // IPアドレスを先に取得
      await _getMyIPAddress();
      if (_myIPAddress == null) {
        debugPrint('IPアドレスの取得に失敗しました');
        return false;
      }

      // 利用可能なポートを見つける
      var port = 49527;
      HttpServer? server;

      for (var attempt = 0; attempt < 10; attempt++) {
        try {
          server = await HttpServer.bind(
            InternetAddress.anyIPv4,
            port + attempt,
            shared: true,
          );
          port = port + attempt;
          break;
        } catch (e) {
          debugPrint('ポート ${port + attempt} は使用中: $e');
          continue;
        }
      }

      if (server == null) {
        debugPrint('利用可能なポートが見つかりません');
        return false;
      }

      _server = server;
      _serverPort = port;
      _isServerRunning = true;

      _server!.listen((request) async {
        await _handleRequest(request, onPhotoReceived);
      });

      // Bonjourサービスを公開
      await _startBonjourService();

      debugPrint('VRCNSyncサーバーがポート$portで開始されました');
      debugPrint('最終確認 - IP: $_myIPAddress, Port: $_serverPort');

      return true;
    } catch (e) {
      debugPrint('サーバー開始エラー: $e');
      _isServerRunning = false;
      _serverPort = null;
      return false;
    }
  }

  // Bonjourサービスの開始
  Future<void> _startBonjourService() async {
    try {
      if (_serverPort == null) {
        debugPrint('Bonjourサービス開始失敗: ポートがnullです');
        return;
      }

      String deviceName;
      if (Platform.isIOS) {
        deviceName = 'VRCN-iOS';
      } else if (Platform.isAndroid) {
        deviceName = 'VRCN-Android';
      } else {
        deviceName = 'VRCN';
      }

      final uniqueId = DateTime.timestamp().millisecondsSinceEpoch % 10000;
      deviceName = '$deviceName-$uniqueId';

      final txtRecords = <String, Uint8List?>{
        'version': _stringToUint8List('1.0.0'),
        'platform': _stringToUint8List(Platform.operatingSystem),
        'capabilities': _stringToUint8List('photo_receive'),
        'device_type': _stringToUint8List('mobile'),
        'app': _stringToUint8List('VRCN'),
        'background': _stringToUint8List('true'), // バックグラウンド動作を明示
        'server_ip': _stringToUint8List(_myIPAddress ?? ''),
        'server_port': _stringToUint8List(_serverPort.toString()),
      };

      final service = Service(
        name: deviceName,
        type: '_vrcnsync._tcp',
        port: _serverPort!,
        txt: txtRecords,
      );

      _bonjourService = await register(service);
      debugPrint(
        'Bonjourサービスを公開しました: $deviceName (IP: $_myIPAddress, ポート: $_serverPort)',
      );
    } catch (e) {
      debugPrint('Bonjour公開エラー: $e');
    }
  }

  // 文字列をUint8Listに変換
  Uint8List _stringToUint8List(String str) {
    return Uint8List.fromList(utf8.encode(str));
  }

  // Bonjourサービスの停止
  Future<void> _stopBonjourService() async {
    try {
      if (_bonjourService != null) {
        await unregister(_bonjourService!);
        _bonjourService = null;
        debugPrint('Bonjourサービスを停止しました');
      }
    } catch (e) {
      debugPrint('Bonjour停止エラー: $e');
    }
  }

  // IPアドレスを取得（複数の方法を試行）
  Future<void> _getMyIPAddress() async {
    String? ipAddress;

    try {
      final info = NetworkInfo();
      ipAddress = await info.getWifiIP();
      debugPrint('NetworkInfoPlus結果: $ipAddress');

      _myIPAddress = ipAddress;
      debugPrint('最終IPアドレス: $_myIPAddress');
    } catch (e) {
      debugPrint('IPアドレス取得エラー: $e');
      _myIPAddress = null;
    }
  }

  // HTTPサーバーの停止
  Future<void> stopServer() async {
    try {
      await _stopBonjourService();
      await _server?.close(force: true);
      _server = null;
      _isServerRunning = false;

      debugPrint('VRCNSyncサーバーが停止されました');
    } catch (e) {
      debugPrint('サーバー停止エラー: $e');
    }
  }

  // HTTPリクエストの処理
  Future<void> _handleRequest(
    HttpRequest request,
    Function(File, bool)? onPhotoReceived,
  ) async {
    try {
      // CORS設定
      request.response.headers.set('Access-Control-Allow-Origin', '*');
      request.response.headers.set(
        'Access-Control-Allow-Methods',
        'GET, POST, OPTIONS',
      );
      request.response.headers.set(
        'Access-Control-Allow-Headers',
        'Content-Type',
      );

      switch (request.method) {
        case 'OPTIONS':
          request.response.statusCode = HttpStatus.ok;
          await request.response.close();

        case 'GET':
          if (request.uri.path == '/ping') {
            await _handlePing(request);
          } else {
            request.response.statusCode = HttpStatus.notFound;
            await request.response.close();
          }

        case 'POST':
          if (request.uri.path == '/photo') {
            await _handlePhotoUpload(request, onPhotoReceived);
          } else {
            request.response.statusCode = HttpStatus.notFound;
            await request.response.close();
          }

        default:
          request.response.statusCode = HttpStatus.methodNotAllowed;
          await request.response.close();
      }
    } catch (e) {
      debugPrint('リクエスト処理エラー: $e');
      try {
        request.response.statusCode = HttpStatus.internalServerError;
        await request.response.close();
      } catch (_) {
        // エラーレスポンス送信に失敗してもクラッシュを防ぐ
      }
    }
  }

  // Pingリクエストの処理
  Future<void> _handlePing(HttpRequest request) async {
    try {
      final response = {
        'service': 'vrcnsync',
        'name': 'VRCN',
        'version': '1.0.0',
        'platform': Platform.operatingSystem,
        'capabilities': ['photo_receive'],
        'device_type': 'mobile',
        'background_mode': true, // バックグラウンド動作を明示
        'server_ip': _myIPAddress,
        'server_port': _serverPort,
      };

      request.response
        ..headers.contentType = ContentType.json
        ..write(jsonEncode(response));
      await request.response.close();
    } catch (e) {
      debugPrint('Ping処理エラー: $e');
    }
  }

  // 写真アップロードの処理
  Future<void> _handlePhotoUpload(
    HttpRequest request,
    Function(File, bool)? onPhotoReceived,
  ) async {
    try {
      final bytes = await request.fold<List<int>>(
        [],
        (previous, element) => previous..addAll(element),
      );

      if (bytes.isEmpty) {
        request.response.statusCode = HttpStatus.badRequest;
        request.response.write('No data received');
        await request.response.close();
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = 'vrcnsync_temp_$timestamp.jpg';
      final tempFile = File(path.join(tempDir.path, filename));

      await tempFile.writeAsBytes(bytes);
      debugPrint('一時ファイルに写真を保存: ${tempFile.path}');

      // VRCNアルバムに保存
      final savedToAlbum = await PhotoSaveService.saveReceivedPhotoToAlbum(
        tempFile,
      );

      if (savedToAlbum) {
        debugPrint('写真をVRCNアルバムに保存しました');
        onPhotoReceived?.call(tempFile, true);

        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(
            jsonEncode({
              'status': 'success',
              'message': 'Photo saved to VRCN album',
              'filename': filename,
              'saved_to_album': true,
              'background_mode': true,
            }),
          );
      } else {
        debugPrint('VRCNアルバムへの保存に失敗、一時ファイルとして保存');
        onPhotoReceived?.call(tempFile, false);

        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(
            jsonEncode({
              'status': 'success',
              'message': 'Photo received but not saved to album',
              'filename': filename,
              'saved_to_album': false,
              'background_mode': true,
            }),
          );
      }

      await request.response.close();
    } catch (e) {
      debugPrint('写真アップロード処理エラー: $e');
      try {
        request.response.statusCode = HttpStatus.internalServerError;
        request.response.write('Upload failed: $e');
        await request.response.close();
      } catch (_) {
        // エラーレスポンス送信に失敗してもクラッシュを防ぐ
      }
    }
  }

  void dispose() {
    try {
      _devicesController.close();
      stopServer();
    } catch (e) {
      debugPrint('dispose処理エラー: $e');
    }
  }
}
