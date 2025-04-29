import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/friends_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/widgets/app_drawer.dart';
import 'package:vrchat/widgets/error_container.dart';
import 'package:vrchat/widgets/friend_list_item.dart';
import 'package:vrchat/widgets/loading_indicator.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class FriendsPage extends ConsumerWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsProvider);
    ref.watch(friendFilterProvider);

    final currentUserAsync = ref.watch(currentUserProvider);

    final vrchatApi = ref.watch(vrchatProvider).value;
    final headers = {
      'User-Agent': vrchatApi?.userAgent.toString() ?? 'VRChat/1.0',
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: CircleAvatar(
          backgroundImage: AssetImage("assets/images/default.png"),
        ),

        leading: Builder(
          builder:
              (context) => currentUserAsync.when(
                data:
                    (currentUser) => IconButton(
                      icon: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey[300],
                        backgroundImage:
                            currentUser
                                    .currentAvatarThumbnailImageUrl
                                    .isNotEmpty
                                ? CachedNetworkImageProvider(
                                  currentUser.currentAvatarThumbnailImageUrl,
                                  headers: headers,
                                )
                                : const AssetImage("assets/images/default.png")
                                    as ImageProvider,
                      ),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      tooltip:
                          MaterialLocalizations.of(
                            context,
                          ).openAppDrawerTooltip,
                    ),
                loading:
                    () => IconButton(
                      icon: const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                error:
                    (_, __) => IconButton(
                      icon: const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey,
                        backgroundImage: AssetImage(
                          "assets/images/default.png",
                        ),
                      ),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
              ),
        ),
      ),
      drawer: const AppDrawer(),
      body: friendsAsync.when(
        data: (friends) => _buildFriendsList(context, friends),
        loading: () => const LoadingIndicator(message: 'フレンド情報を読み込み中...'),
        error:
            (error, stackTrace) => ErrorContainer(
              message: 'フレンドの情報の取得に失敗しました: ${error.toString()}',
              onRetry: () => ref.refresh(friendsProvider),
            ),
      ),
    );
  }

  Widget _buildFriendsList(BuildContext context, List<LimitedUser> friends) {
    if (friends.isEmpty) {
      return Center(
        child: Text(
          'フレンドが見つかりませんでした',
          style: GoogleFonts.notoSans(fontSize: 16),
        ),
      );
    }

    // RefreshIndicatorでListViewをラップして、スワイプで更新機能を追加
    return RefreshIndicator(
      // 更新時の処理
      onRefresh: () async {
        // friendsProviderを再読み込み
        await Future.delayed(const Duration(milliseconds: 300));
        ProviderScope.containerOf(context).refresh(friendsProvider);
      },
      // 色をテーマに合わせる
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      // スワイプ時のストロークの幅
      strokeWidth: 2.5,
      // 子要素のListView
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(), // スクロール可能にする
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final friend = friends[index];
          return FriendListItem(
            friend: friend,
            onTap: () => context.push('/friends/${friend.id}'),
          );
        },
      ),
    );
  }
}
