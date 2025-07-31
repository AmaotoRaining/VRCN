import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vrchat/models/vrcnsync_models.dart';
import 'package:vrchat/provider/vrcnsync_provider.dart';
import 'package:vrchat/services/photo_save_service.dart';
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
    // 安全な初期化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeSync();
      }
    });
  }

  Future<void> _initializeSync() async {
    try {
      final notifier = ref.read(vrcnSyncStateProvider.notifier);

      // 権限をリクエスト
      final hasPermissions = await notifier.requestPermissions();
      if (!hasPermissions && mounted) {
        _showPermissionError();
        return;
      }

      // サーバーを開始
      if (mounted) {
        await notifier.startServer(onPhotoReceived: _handlePhotoReceived);
      }
    } catch (e) {
      debugPrint('VRCNSync初期化エラー: $e');
      if (mounted) {
        _showInitializationError(e.toString());
      }
    }
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
                savedToAlbum ? '写真をVRCNアルバムに保存しました' : '写真を受信しました（アルバム保存に失敗）',
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

  void _showPermissionError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                Platform.isIOS ? 'フォトライブラリへのアクセス権限が必要です' : 'ストレージへのアクセス権限が必要です',
                style: GoogleFonts.notoSans(),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: const SnackBarAction(
          label: '設定を開く',
          textColor: Colors.white,
          onPressed: openAppSettings,
        ),
        duration: const Duration(seconds: 6),
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final syncStatus = ref.watch(vrcnSyncStateProvider);

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF151515) : Colors.grey[50],
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: GoogleFonts.notoSans(
              color: isDarkMode ? Colors.grey[50] : const Color(0xFF151515),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            children: [
              const TextSpan(text: 'VRCNSync'),
              TextSpan(
                text: ' (β)',
                style: TextStyle(
                  color: AppTheme.primaryColor.withValues(alpha: 0.8),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? const Color(0xFF151515) : Colors.grey[50],
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ベータ版の警告
              _buildBetaWarningCard(isDarkMode),

              const SizedBox(height: 16),

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

              // サーバーステータス
              _buildServerStatusCard(syncStatus, isDarkMode),

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

  Widget _buildBetaWarningCard(bool isDarkMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.orange.withValues(alpha: .5)),
      ),
      color:
          isDarkMode
              ? Colors.orange.withValues(alpha: 0.15)
              : Colors.orange.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.science_outlined,
              color: Colors.orange.shade700,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ベータ版機能',
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'この機能は開発中のベータ版です。予期せぬ問題が発生する可能性があります。',
                    style: GoogleFonts.notoSans(
                      fontSize: 13,
                      color:
                          isDarkMode
                              ? Colors.orange.shade300
                              : Colors.orange.shade900,
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

  Widget _buildServerStatusCard(SyncStatus status, bool isDarkMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
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
                    status.isServerRunning
                        ? Icons.circle
                        : Icons.circle_outlined,
                    color: status.isServerRunning ? Colors.green : Colors.red,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        status.isServerRunning ? 'サーバー実行中' : 'サーバー停止中',
                        style: GoogleFonts.notoSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        status.isServerRunning
                            ? 'PCからの写真をVRCNアルバムに保存します'
                            : 'サーバーが停止しています',
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (status.isServerRunning) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
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
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '受信した写真は「VRCN」アルバムに自動保存されます',
                            style: GoogleFonts.notoSans(
                              fontSize: 13,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // サーバー情報表示
                    Container(
                      padding: const EdgeInsets.all(8),
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
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'サーバー情報',
                                style: GoogleFonts.notoSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.wifi,
                                color:
                                    isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'IP: ${status.serverIP ?? "取得中..."}',
                                style: GoogleFonts.notoSans(
                                  fontSize: 11,
                                  color:
                                      isDarkMode
                                          ? Colors.grey[300]
                                          : Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.settings_ethernet,
                                color:
                                    isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'ポート: ${status.serverPort ?? "49527"}',
                                style: GoogleFonts.notoSans(
                                  fontSize: 11,
                                  color:
                                      isDarkMode
                                          ? Colors.grey[300]
                                          : Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          if (status.serverIP != null &&
                              status.serverPort != null) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'http://${status.serverIP}:${status.serverPort}',
                                style: GoogleFonts.notoSans(
                                  fontSize: 10,
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
              'PCでVRCNSyncアプリを起動',
              'PCでVRCNSyncアプリを起動してください',
              Icons.computer,
              isDarkMode,
            ),
            const SizedBox(height: 8),
            _buildUsageStep(
              '2',
              '同じWiFiネットワークに接続',
              'PC・モバイル端末を同じWiFiネットワークに接続してください',
              Icons.wifi,
              isDarkMode,
            ),
            const SizedBox(height: 8),
            _buildUsageStep(
              '3',
              '接続先にモバイル端末を指定',
              'PCアプリで上記のIPアドレスとポートを指定してください',
              Icons.settings_ethernet,
              isDarkMode,
            ),
            const SizedBox(height: 8),
            _buildUsageStep(
              '4',
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
                  '接続状況',
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
                Expanded(
                  child: _buildStatItem(
                    'サーバー状態',
                    status.isServerRunning ? '実行中' : '停止中',
                    status.isServerRunning ? Icons.check_circle : Icons.cancel,
                    status.isServerRunning ? Colors.green : Colors.red,
                    isDarkMode,
                  ),
                ),
                const SizedBox(width: 16),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.notoSans(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.notoSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
