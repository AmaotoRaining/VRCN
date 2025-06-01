import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/user_provider.dart';
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
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDarkMode
                    ? [const Color(0xFF141E30), const Color(0xFF243B55)]
                    : [Colors.white, const Color(0xFFF5F7FA)],
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(5, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            // ユーザー情報ヘッダー
            currentUserAsync.when(
              data:
                  (user) =>
                      _buildEnhancedHeader(context, user, headers, isDarkMode),
              loading: () => _buildStylishLoadingHeader(context, isDarkMode),
              error:
                  (_, _) => _buildEnhancedErrorHeader(context, ref, isDarkMode),
            ),

            // メニュー項目
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color:
                      isDarkMode
                          ? const Color(0xFF1A1F2C).withValues(alpha: 0.9)
                          : Colors.white.withValues(alpha: 0.9),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(0),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        // メインナビゲーション
                        _buildNavigationSection(
                          context: context,
                          isDarkMode: isDarkMode,
                          items: [
                            _MenuItem(
                              icon: Icons.home_rounded,
                              title: 'ホーム',
                              isSelected:
                                  GoRouterState.of(context).uri.path == '/',
                              onTap: () {
                                context.go('/');
                                Navigator.pop(context);
                              },
                            ),
                            _MenuItem(
                              icon: Icons.person_rounded,
                              title: 'プロフィール',
                              isSelected:
                                  GoRouterState.of(context).uri.path ==
                                  '/profile',
                              onTap: () {
                                context.push('/profile');
                                Navigator.pop(context);
                              },
                            ),
                            _MenuItem(
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
                            _MenuItem(
                              icon: Icons.calendar_month,
                              title: 'イベントカレンダー',
                              isSelected: GoRouterState.of(
                                context,
                              ).uri.path.startsWith('/event_calendar'),
                              onTap: () {
                                context.push('/event_calendar');
                                Navigator.pop(context);
                              },
                            ),
                            // _MenuItem(
                            //   icon: Icons.control_camera,
                            //   title: 'OSCコントローラー',
                            //   isSelected: GoRouterState.of(
                            //     context,
                            //   ).uri.path.startsWith('/osc'),
                            //   onTap: () {
                            //     context.push('/osc');
                            //     Navigator.pop(context);
                            //   },
                            // ),
                          ],
                        ),

                        // コンテンツセクション
                        _buildSectionHeader('コンテンツ', isDarkMode),
                        _buildNavigationSection(
                          context: context,
                          isDarkMode: isDarkMode,
                          items: [
                            _MenuItem(
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
                            _MenuItem(
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
                          ],
                        ),

                        // 設定セクション
                        _buildSectionHeader('その他', isDarkMode),
                        _buildNavigationSection(
                          context: context,
                          isDarkMode: isDarkMode,
                          items: [
                            _MenuItem(
                              icon: Icons.settings_rounded,
                              title: '設定',
                              isSelected:
                                  GoRouterState.of(context).uri.path ==
                                  '/settings',
                              onTap: () {
                                context.push('/settings');
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // セクションヘッダー
  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.notoSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  // ナビゲーションセクション
  Widget _buildNavigationSection({
    required BuildContext context,
    required bool isDarkMode,
    required List<_MenuItem> items,
  }) {
    return Column(
      children:
          items
              .map(
                (item) => _buildAnimatedMenuItem(
                  context: context,
                  icon: item.icon,
                  title: item.title,
                  isSelected: item.isSelected,
                  onTap: item.onTap,
                  isDarkMode: isDarkMode,
                ),
              )
              .toList(),
    );
  }

  // アニメーション付きメニュー項目
  Widget _buildAnimatedMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    const selectedColor = AppTheme.primaryColor;
    final unselectedIconColor =
        isDarkMode ? Colors.grey[400] : Colors.grey[700];
    final unselectedTextColor =
        isDarkMode ? Colors.grey[300] : Colors.grey[800];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color:
            isSelected
                ? selectedColor.withValues(alpha: isDarkMode ? 0.15 : 0.1)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: selectedColor.withValues(alpha: 0.1),
          highlightColor: selectedColor.withValues(alpha: 0.05),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // アイコン（アニメーション付き）
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? selectedColor
                            : isDarkMode
                            ? const Color(0xFF2A3142)
                            : const Color(0xFFF0F3F6),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow:
                        isSelected
                            ? [
                              BoxShadow(
                                color: selectedColor.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                            : null,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : unselectedIconColor,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 16),

                // タイトル（アニメーション付き）
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.notoSans(
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? selectedColor : unselectedTextColor,
                    ),
                  ),
                ),

                // 選択インジケーター
                if (isSelected)
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: selectedColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: selectedColor.withValues(alpha: 0.3),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 強化されたヘッダー
  Widget _buildEnhancedHeader(
    BuildContext context,
    CurrentUser user,
    Map<String, String> headers,
    bool isDarkMode,
  ) {
    final statusColor = StatusHelper.getStatusColor(user.status);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDarkMode
                  ? [const Color(0xFF2A3F54), const Color(0xFF1F2A40)]
                  : [
                    const Color(0xFF5C6BC0).withValues(alpha: 0.15),
                    const Color(0xFF9FA8DA).withValues(alpha: 0.1),
                  ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ユーザーアバター
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withValues(alpha: 0.7),
                          AppTheme.primaryColor.withValues(alpha: 0.3),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor:
                          isDarkMode ? Colors.grey[800] : Colors.grey[200],
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
                          user.currentAvatarThumbnailImageUrl.isEmpty &&
                                  user.userIcon.isEmpty
                              ? Icon(
                                Icons.person,
                                size: 36,
                                color:
                                    isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
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
                        color:
                            isDarkMode ? const Color(0xFF1F2A40) : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ユーザー情報
            Column(
              children: [
                // 表示名
                Text(
                  user.displayName,
                  style: GoogleFonts.notoSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 2),

                // 代名詞
                Text(
                  user.pronouns,
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 2),

                // ユーザーID
                Text(
                  '@${user.username}',
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),

                // ステータスメッセージ
                if (user.statusDescription.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isDarkMode
                              ? Colors.black.withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      user.statusDescription,
                      style: GoogleFonts.notoSans(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // スタイリッシュなローディングヘッダー
  Widget _buildStylishLoadingHeader(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors:
              isDarkMode
                  ? [const Color(0xFF2A3F54), const Color(0xFF1F2A40)]
                  : [
                    AppTheme.primaryColor.withValues(alpha: 0.15),
                    AppTheme.primaryColor.withValues(alpha: 0.05),
                  ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // カスタムローディングアニメーション
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkMode ? Colors.black12 : Colors.white38,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDarkMode ? Colors.white70 : AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'ユーザー情報を読み込み中...',
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // スタイリッシュなエラーヘッダー
  Widget _buildEnhancedErrorHeader(
    BuildContext context,
    WidgetRef ref,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.red[400]!, Colors.red[700]!],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // エラーアイコン（アニメーション風）
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'ユーザー情報の取得に失敗しました',
                style: GoogleFonts.notoSans(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // スタイリッシュなリトライボタン
              ElevatedButton.icon(
                onPressed: () {
                  // プロバイダーをリフレッシュして再取得
                  final refreshedUser = ref.refresh(currentUserProvider);
                  // ユーザー情報が更新されるのを待つ
                  refreshedUser.whenData((_) => {});
                },
                icon: const Icon(Icons.refresh_rounded),
                label: Text('再試行', style: GoogleFonts.notoSans()),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red[700],
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// メニュー項目データクラス
@immutable
class _MenuItem {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });
}
