import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
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

    // ステータスに基づく色
    final statusColor = StatusHelper.getStatusColor(friend.status);
    StatusHelper.getStatusText(friend.status);

    // ユーザータイプに基づく色
    final userTypeColor = UserTypeHelper.getUserTypeColor(friend.tags);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withValues(alpha: 0.05),
            isDarkMode ? Colors.black12 : Colors.white,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.7),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: statusColor.withValues(alpha: 0.2),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage:
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
                            (friend.userIcon!.isNotEmpty &&
                                    friend.currentAvatarThumbnailImageUrl ==
                                        null)
                                ? Colors.grey[300]
                                : null,
                        child:
                            (friend.userIcon!.isNotEmpty &&
                                    friend.currentAvatarThumbnailImageUrl ==
                                        null)
                                ? const Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.grey,
                                )
                                : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDarkMode ? Colors.black : Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        friend.displayName,
                        style: GoogleFonts.notoSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                          color: userTypeColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      if (friend.statusDescription.isNotEmpty == true) ...[
                        const SizedBox(height: 4),
                        Text(
                          friend.statusDescription,
                          style: GoogleFonts.notoSans(
                            fontSize: 13,
                            color:
                                isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        if (friend.location != "offline" &&
                            friend.location != null) ...[
                          Text(friend.location ?? 'Unknown location'),
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
