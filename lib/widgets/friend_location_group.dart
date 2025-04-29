import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/world_provider.dart';
import 'package:vrchat/widgets/friend_list_item.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class FriendLocationGroup extends ConsumerWidget {
  final String locationName;
  final IconData locationIcon;
  final List<LimitedUser> friends;
  final Function(LimitedUser) onTapFriend;
  final Color iconColor;
  final String? worldId;
  final bool isOffline;
  final bool isPrivate;
  final bool compact; // コンパクトモード設定を追加

  const FriendLocationGroup({
    Key? key,
    required this.locationName,
    required this.locationIcon,
    required this.friends,
    required this.onTapFriend,
    this.iconColor = Colors.blue,
    this.worldId,
    this.isOffline = false,
    this.isPrivate = false,
    this.compact = false, // デフォルトはコンパクトモードオフ
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[850] : Colors.grey[100];

    // ワールド名を取得（worldIdがあり、プライベートでもオフラインでもない場合）
    final worldNameAsync =
        (!isPrivate && !isOffline && worldId != null)
            ? ref.watch(worldDetailProvider(worldId!))
            : null;

    // ロケーション名（ワールド名があれば表示）
    final displayName =
        worldNameAsync?.maybeWhen(
          data: (world) => world.name,
          orElse: () => locationName,
        ) ??
        locationName;

    // ステータステキスト（プライベート・オフライン・オンラインで表示を変える）
    String statusText;
    if (isPrivate) {
      statusText = '${friends.length}人がプライベート中';
    } else if (isOffline) {
      statusText = '${friends.length}人がオフライン';
    } else {
      statusText = '${friends.length}人が滞在中';
    }

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ), // 標準のマージン
      elevation: 2, // 少し控えめな影に
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ロケーションのヘッダー
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(locationIcon, color: iconColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        statusText,
                        style: GoogleFonts.notoSans(
                          fontSize: 12,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // このロケーションにいるフレンドのリスト
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];
              return FriendListItem(
                friend: friend,
                onTap: () => onTapFriend(friend),
                compact: compact, // 親から受け取ったcompact設定を渡す
              );
            },
          ),
        ],
      ),
    );
  }
}
