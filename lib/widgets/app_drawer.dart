import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/friends_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/theme/app_theme.dart';
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
    final Map<String, String> headers = {
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
            error: (_, __) => _buildErrorHeader(context),
          ),

          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: Container(
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
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'メニュー',
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

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

                      const SizedBox(height: 30),

                      // フィルターセクション
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[850] : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.filter_list_rounded,
                                  size: 20,
                                  color: AppTheme.primaryColor,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'フィルター設定',
                                  style: GoogleFonts.notoSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildStylishFilterRadio(context, ref, isDarkMode),
                          ],
                        ),
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
      padding: const EdgeInsets.only(top: 16, bottom: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryColor, statusColor],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // アバターとステータスアイコン
            Stack(
              children: [
                // プロフィール画像
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        user.currentAvatarThumbnailImageUrl.isNotEmpty
                            ? CachedNetworkImageProvider(
                              user.currentAvatarThumbnailImageUrl,
                              headers: headers,
                            )
                            : null,
                    child:
                        user.currentAvatarThumbnailImageUrl.isEmpty
                            ? const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white70,
                            )
                            : null,
                  ),
                ),

                // ステータスインジケーター
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ユーザー名とステータス
            Text(
              user.displayName,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 8,
                    color: Colors.black.withValues(alpha: 0.3),
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),

            if (user.statusDescription.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                user.statusDescription,
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.9),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
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
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.8),
            AppTheme.primaryColor,
          ],
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
                ? AppTheme.primaryColor.withValues(
                  alpha: isDarkMode ? 0.15 : 0.1,
                )
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
                  decoration: BoxDecoration(
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

  // スタイリッシュなフィルターラジオボタン
  Widget _buildStylishFilterRadio(
    BuildContext context,
    WidgetRef ref,
    bool isDarkMode,
  ) {
    final currentFilter = ref.watch(friendFilterProvider);

    return Column(
      children: [
        _buildFilterOption(
          context: context,
          icon: Icons.people_alt_rounded,
          title: 'すべて表示',
          isSelected: currentFilter == FriendFilter.all,
          isDarkMode: isDarkMode,
          onTap: () {
            ref.read(friendFilterProvider.notifier).state = FriendFilter.all;
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 10),
        _buildFilterOption(
          context: context,
          icon: Icons.wifi_rounded,
          title: 'オンラインのみ',
          isSelected: currentFilter == FriendFilter.online,
          isDarkMode: isDarkMode,
          onTap: () {
            ref.read(friendFilterProvider.notifier).state = FriendFilter.online;
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 10),
        _buildFilterOption(
          context: context,
          icon: Icons.wifi_off_rounded,
          title: 'オフラインのみ',
          isSelected: currentFilter == FriendFilter.offline,
          isDarkMode: isDarkMode,
          onTap: () {
            ref.read(friendFilterProvider.notifier).state =
                FriendFilter.offline;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  // フィルターオプション
  Widget _buildFilterOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool isSelected,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppTheme.primaryColor.withValues(alpha: 0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? AppTheme.primaryColor
                    : isDarkMode
                    ? Colors.grey[700]!
                    : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  isSelected
                      ? AppTheme.primaryColor
                      : isDarkMode
                      ? Colors.grey[400]
                      : Colors.grey[600],
              size: 18,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.notoSans(
                fontSize: 14,
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
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected
                          ? AppTheme.primaryColor
                          : isDarkMode
                          ? Colors.grey[600]!
                          : Colors.grey[400]!,
                  width: 1.5,
                ),
              ),
              child:
                  isSelected
                      ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
