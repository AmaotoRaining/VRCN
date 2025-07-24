import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/models/vrcnsync_models.dart';
import 'package:vrchat/provider/vrcnsync_provider.dart';
import 'package:vrchat/theme/app_theme.dart';
import 'package:vrchat/widgets/error_container.dart';

class VrcnSyncPage extends ConsumerStatefulWidget {
  const VrcnSyncPage({super.key});

  @override
  ConsumerState<VrcnSyncPage> createState() => _VrcnSyncPageState();
}

class _VrcnSyncPageState extends ConsumerState<VrcnSyncPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeSync();
      }
    });
  }

  Future<void> _initializeSync() async {
    try {
      final notifier = ref.read(vrcnSyncStateProvider.notifier);

      final hasPermissions = await notifier.requestPermissions();
      if (!hasPermissions && mounted) {
        _showPermissionError();
        return;
      }

      // サーバー情報を更新
      await notifier.updateServerInfo();
    } catch (e) {
      debugPrint('VRCNSync初期化エラー: $e');
      if (mounted) {
        _showInitializationError(e.toString());
      }
    }
  }

  // サーバーを停止
  Future<void> stopServer() async {
    try {
      final notifier = ref.read(vrcnSyncStateProvider.notifier);
      await notifier.stopServer();
    } catch (e) {
      debugPrint('サーバー停止エラー: $e');
      _showErrorMessage('サーバーの停止に失敗しました: $e');
    }
  }

  // サーバー情報を更新
  Future<void> _refreshServerInfo() async {
    try {
      final notifier = ref.read(vrcnSyncStateProvider.notifier);
      await notifier.updateServerInfo();
    } catch (e) {
      debugPrint('サーバー情報更新エラー: $e');
    }
  }

  Future<void> _toggleServer(bool value) async {
    try {
      final notifier = ref.read(vrcnSyncStateProvider.notifier);
      await notifier.toggleServer(value);
      _showServerToggleNotification(value);
    } catch (e) {
      debugPrint('サーバー切り替えエラー: $e');
      _showErrorMessage('サーバーの切り替えに失敗しました: $e');
    }
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
          // 更新ボタン
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshServerInfo,
            tooltip: 'サーバー情報を更新',
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshServerInfo,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                      onRetry:
                          () =>
                              ref
                                  .read(vrcnSyncStateProvider.notifier)
                                  .clearError(),
                    ),
                  ),

                // サーバー情報カード（IPアドレスとポート表示）
                _buildServerInfoCard(syncStatus, isDarkMode),

                const SizedBox(height: 16),

                // サーバー制御ボタン
                _buildServerControlCard(syncStatus, isDarkMode),

                const SizedBox(height: 16),

                // 使用方法カード
                _buildUsageCard(isDarkMode),

                const SizedBox(height: 16),

                // 統計情報カード
                _buildStatsCard(syncStatus, isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // サーバー情報カード（IPアドレスとポート表示）
  Widget _buildServerInfoCard(SyncStatus status, bool isDarkMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // タイトル行
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        status.isServerRunning
                            ? Colors.green.withValues(alpha: 0.2)
                            : Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    status.isServerRunning ? Icons.wifi : Icons.wifi_off,
                    color: status.isServerRunning ? Colors.green : Colors.red,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'サーバー情報',
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        status.isServerRunning ? '実行中 - 写真受信待機' : '停止中',
                        style: GoogleFonts.notoSans(
                          fontSize: 13,
                          color:
                              status.isServerRunning
                                  ? Colors.green
                                  : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // IPアドレスとポート情報
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IPアドレス
                  Row(
                    children: [
                      const Icon(
                        Icons.computer,
                        color: AppTheme.primaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'IPアドレス',
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      status.serverIP ?? '取得中...',
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            status.serverIP != null
                                ? (isDarkMode ? Colors.white : Colors.black87)
                                : Colors.grey[600],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ポート番号
                  Row(
                    children: [
                      const Icon(
                        Icons.settings_ethernet,
                        color: AppTheme.primaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ポート番号',
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      status.serverPort?.toString() ?? '---',
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            status.serverPort != null
                                ? (isDarkMode ? Colors.white : Colors.black87)
                                : Colors.grey[600],
                      ),
                    ),
                  ),

                  // 完全なURL表示
                  if (status.serverIP != null && status.serverPort != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.link,
                          color: AppTheme.primaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'アクセスURL',
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: 0.3),
                        ),
                      ),
                      child: SelectableText(
                        'http://${status.serverIP}:${status.serverPort}',
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // PCでの使用方法
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PC版VRCNSyncでの設定',
                          style: GoogleFonts.notoSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          status.serverIP != null && status.serverPort != null
                              ? '上記のIPアドレス（${status.serverIP}）とポート（${status.serverPort}）をPC版アプリに入力してください'
                              : 'サーバーが開始されると、PC版アプリに入力するIPアドレスとポートが表示されます',
                          style: GoogleFonts.notoSans(
                            fontSize: 11,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
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
                const Icon(
                  Icons.settings,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
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

            // サーバー状態表示とスイッチ
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    status.isServerRunning
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      status.isServerRunning
                          ? Colors.green.withValues(alpha: 0.3)
                          : Colors.grey.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  // ステータスアイコン
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          status.isServerRunning
                              ? Colors.green.withValues(alpha: 0.2)
                              : Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      status.isServerRunning
                          ? Icons.play_circle_filled
                          : Icons.pause_circle_filled,
                      color:
                          status.isServerRunning
                              ? Colors.green
                              : Colors.grey[600],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // ステータステキスト
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'VRCNSyncサーバー',
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          status.isServerRunning ? '実行中 - 写真受信待機' : '停止中',
                          style: GoogleFonts.notoSans(
                            fontSize: 12,
                            color:
                                status.isServerRunning
                                    ? Colors.green
                                    : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // スイッチ
                  Transform.scale(
                    scale: 1.1,
                    child: Switch(
                      value: status.isServerRunning,
                      onChanged: (value) => _toggleServer(value),
                      activeColor: Colors.green,
                      activeTrackColor: Colors.green.withValues(alpha: 0.3),
                      inactiveThumbColor: Colors.grey[600],
                      inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
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

  // サーバー切り替え通知
  void _showServerToggleNotification(bool isStarted) {
    final message = isStarted ? 'サーバーを開始しました' : 'サーバーを停止しました';
    final color = isStarted ? Colors.green.shade600 : Colors.orange.shade600;
    final icon =
        isStarted ? Icons.play_circle_filled : Icons.pause_circle_filled;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: GoogleFonts.notoSans())),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
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
                Platform.isIOS ? 'フォトライブラリへのアクセス権限が必要です' : '必要な権限が付与されていません',
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
                const Icon(
                  Icons.analytics,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
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
            // 受信統計
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    '受信した写真',
                    '${status.receivedPhotosCount}枚',
                    Icons.photo_camera,
                    status.receivedPhotosCount > 0
                        ? Colors.purple
                        : Colors.grey,
                    isDarkMode,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    'サーバー状態',
                    status.isServerRunning ? '実行中' : '停止中',
                    status.isServerRunning ? Icons.check_circle : Icons.cancel,
                    status.isServerRunning ? Colors.green : Colors.red,
                    isDarkMode,
                  ),
                ),
              ],
            ),
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

  // 使用方法カード
  Widget _buildUsageCard(bool isDarkMode) {
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
            const SizedBox(height: 16),

            // PCでの設定手順
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.computer, color: Colors.blue, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'PC（VRChat）での設定',
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ステップ1
                  _buildUsageStep(
                    '1',
                    'PC版VRCNSyncツールを起動',
                    Icons.desktop_windows,
                    Colors.blue,
                    isDarkMode,
                  ),
                  const SizedBox(height: 8),

                  // ステップ2
                  _buildUsageStep(
                    '2',
                    '上記のIPアドレスとポートを入力',
                    Icons.settings_ethernet,
                    Colors.blue,
                    isDarkMode,
                  ),
                  const SizedBox(height: 8),

                  // ステップ3
                  _buildUsageStep(
                    '3',
                    'VRChatで写真を撮影して自動転送',
                    Icons.camera_alt,
                    Colors.blue,
                    isDarkMode,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 注意事項
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber,
                    color: Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '注意事項',
                          style: GoogleFonts.notoSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '• PC版VRCNSyncツールが必要です\n'
                          '• 同じWi-Fiネットワークに接続してください\n'
                          '• ファイアウォールで通信がブロックされていないか確認してください',
                          style: GoogleFonts.notoSans(
                            fontSize: 11,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
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

  // 使用手順のステップを構築
  Widget _buildUsageStep(
    String stepNumber,
    String description,
    IconData icon,
    Color color,
    bool isDarkMode,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ステップ番号
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
        const SizedBox(width: 10),

        // アイコン
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),

        // 説明テキスト
        Expanded(
          child: Text(
            description,
            style: GoogleFonts.notoSans(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}
