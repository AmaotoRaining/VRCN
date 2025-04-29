import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/friend_sort_provider.dart';
import 'package:vrchat/provider/friends_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/provider/world_provider.dart';
import 'package:vrchat/widgets/app_drawer.dart';
import 'package:vrchat/widgets/error_container.dart';
import 'package:vrchat/widgets/friend_list_item.dart';
import 'package:vrchat/widgets/friend_location_group.dart';
import 'package:vrchat/widgets/loading_indicator.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class FriendsPage extends ConsumerWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsProvider);
    ref.watch(friendFilterProvider);
    // 並び替え状態を監視
    final sortType = ref.watch(friendSortTypeProvider);
    final sortDirection = ref.watch(friendSortDirectionProvider);

    // グループ表示の設定を取得（デフォルトはtrue）
    final groupByLocation = ref.watch(groupByLocationProvider);

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
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        actions: [
          // グループ表示切り替えボタン
          IconButton(
            icon: Icon(
              groupByLocation ? Icons.grid_view : Icons.view_list,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            tooltip: groupByLocation ? 'グループ表示' : 'リスト表示',
            onPressed: () {
              ref.read(groupByLocationProvider.notifier).state =
                  !groupByLocation;
            },
          ),
          // 並び替えボタン
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: '並び替え',
            onPressed: () => _showSortOptions(context, ref),
          ),
        ],
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
        data: (friends) {
          // 並び替えたフレンドリストを使用
          final sortedFriends = _sortFriends(friends, sortType, sortDirection);
          return _buildFriendsList(
            context,
            sortedFriends,
            groupByLocation,
            ref,
          );
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

  // 並び替えオプションを表示するダイアログ
  void _showSortOptions(BuildContext context, WidgetRef ref) {
    // ローカル変数を用意して即時の状態更新を可能にする
    var localSortType = ref.read(friendSortTypeProvider);
    var localDirection = ref.read(friendSortDirectionProvider);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '並び替え',
                      style: GoogleFonts.notoSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // 並び替え種類
                  ListTile(
                    leading: const Icon(Icons.circle),
                    title: Text('オンライン状態順', style: GoogleFonts.notoSans()),
                    trailing:
                        localSortType == FriendSortType.status
                            ? const Icon(Icons.check)
                            : null,
                    onTap: () {
                      // プロバイダーを更新
                      ref
                          .read(friendSortTypeProvider.notifier)
                          .setSortType(FriendSortType.status);
                      // ローカル変数も更新
                      setState(() {
                        localSortType = FriendSortType.status;
                      });
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.sort_by_alpha),
                    title: Text('名前順', style: GoogleFonts.notoSans()),
                    trailing:
                        localSortType == FriendSortType.name
                            ? const Icon(Icons.check)
                            : null,
                    onTap: () {
                      ref
                          .read(friendSortTypeProvider.notifier)
                          .setSortType(FriendSortType.name);
                      setState(() {
                        localSortType = FriendSortType.name;
                      });
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text('最終ログイン順', style: GoogleFonts.notoSans()),
                    trailing:
                        localSortType == FriendSortType.lastLogin
                            ? const Icon(Icons.check)
                            : null,
                    onTap: () {
                      ref
                          .read(friendSortTypeProvider.notifier)
                          .setSortType(FriendSortType.lastLogin);
                      setState(() {
                        localSortType = FriendSortType.lastLogin;
                      });
                    },
                  ),

                  const Divider(),

                  // 昇順・降順
                  ListTile(
                    leading: Icon(
                      localDirection == SortDirection.ascending
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                    ),
                    title: Text(
                      localDirection == SortDirection.ascending ? '昇順' : '降順',
                      style: GoogleFonts.notoSans(),
                    ),
                    onTap: () {
                      final newDirection =
                          localDirection == SortDirection.ascending
                              ? SortDirection.descending
                              : SortDirection.ascending;
                      ref
                          .read(friendSortDirectionProvider.notifier)
                          .setDirection(newDirection);
                      setState(() {
                        localDirection = newDirection;
                      });
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: Text('閉じる', style: GoogleFonts.notoSans()),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// ローカルでフレンドリストを並び替える
  List<LimitedUser> _sortFriends(
    List<LimitedUser> friends,
    FriendSortType sortType,
    SortDirection direction,
  ) {
    List<LimitedUser> sortedList = List.from(friends);

    switch (sortType) {
      case FriendSortType.status:
        // オンライン状態でソート
        sortedList.sort((a, b) {
          final weightA = _getStatusWeight(a.status);
          final weightB = _getStatusWeight(b.status);
          final comparison = weightB.compareTo(weightA);
          return direction == SortDirection.ascending
              ? comparison
              : -comparison;
        });
        break;

      case FriendSortType.name:
        // 名前でソート
        sortedList.sort((a, b) {
          final comparison = a.displayName.compareTo(b.displayName);
          return direction == SortDirection.ascending
              ? comparison
              : -comparison;
        });
        break;

      case FriendSortType.lastLogin:
        // 最終ログイン順でソート
        sortedList.sort((a, b) {
          final lastLoginA =
              a.lastLogin ?? DateTime.fromMillisecondsSinceEpoch(0);
          final lastLoginB =
              b.lastLogin ?? DateTime.fromMillisecondsSinceEpoch(0);
          final comparison = lastLoginB.compareTo(lastLoginA);
          return direction == SortDirection.ascending
              ? comparison
              : -comparison;
        });
        break;
    }

    return sortedList;
  }

  // オンライン状態の重み付け（ソート用）
  int _getStatusWeight(UserStatus? status) {
    if (status == null) return 0;

    switch (status) {
      case UserStatus.joinMe:
        return 5;
      case UserStatus.active:
        return 3;
      case UserStatus.askMe:
        return 2;
      case UserStatus.busy:
        return 1;
      default:
        return 0;
    }
  }

  Widget _buildFriendsList(
    BuildContext context,
    List<LimitedUser> friends,
    bool groupByLocation,
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
        await Future.delayed(const Duration(milliseconds: 300));
        ProviderScope.containerOf(context).refresh(friendsProvider);
      },
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      strokeWidth: 2.5,
      child:
          groupByLocation
              ? _buildGroupedFriendsList(context, friends, ref)
              : _buildSimpleFriendsList(context, friends),
    );
  }

  // シンプルなリスト表示（従来の表示方法）
  Widget _buildSimpleFriendsList(
    BuildContext context,
    List<LimitedUser> friends,
  ) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return FriendListItem(
          friend: friend,
          onTap: () => context.push('/friends/${friend.id}'),
        );
      },
    );
  }

  // ロケーションでグループ化したリスト表示（新機能）
  Widget _buildGroupedFriendsList(
    BuildContext context,
    List<LimitedUser> friends,
    WidgetRef ref,
  ) {
    // フレンドをロケーションごとにグループ化
    final Map<String, List<LimitedUser>> friendGroups = {};

    // オンライン/オフラインでまず大きく分ける
    final List<LimitedUser> offlineFriends = [];
    final List<LimitedUser> privateFriends = [];
    final List<LimitedUser> onlineFriends = [];

    for (final friend in friends) {
      if (friend.location == null || friend.location == 'offline') {
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

    // ワールド情報の事前取得（同じロケーションにいるフレンドが多い場合に効率的）
    for (final location in friendGroups.keys) {
      if (location.startsWith('wrld_')) {
        final worldId = location.split(':').first;
        ref.read(worldDetailProvider(worldId));
      }
    }

    // 人数の多い順にグループをソート
    final sortedLocations =
        friendGroups.keys.toList()..sort(
          (a, b) => friendGroups[b]!.length.compareTo(friendGroups[a]!.length),
        );

    // グループ化したフレンドリストを構築
    final List<Widget> groupWidgets = [];

    // オンラインワールドグループを人数順に表示（パブリックグループ）
    for (final location in sortedLocations) {
      final locationFriends = friendGroups[location]!;

      groupWidgets.add(
        FriendLocationGroup(
          locationName: location,
          locationIcon: Icons.public,
          friends: locationFriends,
          onTapFriend: (friend) => context.push('/friends/${friend.id}'),
          iconColor: Colors.green,
          // ワールド情報プロバイダーを渡す（世界名を表示するため）
          worldId:
              location.startsWith('wrld_') ? location.split(':').first : null,
          isOffline: false,
          compact: false, // コンパクトモードをオフに
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
          onTapFriend: (friend) => context.push('/friends/${friend.id}'),
          iconColor: Colors.redAccent,
          isPrivate: true,
          compact: false, // コンパクトモードをオフに
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
          onTapFriend: (friend) => context.push('/friends/${friend.id}'),
          iconColor: Colors.grey,
          isOffline: true,
          compact: false, // コンパクトモードをオフに
        ),
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: groupWidgets,
    );
  }
}

// グループ表示を切り替えるためのプロバイダー
final groupByLocationProvider = StateProvider<bool>((ref) => true);
