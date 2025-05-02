import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/provider/world_provider.dart';
import 'package:vrchat/widgets/friend_list_item.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class FriendLocationGroup extends ConsumerWidget {
  final String locationName;
  final String? worldId;
  final List<LimitedUser> friends;
  final Function(LimitedUser) onTapFriend;
  final IconData locationIcon;
  final Color iconColor;
  final bool isOffline;
  final bool isPrivate;
  final bool isTraveling;
  final String? travelingToWorldId;
  final bool compact;
  final bool isActive; // 追加: オフラインでもアクティブなユーザー用フラグ

  const FriendLocationGroup({
    super.key,
    required this.locationName,
    this.worldId,
    required this.friends,
    required this.onTapFriend,
    required this.locationIcon,
    required this.iconColor,
    this.isOffline = false,
    this.isPrivate = false,
    this.isTraveling = false,
    this.travelingToWorldId,
    this.compact = false,
    this.isActive = false, // 追加: デフォルトはfalse
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[850] : Colors.grey[100];

    // VRChat APIのインスタンスからヘッダー情報を取得
    final vrchatApi = ref.watch(vrchatProvider).value;
    final headers = <String, String>{
      'User-Agent': vrchatApi?.userAgent.toString() ?? 'VRChat/1.0',
    };

    // 使用するワールドIDを決定
    final effectiveWorldId = isTraveling ? travelingToWorldId : worldId;

    // ワールド情報を取得
    final worldNameAsync =
        (!isPrivate && !isOffline && effectiveWorldId != null)
            ? ref.watch(worldDetailProvider(effectiveWorldId))
            : null;

    // ワールド情報の展開
    var displayName = locationName;
    String? thumbnailUrl;

    worldNameAsync?.whenData((world) {
      displayName = world.name;
      thumbnailUrl = world.thumbnailImageUrl;
    });

    // ステータステキスト
    String statusText;
    if (isPrivate) {
      statusText = '${friends.length}人がプライベート中';
    } else if (isOffline && isActive) {
      statusText = '${friends.length}人がアクティブ'; // アクティブなオフラインユーザー
    } else if (isOffline) {
      statusText = '${friends.length}人がオフライン';
    } else if (isTraveling) {
      statusText = '${friends.length}人が移動中';
    } else {
      statusText = '${friends.length}人が滞在中';
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ヘッダー部分（ワールド情報とサムネイル）
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
                // ワールドアイコンまたはサムネイル
                if (thumbnailUrl != null && !isPrivate && !isOffline) ...[
                  // ワールドサムネイル表示
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: CachedNetworkImage(
                        imageUrl: thumbnailUrl!,
                        httpHeaders: headers,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => Container(
                              color:
                                  isDarkMode
                                      ? Colors.grey[700]
                                      : Colors.grey[300],
                              child: const Icon(
                                Icons.image,
                                color: Colors.white54,
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              color:
                                  isDarkMode
                                      ? Colors.grey[700]
                                      : Colors.grey[300],
                              child: Icon(locationIcon, color: iconColor),
                            ),
                      ),
                    ),
                  ),
                ] else ...[
                  // 通常のアイコン表示
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          (isActive && isOffline)
                              ? Colors.green.withOpacity(
                                0.1,
                              ) // アクティブなオフラインユーザー用の色
                              : iconColor.withOpacity(0.1),
                    ),
                    child: Icon(
                      (isActive && isOffline)
                          ? Icons.circle
                          : locationIcon, // アクティブなオフラインユーザー用のアイコン
                      color: (isActive && isOffline) ? Colors.green : iconColor,
                      size: 20,
                    ),
                  ),
                ],

                const SizedBox(width: 12),

                // ワールド名と人数
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ワールド名をタップ可能にする
                      InkWell(
                        onTap: () {
                          // ワールドIDが有効かつプライベートではない場合のみ詳細画面に飛ぶ
                          if (effectiveWorldId != null &&
                              !isPrivate &&
                              !isOffline) {
                            context.push('/worlds/$effectiveWorldId');
                          }
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                displayName,
                                style: GoogleFonts.notoSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      (isActive && isOffline)
                                          ? Colors
                                              .green
                                              .shade700 // アクティブなオフラインユーザー用の色
                                          : null,
                                  decorationColor: Colors.green.withOpacity(
                                    0.7,
                                  ),
                                  decorationThickness: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // ナビゲート可能な場合は矢印アイコンも表示
                            if (effectiveWorldId != null &&
                                !isPrivate &&
                                !isOffline)
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color:
                                    isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                              ),
                          ],
                        ),
                      ),
                      Text(
                        statusText,
                        style: GoogleFonts.notoSans(
                          fontSize: 12,
                          color:
                              (isActive && isOffline)
                                  ? Colors.green.withOpacity(
                                    0.8,
                                  ) // アクティブなオフラインユーザー用の色
                                  : (isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // フレンドリスト部分
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];
              return FriendListItem(
                friend: friend,
                onTap: () => onTapFriend(friend),
                compact: compact,
              );
            },
          ),
        ],
      ),
    );
  }
}
