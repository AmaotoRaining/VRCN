import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrchat/services/vrcnsync_service.dart';

class VrcnSyncBackgroundService {
  static const _isRunningKey = 'vrcnsync_running';
  static const _photoCountKey = 'vrcnsync_photo_count';

  static FlutterLocalNotificationsPlugin? _notificationsPlugin;
  static var _isInitialized = false;

  // サービスの初期化
  static Future<void> initializeService() async {
    if (_isInitialized) return;

    final service = FlutterBackgroundService();

    _notificationsPlugin = FlutterLocalNotificationsPlugin();

    const androidInitSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosInitSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _notificationsPlugin!.initialize(initSettings);

    // バックグラウンドサービスの設定
    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        autoStartOnBoot: true,
        notificationChannelId: 'vrcnsync_channel',
        initialNotificationTitle: 'VRCNSync',
        initialNotificationContent: 'バックグラウンドでサーバーが実行中です',
        foregroundServiceNotificationId: 888,
      ),
    );

    _isInitialized = true;
  }

  // サービス開始
  static Future<bool> startService() async {
    try {
      await initializeService();

      final service = FlutterBackgroundService();
      final isRunning = await service.isRunning();

      if (isRunning) {
        debugPrint('VRCNSyncサービスは既に実行中です');
        // 既に実行中でもサーバー情報を更新
        service.invoke('update_server_info');
        return true;
      }

      await service.startService();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isRunningKey, true);

      debugPrint('VRCNSyncバックグラウンドサービスを開始しました');
      return true;
    } catch (e) {
      debugPrint('バックグラウンドサービス開始エラー: $e');
      return false;
    }
  }

  // サービス停止
  static Future<void> stopService() async {
    try {
      final service = FlutterBackgroundService();
      service.invoke('stop');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isRunningKey, false);

      debugPrint('VRCNSyncバックグラウンドサービスを停止しました');
    } catch (e) {
      debugPrint('バックグラウンドサービス停止エラー: $e');
    }
  }

  // サービス実行状態の確認
  static Future<bool> isServiceRunning() async {
    try {
      final service = FlutterBackgroundService();
      return await service.isRunning();
    } catch (e) {
      debugPrint('サービス状態確認エラー: $e');
      return false;
    }
  }

  // 写真受信カウントの更新
  static Future<void> incrementPhotoCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCount = prefs.getInt(_photoCountKey) ?? 0;
      await prefs.setInt(_photoCountKey, currentCount + 1);

      final service = FlutterBackgroundService();
      service.invoke('photo_received', {
        'count': currentCount + 1,
        'timestamp': DateTime.timestamp().millisecondsSinceEpoch,
      });
    } catch (e) {
      debugPrint('写真カウント更新エラー: $e');
    }
  }

  // 写真受信通知の表示
  static Future<void> showPhotoReceivedNotification(String filename) async {
    if (_notificationsPlugin == null) return;

    try {
      const androidDetails = AndroidNotificationDetails(
        'vrcnsync_photos',
        'VRCNSync Photos',
        channelDescription: 'VRCNSyncで受信した写真の通知',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin!.show(
        DateTime.timestamp().millisecondsSinceEpoch.remainder(100000),
        'VRCNSync',
        '写真を受信しました: $filename',
        notificationDetails,
      );
    } catch (e) {
      debugPrint('通知表示エラー: $e');
    }
  }

  // サーバー情報を取得（タイムアウトとリトライを追加）
  static Future<Map<String, dynamic>?> getServerInfo() async {
    try {
      final service = FlutterBackgroundService();

      // 複数回試行
      for (var attempt = 0; attempt < 3; attempt++) {
        final completer = Completer<Map<String, dynamic>?>();

        // リスナーを一時的に設定
        late StreamSubscription subscription;
        subscription = service.on('server_info_response').listen((event) {
          subscription.cancel();
          debugPrint('サーバー情報レスポンス受信 (試行${attempt + 1}): $event');
          if (event is Map<String, dynamic>) {
            completer.complete(event);
          } else {
            completer.complete(null);
          }
        });

        // タイムアウト設定（試行ごとに短くする）
        Timer(Duration(seconds: 2 + attempt), () {
          if (!completer.isCompleted) {
            subscription.cancel();
            debugPrint('サーバー情報取得タイムアウト (試行${attempt + 1})');
            completer.complete(null);
          }
        });

        // サーバー情報をリクエスト
        debugPrint('サーバー情報リクエスト送信 (試行${attempt + 1})');
        service.invoke('get_server_info');

        final result = await completer.future;
        if (result != null) {
          debugPrint('サーバー情報取得成功: $result');
          return result;
        }

        // 失敗した場合は少し待ってから次の試行
        if (attempt < 2) {
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      debugPrint('すべての試行が失敗しました');
      return null;
    } catch (e) {
      debugPrint('サーバー情報取得エラー: $e');
      return null;
    }
  }

  // メインサービス関数
  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    debugPrint('VRCNSyncバックグラウンドサービスが開始されました');

    VrcnSyncService? syncService;
    Timer? heartbeatTimer;

    try {
      syncService = VrcnSyncService();
      await syncService.initialize();

      debugPrint('初期化後のサーバー情報: ${syncService.getCurrentServerInfo()}');

      // サーバーの開始
      final success = await syncService.startServer(
        onPhotoReceived: (file, savedToAlbum) async {
          await incrementPhotoCount();
          await showPhotoReceivedNotification(file.path.split('/').last);

          debugPrint('バックグラウンドで写真を受信: ${file.path} (アルバム保存: $savedToAlbum)');
        },
      );

      if (!success) {
        debugPrint('バックグラウンドでサーバー開始に失敗');
        await service.stopSelf();
        return;
      }

      debugPrint('サーバー開始後のサーバー情報: ${syncService.getCurrentServerInfo()}');

      // 通知を更新
      await _updateForegroundNotification(syncService);

      // ハートビートタイマー（より頻繁に送信）
      heartbeatTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        final serverInfo = syncService?.getCurrentServerInfo();
        debugPrint('ハートビート送信: $serverInfo');

        service.invoke('heartbeat', {
          'timestamp': DateTime.timestamp().millisecondsSinceEpoch,
          'server_running': syncService?.isServerRunning ?? false,
          'server_ip': syncService?.serverIPAddress,
          'server_port': syncService?.serverPort,
        });
      });

      // 即座にハートビートを送信
      final initialInfo = syncService.getCurrentServerInfo();
      debugPrint('初期ハートビート送信: $initialInfo');

      service.invoke('heartbeat', {
        'timestamp': DateTime.timestamp().millisecondsSinceEpoch,
        'server_running': syncService.isServerRunning,
        'server_ip': syncService.serverIPAddress,
        'server_port': syncService.serverPort,
      });

      // サービス停止リクエストの監視
      service.on('stop').listen((event) async {
        debugPrint('VRCNSyncサービス停止要求を受信');
        heartbeatTimer?.cancel();
        await syncService?.stopServer();
        await service.stopSelf();
      });

      // サーバー情報更新要求の監視
      service.on('update_server_info').listen((event) async {
        debugPrint('サーバー情報更新要求を受信');
        await syncService?.updateServerInfo();
        await _updateForegroundNotification(syncService!);

        // 更新後のハートビートを送信
        final updatedInfo = syncService.getCurrentServerInfo();
        debugPrint('更新後ハートビート送信: $updatedInfo');

        service.invoke('heartbeat', {
          'timestamp': DateTime.timestamp().millisecondsSinceEpoch,
          'server_running': syncService.isServerRunning,
          'server_ip': syncService.serverIPAddress,
          'server_port': syncService.serverPort,
        });
      });

      // サーバー情報取得要求の監視（レスポンスを確実に送信）
      service.on('get_server_info').listen((event) async {
        debugPrint('サーバー情報取得要求を受信');

        // 最新情報を取得してから返す
        await syncService?.updateServerInfo();

        final responseInfo = {
          'server_running': syncService?.isServerRunning ?? false,
          'server_ip': syncService?.serverIPAddress,
          'server_port': syncService?.serverPort,
          'timestamp': DateTime.timestamp().millisecondsSinceEpoch,
        };

        debugPrint('サーバー情報レスポンス送信: $responseInfo');

        // レスポンスを確実に送信するため、少し遅延を入れる
        await Future.delayed(const Duration(milliseconds: 100));
        service.invoke('server_info_response', responseInfo);

        // 念のため、もう一度送信
        await Future.delayed(const Duration(milliseconds: 100));
        service.invoke('server_info_response', responseInfo);
      });

      // 統計リセット要求の監視
      service.on('reset_stats').listen((event) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_photoCountKey, 0);
        debugPrint('VRCNSync統計をリセットしました');
      });

      debugPrint('VRCNSyncバックグラウンドサービス: 初期化完了');
      debugPrint(
        'サーバー情報: IP=${syncService.serverIPAddress}, Port=${syncService.serverPort}',
      );
    } catch (e) {
      debugPrint('VRCNSyncバックグラウンドサービスエラー: $e');
      heartbeatTimer?.cancel();
      await syncService?.stopServer();
      await service.stopSelf();
    }
  }

  // フォアグラウンド通知の更新
  static Future<void> _updateForegroundNotification(
    VrcnSyncService syncService,
  ) async {
    if (Platform.isAndroid) {
      try {
        final service = FlutterBackgroundService();
        final ip = syncService.serverIPAddress ?? '取得中...';
        final port = syncService.serverPort ?? 0;

        service.invoke('setAsForeground', {
          'title': 'VRCNSync - 常時実行中',
          'content': 'サーバー: $ip:$port\n写真受信待機中',
        });

        debugPrint('フォアグラウンド通知を更新: $ip:$port');
      } catch (e) {
        debugPrint('フォアグラウンド通知更新エラー: $e');
      }
    }
  }

  // iOS用バックグラウンド処理
  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    debugPrint('VRCNSync iOS バックグラウンド処理');
    return true;
  }
}
