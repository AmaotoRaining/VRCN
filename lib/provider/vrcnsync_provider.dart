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

    // バックグラウンドサービスの初期化のみ
    await VrcnSyncBackgroundService.initializeService();

    // バックグラウンドサービスからのイベントを監視
    _listenToBackgroundService();
  }

  // バックグラウンドサービスからのイベントを監視
  void _listenToBackgroundService() {
    final service = FlutterBackgroundService();

    // ハートビート監視
    service.on('heartbeat').listen((event) {
      if (event is Map<String, dynamic>) {
        final serverRunning = event['server_running'] as bool? ?? false;
        final serverIP = event['server_ip'] as String?;
        final serverPort = event['server_port'] as int?;

        state = state.copyWith(
          isServerRunning: serverRunning,
          serverIP: serverIP,
          serverPort: serverPort,
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

  // サーバー開始
  Future<void> startServer() async {
    try {
      final success = await VrcnSyncBackgroundService.startService();
      if (success) {
        // ハートビートで状態が反映されるまで待つ
        await Future.delayed(const Duration(seconds: 3));
      } else {
        state = state.copyWith(errorMessage: 'サーバーの開始に失敗しました');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'サーバー開始エラー: $e');
    }
  }

  // サーバー停止
  Future<void> stopServer() async {
    try {
      await VrcnSyncBackgroundService.stopService();
      state = state.copyWith(
        isServerRunning: false,
        serverIP: null,
        serverPort: null,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'サーバー停止エラー: $e');
    }
  }

  // サーバーのオンオフ切り替え（スイッチ用）
  Future<void> toggleServer(bool value) async {
    if (value) {
      await VrcnSyncBackgroundService.startService();
    } else {
      await VrcnSyncBackgroundService.stopService();
      // 状態を即座に反映
      state = state.copyWith(
        isServerRunning: false,
        serverIP: null,
        serverPort: null,
      );
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
