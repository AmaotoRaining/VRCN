// ignore_for_file: document_ignores, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/friends_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/theme/app_theme.dart';
import 'package:vrchat/utils/cache_manager.dart';
import 'package:vrchat/utils/status_helpers.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final vrchatApi = ref.watch(vrchatProvider).value;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // User-Agentヘッダーの定義
    final headers = <String, String>{
      'User-Agent': vrchatApi?.userAgent.toString() ?? 'VRChat/1.0',
    };

    return Drawer(
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      child: Column(
        children: [
          currentUserAsync.when(
            data:
                (user) =>
                    _buildStylishHeader(context, user, headers, isDarkMode),
            loading: () => _buildLoadingHeader(context),
            error: (_, _) => _buildErrorHeader(context),
          ),

          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF212121) : Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 6),

                      _buildMenuItem(
                        context: context,
                        icon: Icons.home_rounded,
                        title: 'ホーム',
                        isSelected: GoRouterState.of(context).uri.path == '/',
                        onTap: () {
                          context.go('/');
                          Navigator.pop(context);
                        },
                      ),

                      // プロフィールメニュー
                      _buildMenuItem(
                        context: context,
                        icon: Icons.person_rounded,
                        title: 'プロフィール',
                        isSelected:
                            GoRouterState.of(context).uri.path == '/profile',
                        onTap: () {
                          context.push('/profile');
                          Navigator.pop(context);
                        },
                      ),
                      // お気に入りメニュー追加
                      _buildMenuItem(
                        context: context,
                        icon: Icons.favorite_rounded,
                        title: 'お気に入り',
                        isSelected: GoRouterState.of(
                          context,
                        ).uri.path.startsWith('/favorites'),
                        onTap: () {
                          context.push('/favorites');
                          Navigator.pop(context);
                        },
                      ),
                      // アバターメニュー追加
                      _buildMenuItem(
                        context: context,
                        icon: Icons.face_rounded,
                        title: 'アバター',
                        isSelected: GoRouterState.of(
                          context,
                        ).uri.path.startsWith('/avatars'),
                        onTap: () {
                          context.push('/avatars');
                          Navigator.pop(context);
                        },
                      ),
                      // グループメニュー追加
                      _buildMenuItem(
                        context: context,
                        icon: Icons.group_rounded,
                        title: 'グループ',
                        isSelected: GoRouterState.of(
                          context,
                        ).uri.path.startsWith('/groups'),
                        onTap: () {
                          context.push('/groups');
                          Navigator.pop(context);
                        },
                      ),
                      const Divider(height: 1),
                      // 設定メニュー
                      _buildMenuItem(
                        context: context,
                        icon: Icons.settings_rounded,
                        title: '設定',
                        isSelected:
                            GoRouterState.of(context).uri.path == '/settings',
                        onTap: () {
                          context.push('/settings');
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 改良したスタイリッシュなヘッダー
  Widget _buildStylishHeader(
    BuildContext context,
    CurrentUser user,
    Map<String, String> headers,
    bool isDarkMode,
  ) {
    final statusColor = StatusHelper.getStatusColor(user.status);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF15202B) : Colors.white,
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // プロフィール画像（アバター）
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        user.userIcon.isNotEmpty
                            ? CachedNetworkImageProvider(
                              user.userIcon,
                              headers: headers,
                              cacheManager: JsonCacheManager(),
                            )
                            : user.currentAvatarThumbnailImageUrl.isNotEmpty
                            ? CachedNetworkImageProvider(
                              user.currentAvatarThumbnailImageUrl,
                              headers: headers,
                              cacheManager: JsonCacheManager(),
                            )
                            : const AssetImage('assets/images/default.png')
                                as ImageProvider,
                    child:
                        user.currentAvatarThumbnailImageUrl.isEmpty
                            ? const Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.white70,
                            )
                            : null,
                  ),
                ),

                // ステータス表示
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color:
                          isDarkMode ? const Color(0xFF15202B) : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 12),

            // ユーザー情報
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 表示名
                  Text(
                    user.displayName,
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // ユーザーID
                  Text(
                    '@${user.username}',
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // ステータスメッセージ（あれば）
                  if (user.statusDescription.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      user.statusDescription,
                      style: GoogleFonts.notoSans(
                        fontSize: 13,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ローディング中のヘッダー
  Widget _buildLoadingHeader(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryColor.withAlpha(204), AppTheme.primaryColor],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
            SizedBox(height: 16),
            Text(
              'ユーザー情報を読み込み中...',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // エラー時のヘッダー
  Widget _buildErrorHeader(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.red[300]!, Colors.red[700]!],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 48),
            const SizedBox(height: 16),
            Text(
              'ユーザー情報の取得に失敗しました',
              style: GoogleFonts.notoSans(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // スタイリッシュなメニューアイテム
  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      decoration: BoxDecoration(
        color:
            isSelected
                ? AppTheme.primaryColor.withAlpha(isDarkMode ? 38 : 25)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              // アイコン
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? AppTheme.primaryColor
                          : isDarkMode
                          ? Colors.grey[800]
                          : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color:
                      isSelected
                          ? Colors.white
                          : isDarkMode
                          ? Colors.white70
                          : Colors.grey[700],
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),

              // タイトル
              Text(
                title,
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color:
                      isSelected
                          ? AppTheme.primaryColor
                          : isDarkMode
                          ? Colors.white
                          : Colors.black87,
                ),
              ),

              const Spacer(),

              // 選択インジケーター
              if (isSelected)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
