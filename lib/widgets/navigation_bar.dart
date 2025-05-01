import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vrchat/widgets/app_bar.dart';
import 'package:vrchat/widgets/app_drawer.dart';
import 'package:vrchat/widgets/friend_sort_dialog.dart';

class Navigation extends ConsumerWidget {
  final Widget child;
  final int currentIndex;

  const Navigation({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: _buildAppBarForPage(context, scaffoldKey, ref),
      drawer: const AppDrawer(),
      body: SafeArea(top: true, bottom: false, child: child),
      bottomNavigationBar: _buildTwitterStyleNavBar(context, isDarkMode),
    );
  }

  PreferredSizeWidget _buildAppBarForPage(
    BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
    WidgetRef ref,
  ) {
    switch (currentIndex) {
      case 0:
        return CustomAppBar(
          onAvatarPressed: () => scaffoldKey.currentState?.openDrawer(),
          actions: [
            IconButton(
              icon: const Icon(Icons.sort),
              tooltip: '並び替え',
              onPressed: () {
                // フレンド一覧の並び替えダイアログを表示
                showFriendSortOptions(context, ref);
              },
            ),
          ],
        );
      case 1:
        return CustomAppBar(
          title: '検索',
          onAvatarPressed: () => scaffoldKey.currentState?.openDrawer(),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              tooltip: 'フィルター',
              onPressed: () {
                // フィルター機能
              },
            ),
          ],
        );
      case 2:
        return CustomAppBar(
          title: '通知',
          onAvatarPressed: () => scaffoldKey.currentState?.openDrawer(),
          actions: [
            IconButton(
              icon: const Icon(Icons.done_all),
              tooltip: 'すべて既読にする',
              onPressed: () {
                // 全て既読にする機能
              },
            ),
          ],
        );
      default:
        return CustomAppBar(
          title: 'VRChat',
          onAvatarPressed: () => scaffoldKey.currentState?.openDrawer(),
        );
    }
  }


  // Twitterスタイルのナビゲーションバー構築
  Widget _buildTwitterStyleNavBar(BuildContext context, bool isDarkMode) {
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final borderColor = isDarkMode ? Colors.grey[900] : Colors.grey[200];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(top: BorderSide(color: borderColor!, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTwitterNavItem(
                context,
                0,
                Icons.people_outline,
                Icons.people,
                isDarkMode,
              ),
              _buildTwitterNavItem(
                context,
                1,
                Icons.search_outlined,
                Icons.search,
                isDarkMode,
              ),
              _buildTwitterNavItem(
                context,
                2,
                Icons.notifications_none_outlined,
                Icons.notifications,
                isDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ナビゲーションアイテム構築
  Widget _buildTwitterNavItem(
    BuildContext context,
    int index,
    IconData icon,
    IconData activeIcon,
    bool isDarkMode,
  ) {
    final isActive = currentIndex == index;

    const twitterBlue = Color(0xFF1DA1F2);
    const activeColor = twitterBlue;
    final inactiveColor = isDarkMode ? Colors.grey[600] : Colors.grey[700];

    return InkWell(
      onTap: () {
        if (currentIndex == index) return; // 現在のタブをタップした場合は何もしない

        final router = GoRouter.of(context);
        final String destination;

        switch (index) {
          case 0:
            destination = '/';
          case 1:
            destination = '/search';
          case 2:
            destination = '/notifications';
          default:
            destination = '/';
        }

        // アニメーションなしでページ遷移
        router.routerDelegate.navigatorKey.currentState?.pushReplacement(
          PageRouteBuilder(
            settings: RouteSettings(name: destination),
            pageBuilder: (context, animation, secondaryAnimation) {
              // GoRouterの内部状態を更新
              router.go(destination);
              // この部分は実際には表示されない（GoRouterが処理するため）
              return const SizedBox.shrink();
            },
            transitionDuration: Duration.zero,
          ),
        );
      },
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? activeColor : inactiveColor,
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}
