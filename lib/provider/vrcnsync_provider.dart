import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrchat/models/vrcnsync_models.dart';
import 'package:vrchat/services/vrcnsync_background_service.dart';
import 'package:vrchat/services/vrcnsync_service.dart';

final vrcnSyncStateProvider =
    StateNotifierProvider<VrcnSyncNotifier, SyncStatus>((ref) {
      return VrcnSyncNotifier();
    });

class VrcnSyncNotifier extends StateNotifier<SyncStatus> {
  VrcnSyncNotifier() : super(const SyncStatus()) {
    _init();
  }

  late VrcnSyncService _service;
  Timer? _updateTimer;

  void _init() async {
    _service = VrcnSyncService();
    await _service.initialize();

    // バックグラウンドサービスの初期化と自動開始
    await VrcnSyncBackgroundService.initializeService();

    // 常にバックグラウンドサービスを開始
    await _startBackgroundServiceAutomatically();

    // バックグラウンドサービスからのイベントを監視
    _listenToBackgroundService();

    // 定期的にサーバー情報を更新
    _startPeriodicUpdate();
  }

  // バックグラウンドサービスを自動開始
  Future<void> _startBackgroundServiceAutomatically() async {
    try {
      final success = await VrcnSyncBackgroundService.startService();
      if (success) {
        // サービス開始後、十分な時間を待ってから情報を取得
        await Future.delayed(const Duration(seconds: 3));
        await _updateFromBackgroundService();
        debugPrint('バックグラウンドサービスが自動開始されました');
      }
    } catch (e) {
      debugPrint('バックグラウンドサービス自動開始エラー: $e');
    }
  }

  // 定期的なサーバー情報更新
  void _startPeriodicUpdate() {
    // 3秒ごとにサーバー情報を更新
    _updateTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await _updateFromBackgroundService();
    });
  }

  // バックグラウンドサービスから情報を更新（SharedPreferences削除）
  Future<void> _updateFromBackgroundService() async {
    try {
      final isRunning = await VrcnSyncBackgroundService.isServiceRunning();

      // バックグラウンドサービスから直接サーバー情報を取得
      final serverInfo = await VrcnSyncBackgroundService.getServerInfo();
      debugPrint('バックグラウンドサービスからの情報: $serverInfo');

      String? serverIP;
      int? serverPort;

      if (serverInfo != null) {
        serverIP = serverInfo['server_ip'] as String?;
        serverPort = serverInfo['server_port'] as int?;
        debugPrint('バックグラウンドから取得: IP=$serverIP, Port=$serverPort');
      }

      // 写真受信カウントのみSharedPreferencesから取得
      final prefs = await SharedPreferences.getInstance();
      final photoCount = prefs.getInt('vrcnsync_photo_count') ?? 0;

      state = state.copyWith(
        isServerRunning: isRunning,
        serverIP: serverIP,
        serverPort: serverPort,
        receivedPhotosCount: photoCount,
      );

      debugPrint('最終状態更新: Running=$isRunning, IP=$serverIP, Port=$serverPort');
    } catch (e) {
      debugPrint('バックグラウンド情報更新エラー: $e');
    }
  }

  // バックグラウンドサービスからのイベントを監視
  void _listenToBackgroundService() {
    final service = FlutterBackgroundService();

    // ハートビート監視（優先的に情報を更新）
    service.on('heartbeat').listen((event) {
      if (event is Map<String, dynamic>) {
        final serverRunning = event['server_running'] as bool? ?? false;
        final serverIP = event['server_ip'] as String?;
        final serverPort = event['server_port'] as int?;

        debugPrint('ハートビート受信データ: $event');

        // ハートビートで有効な情報が来た場合は即座に更新
        if (serverIP != null && serverPort != null) {
          state = state.copyWith(
            isServerRunning: serverRunning,
            serverIP: serverIP,
            serverPort: serverPort,
          );

          debugPrint(
            'ハートビート受信: Running=$serverRunning, IP=$serverIP, Port=$serverPort',
          );
        }
      }
    });

    // 写真受信イベント監視
    service.on('photo_received').listen((event) {
      if (event is Map<String, dynamic>) {
        final count = event['count'] as int? ?? 0;
        final timestamp = event['timestamp'] as int?;

        state = state.copyWith(
          receivedPhotosCount: count,
          lastReceived:
              timestamp != null
                  ? DateTime.fromMillisecondsSinceEpoch(timestamp)
                  : null,
        );
      }
    });
  }

  // 権限をリクエスト
  Future<bool> requestPermissions() async {
    try {
      return await _service.requestPermissions();
    } catch (e) {
      state = state.copyWith(errorMessage: '権限リクエストエラー: $e');
      return false;
    }
  }

  // サーバーを強制的に再開始
  Future<void> restartServer() async {
    try {
      state = state.copyWith(errorMessage: null);

      // バックグラウンドサービスを停止してから再開始
      await VrcnSyncBackgroundService.stopService();
      await Future.delayed(const Duration(seconds: 2));

      final success = await VrcnSyncBackgroundService.startService();
      if (success) {
        // 再開始後に情報を更新（十分な時間を待つ）
        await Future.delayed(const Duration(seconds: 3));
        await _updateFromBackgroundService();
      } else {
        state = state.copyWith(errorMessage: 'サーバーの再開始に失敗しました');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'サーバー再開始エラー: $e');
    }
  }

  // サーバーを停止（一時的）
  Future<void> stopServer() async {
    try {
      await VrcnSyncBackgroundService.stopService();
      state = state.copyWith(isServerRunning: false);
    } catch (e) {
      state = state.copyWith(errorMessage: 'サーバー停止エラー: $e');
    }
  }

  // サーバー情報を手動更新
  Future<void> updateServerInfo() async {
    try {
      // バックグラウンドサービスにも情報更新を指示
      final service = FlutterBackgroundService();
      service.invoke('update_server_info');

      // 更新指示後、十分な時間を待ってから情報を取得
      await Future.delayed(const Duration(seconds: 2));
      await _updateFromBackgroundService();

      debugPrint('手動サーバー情報更新完了');
    } catch (e) {
      debugPrint('サーバー情報更新指示エラー: $e');
    }
  }

  // 統計をリセット
  void resetStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('vrcnsync_photo_count', 0);

      final service = FlutterBackgroundService();
      service.invoke('reset_stats');

      state = state.copyWith(receivedPhotosCount: 0, lastReceived: null);
    } catch (e) {
      debugPrint('統計リセットエラー: $e');
    }
  }

  // エラーメッセージをクリア
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _service.dispose();
    super.dispose();
  }
}
