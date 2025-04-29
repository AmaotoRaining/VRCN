import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/friends_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/provider/world_provider.dart';
import 'package:vrchat/utils/status_helpers.dart';
import 'package:vrchat/utils/user_type_helpers.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class FriendListItem extends ConsumerWidget {
  final LimitedUser friend;
  final VoidCallback onTap;

  const FriendListItem({super.key, required this.friend, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // VRChat APIのインスタンスから User-Agent を取得
    final vrchatApi = ref.watch(vrchatProvider).value;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // User-Agent ヘッダーの定義
    final Map<String, String> headers = {
      'User-Agent': vrchatApi?.userAgent.toString() ?? 'VRChat/1.0',
    };

    final statusColor = StatusHelper.getStatusColor(friend.status);
    final userTypeColor = UserTypeHelper.getUserTypeColor(friend.tags);

    // friend.idを使ってUserの詳細情報を取得（オンラインの場合のみ）
    final userDetailAsync =
        (friend.location != 'offline' && friend.location != 'private')
            ? ref.watch(friendDetailProvider(friend.id))
            : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withAlpha(13),
            isDarkMode ? Colors.black12 : Colors.white,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: statusColor.withAlpha(77), width: 1.0),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: statusColor.withAlpha(179),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: statusColor.withAlpha(51),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundImage:
                            friend.userIcon != null &&
                                    friend.userIcon!.isNotEmpty
                                ? CachedNetworkImageProvider(
                                  friend.userIcon!,
                                  headers: headers,
                                )
                                : (friend.currentAvatarThumbnailImageUrl != null
                                    ? CachedNetworkImageProvider(
                                      friend.currentAvatarThumbnailImageUrl!,
                                      headers: headers,
                                    )
                                    : null),
                        backgroundColor:
                            (friend.userIcon == null ||
                                        friend.userIcon!.isEmpty) &&
                                    friend.currentAvatarThumbnailImageUrl ==
                                        null
                                ? Colors.grey[300]
                                : null,
                        child:
                            (friend.userIcon == null ||
                                        friend.userIcon!.isEmpty) &&
                                    friend.currentAvatarThumbnailImageUrl ==
                                        null
                                ? const Icon(
                                  Icons.person,
                                  size: 20,
                                  color: Colors.grey,
                                )
                                : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDarkMode ? Colors.black : Colors.white,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(26),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        friend.displayName,
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.1,
                          color: userTypeColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (friend.statusDescription.isNotEmpty == true) ...[
                        const SizedBox(height: 2),
                        Text(
                          friend.statusDescription,
                          style: GoogleFonts.notoSans(
                            fontSize: 12,
                            color:
                                isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      if (friend.location != 'offline' &&
                          friend.location != null) ...[
                        const SizedBox(height: 2),

                        if (friend.location == 'private') ...[
                          Row(
                            children: [
                              Icon(
                                Icons.lock_outline,
                                size: 12,
                                color:
                                    isDarkMode
                                        ? Colors.red[300]
                                        : Colors.red[700],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'プライベート',
                                style: GoogleFonts.notoSans(
                                  fontSize: 12,
                                  color:
                                      isDarkMode
                                          ? Colors.red[300]
                                          : Colors.red[700],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ] else if (userDetailAsync != null) ...[
                          userDetailAsync.when(
                            data: (userDetail) {
                              final worldDetailAsync =
                                  userDetail.worldId != null
                                      ? ref.watch(
                                        worldDetailProvider(
                                          userDetail.worldId!,
                                        ),
                                      )
                                      : null;

                              if (worldDetailAsync != null) {
                                return worldDetailAsync.when(
                                  data:
                                      (worldInfo) => Row(
                                        children: [
                                          Icon(
                                            Icons.public,
                                            size: 12,
                                            color:
                                                isDarkMode
                                                    ? Colors.green[300]
                                                    : Colors.green[700],
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              worldInfo.name,
                                              style: GoogleFonts.notoSans(
                                                fontSize: 12,
                                                color:
                                                    isDarkMode
                                                        ? Colors.green[300]
                                                        : Colors.green[700],
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                  loading:
                                      () => Row(
                                        children: [
                                          SizedBox(
                                            width: 12,
                                            height: 12,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color:
                                                  isDarkMode
                                                      ? Colors.grey[400]
                                                      : Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'ワールド情報を取得中...',
                                            style: GoogleFonts.notoSans(
                                              fontSize: 12,
                                              color:
                                                  isDarkMode
                                                      ? Colors.grey[400]
                                                      : Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                  error:
                                      (_, __) => Text(
                                        userDetail.worldId ?? 'Unknown world',
                                        style: GoogleFonts.notoSans(
                                          fontSize: 12,
                                          color:
                                              isDarkMode
                                                  ? Colors.amber[300]
                                                  : Colors.amber[700],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                );
                              } else {
                                return Text(
                                  'オンライン (ワールド情報なし)',
                                  style: GoogleFonts.notoSans(
                                    fontSize: 12,
                                    color:
                                        isDarkMode
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                );
                              }
                            },
                            loading:
                                () => Row(
                                  children: [
                                    SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color:
                                            isDarkMode
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'ユーザー情報を取得中...',
                                      style: GoogleFonts.notoSans(
                                        fontSize: 12,
                                        color:
                                            isDarkMode
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                            error:
                                (_, __) => Text(
                                  friend.location ?? 'Unknown location',
                                  style: GoogleFonts.notoSans(
                                    fontSize: 12,
                                    color:
                                        isDarkMode
                                            ? Colors.red[300]
                                            : Colors.red[700],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                          ),
                        ] else ...[
                          Text(
                            friend.location ?? 'Unknown location',
                            style: GoogleFonts.notoSans(
                              fontSize: 12,
                              color:
                                  isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
