import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // エラー表示
              if (syncStatus.errorMessage != null)
                ErrorContainer(
                  message: syncStatus.errorMessage!,
                  onRetry:
                      () =>
                          ref.read(vrcnSyncStateProvider.notifier).clearError(),
                ),

              // サーバーステータス
              _buildServerStatusCard(syncStatus, isDarkMode),

              const SizedBox(height: 16),

              // スキャンボタン
              _buildScanButton(syncStatus, isDarkMode),

              const SizedBox(height: 16),

              // デバイスリスト
              Expanded(child: _buildDevicesList(syncStatus, isDarkMode)),
            ],
          ),
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
                        Icon(
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
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppTheme.primaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            Platform.isIOS ? 'ポート自動選択で待機中' : 'ポート 49527 で待機中',
                            style: GoogleFonts.notoSans(
                              fontSize: 11,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildScanButton(SyncStatus status, bool isDarkMode) {
    return ElevatedButton.icon(
      onPressed:
          status.isScanning
              ? null
              : () {
                if (mounted) {
                  ref.read(vrcnSyncStateProvider.notifier).startDiscovery();
                }
              },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      icon:
          status.isScanning
              ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
              : const Icon(Icons.search, size: 20),
      label: Text(
        status.isScanning ? 'デバイスを検索中...' : 'デバイスを検索',
        style: GoogleFonts.notoSans(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildDevicesList(SyncStatus status, bool isDarkMode) {
    if (status.devices.isEmpty && !status.isScanning) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.devices_other,
                size: 64,
                color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'デバイスが見つかりません',
                style: GoogleFonts.notoSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                Platform.isIOS
                    ? 'PCでVRCNSyncアプリを起動してから\n検索ボタンを押してください'
                    : 'PCでVRCNSyncアプリを起動してから\n検索ボタンを押してください\n\n※同じWiFiネットワークに接続している必要があります',
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.devices,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '検出されたデバイス',
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const Spacer(),
                if (status.devices.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${status.devices.length}',
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: status.devices.length,
              separatorBuilder:
                  (context, index) => Divider(
                    height: 1,
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                    indent: 16,
                    endIndent: 16,
                  ),
              itemBuilder: (context, index) {
                final device = status.devices[index];
                return _buildDeviceListItem(device, isDarkMode);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceListItem(DeviceInfo device, bool isDarkMode) {
    IconData deviceIcon;
    Color iconColor;

    switch (device.type) {
      case 'mdns':
        deviceIcon = Icons.wifi;
        iconColor = Colors.blue;
      case 'http':
        deviceIcon = Icons.desktop_windows;
        iconColor = Colors.green;
      default:
        deviceIcon = Icons.device_unknown;
        iconColor = Colors.grey;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(deviceIcon, color: iconColor, size: 24),
      ),
      title: Text(
        device.name,
        style: GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            '${device.ip}:${device.port}',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              device.type.toUpperCase(),
              style: GoogleFonts.notoSans(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
      trailing: const Icon(Icons.sync, color: Colors.green, size: 20),
    );
  }
}
