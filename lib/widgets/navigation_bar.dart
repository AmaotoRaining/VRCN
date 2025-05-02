import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vrchat/provider/navigation_provider.dart';
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
    final scaffoldKey = ref.watch(scaffoldKeyProvider);

    return Scaffold(
      key: scaffoldKey,
      appBar: _buildAppBarForPage(context, scaffoldKey, ref),
      drawer: const AppDrawer(),
      body: SafeArea(top: true, bottom: false, child: child),
      bottomNavigationBar: _buildTwitterStyleNavBar(context, isDarkMode, ref),
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

  Widget _buildTwitterStyleNavBar(
    BuildContext context,
    bool isDarkMode,
    WidgetRef ref,
  ) {
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
                ref,
              ),
              _buildTwitterNavItem(
                context,
                1,
                Icons.search_outlined,
                Icons.search,
                isDarkMode,
                ref,
              ),
              _buildTwitterNavItem(
                context,
                2,
                Icons.notifications_none_outlined,
                Icons.notifications,
                isDarkMode,
                ref,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTwitterNavItem(
    BuildContext context,
    int index,
    IconData icon,
    IconData activeIcon,
    bool isDarkMode,
    WidgetRef ref,
  ) {
    final isActive = currentIndex == index;

    const twitterBlue = Color(0xFF1DA1F2);
    const activeColor = twitterBlue;
    final inactiveColor = isDarkMode ? Colors.grey[600] : Colors.grey[700];

    return InkWell(
      onTap: () {
        if (currentIndex == index) return;

        // インデックスを更新
        ref.read(navigationIndexProvider.notifier).state = index;

        final router = GoRouter.of(context);
        final String destination;

        // 遷移先の設定
        switch (index) {
          case 0:
            destination = '/';
            break; // breakを追加
          case 1:
            destination = '/search';
            break; // breakを追加
          case 2:
            destination = '/notifications';
            break; // breakを追加
          default:
            destination = '/';
            break; // breakを追加
        }

        // extraパラメータを使わずに単純に遷移
        router.go(destination);
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
