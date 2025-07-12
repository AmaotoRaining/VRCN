import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrchat/provider/auth_storage_provider.dart';
import 'package:vrchat/provider/cache_provider.dart';
import 'package:vrchat/provider/event_reminder_provider.dart';
import 'package:vrchat/provider/settings_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/router/app_router.dart';
import 'package:vrchat/theme/app_theme.dart';
import 'package:vrchat/widgets/reminder_management_dialog.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
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
    final primaryColor = Theme.of(context).colorScheme.primary;
    final headerColor =
        isDarkMode
            ? HSLColor.fromColor(
              primaryColor,
            ).withLightness(0.25).withSaturation(0.6).toColor()
            : HSLColor.fromColor(
              primaryColor,
            ).withLightness(0.92).withSaturation(0.3).toColor();

    // 背景色グラデーション
    final gradientColors =
        isDarkMode
            ? [const Color(0xFF1C1C1E), const Color(0xFF121214)]
            : [Colors.white, const Color(0xFFF8F9FA)];

    // セクション背景色
    final sectionBgColor = isDarkMode ? const Color(0xFF252528) : Colors.white;

    // ボタン色
    final buttonColor =
        isDarkMode ? const Color(0xFF2E2E36) : const Color(0xFFF0F0F5);

    // テキスト色
    final textColor = isDarkMode ? Colors.white : const Color(0xFF2A2A2A);
    final secondaryTextColor =
        isDarkMode ? Colors.white70 : const Color(0xFF6E6E73);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: false,
                expandedHeight: 60,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  title: Text(
                    '設定',
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          headerColor.withValues(alpha: 0.6),
                          headerColor.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // アプリ外観設定
                        _buildSettingsSection(
                              title: '外観',
                              icon: Icons.palette_outlined,
                              iconColor: const Color(0xFF8E8CD8),
                              backgroundColor: sectionBgColor,
                              textColor: textColor,
                              secondaryTextColor: secondaryTextColor,
                              buttonColor: buttonColor,
                              isDarkMode: isDarkMode,
                              children: [
                                _buildThemeModeSetting(
                                  isDarkMode,
                                  textColor,
                                  secondaryTextColor,
                                  buttonColor,
                                ),
                              ],
                            )
                            .animate()
                            .fadeIn(delay: 100.ms, duration: 600.ms)
                            .slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 24),

                        if (Platform.isIOS) ...[
                          // アプリアイコン設定 (iOS限定)
                          _buildSettingsSection(
                                title: 'アプリアイコン',
                                icon: Icons.app_settings_alt_outlined,
                                iconColor: const Color(0xFF52B69A),
                                backgroundColor: sectionBgColor,
                                textColor: textColor,
                                secondaryTextColor: secondaryTextColor,
                                buttonColor: buttonColor,
                                isDarkMode: isDarkMode,
                                children: [
                                  _buildAppIconSection(
                                    context,
                                    ref,
                                    isDarkMode,
                                    textColor,
                                    secondaryTextColor,
                                  ),
                                ],
                              )
                              .animate()
                              .fadeIn(delay: 200.ms, duration: 600.ms)
                              .slideY(begin: 0.1, end: 0),

                          const SizedBox(height: 24),
                        ],

                        // コンテンツ設定
                        _buildSettingsSection(
                              title: 'コンテンツ設定',
                              icon: Icons.content_paste_outlined,
                              iconColor: const Color(0xFFE76F51),
                              backgroundColor: sectionBgColor,
                              textColor: textColor,
                              secondaryTextColor: secondaryTextColor,
                              buttonColor: buttonColor,
                              isDarkMode: isDarkMode,
                              children: [
                                _buildApiUrlSetting(
                                  context,
                                  ref,
                                  isDarkMode,
                                  textColor,
                                  secondaryTextColor,
                                ),
                                _buildSwitchSetting(
                                  icon: Icons.search,
                                  iconColor: const Color(0xFFE76F51),
                                  title: '検索機能を有効',
                                  subtitle:
                                      '検索結果に性的なコンテンツや暴力的なコンテンツが表示される可能性があります。',
                                  value: settings.allowNsfw,
                                  onChanged: (value) {
                                    ref
                                        .read(settingsProvider.notifier)
                                        .setAllowNsfw(value);
                                    _showNsfwToast(context, value);
                                  },
                                  textColor: textColor,
                                  secondaryTextColor: secondaryTextColor,
                                  isDarkMode: isDarkMode,
                                ),
                              ],
                            )
                            .animate()
                            .fadeIn(delay: 300.ms, duration: 600.ms)
                            .slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 24),

                        // 通知設定
                        _buildSettingsSection(
                              title: '通知設定',
                              icon: Icons.notifications_outlined,
                              iconColor: const Color(0xFF3A86FF),
                              backgroundColor: sectionBgColor,
                              textColor: textColor,
                              secondaryTextColor: secondaryTextColor,
                              buttonColor: buttonColor,
                              isDarkMode: isDarkMode,
                              children: [
                                _buildSwitchSetting(
                                  icon: Icons.event_available,
                                  iconColor: const Color(0xFF3A86FF),
                                  title: 'イベントリマインダー',
                                  subtitle: '設定したイベントの開始前に通知を受け取ります',
                                  value: settings.enableEventReminders,
                                  onChanged: (value) {
                                    ref
                                        .read(settingsProvider.notifier)
                                        .setEnableEventReminders(value);
                                    _toggleReminders(ref, value);
                                  },
                                  textColor: textColor,
                                  secondaryTextColor: secondaryTextColor,
                                  isDarkMode: isDarkMode,
                                ),
                                _buildReminderManagementButton(
                                  context,
                                  isDarkMode,
                                  textColor,
                                  secondaryTextColor,
                                  buttonColor,
                                ),
                              ],
                            )
                            .animate()
                            .fadeIn(delay: 400.ms, duration: 600.ms)
                            .slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 24),

                        // データとストレージ
                        _buildSettingsSection(
                              title: 'データとストレージ',
                              icon: Icons.storage_outlined,
                              iconColor: const Color(0xFF2A9D8F),
                              backgroundColor: sectionBgColor,
                              textColor: textColor,
                              secondaryTextColor: secondaryTextColor,
                              buttonColor: buttonColor,
                              isDarkMode: isDarkMode,
                              children: [
                                _buildCacheClearItem(
                                  isDarkMode,
                                  textColor,
                                  secondaryTextColor,
                                ),
                              ],
                            )
                            .animate()
                            .fadeIn(delay: 550.ms, duration: 600.ms)
                            .slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 24),

                        // アプリ情報
                        if (_packageInfo != null)
                          _buildSettingsSection(
                                title: 'アプリ情報',
                                icon: Icons.info_outline,
                                iconColor: const Color(0xFF9381FF),
                                backgroundColor: sectionBgColor,
                                textColor: textColor,
                                secondaryTextColor: secondaryTextColor,
                                buttonColor: buttonColor,
                                isDarkMode: isDarkMode,
                                children: [
                                  _buildInfoItem(
                                    icon: Icons.tag,
                                    iconColor: const Color(0xFF9381FF),
                                    title: 'バージョン',
                                    value:
                                        '${_packageInfo!.version} (${_packageInfo!.buildNumber})',
                                    textColor: textColor,
                                    secondaryTextColor: secondaryTextColor,
                                  ),
                                  if (kDebugMode) ...[
                                    _buildInfoItem(
                                      icon: Icons.code,
                                      iconColor: const Color(0xFF9381FF),
                                      title: 'パッケージ名',
                                      value: _packageInfo!.packageName,
                                      textColor: textColor,
                                      secondaryTextColor: secondaryTextColor,
                                    ),
                                  ],
                                  const Divider(height: 1),
                                  _buildLinkItem(
                                    icon: Icons.person,
                                    iconColor: const Color(0xFF9381FF),
                                    title: 'クレジット',
                                    subtitle: '開発者・貢献者情報',
                                    onTap: () => context.push('/credits'),
                                    textColor: textColor,
                                    secondaryTextColor: secondaryTextColor,
                                  ),
                                  _buildLinkItem(
                                    icon: Icons.email_outlined,
                                    iconColor: const Color(0xFF9381FF),
                                    title: 'お問い合わせ',
                                    subtitle: '不具合報告・ご意見はこちら',
                                    onTap:
                                        () => _launchURL(
                                          'https://discord.gg/wNgbkdXq6M',
                                        ),
                                    textColor: textColor,
                                    secondaryTextColor: secondaryTextColor,
                                  ),
                                  _buildLinkItem(
                                    icon: Icons.security_outlined,
                                    iconColor: const Color(0xFF9381FF),
                                    title: 'プライバシーポリシー',
                                    subtitle: '個人情報の取り扱いについて',
                                    onTap:
                                        () => _launchURL(
                                          'https://null-base.com/vrcn/privacy-policy/',
                                        ),
                                    textColor: textColor,
                                    secondaryTextColor: secondaryTextColor,
                                  ),
                                  _buildLinkItem(
                                    icon: Icons.description_outlined,
                                    iconColor: const Color(0xFF9381FF),
                                    title: '利用規約',
                                    subtitle: 'アプリのご利用条件',
                                    onTap:
                                        () => _launchURL(
                                          'https://null-base.com/vrcn/terms-of-service',
                                        ),
                                    textColor: textColor,
                                    secondaryTextColor: secondaryTextColor,
                                  ),
                                  _buildLinkItem(
                                    icon: Icons.code_outlined,
                                    iconColor: const Color(0xFF9381FF),
                                    title: 'オープンソース情報',
                                    subtitle: '使用しているライブラリ等のライセンス',
                                    onTap: _showLicenses,
                                    textColor: textColor,
                                    secondaryTextColor: secondaryTextColor,
                                  ),
                                  _buildLinkItem(
                                    icon: Icons.code_rounded,
                                    iconColor: const Color(0xFF9381FF),
                                    title: 'GitHubリポジトリ',
                                    subtitle: 'ソースコードを見る',
                                    onTap:
                                        () => _launchURL(
                                          'https://github.com/null-base/vrcn',
                                        ),
                                    textColor: textColor,
                                    secondaryTextColor: secondaryTextColor,
                                  ),
                                ],
                              )
                              .animate()
                              .fadeIn(delay: 500.ms, duration: 600.ms)
                              .slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 24),

                        // ログアウトボタン
                        Center(
                          child: _buildLogoutButton(
                            isDarkMode,
                            textColor,
                            secondaryTextColor,
                          ),
                        ).animate().fadeIn(delay: 600.ms, duration: 600.ms),

                        const SizedBox(height: 20),

                        // フッター
                        Center(
                          child: Text(
                            '© 2025 null_base',
                            style: GoogleFonts.notoSans(
                              fontSize: 12,
                              color: secondaryTextColor,
                            ),
                          ),
                        ).animate().fadeIn(delay: 700.ms, duration: 600.ms),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ]),
              ),
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
    required Color iconColor,
    required Color backgroundColor,
    required Color textColor,
    required Color secondaryTextColor,
    required Color buttonColor,
    required bool isDarkMode,
    required List<Widget> children,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withValues(alpha: .2)
                    : Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // セクションヘッダー
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: isDarkMode ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: GoogleFonts.notoSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
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
  Widget _buildThemeModeSetting(
    bool isDarkMode,
    Color textColor,
    Color secondaryTextColor,
    Color buttonColor,
  ) {
    final currentThemeMode = ref.watch(settingsProvider).themeMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF8E8CD8,
                  ).withValues(alpha: isDarkMode ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.brightness_6_outlined,
                  size: 20,
                  color: Color(0xFF8E8CD8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'テーマモード',
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'アプリの表示テーマを選択できます',
                      style: GoogleFonts.notoSans(
                        fontSize: 13,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DecoratedBox(
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
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
                  textColor: textColor,
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
                  textColor: textColor,
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
                  textColor: textColor,
                ),
              ],
            ),
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
    required Color textColor,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? AppTheme.primaryColor.withValues(
                      alpha: isDarkMode ? 0.3 : 0.2,
                    )
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color:
                    isSelected
                        ? AppTheme.primaryColor
                        : textColor.withValues(alpha: 0.7),
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color:
                      isSelected
                          ? AppTheme.primaryColor
                          : textColor.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // スイッチ設定
  Widget _buildSwitchSetting({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required Color textColor,
    required Color secondaryTextColor,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: isDarkMode ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppTheme.primaryColor,
              activeTrackColor: AppTheme.primaryColor.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  // リマインダー管理ボタン
  Widget _buildReminderManagementButton(
    BuildContext context,
    bool isDarkMode,
    Color textColor,
    Color secondaryTextColor,
    Color buttonColor,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => const ReminderManagementDialog(),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF3A86FF,
                  ).withValues(alpha: isDarkMode ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.list_alt_rounded,
                  color: Color(0xFF3A86FF),
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '設定済みリマインダーの管理',
                      style: GoogleFonts.notoSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '通知のキャンセルや確認ができます',
                      style: GoogleFonts.notoSans(
                        fontSize: 13,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: secondaryTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // API URL設定
  Widget _buildApiUrlSetting(
    BuildContext context,
    WidgetRef ref,
    bool isDarkMode,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: InkWell(
        onTap: () {
          final controller = TextEditingController(
            text: ref.read(settingsProvider).avatarSearchApiUrl,
          );

          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    'アバター検索API URL',
                    style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
                  ),
                  content: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'https://null-base.com/',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    autofocus: true,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('キャンセル', style: GoogleFonts.notoSans()),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final url = controller.text.trim();
                        ref
                            .read(settingsProvider.notifier)
                            .setAvatarSearchApiUrl(url);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('URLを保存しました'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                      child: Text('保存', style: GoogleFonts.notoSans()),
                    ),
                  ],
                ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(
                  0xFFE76F51,
                ).withValues(alpha: isDarkMode ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.link_rounded,
                size: 20,
                color: Color(0xFFE76F51),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'アバター検索 API URL',
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ref.watch(settingsProvider).avatarSearchApiUrl.isEmpty
                        ? '未設定 (アバター検索機能が使用できません)'
                        : ref.watch(settingsProvider).avatarSearchApiUrl,
                    style: GoogleFonts.notoSans(
                      fontSize: 13,
                      color: secondaryTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.edit, size: 18, color: secondaryTextColor),
          ],
        ),
      ),
    );
  }

  // 情報アイテム
  Widget _buildInfoItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  value,
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // リンク付き情報アイテム
  Widget _buildLinkItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.notoSans(
                      fontSize: 13,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: secondaryTextColor,
            ),
          ],
        ),
      ),
    );
  }

  // アプリアイコンセクション
  Widget _buildAppIconSection(
    BuildContext context,
    WidgetRef ref,
    bool isDarkMode,
    Color textColor,
    Color secondaryTextColor,
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
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    isDarkMode
                        ? Colors.red.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      isDarkMode
                          ? Colors.red.withValues(alpha: 0.3)
                          : Colors.red.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.red.withValues(alpha: 0.8),
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'お使いのデバイスではアプリアイコンの変更がサポートされていません',
                      style: GoogleFonts.notoSans(
                        color: Colors.red.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // サポートされている場合
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFF52B69A,
                      ).withValues(alpha: isDarkMode ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.app_shortcut,
                      size: 20,
                      color: Color(0xFF52B69A),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'アプリアイコン',
                          style: GoogleFonts.notoSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ホーム画面に表示されるアプリのアイコンを変更します',
                          style: GoogleFonts.notoSans(
                            fontSize: 13,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildAppIconOption(
                    context: context,
                    ref: ref,
                    iconType: AppIconType.nullbase,
                    label: 'デフォルト',
                    assetPath: 'assets/icons/default.png',
                    isSelected: settings.appIcon == AppIconType.nullbase,
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                  ),
                  _buildAppIconOption(
                    context: context,
                    ref: ref,
                    iconType: AppIconType.vrcn_icon,
                    label: 'アイコン',
                    assetPath: 'assets/icons/vrcn_icon@3x.png',
                    isSelected: settings.appIcon == AppIconType.vrcn_icon,
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                  ),
                  _buildAppIconOption(
                    context: context,
                    ref: ref,
                    iconType: AppIconType.vrcn_logo,
                    label: 'ロゴ',
                    assetPath: 'assets/icons/vrcn_logo@3x.png',
                    isSelected: settings.appIcon == AppIconType.vrcn_logo,
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                  ),
                  _buildAppIconOption(
                    context: context,
                    ref: ref,
                    iconType: AppIconType.nullkalne,
                    label: 'null_base',
                    assetPath: 'assets/icons/nullkalne@3x.png',
                    isSelected: settings.appIcon == AppIconType.nullkalne,
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                  ),
                  _buildAppIconOption(
                    context: context,
                    ref: ref,
                    iconType: AppIconType.annobu,
                    label: 'annobu',
                    assetPath: 'assets/icons/annobu@3x.png',
                    isSelected: settings.appIcon == AppIconType.annobu,
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                  ),
                  _buildAppIconOption(
                    context: context,
                    ref: ref,
                    iconType: AppIconType.kazkiller,
                    label: 'KAZkiller',
                    assetPath: 'assets/icons/kazkiller@3x.png',
                    isSelected: settings.appIcon == AppIconType.kazkiller,
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                  ),
                  _buildAppIconOption(
                    context: context,
                    ref: ref,
                    iconType: AppIconType.miyamoto,
                    label: 'lonely縷縷',
                    assetPath: 'assets/icons/miyamoto@3x.png',
                    isSelected: settings.appIcon == AppIconType.miyamoto,
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                  ),
                  _buildAppIconOption(
                    context: context,
                    ref: ref,
                    iconType: AppIconType.le0yuki,
                    label: 'Le0yuki',
                    assetPath: 'assets/icons/le0yuki@3x.png',
                    isSelected: settings.appIcon == AppIconType.le0yuki,
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                  ),
                  _buildAppIconOption(
                    context: context,
                    ref: ref,
                    iconType: AppIconType.ray,
                    label: 'Ray',
                    assetPath: 'assets/icons/ray@3x.png',
                    isSelected: settings.appIcon == AppIconType.ray,
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                  ),
                  _buildAppIconOption(
                    context: context,
                    ref: ref,
                    iconType: AppIconType.hare,
                    label: 'Hare',
                    assetPath: 'assets/icons/hare@3x.png',
                    isSelected: settings.appIcon == AppIconType.hare,
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                  ),
                  _buildAppIconOption(
                    context: context,
                    ref: ref,
                    iconType: AppIconType.aihuru,
                    label: 'アイフル',
                    assetPath: 'assets/icons/aihuru@3x.png',
                    isSelected: settings.appIcon == AppIconType.aihuru,
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                  ),
                  _buildAppIconOption(
                    context: context,
                    ref: ref,
                    iconType: AppIconType.rea,
                    label: 'Rea',
                    assetPath: 'assets/icons/rea@3x.png',
                    isSelected: settings.appIcon == AppIconType.rea,
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                  ),
                  _buildAppIconOption(
                    context: context,
                    ref: ref,
                    iconType: AppIconType.masukawa,
                    label: 'ますかわ',
                    assetPath: 'assets/icons/masukawa@3x.png',
                    isSelected: settings.appIcon == AppIconType.masukawa,
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                  ),
                  _buildAppIconOption(
                    context: context,
                    ref: ref,
                    iconType: AppIconType.abuki,
                    label: 'AbukI',
                    assetPath: 'assets/icons/abuki@3x.png',
                    isSelected: settings.appIcon == AppIconType.abuki,
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                  ),
                  _buildAppIconOption(
                    context: context,
                    ref: ref,
                    iconType: AppIconType.enadori,
                    label: 'エナドリ',
                    assetPath: 'assets/icons/enadori@3x.png',
                    isSelected: settings.appIcon == AppIconType.enadori,
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                  ),
                  _buildAppIconOption(
                    context: context,
                    ref: ref,
                    iconType: AppIconType.roize,
                    label: 'Roize',
                    assetPath: 'assets/icons/roize@3x.png',
                    isSelected: settings.appIcon == AppIconType.roize,
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                  ),
                  _buildAppIconOption(
                    context: context,
                    ref: ref,
                    iconType: AppIconType.r4in,
                    label: 'R4in',
                    assetPath: 'assets/icons/r4in@3x.png',
                    isSelected: settings.appIcon == AppIconType.r4in,
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                  ),
                  _buildAppIconOption(
                    context: context,
                    ref: ref,
                    iconType: AppIconType.etoeto,
                    label: 'えと干支',
                    assetPath: 'assets/icons/etoeto@3x.png',
                    isSelected: settings.appIcon == AppIconType.etoeto,
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                  ),
                  _buildAppIconOption(
                    context: context,
                    ref: ref,
                    iconType: AppIconType.pampy,
                    label: 'ぱんぴー',
                    assetPath: 'assets/icons/pampy@3x.png',
                    isSelected: settings.appIcon == AppIconType.pampy,
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                  ),
                  _buildAppIconOption(
                    context: context,
                    ref: ref,
                    iconType: AppIconType.yume,
                    label: '~yume~',
                    assetPath: 'assets/icons/yume@3x.png',
                    isSelected: settings.appIcon == AppIconType.yume,
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                  ),
                ],
              ),
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
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: () async {
        final success = await ref
            .read(settingsProvider.notifier)
            .setAppIcon(iconType);
        if (!success && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('アイコンの変更に失敗しました'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isSelected ? AppTheme.primaryColor : Colors.transparent,
                  width: 3,
                ),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: AppTheme.primaryColor.withValues(alpha: 0.3),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]
                        : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: Image.asset(assetPath, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check, size: 10, color: Colors.white),
                        const SizedBox(width: 2),
                        Text(
                          label,
                          style: GoogleFonts.notoSans(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    label,
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ログアウトボタン
  Widget _buildLogoutButton(
    bool isDarkMode,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: isDarkMode ? 0.3 : 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showLogoutConfirmation,
          borderRadius: BorderRadius.circular(30),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade500, Colors.red.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ログアウト',
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // NSFWトーストを表示
  void _showNsfwToast(BuildContext context, bool value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value ? '検索機能が有効になりました' : '検索機能が無効になりました'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // リマインダー設定を切り替え
  void _toggleReminders(WidgetRef ref, bool value) {
    if (!value) {
      ref.read(eventReminderProvider.notifier).cancelAllNotifications();
    } else {
      ref.read(eventReminderProvider.notifier).rescheduleAllNotifications();
    }
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
      try {
        // 保存された認証情報をクリア
        final authStorage = ref.read(authStorageProvider);
        await authStorage.clearCredentials();

        // ログアウト処理
        final auth = await ref.read(vrchatAuthProvider.future);
        await auth.logout();
        ref.read(authRefreshProvider.notifier).state++;

        if (mounted) {
          context.go('/login');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ログアウト中にエラーが発生しました: ${e.toString()}'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> _launchURL(String urlString) async {
    final url = Uri.parse(urlString);
    await launchUrl(url);
  }

  // ライセンス表示メソッド
  void _showLicenses() {
    showLicensePage(
      context: context,
      applicationName: 'VRCN',
      applicationVersion: _packageInfo?.version ?? '',
      applicationIcon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/icons/default.png', width: 64, height: 64),
      ),
      applicationLegalese: '© 2025 null_base',
    );
  }

  // キャッシュクリアアイテム
  Widget _buildCacheClearItem(
    bool isDarkMode,
    Color textColor,
    Color secondaryTextColor,
  ) {
    final cacheSizeAsync = ref.watch(cacheSizeProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: InkWell(
        onTap: _showClearCacheConfirmation,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(
                  0xFF2A9D8F,
                ).withValues(alpha: isDarkMode ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.cleaning_services_outlined,
                size: 20,
                color: Color(0xFF2A9D8F),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'キャッシュを削除',
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  cacheSizeAsync.when(
                    data:
                        (size) => Text(
                          'キャッシュサイズ: $size',
                          style: GoogleFonts.notoSans(
                            fontSize: 13,
                            color: secondaryTextColor,
                          ),
                        ),
                    loading:
                        () => Text(
                          'キャッシュサイズを計算中...',
                          style: GoogleFonts.notoSans(
                            fontSize: 13,
                            color: secondaryTextColor,
                          ),
                        ),
                    error:
                        (_, _) => Text(
                          'キャッシュサイズを取得できませんでした',
                          style: GoogleFonts.notoSans(
                            fontSize: 13,
                            color: Colors.red[300],
                          ),
                        ),
                  ),
                ],
              ),
            ),
            Icon(Icons.delete_outline, size: 22, color: Colors.red[400]),
          ],
        ),
      ),
    );
  }

  // キャッシュ削除確認ダイアログ
  Future<void> _showClearCacheConfirmation() async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.amber[700]),
                const SizedBox(width: 12),
                Text(
                  'キャッシュを削除',
                  style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Text(
              'キャッシュを削除すると、一時的に保存された画像やデータが削除されます。\n\nアカウント情報やアプリの設定は削除されません。',
              style: GoogleFonts.notoSans(),
            ),
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
                  backgroundColor: const Color(0xFF2A9D8F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('削除する', style: GoogleFonts.notoSans()),
              ),
            ],
          ),
    );

    if (shouldClear == true) {
      final cacheService = ref.read(cacheServiceProvider);
      final success = await cacheService.clearCache();

      if (mounted) {
        // キャッシュサイズを再計算するためプロバイダーを更新
        ref.invalidate(cacheSizeProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'キャッシュを削除しました' : 'キャッシュの削除中にエラーが発生しました'),
            backgroundColor: success ? Colors.green : Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }
}
