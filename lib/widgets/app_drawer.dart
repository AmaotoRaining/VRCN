import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/friends_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/router/app_router.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    // VRChat APIのインスタンスからUser-Agentを取得
    final vrchatApi = ref.watch(vrchatProvider).value;
    // User-Agentヘッダーの定義
    final Map<String, String> headers = {
      'User-Agent': vrchatApi?.userAgent.toString() ?? 'VRChat/1.0',
    };

    return Drawer(
      child: Column(
        children: [
          // ドロワーヘッダー - ユーザー情報を表示
          currentUserAsync.when(
            data:
                (user) => UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage:
                        user.currentAvatarThumbnailImageUrl.isNotEmpty
                            ? CachedNetworkImageProvider(
                              user.currentAvatarThumbnailImageUrl,
                              headers: headers, // User-Agentヘッダーを追加
                            )
                            : null,
                    child:
                        user.currentAvatarThumbnailImageUrl.isEmpty
                            ? const Icon(Icons.person)
                            : null,
                  ),
                  accountName: Text(
                    user.displayName,
                    style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text('Status: ${_getStatusText(user.status)}'),
                ),
            loading:
                () => const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.deepPurple),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
            error:
                (_, __) => DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  child: const Center(child: Text('ユーザー情報の取得に失敗しました')),
                ),
          ),

          // ドロワーアイテム
          ListTile(
            leading: const Icon(Icons.home),
            title: Text('ホーム', style: GoogleFonts.notoSans()),
            onTap: () {
              context.go('/');
              Navigator.pop(context); // ドロワーを閉じる
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text('プロフィール', style: GoogleFonts.notoSans()),
            onTap: () {
              context.push('/profile');
              Navigator.pop(context); // ドロワーを閉じる
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text('設定', style: GoogleFonts.notoSans()),
            onTap: () {
              context.push('/settings');
              Navigator.pop(context); // ドロワーを閉じる
            },
          ),
          const Divider(),

          // フィルター設定
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'フレンド表示フィルター',
                  style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildFilterRadio(context, ref),
              ],
            ),
          ),

          const Divider(),

          // ログアウトボタン
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              'ログアウト',
              style: GoogleFonts.notoSans(color: Colors.red),
            ),
            onTap: () => _showLogoutDialog(context, ref),
          ),
        ],
      ),
    );
  }

  // フィルター設定用ラジオボタン
  Widget _buildFilterRadio(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(friendFilterProvider);

    return Column(
      children: [
        RadioListTile<FriendFilter>(
          title: Text('すべて表示', style: GoogleFonts.notoSans()),
          value: FriendFilter.all,
          groupValue: currentFilter,
          onChanged: (value) {
            if (value != null) {
              ref.read(friendFilterProvider.notifier).state = value;
              Navigator.pop(context); // ドロワーを閉じる
            }
          },
        ),
        RadioListTile<FriendFilter>(
          title: Text('オンラインのみ', style: GoogleFonts.notoSans()),
          value: FriendFilter.online,
          groupValue: currentFilter,
          onChanged: (value) {
            if (value != null) {
              ref.read(friendFilterProvider.notifier).state = value;
              Navigator.pop(context); // ドロワーを閉じる
            }
          },
        ),
        RadioListTile<FriendFilter>(
          title: Text('オフラインのみ', style: GoogleFonts.notoSans()),
          value: FriendFilter.offline,
          groupValue: currentFilter,
          onChanged: (value) {
            if (value != null) {
              ref.read(friendFilterProvider.notifier).state = value;
              Navigator.pop(context); // ドロワーを閉じる
            }
          },
        ),
      ],
    );
  }

  // ログアウト確認ダイアログ
  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('ログアウト', style: GoogleFonts.notoSans()),
            content: Text('ログアウトしますか？', style: GoogleFonts.notoSans()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('キャンセル', style: GoogleFonts.notoSans()),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('ログアウト', style: GoogleFonts.notoSans()),
              ),
            ],
          ),
    );

    // ドロワーを閉じる
    if (context.mounted) {
      Navigator.pop(context);
    }

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
            SnackBar(content: Text('ログアウト中にエラーが発生しました: ${e.toString()}')),
          );
        }
      }
    }
  }

  // ステータステキストの取得
  String _getStatusText(UserStatus? status) {
    switch (status) {
      case UserStatus.active:
        return 'オンライン';
      case UserStatus.joinMe:
        return 'だれでもおいで';
      case UserStatus.askMe:
        return 'きいてみてね';
      case UserStatus.busy:
        return '取り込み中';
      case UserStatus.offline:
        return 'オフライン';
      default:
        return 'ステータス不明';
    }
  }
}
