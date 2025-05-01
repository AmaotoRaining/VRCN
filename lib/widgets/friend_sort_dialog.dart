import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/friend_sort_provider.dart';

/// フレンドリスト並び替えダイアログ
void showFriendSortOptions(BuildContext context, WidgetRef ref) {
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

                // 並び替え方向
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
              ],
            ),
          );
        },
      );
    },
  );
}
