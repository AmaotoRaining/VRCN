import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('設定', style: GoogleFonts.notoSans())),
      body: ListView(
        children: [
          // テーマ設定セクション
          _buildSectionHeader(context, 'テーマ設定'),
          _buildThemeSettings(context, ref, settings),

          const Divider(),

          // データ設定セクション
          _buildSectionHeader(context, 'データ設定'),
          SwitchListTile(
            title: Text('Wi-Fi接続時のみ画像を読み込む', style: GoogleFonts.notoSans()),
            subtitle: Text(
              'モバイルデータ通信量を節約します',
              style: GoogleFonts.notoSans(fontSize: 12),
            ),
            value: settings.loadImageOnWifi,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setLoadImageOnWifi(value);
            },
          ),
          ListTile(
            title: Text('最大フレンドキャッシュ数', style: GoogleFonts.notoSans()),
            subtitle: Text(
              'アプリが保存するフレンド情報の最大数',
              style: GoogleFonts.notoSans(fontSize: 12),
            ),
            trailing: DropdownButton<int>(
              value: settings.maxFriendCache,
              items:
                  [100, 300, 500, 1000, 2000]
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text('$e人', style: GoogleFonts.notoSans()),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setMaxFriendCache(value);
                }
              },
            ),
          ),

          const Divider(),

          // 通知設定セクション
          Text("実装検討中"),
          _buildSectionHeader(context, '通知設定'),
          SwitchListTile(
            title: Text('フレンドリクエスト通知', style: GoogleFonts.notoSans()),
            subtitle: Text(
              '新しいフレンドリクエストを通知します',
              style: GoogleFonts.notoSans(fontSize: 12),
            ),
            value: settings.notifyNewFriendRequests,
            onChanged: (value) {
              ref
                  .read(settingsProvider.notifier)
                  .setNotifyNewFriendRequests(value);
            },
          ),
          SwitchListTile(
            title: Text('フレンドオンライン通知', style: GoogleFonts.notoSans()),
            subtitle: Text(
              'フレンドがオンラインになったときに通知します',
              style: GoogleFonts.notoSans(fontSize: 12),
            ),
            value: settings.notifyFriendOnline,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setNotifyFriendOnline(value);
            },
          ),

          const Divider(),

          // アプリ情報セクション
          _buildSectionHeader(context, 'アプリ情報'),
          ListTile(
            title: Text('バージョン', style: GoogleFonts.notoSans()),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            title: Text('利用規約', style: GoogleFonts.notoSans()),
            onTap: () {
              // 利用規約表示処理
            },
          ),
          ListTile(
            title: Text('プライバシーポリシー', style: GoogleFonts.notoSans()),
            onTap: () {
              // プライバシーポリシー表示処理
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: GoogleFonts.notoSans(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildThemeSettings(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    return Column(
      children: [
        RadioListTile<AppThemeMode>(
          title: Text('ライトテーマ', style: GoogleFonts.notoSans()),
          value: AppThemeMode.light,
          groupValue: settings.themeMode,
          onChanged: (value) {
            if (value != null) {
              ref.read(settingsProvider.notifier).setThemeMode(value);
            }
          },
        ),
        RadioListTile<AppThemeMode>(
          title: Text('ダークテーマ', style: GoogleFonts.notoSans()),
          value: AppThemeMode.dark,
          groupValue: settings.themeMode,
          onChanged: (value) {
            if (value != null) {
              ref.read(settingsProvider.notifier).setThemeMode(value);
            }
          },
        ),
        RadioListTile<AppThemeMode>(
          title: Text('システム設定に従う', style: GoogleFonts.notoSans()),
          value: AppThemeMode.system,
          groupValue: settings.themeMode,
          onChanged: (value) {
            if (value != null) {
              ref.read(settingsProvider.notifier).setThemeMode(value);
            }
          },
        ),
      ],
    );
  }
}
