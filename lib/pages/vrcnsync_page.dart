import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/models/vrcnsync_models.dart';
import 'package:vrchat/provider/vrcnsync_provider.dart';
import 'package:vrchat/services/photo_save_service.dart';
import 'package:vrchat/services/vrcnsync_background_service.dart';
import 'package:vrchat/theme/app_theme.dart';
import 'package:vrchat/widgets/error_container.dart';

class VrcnSyncPage extends ConsumerStatefulWidget {
  const VrcnSyncPage({super.key});

  @override
  ConsumerState<VrcnSyncPage> createState() => _VrcnSyncPageState();
}

class _VrcnSyncPageState extends ConsumerState<VrcnSyncPage>
    with TickerProviderStateMixin {
  Function(File, bool)? _photoReceivedCallback;
  var _isBackgroundMode = false;

  @override
  void initState() {
    super.initState();
    _photoReceivedCallback = _handlePhotoReceived;

    // 初期化時は自動でサーバーを開始しない
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeSync();
      }
    });
  }

  // 初期化処理（バックグラウンドサービス対応）
  Future<void> _initializeSync() async {
    try {
      final notifier = ref.read(vrcnSyncStateProvider.notifier);

      // 権限をリクエスト
      final hasPermissions = await notifier.requestPermissions();
      if (!hasPermissions && mounted) {
        _showPermissionError();
        return;
      }

      // バックグラウンドサービスの初期化
      await VrcnSyncBackgroundService.initializeService();

      // 既にバックグラウンドサービスが動いているかチェック
      final isRunning = await VrcnSyncBackgroundService.isServiceRunning();
      setState(() {
        _isBackgroundMode = isRunning;
      });

      if (isRunning) {
        // バックグラウンドサービスから状態を復元
        await notifier.restoreBackgroundState();
      }

    } catch (e) {
      debugPrint('VRCNSync初期化エラー: $e');
      if (mounted) {
        _showInitializationError(e.toString());
      }
    }
  }

  // サーバーを手動で開始（バックグラウンド対応）
  Future<void> _startServer() async {
    try {
      final notifier = ref.read(vrcnSyncStateProvider.notifier);

      if (_isBackgroundMode) {
        // バックグラウンドモードで開始
        final success = await VrcnSyncBackgroundService.startService();
        if (success) {
          await notifier.restoreBackgroundState();
          _showBackgroundModeNotification();
        } else {
          _showErrorMessage('バックグラウンドサービスの開始に失敗しました');
        }
      } else {
        // フォアグラウンドモードで開始
        await notifier.startServerManually(onPhotoReceived: _photoReceivedCallback);
      }
    } catch (e) {
      debugPrint('サーバー開始エラー: $e');
      _showErrorMessage('サーバーの開始に失敗しました: $e');
    }
  }

  // サーバーを手動で停止
  Future<void> _stopServer() async {
    try {
      final notifier = ref.read(vrcnSyncStateProvider.notifier);

      if (_isBackgroundMode) {
        // バックグラウンドサービスを停止
        await VrcnSyncBackgroundService.stopService();
      }

      // フォアグラウンドサーバーも停止
      await notifier.stopServerManually();

    } catch (e) {
      debugPrint('サーバー停止エラー: $e');
      _showErrorMessage('サーバーの停止に失敗しました: $e');
    }
  }

  // バックグラウンドモードの切り替え
  void _toggleBackgroundMode(bool value) {
    setState(() {
      _isBackgroundMode = value;
    });

    final message = value
        ? 'バックグラウンドモードを有効にしました。アプリを閉じても動作します。'
        : 'フォアグラウンドモードに切り替えました。';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.notoSans()),
        backgroundColor: Colors.blue.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _handlePhotoReceived(File file, bool savedToAlbum) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              savedToAlbum ? Icons.photo_album : Icons.photo,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                savedToAlbum
                    ? '写真をVRCNアルバムに保存しました'
                    : '写真を受信しました（アルバム保存に失敗）',
                style: GoogleFonts.notoSans(),
              ),
            ),
          ],
        ),
        backgroundColor:
            savedToAlbum ? Colors.green.shade600 : Colors.orange.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: savedToAlbum ? 'アルバムを開く' : '確認',
          textColor: Colors.white,
          onPressed: () {
            if (savedToAlbum) {
              _openVRCNAlbum();
            }
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // VRCNアルバムを開く
  Future<void> _openVRCNAlbum() async {
    try {
      await PhotoSaveService.openPhotoApp();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('フォトアプリを開けませんでした', style: GoogleFonts.notoSans()),
            backgroundColor: Colors.orange.shade600,
          ),
        );
      }
    }
  }

  void _showBackgroundModeNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.cloud_done, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'バックグラウンドサービスが開始されました。アプリを閉じても動作し続けます。',
                style: GoogleFonts.notoSans(),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _showPermissionError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                Platform.isIOS
                    ? 'フォトライブラリへのアクセス権限が必要です'
                    : '必要な権限が付与されていません',
                style: GoogleFonts.notoSans(),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showInitializationError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text('初期化に失敗しました: $error', style: GoogleFonts.notoSans()),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.notoSans()),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final syncStatus = ref.watch(vrcnSyncStateProvider);

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF151515) : Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'VRCNSync',
          style: GoogleFonts.notoSans(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // バックグラウンドモード表示
          if (_isBackgroundMode && syncStatus.isServerRunning)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cloud, color: Colors.green, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'バックグラウンド',
                    style: GoogleFonts.notoSans(
                      fontSize: 10,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // エラー表示
              if (syncStatus.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ErrorContainer(
                    message: syncStatus.errorMessage!,
                    onRetry: () => ref
                        .read(vrcnSyncStateProvider.notifier)
                        .clearError(),
                  ),
                ),

              // バックグラウンドモード設定カード
              _buildBackgroundModeCard(syncStatus, isDarkMode),

              const SizedBox(height: 16),

              // サーバーステータス
              _buildServerStatusCard(syncStatus, isDarkMode),

              const SizedBox(height: 16),

              // サーバー制御ボタン
              _buildServerControlCard(syncStatus, isDarkMode),

              const SizedBox(height: 16),

              // 使用方法カード
              _buildUsageCard(isDarkMode),

              const SizedBox(height: 16),

              // 統計情報カード
              _buildStatsCard(syncStatus, isDarkMode),

              // 下部に余白を追加
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // バックグラウンドモード設定カード
  Widget _buildBackgroundModeCard(SyncStatus status, bool isDarkMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cloud_queue,
                  color: _isBackgroundMode ? Colors.green : AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'バックグラウンド動作',
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: _isBackgroundMode,
                  onChanged: status.isServerRunning ? null : _toggleBackgroundMode,
                  activeColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (_isBackgroundMode ? Colors.green : AppTheme.primaryColor)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (_isBackgroundMode ? Colors.green : AppTheme.primaryColor)
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isBackgroundMode ? Icons.check_circle : Icons.info,
                        color: _isBackgroundMode ? Colors.green : AppTheme.primaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _isBackgroundMode ? 'バックグラウンド動作モード' : 'フォアグラウンド動作モード',
                        style: GoogleFonts.notoSans(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _isBackgroundMode ? Colors.green : AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isBackgroundMode
                        ? 'アプリを閉じても写真の受信を継続します。受信時に通知が表示されます。'
                        : 'アプリが開いている間のみ写真を受信します。',
                    style: GoogleFonts.notoSans(
                      fontSize: 11,
                      color: _isBackgroundMode ? Colors.green.shade700 : AppTheme.primaryColor,
                    ),
                  ),
                  if (status.isServerRunning && _isBackgroundMode) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '現在バックグラウンドで動作中',
                        style: GoogleFonts.notoSans(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (status.isServerRunning) ...[
              const SizedBox(height: 8),
              Text(
                'サーバー実行中はモード変更はできません',
                style: GoogleFonts.notoSans(
                  fontSize: 11,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // サーバー制御カード
  Widget _buildServerControlCard(SyncStatus status, bool isDarkMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.settings, color: AppTheme.primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'サーバー制御',
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // 開始ボタン
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: status.isServerRunning ? null : _startServer,
                    icon: Icon(
                      Icons.play_arrow,
                      color: status.isServerRunning ? Colors.grey[400] : Colors.white,
                    ),
                    label: Text(
                      '開始',
                      style: GoogleFonts.notoSans(
                        color: status.isServerRunning ? Colors.grey[400] : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: status.isServerRunning ? Colors.grey[300] : Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: status.isServerRunning ? 0 : 2,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 停止ボタン
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: status.isServerRunning ? _stopServer : null,
                    icon: Icon(
                      Icons.stop,
                      color: status.isServerRunning ? Colors.white : Colors.grey[400],
                    ),
                    label: Text(
                      '停止',
                      style: GoogleFonts.notoSans(
                        color: status.isServerRunning ? Colors.white : Colors.grey[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: status.isServerRunning ? Colors.red : Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: status.isServerRunning ? 2 : 0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppTheme.primaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _isBackgroundMode
                          ? 'バックグラウンドモードでサーバーを開始します'
                          : 'フォアグラウンドモードでサーバーを開始します',
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // サーバーステータスカードを更新（制御ボタンを削除）
  Widget _buildServerStatusCard(SyncStatus status, bool isDarkMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: status.isServerRunning
                        ? Colors.green.withValues(alpha: 0.2)
                        : Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    status.isServerRunning ? Icons.circle : Icons.circle_outlined,
                    color: status.isServerRunning ? Colors.green : Colors.red,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            status.isServerRunning ? 'サーバー実行中' : 'サーバー停止中',
                            style: GoogleFonts.notoSans(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          if (_isBackgroundMode && status.isServerRunning) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green.withValues(alpha: 0.5)),
                              ),
                              child: Text(
                                'BG',
                                style: GoogleFonts.notoSans(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        status.isServerRunning
                            ? 'PCからの写真をVRCNアルバムに保存します'
                            : 'サーバーが停止しています',
                        style: GoogleFonts.notoSans(
                          fontSize: 13,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (status.isServerRunning) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.photo_album,
                          color: AppTheme.primaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '受信した写真は「VRCN」アルバムに自動保存されます',
                            style: GoogleFonts.notoSans(
                              fontSize: 12,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // サーバー情報表示
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.computer,
                                color: AppTheme.primaryColor,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'サーバー情報',
                                style: GoogleFonts.notoSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(
                                Icons.wifi,
                                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'IP: ${status.serverIP ?? "取得中..."}',
                                  style: GoogleFonts.notoSans(
                                    fontSize: 10,
                                    color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 1),
                          Row(
                            children: [
                              Icon(
                                Icons.settings_ethernet,
                                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'ポート: ${status.serverPort ?? "---"}',
                                  style: GoogleFonts.notoSans(
                                    fontSize: 10,
                                    color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (status.serverIP != null && status.serverPort != null) ...[
                            const SizedBox(height: 3),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: SelectableText(
                                'http://${status.serverIP}:${status.serverPort}',
                                style: GoogleFonts.notoSans(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUsageCard(bool isDarkMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.help_outline,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '使用方法',
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildUsageStep(
              '1',
              'バックグラウンドモードを選択',
              'アプリを閉じても動作させる場合はバックグラウンドモードを有効にしてください',
              Icons.cloud_queue,
              isDarkMode,
            ),
            const SizedBox(height: 8),
            _buildUsageStep(
              '2',
              'サーバーを開始',
              '上記の「開始」ボタンを押してVRCNSyncサーバーを開始してください',
              Icons.play_arrow,
              isDarkMode,
            ),
            const SizedBox(height: 8),
            _buildUsageStep(
              '3',
              'PCでVRCNSyncアプリを起動',
              'デスクトップ版のVRCNSyncアプリを起動してください',
              Icons.computer,
              isDarkMode,
            ),
            const SizedBox(height: 8),
            _buildUsageStep(
              '4',
              '同じWiFiネットワークに接続',
              'PC・モバイル端末を同じWiFiネットワークに接続してください',
              Icons.wifi,
              isDarkMode,
            ),
            const SizedBox(height: 8),
            _buildUsageStep(
              '5',
              '接続先にモバイル端末を指定',
              'PCアプリで上記のIPアドレスとポートを指定してください',
              Icons.settings_ethernet,
              isDarkMode,
            ),
            const SizedBox(height: 8),
            _buildUsageStep(
              '6',
              '写真を送信',
              'PCから写真を送信すると、自動的にVRCNアルバムに保存されます',
              Icons.photo_album,
              isDarkMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageStep(
    String stepNumber,
    String title,
    String description,
    IconData icon,
    bool isDarkMode,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: GoogleFonts.notoSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Icon(icon, color: AppTheme.primaryColor, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // サーバー統計カード
  Widget _buildStatsCard(SyncStatus status, bool isDarkMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics, color: AppTheme.primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  '受信状況',
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const Spacer(),
                // 統計リセットボタン
                if (status.receivedPhotosCount > 0)
                  IconButton(
                    onPressed: () {
                      ref.read(vrcnSyncStateProvider.notifier).resetStats();
                    },
                    icon: const Icon(
                      Icons.refresh,
                      size: 18,
                      color: AppTheme.primaryColor,
                    ),
                    tooltip: '統計をリセット',
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // 上段：サーバー状態とネットワーク
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'サーバー状態',
                    status.isServerRunning ? '実行中' : '停止中',
                    status.isServerRunning ? Icons.check_circle : Icons.cancel,
                    status.isServerRunning ? Colors.green : Colors.red,
                    isDarkMode,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    'ネットワーク',
                    status.serverIP != null ? '接続済み' : '未接続',
                    status.serverIP != null ? Icons.wifi : Icons.wifi_off,
                    status.serverIP != null ? Colors.blue : Colors.grey,
                    isDarkMode,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 下段：受信統計
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    '受信した写真',
                    '${status.receivedPhotosCount}枚',
                    Icons.photo_camera,
                    status.receivedPhotosCount > 0 ? Colors.purple : Colors.grey,
                    isDarkMode,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    '動作モード',
                    _isBackgroundMode ? 'バックグラウンド' : 'フォアグラウンド',
                    _isBackgroundMode ? Icons.cloud : Icons.visibility,
                    _isBackgroundMode ? Colors.green : Colors.orange,
                    isDarkMode,
                  ),
                ),
              ],
            ),
            // IPアドレス詳細表示
            if (status.isServerRunning && status.serverIP != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppTheme.primaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '接続情報',
                          style: GoogleFonts.notoSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'IP: ${status.serverIP}',
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                    Text(
                      'ポート: ${status.serverPort}',
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      'http://${status.serverIP}:${status.serverPort}',
                      style: GoogleFonts.notoSans(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.notoSans(
              fontSize: 11,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: GoogleFonts.notoSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // 最後の受信時刻をフォーマット
}
