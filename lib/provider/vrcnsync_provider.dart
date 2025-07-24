import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrchat/models/vrcnsync_models.dart';
import 'package:vrchat/services/vrcnsync_background_service.dart';
import 'package:vrchat/services/vrcnsync_service.dart';

// VRCNSyncの状態を管理するプロバイダー
final vrcnSyncStateProvider =
    StateNotifierProvider<VrcnSyncNotifier, SyncStatus>((ref) {
      return VrcnSyncNotifier();
    });

class VrcnSyncNotifier extends StateNotifier<SyncStatus> {
  VrcnSyncNotifier() : super(const SyncStatus()) {
    _init();
  }

  late VrcnSyncService _service;

  void _init() async {
    _service = VrcnSyncService();

    // バックグラウンドサービスの初期化
    await VrcnSyncBackgroundService.initializeService();

    // 保存された状態を復元
    await _restoreState();

    // バックグラウンドサービスからのイベントを監視
    _listenToBackgroundService();
  }

  // 保存された状態を復元
  Future<void> _restoreState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isRunning = await VrcnSyncBackgroundService.isServiceRunning();
      final photoCount = prefs.getInt('vrcnsync_photo_count') ?? 0;

      if (isRunning) {
        // サーバー情報を更新
        await _updateServerInfo();
      }

      state = state.copyWith(
        isServerRunning: isRunning,
        receivedPhotosCount: photoCount,
      );
    } catch (e) {
      debugPrint('状態復元エラー: $e');
    }
  }

  // バックグラウンドサービスからのイベントを監視
  void _listenToBackgroundService() {
    final service = FlutterBackgroundService();

    // ハートビート監視
    service.on('heartbeat').listen((event) {
      final data = event as Map<String, dynamic>?;
      if (data != null) {
        final serverRunning = data['server_running'] as bool? ?? false;
        final serverIP = data['server_ip'] as String?;
        final serverPort = data['server_port'] as int?;

        state = state.copyWith(
          isServerRunning: serverRunning,
          serverIP: serverIP,
          serverPort: serverPort,
        );
      }
    });

    // 写真受信イベント監視
    service.on('photo_received').listen((event) {
      final data = event as Map<String, dynamic>?;
      if (data != null) {
        final count = data['count'] as int? ?? 0;
        final timestamp = data['timestamp'] as int?;

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

  // サーバーを手動で開始（バックグラウンド対応）
  Future<void> startServerManually({
    Function(File, bool)? onPhotoReceived,
  }) async {
    try {
      state = state.copyWith(errorMessage: null);

      // バックグラウンドサービスとして開始
      final success = await VrcnSyncBackgroundService.startService();

      if (success) {
        await _updateServerInfo();
        state = state.copyWith(isServerRunning: true);

        // フォアグラウンドでも写真受信コールバックを設定
        if (onPhotoReceived != null) {
          await _service.startServer(onPhotoReceived: onPhotoReceived);
        }
      } else {
        state = state.copyWith(errorMessage: 'バックグラウンドサーバーの開始に失敗しました');
      }
    } catch (e) {
      state = state.copyWith(
        isServerRunning: false,
        errorMessage: 'サーバー開始エラー: $e',
      );
    }
  }

  // サーバーを手動で停止
  Future<void> stopServerManually() async {
    try {
      await VrcnSyncBackgroundService.stopService();
      await _service.stopServer();

      state = state.copyWith(
        isServerRunning: false,
        serverIP: null,
        serverPort: null,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'サーバー停止エラー: $e');
    }
  }

  // バックグラウンドサービスから状態を復元
  Future<void> restoreBackgroundState() async {
    try {
      final isRunning = await VrcnSyncBackgroundService.isServiceRunning();
      if (isRunning) {
        // サーバー情報を更新
        await _updateServerInfo();

        // 統計情報を復元
        final prefs = await SharedPreferences.getInstance();
        final photoCount = prefs.getInt('vrcnsync_photo_count') ?? 0;

        state = state.copyWith(
          isServerRunning: true,
          receivedPhotosCount: photoCount,
        );
      }
    } catch (e) {
      debugPrint('バックグラウンド状態復元エラー: $e');
    }
  }

  // サーバー情報を更新
  Future<void> updateServerInfo() async {
    await _updateServerInfo();
  }

  Future<void> _updateServerInfo() async {
    try {
      final ip = _service.serverIPAddress;
      final port = _service.serverPort;

      state = state.copyWith(serverIP: ip, serverPort: port);
    } catch (e) {
      debugPrint('サーバー情報更新エラー: $e');
    }
  }

  // 統計をリセット
  void resetStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('vrcnsync_photo_count', 0);

      // バックグラウンドサービスにも通知
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
    _service.dispose();
    super.dispose();
  }
}
