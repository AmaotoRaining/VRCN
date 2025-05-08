import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vrchat/pages/search_page.dart';
import 'package:vrchat/provider/navigation_provider.dart';
import 'package:vrchat/provider/notification_provider.dart';
import 'package:vrchat/provider/search_providers.dart';
import 'package:vrchat/widgets/app_bar.dart';
import 'package:vrchat/widgets/app_drawer.dart';
import 'package:vrchat/widgets/friend_sort_dialog.dart';

class Navigation extends ConsumerWidget {
  final Widget child;
  final int currentIndex;

  // 検索ページへのアクセス用のキー
  final searchPageKey = GlobalKey<SearchPageState>();

  Navigation({super.key, required this.child, required this.currentIndex});

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
        // SearchPageのコントローラーを取得
        final searchController = TextEditingController();
        final searchPageController = SearchPage.of(context);

        // 検索ページの初回表示時にコントローラーに現在の検索クエリをセット
        searchController.text = ref.read(searchQueryProvider);

        return CustomAppBar(
          showSearchBar: true,
          searchController:
              searchPageController?.searchController ?? searchController,
          onSearchChanged: (query) {
            if (searchPageController != null) {
              searchPageController.onSearchChanged(query);
            } else {
              // すべてのタブのオフセットをリセット
              ref.read(userSearchOffsetProvider.notifier).state = 0;
              ref.read(worldSearchOffsetProvider.notifier).state = 0;
              ref.read(avatarSearchOffsetProvider.notifier).state = 0;
              ref.read(groupSearchOffsetProvider.notifier).state = 0;
              // 検索クエリを更新
              ref.read(searchQueryProvider.notifier).state = query;
            }
          },
          searchHint: '検索',
          onAvatarPressed: () => scaffoldKey.currentState?.openDrawer(),
          actions: const [
            // IconButton(
            //   icon: const Icon(Icons.filter_list),
            //   tooltip: 'フィルター',
            //   onPressed: () {
            //     // フィルター機能
            //   },
            // ),
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
                // 通知をすべて既読にする
                ref.read(notificationsProvider.notifier).markAllAsRead();

                // フィードバックを表示
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('すべての通知を既読にしました'),
                    duration: Duration(seconds: 2),
                  ),
                );
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
              _buildNavItem(
                context,
                0,
                Icons.home_outlined,
                Icons.home,
                isDarkMode,
                ref,
              ),
              _buildNavItem(
                context,
                1,
                Icons.search_outlined,
                Icons.search,
                isDarkMode,
                ref,
              ),
              _buildNavItem(
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

  Widget _buildNavItem(
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
          case 1:
            destination = '/search';
          case 2:
            destination = '/notifications';
          default:
            destination = '/';
        }

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
