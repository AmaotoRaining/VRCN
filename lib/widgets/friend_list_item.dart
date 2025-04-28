import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class FriendListItem extends ConsumerWidget {
  final LimitedUser friend;
  final VoidCallback onTap;

  const FriendListItem({super.key, required this.friend, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // VRChat APIのインスタンスから User-Agent を取得
    final vrchatApi = ref.watch(vrchatProvider).value;
    // User-Agent ヘッダーの定義
    final Map<String, String> headers = {
      'User-Agent': vrchatApi?.userAgent.toString() ?? 'VRChat/1.0',
    };

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // プロフィール画像にUser-Agentヘッダーを適用
              CircleAvatar(
                radius: 30,
                backgroundImage:
                    friend.currentAvatarThumbnailImageUrl != null
                        ? CachedNetworkImageProvider(
                          friend.currentAvatarThumbnailImageUrl!,
                          headers: headers, // User-Agentヘッダーを追加
                        )
                        : null,
                backgroundColor:
                    friend.currentAvatarThumbnailImageUrl == null
                        ? Colors.grey[200]
                        : null,
                child:
                    friend.currentAvatarThumbnailImageUrl == null
                        ? const Icon(Icons.person, size: 30, color: Colors.grey)
                        : null,
              ),
              const SizedBox(width: 16),
              // ユーザー情報（変更なし）
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friend.displayName,
                      style: GoogleFonts.notoSans(fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildStatusIndicator(friend.status),
                        const SizedBox(width: 8),
                        Text(
                          _getStatusText(friend.status),
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(UserStatus? status) {
    Color color;
    switch (status) {
      case UserStatus.active:
        color = Colors.green;
        break;
      case UserStatus.joinMe:
        color = Colors.blue;
        break;
      case UserStatus.askMe:
        color = Colors.orange;
        break;
      case UserStatus.busy:
        color = Colors.red;
        break;
      case UserStatus.offline:
      default:
        color = Colors.grey;
        break;
    }

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  String _getStatusText(UserStatus? status) {
    switch (status) {
      case UserStatus.active:
        return 'オンライン';
      case UserStatus.joinMe:
        return 'だれでもおいで';
      case UserStatus.askMe:
        return 'きいてみてね';
      case UserStatus.busy:
        return '取り込み中';
      case UserStatus.offline:
        return 'オフライン';
      default:
        return 'ステータス不明';
    }
  }
}
