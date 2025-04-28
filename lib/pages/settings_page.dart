import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vrchat/provider/settings_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/router/app_router.dart';
import 'package:vrchat/theme/app_theme.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _animationController.forward();
    _loadPackageInfo();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _packageInfo = info;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '設定',
          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor:
            isDarkMode
                ? const Color(0xFF1E1E1E)
                : AppTheme.primaryColor.withValues(alpha: 0.05),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors:
                  isDarkMode
                      ? [const Color(0xFF1E1E1E), const Color(0xFF141414)]
                      : [Colors.white, const Color(0xFFF5F5F5)],
            ),
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              // アプリ外観設定
              _buildSettingsSection(
                title: '外観',
                icon: Icons.palette_outlined,
                children: [_buildThemeModeSetting(isDarkMode)],
              ),

              const SizedBox(height: 24),

              // アプリアイコン設定
              _buildSettingsSection(
                title: 'アプリアイコン',
                icon: Icons.app_settings_alt_outlined,
                children: [_buildAppIconSection(context, ref, isDarkMode)],
              ),

              const SizedBox(height: 24),

              // 通知設定
              _buildSettingsSection(
                title: '通知',
                icon: Icons.notifications_outlined,
                children: [
                  _buildSwitchSetting(
                    icon: Icons.person_add_outlined,
                    title: 'フレンドリクエスト通知',
                    subtitle: 'フレンドリクエストを受け取ったときに通知します',
                    value: settings.notifyNewFriendRequests,
                    onChanged: (value) {
                      ref
                          .read(settingsProvider.notifier)
                          .setNotifyNewFriendRequests(value);
                    },
                    isDarkMode: isDarkMode,
                  ),
                  _buildSwitchSetting(
                    icon: Icons.people_outlined,
                    title: 'フレンドオンライン通知',
                    subtitle: 'フレンドがオンラインになったときに通知します',
                    value: settings.notifyFriendOnline,
                    onChanged: (value) {
                      ref
                          .read(settingsProvider.notifier)
                          .setNotifyFriendOnline(value);
                    },
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // データと通信設定
              _buildSettingsSection(
                title: 'データと通信',
                icon: Icons.data_usage_outlined,
                children: [
                  _buildSwitchSetting(
                    icon: Icons.wifi_outlined,
                    title: 'Wi-Fi接続時のみ画像を読み込む',
                    subtitle: 'モバイルデータ通信量を節約します',
                    value: settings.loadImageOnWifi,
                    onChanged: (value) {
                      ref
                          .read(settingsProvider.notifier)
                          .setLoadImageOnWifi(value);
                    },
                    isDarkMode: isDarkMode,
                  ),
                  _buildSliderSetting(
                    icon: Icons.storage_outlined,
                    title: 'フレンドキャッシュ上限',
                    subtitle: 'キャッシュするフレンド情報の最大数',
                    value: settings.maxFriendCache.toDouble(),
                    min: 100,
                    max: 1000,
                    divisions: 9,
                    onChanged: (value) {
                      ref
                          .read(settingsProvider.notifier)
                          .setMaxFriendCache(value.round());
                    },
                    valueDisplay: '${settings.maxFriendCache}人',
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // アプリ情報
              if (_packageInfo != null)
                _buildSettingsSection(
                  title: 'アプリ情報',
                  icon: Icons.info_outline,
                  children: [
                    _buildInfoItem(
                      icon: Icons.tag,
                      title: 'バージョン',
                      value:
                          '${_packageInfo!.version} (${_packageInfo!.buildNumber})',
                      isDarkMode: isDarkMode,
                    ),
                    _buildInfoItem(
                      icon: Icons.code,
                      title: 'パッケージ名',
                      value: _packageInfo!.packageName,
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),

              const SizedBox(height: 40),

              // アカウント関連
              Center(
                child: TextButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: Text(
                    'ログアウト',
                    style: GoogleFonts.notoSans(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                    _showLogoutConfirmation();
                  },
                ),
              ),

              const SizedBox(height: 16),

              // フッター
              Center(
                child: Text(
                  '© 2025 null_base',
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 設定セクション
  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF262626) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // セクションヘッダー
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppTheme.primaryColor, size: 22),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.notoSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // セクションの内容
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  // テーマモード設定
  Widget _buildThemeModeSetting(bool isDarkMode) {
    final currentThemeMode = ref.watch(settingsProvider).themeMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.brightness_6_outlined,
                size: 22,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
              ),
              const SizedBox(width: 16),
              Text(
                'テーマモード',
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildThemeModeOption(
                title: '明るい',
                icon: Icons.wb_sunny_outlined,
                isSelected: currentThemeMode == AppThemeMode.light,
                onTap: () {
                  ref
                      .read(settingsProvider.notifier)
                      .setThemeMode(AppThemeMode.light);
                },
                isDarkMode: isDarkMode,
              ),
              _buildThemeModeOption(
                title: 'システム',
                icon: Icons.settings_brightness,
                isSelected: currentThemeMode == AppThemeMode.system,
                onTap: () {
                  ref
                      .read(settingsProvider.notifier)
                      .setThemeMode(AppThemeMode.system);
                },
                isDarkMode: isDarkMode,
              ),
              _buildThemeModeOption(
                title: '暗い',
                icon: Icons.nightlight_round,
                isSelected: currentThemeMode == AppThemeMode.dark,
                onTap: () {
                  ref
                      .read(settingsProvider.notifier)
                      .setThemeMode(AppThemeMode.dark);
                },
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // テーマモードオプション
  Widget _buildThemeModeOption({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppTheme.primaryColor.withValues(alpha: 0.1)
                  : isDarkMode
                  ? Colors.grey[800]
                  : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color:
                  isSelected
                      ? AppTheme.primaryColor
                      : isDarkMode
                      ? Colors.grey[400]
                      : Colors.grey[700],
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.notoSans(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppTheme.primaryColor : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // スイッチ設定
  Widget _buildSwitchSetting({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 22,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
            activeTrackColor: AppTheme.primaryColor.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  // スライダー設定
  Widget _buildSliderSetting({
    required IconData icon,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required Function(double) onChanged,
    required String valueDisplay,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  valueDisplay,
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppTheme.primaryColor,
              inactiveTrackColor: AppTheme.primaryColor.withValues(alpha: 0.3),
              thumbColor: AppTheme.primaryColor,
              overlayColor: AppTheme.primaryColor.withValues(alpha: 0.2),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                min.toInt().toString(),
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                ),
              ),
              Text(
                max.toInt().toString(),
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 情報アイテム
  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 22,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  value,
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // アプリアイコンセクション
  Widget _buildAppIconSection(
    BuildContext context,
    WidgetRef ref,
    bool isDarkMode,
  ) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return FutureBuilder<bool>(
      future: notifier.isAppIconChangeSupported(),
      builder: (context, snapshot) {
        // ローディング中の表示
        if (!snapshot.hasData) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        // サポートされていない場合
        if (snapshot.data == false) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'お使いのデバイスではアプリアイコンの変更がサポートされていません',
              style: GoogleFonts.notoSans(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
            ),
          );
        }

        // サポートされている場合（snapshot.data == true）
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.app_shortcut,
                    size: 22,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'アプリアイコン',
                          style: GoogleFonts.notoSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ホーム画面に表示されるアプリのアイコンを変更します',
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                            color:
                                isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildAppIconOption(
                  context: context,
                  ref: ref,
                  iconType: AppIconType.default_icon,
                  label: 'デフォルト',
                  assetPath: 'assets/images/default.png',
                  isSelected: settings.appIcon == AppIconType.default_icon,
                  isDarkMode: isDarkMode,
                ),
                _buildAppIconOption(
                  context: context,
                  ref: ref,
                  iconType: AppIconType.annobu,
                  label: 'annobu',
                  assetPath: 'assets/images/annobu@3x.png',
                  isSelected: settings.appIcon == AppIconType.annobu,
                  isDarkMode: isDarkMode,
                ),
                _buildAppIconOption(
                  context: context,
                  ref: ref,
                  iconType: AppIconType.kazkiller,
                  label: 'キチ顔',
                  assetPath: 'assets/images/kazkiller@3x.png',
                  isSelected: settings.appIcon == AppIconType.kazkiller,
                  isDarkMode: isDarkMode,
                ),
                _buildAppIconOption(
                  context: context,
                  ref: ref,
                  iconType: AppIconType.miyamoto,
                  label: 'Miyamoto_',
                  assetPath: 'assets/images/miyamoto@3x.png',
                  isSelected: settings.appIcon == AppIconType.miyamoto,
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // アイコンオプション
  Widget _buildAppIconOption({
    required BuildContext context,
    required WidgetRef ref,
    required AppIconType iconType,
    required String label,
    required String assetPath,
    required bool isSelected,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: () async {
        final success = await ref
            .read(settingsProvider.notifier)
            .setAppIcon(iconType);
        if (!success && context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('アイコンの変更に失敗しました')));
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(assetPath, fit: BoxFit.cover),
            ),
          ),

          // 余白を減らす
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: AppTheme.primaryColor,
                ),
              if (isSelected) const SizedBox(width: 2),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppTheme.primaryColor : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ログアウト確認ダイアログ
  Future<void> _showLogoutConfirmation() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'ログアウト',
              style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
            ),
            content: Text('ログアウトしますか？', style: GoogleFonts.notoSans()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'キャンセル',
                  style: GoogleFonts.notoSans(color: Colors.grey[600]),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('ログアウト', style: GoogleFonts.notoSans()),
              ),
            ],
          ),
    );

    if (shouldLogout == true) {
      if (shouldLogout == true) {
        try {
          // ログアウト処理を実行
          final auth = await ref.read(vrchatAuthProvider.future);
          await auth.logout();
          ref.read(authRefreshProvider.notifier).state++;
          if (context.mounted) {
            context.go('/login');
          }
        } catch (e) {
          // エラーハンドリング
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('ログアウト中にエラーが発生しました: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }
  }
}
