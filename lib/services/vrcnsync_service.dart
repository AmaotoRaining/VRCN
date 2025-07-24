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

class VrcnSyncService {
  HttpServer? _server;
  Registration? _bonjourService; // Bonjourサービス登録
  final StreamController<List<DeviceInfo>> _devicesController =
      StreamController.broadcast();
  var _isServerRunning = false;
  String? _myIPAddress; // 自分のIPアドレスを保存
  int? _serverPort; // サーバーのポート番号を保存

  Stream<List<DeviceInfo>> get devicesStream => _devicesController.stream;
  bool get isServerRunning => _isServerRunning;
  String? get serverIPAddress => _myIPAddress; // IPアドレスを取得
  int? get serverPort => _serverPort; // ポート番号を取得

  // 権限のリクエスト
  Future<bool> requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        final permissions = <Permission>[];

        // 基本的な権限
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
        // iOSでは写真ライブラリの追加権限のみ
        final permissions = [Permission.photosAddOnly];

        final statuses = await permissions.request();
        return statuses.values.every(
          (status) => status.isGranted || status.isLimited,
        );
      }
      return true;
    } catch (e) {
      debugPrint('権限リクエストエラー: $e');
      // 権限エラーでもアプリがクラッシュしないように
      return true;
    }
  }

  // HTTPサーバーの開始
  Future<bool> startServer({Function(File, bool)? onPhotoReceived}) async {
    try {
      if (_server != null) {
        await stopServer();
      }

      // 自分のIPアドレスを取得して保存
      await _getMyIPAddress();

      // 利用可能なポートを動的に見つける
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
      _serverPort = port; // ポート番号を保存
      _isServerRunning = true;

      _server!.listen((request) async {
        await _handleRequest(request, onPhotoReceived);
      });

      // Bonjourサービスを公開
      await _startBonjourService();

      debugPrint('VRCNSyncサーバーがポート$portで開始されました');
      debugPrint('自分のIPアドレス: $_myIPAddress');
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
      if (_serverPort == null) return;

      // デバイス名を生成（iOS/Android + デバイス情報）
      String deviceName;
      if (Platform.isIOS) {
        deviceName = 'VRCN-iOS';
      } else if (Platform.isAndroid) {
        deviceName = 'VRCN-Android';
      } else {
        deviceName = 'VRCN';
      }

      // 一意性を保つためにランダムな識別子を追加
      final uniqueId = DateTime.now().millisecondsSinceEpoch % 10000;
      deviceName = '$deviceName-$uniqueId';

      // TXTレコードをUint8Listに変換
      final txtRecords = <String, Uint8List?>{
        'version': _stringToUint8List('1.0.0'),
        'platform': _stringToUint8List(Platform.operatingSystem),
        'capabilities': _stringToUint8List('photo_receive'),
        'device_type': _stringToUint8List('mobile'),
        'app': _stringToUint8List('VRCN'),
      };

      // Bonjourサービスを登録
      final service = Service(
        name: deviceName,
        type: '_vrcnsync._tcp',
        port: _serverPort!,
        txt: txtRecords,
      );

      _bonjourService = await register(service);
      debugPrint('Bonjourサービスを公開しました: $deviceName (ポート: $_serverPort)');
    } catch (e) {
      debugPrint('Bonjour公開エラー: $e');
      // Bonjourが失敗してもサーバーは動作させる
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

  // 自分のIPアドレスを取得
  Future<void> _getMyIPAddress() async {
    try {
      // NetworkInfoPlusを使用
      final info = NetworkInfo();
      String? wifiIP = await info.getWifiIP();

      if (wifiIP == null || wifiIP.isEmpty) {
        // フォールバック: ソケット接続でIPを取得
        try {
          final socket = await Socket.connect('8.8.8.8', 80);
          wifiIP = socket.address.address;
          socket.destroy();
        } catch (e) {
          debugPrint('フォールバックIP取得エラー: $e');
        }
      }

      _myIPAddress = wifiIP;
      debugPrint('自分のIPアドレスを取得: $_myIPAddress');
    } catch (e) {
      debugPrint('IPアドレス取得エラー: $e');
      _myIPAddress = null;
    }
  }

  // HTTPサーバーの停止
  Future<void> stopServer() async {
    try {
      // Bonjourサービスを先に停止
      await _stopBonjourService();

      await _server?.close(force: true);
      _server = null;
      _isServerRunning = false;
      _serverPort = null; // ポート番号をクリア
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
          // CORS プリフライトリクエスト
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
        // レスポンス送信でエラーが発生してもクラッシュを防ぐ
      }
    }
  }

  // Pingリクエストの処理
  Future<void> _handlePing(HttpRequest request) async {
    try {
      final response = {
        'service': 'vrcnsync',
        'name': 'VRCN', // モバイル版を示す名前
        'version': '1.0.0',
        'platform': Platform.operatingSystem, // 'android' または 'ios'
        'capabilities': ['photo_receive'],
        'device_type': 'mobile', // モバイルデバイスであることを明示
      };

      request.response
        ..headers.contentType = ContentType.json
        ..write(jsonEncode(response));
      await request.response.close();
    } catch (e) {
      debugPrint('Ping処理エラー: $e');
    }
  }

  // 写真アップロードの処理（VRCNアルバム保存対応）
  Future<void> _handlePhotoUpload(
    HttpRequest request,
    Function(File, bool)? onPhotoReceived,
  ) async {
    try {
      // リクエストボディを読み取り
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

      // 一時ディレクトリに保存
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

        // コールバックを実行（アルバム保存成功を通知）
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
            }),
          );
      } else {
        // アルバム保存に失敗した場合は一時ファイルとして保持
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
