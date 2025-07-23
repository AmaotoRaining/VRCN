import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_info_plus/network_info_plus.dart';
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
  final StreamController<List<DeviceInfo>> _devicesController =
      StreamController.broadcast();
  final List<DeviceInfo> _discoveredDevices = [];
  var _isServerRunning = false;
  String? _myIPAddress; // 自分のIPアドレスを保存

  Stream<List<DeviceInfo>> get devicesStream => _devicesController.stream;
  bool get isServerRunning => _isServerRunning;

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

      // iOSでは利用可能なポートを動的に見つける
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
      _isServerRunning = true;

      _server!.listen((request) async {
        await _handleRequest(request, onPhotoReceived);
      });

      debugPrint('VRCNSyncサーバーがポート$portで開始されました');
      debugPrint('自分のIPアドレス: $_myIPAddress');
      return true;
    } catch (e) {
      debugPrint('サーバー開始エラー: $e');
      _isServerRunning = false;
      return false;
    }
  }

  // 自分のIPアドレスを取得
  Future<void> _getMyIPAddress() async {
    try {
      final info = NetworkInfo();
      _myIPAddress = await info.getWifiIP();
      debugPrint('自分のIPアドレスを取得: $_myIPAddress');
    } catch (e) {
      debugPrint('IPアドレス取得エラー: $e');
      _myIPAddress = null;
    }
  }

  // HTTPサーバーの停止
  Future<void> stopServer() async {
    try {
      await _server?.close(force: true);
      _server = null;
      _isServerRunning = false;
      debugPrint('VRCNSyncサーバーが停止されました');
    } catch (e) {
      debugPrint('サーバー停止エラー: $e');
    }
  }

  // デバイス検索の開始
  Future<void> startDiscovery() async {
    try {
      _discoveredDevices.clear();

      // 自分のIPアドレスを更新
      await _getMyIPAddress();

      // iOSではmDNSライブラリが不安定なため、HTTPスキャンのみ使用
      if (Platform.isIOS) {
        await _scanLocalNetwork();
      } else {
        // Androidでは両方試行
        await _scanLocalNetwork();
        // mDNSスキャンは除外（ライブラリが不安定）
      }
    } catch (e) {
      debugPrint('デバイス検索エラー: $e');
    }
  }

  // ローカルネットワークスキャン
  Future<void> _scanLocalNetwork() async {
    try {
      final info = NetworkInfo();
      final wifiIP = await info.getWifiIP();
      if (wifiIP == null) {
        debugPrint('WiFi IPアドレスを取得できません');
        return;
      }

      final subnet = wifiIP.substring(0, wifiIP.lastIndexOf('.'));
      debugPrint('ネットワークスキャン開始: $subnet.x');
      debugPrint('自分のIP: $wifiIP をスキップします');

      // 同時接続数を制限してiOSでの安定性を向上
      final maxConcurrent = Platform.isIOS ? 5 : 20;

      for (var i = 1; i <= 254; i += maxConcurrent) {
        final futures = <Future>[];
        final endIndex = (i + maxConcurrent - 1).clamp(1, 254);

        for (var j = i; j <= endIndex; j++) {
          final ip = '$subnet.$j';

          // 自分のIPアドレスはスキップ
          if (ip == _myIPAddress || ip == wifiIP) {
            debugPrint('自分のIPアドレス $ip をスキップしました');
            continue;
          }

          futures.add(_checkDevice(ip, 49527));
        }

        await Future.wait(futures);

        // iOSでは少し待機
        if (Platform.isIOS) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }
    } catch (e) {
      debugPrint('ローカルネットワークスキャンエラー: $e');
    }
  }

  // 特定のIPアドレスでVRCNSyncサービスをチェック
  Future<void> _checkDevice(String ip, int port) async {
    try {
      // 自分のIPアドレスとの二重チェック
      if (ip == _myIPAddress) {
        return;
      }

      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 1);

      final request = await client.getUrl(Uri.parse('http://$ip:$port/ping'));
      request.headers.set('User-Agent', 'VRCN-Mobile');

      final response = await request.close().timeout(
        const Duration(seconds: 2),
      );

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = jsonDecode(responseBody);

        if (data['service'] == 'vrcnsync') {
          // 自分自身のサービスかチェック（プラットフォームとnameで判断）
          final devicePlatform = data['platform'] as String?;
          final deviceName = data['name'] as String?;

          // モバイルプラットフォーム（android/ios）で名前がVRCNの場合は自分自身
          if ((devicePlatform == 'android' || devicePlatform == 'ios') &&
              deviceName == 'VRCN') {
            debugPrint('自分自身のサービス $ip:$port を検出したため除外しました');
            return;
          }

          final device = DeviceInfo(
            name: deviceName ?? 'VRCNSync Device',
            ip: ip,
            port: port,
            type: 'http',
          );

          if (!_discoveredDevices.any((d) => d.ip == device.ip)) {
            _discoveredDevices.add(device);
            _devicesController.add(List.from(_discoveredDevices));
            debugPrint(
              'デバイス発見: ${device.name} (${device.ip}) - ${devicePlatform ?? 'unknown'}',
            );
          }
        }
      }

      client.close();
    } catch (e) {
      // タイムアウトや接続エラーは正常（デバイスがない）
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
      final savedToAlbum = await PhotoSaveService.saveReceivedPhotoToAlbum(tempFile);

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
