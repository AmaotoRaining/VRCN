import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/friends_provider.dart';
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

    return Scaffold(
      appBar: AppBar(),
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

    return ListView.builder(
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
}
