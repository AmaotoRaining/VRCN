import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/friend_sort_provider.dart';
import 'package:vrchat/provider/friends_provider.dart';
import 'package:vrchat/provider/instance_provider.dart';
import 'package:vrchat/widgets/app_drawer.dart';
import 'package:vrchat/widgets/error_container.dart';
import 'package:vrchat/widgets/friend_location_group.dart';
import 'package:vrchat/widgets/loading_indicator.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class FriendsPage extends ConsumerWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsProvider);
    ref.watch(friendFilterProvider);
    final sortedFriends = ref.watch(sortedFriendsProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      body: friendsAsync.when(
        data: (friends) {
          return _buildFriendsList(context, sortedFriends, ref);
        },
        loading: () => const LoadingIndicator(message: 'フレンド情報を読み込み中...'),
        error:
            (error, stackTrace) => ErrorContainer(
              message: 'フレンドの情報の取得に失敗しました: ${error.toString()}',
              onRetry: () => ref.refresh(friendsProvider),
            ),
      ),
    );
  }

  Widget _buildFriendsList(
    BuildContext context,
    List<LimitedUser> friends,
    WidgetRef ref,
  ) {
    if (friends.isEmpty) {
      return Center(
        child: Text(
          'フレンドが見つかりませんでした',
          style: GoogleFonts.notoSans(fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // 短い遅延後にデータを更新
        await Future.delayed(const Duration(milliseconds: 300));

        // refreshの戻り値を適切に利用
        return await ref.refresh(friendsProvider.future);
      },
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      strokeWidth: 2.5,
      // 常にグループ表示のみを使用
      child: _buildGroupedFriendsList(context, friends, ref),
    );
  }

  // ロケーションでグループ化したリスト表示
  Widget _buildGroupedFriendsList(
    BuildContext context,
    List<LimitedUser> friends,
    WidgetRef ref,
  ) {
    // フレンドをロケーションごとにグループ化
    final friendGroups = <String, List<LimitedUser>>{};

    // オンライン/オフライン/アクティブオフラインでまず大きく分ける
    final offlineFriends = <LimitedUser>[];
    final activeOfflineFriends = <LimitedUser>[]; // アクティブオフライン用のリスト追加
    final privateFriends = <LimitedUser>[];
    final onlineFriends = <LimitedUser>[];

    for (final friend in friends) {
      // locationがofflineでもstatusが設定されている場合はアクティブグループに
      if (friend.location == 'offline' &&
          friend.status != UserStatus.offline &&
          friend.status.toString().isNotEmpty) {
        activeOfflineFriends.add(friend);
      } else if (friend.location == null || friend.location == 'offline') {
        offlineFriends.add(friend);
      } else if (friend.location == 'private') {
        privateFriends.add(friend);
      } else {
        onlineFriends.add(friend);
      }
    }

    // オンラインのフレンドをさらにロケーションごとにグループ化
    for (final friend in onlineFriends) {
      final location = friend.location ?? 'unknown';
      if (!friendGroups.containsKey(location)) {
        friendGroups[location] = [];
      }
      friendGroups[location]!.add(friend);
    }

    // ワールド情報の事前取得
    for (final location in friendGroups.keys) {
      ref.read(instanceDetailProvider(location));
    }

    // 人数の多い順にグループをソート
    final sortedLocations =
        friendGroups.keys.toList()..sort(
          (a, b) => friendGroups[b]!.length.compareTo(friendGroups[a]!.length),
        );

    // グループ化したフレンドリストを構築
    final groupWidgets = <Widget>[];

    // オンラインワールドグループを人数順に表示
    for (final location in sortedLocations) {
      final locationFriends = friendGroups[location]!;

      groupWidgets.add(
        FriendLocationGroup(
          locationName: location,
          locationIcon: Icons.public,
          friends: locationFriends,
          onTapFriend: (friend) => context.push('/user/${friend.id}'),
          iconColor: Colors.green,
          location: location,
          isOffline: false,
          compact: false,
        ),
      );
    }

    // プライベートグループを表示（人数に関わらず、パブリックグループの後に表示）
    if (privateFriends.isNotEmpty) {
      groupWidgets.add(
        FriendLocationGroup(
          locationName: 'プライベート',
          locationIcon: Icons.lock_outline,
          friends: privateFriends,
          onTapFriend: (friend) => context.push('/user/${friend.id}'),
          iconColor: Colors.redAccent,
          isPrivate: true,
          compact: false, // コンパクトモードをオフに
        ),
      );
    }

    // アクティブなオフラインフレンドが存在する場合はプライベートの後に表示
    if (activeOfflineFriends.isNotEmpty) {
      groupWidgets.add(
        FriendLocationGroup(
          locationName: 'アクティブ',
          locationIcon: Icons.circle,
          friends: activeOfflineFriends,
          onTapFriend: (friend) => context.push('/user/${friend.id}'),
          iconColor: Colors.green,
          isOffline: true,
          isActive: true,
          compact: false,
        ),
      );
    }

    // オフラインフレンドが存在する場合は最後に表示
    if (offlineFriends.isNotEmpty) {
      groupWidgets.add(
        FriendLocationGroup(
          locationName: 'オフライン',
          locationIcon: Icons.offline_bolt,
          friends: offlineFriends,
          onTapFriend: (friend) => context.push('/user/${friend.id}'),
          iconColor: Colors.grey,
          isOffline: true,
          compact: false,
        ),
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: groupWidgets,
    );
  }
}
