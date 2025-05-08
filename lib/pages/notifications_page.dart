import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vrchat/provider/notification_provider.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final notifications = ref.watch(notificationsProvider);

    // 通知がない場合は空の状態を表示
    if (notifications.isEmpty) {
      return Scaffold(body: _buildEmptyNotifications(isDarkMode));
    }

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationItem(notification, index, isDarkMode, ref);
        },
      ),
    );
  }

  Widget _buildNotificationItem(
    NotificationItem notification,
    int index,
    bool isDarkMode,
    WidgetRef ref,
  ) {
    IconData icon;
    Color color;
    String message;

    switch (notification.type) {
      case NotificationType.friendRequest:
        icon = Icons.person_add;
        color = Colors.blue;
        message = '${notification.userName}さんからフレンドリクエストが届いています';
      case NotificationType.invite:
        icon = Icons.insert_invitation;
        color = Colors.green;
        message =
            '${notification.userName}さんから${notification.worldName ?? "ワールド"}への招待が届いています';
      case NotificationType.friendOnline:
        icon = Icons.login;
        color = Colors.amber;
        message = '${notification.userName}さんがオンラインになりました';
      case NotificationType.friendOffline:
        icon = Icons.logout;
        color = Colors.grey;
        message = '${notification.userName}さんがオフラインになりました';
      case NotificationType.friendActive:
        icon = Icons.schedule;
        color = Colors.teal;
        message = '${notification.userName}さんがアクティブになりました';
      case NotificationType.friendAdd:
        icon = Icons.person_add_alt_1;
        color = Colors.indigo;
        message = '${notification.userName}さんがフレンドに追加されました';
      case NotificationType.friendRemove:
        icon = Icons.person_remove;
        color = Colors.red;
        message = '${notification.userName}さんがフレンドから削除されました';
      case NotificationType.statusUpdate:
        icon = Icons.update;
        color = Colors.purple;
        final status = notification.extraData ?? '不明';
        message = '${notification.userName}さんのステータスが更新されました: $status';
        if (notification.worldName != null &&
            notification.worldName!.isNotEmpty) {
          message += ' (${notification.worldName})';
        }
      case NotificationType.locationChange:
        icon = Icons.location_on;
        color = Colors.orange;
        message = '${notification.userName}さんが${notification.worldName}に移動しました';
      case NotificationType.userUpdate:
        icon = Icons.person_outline;
        color = Colors.cyan;
        message = 'あなたの情報が更新されました';
        if (notification.worldName != null &&
            notification.worldName!.isNotEmpty) {
          message += ': ${notification.worldName}';
        }
      case NotificationType.myLocationChange:
        icon = Icons.my_location;
        color = Colors.deepOrange;
        message = 'あなたの移動: ${notification.worldName}';
      case NotificationType.requestInvite:
        icon = Icons.directions_run;
        color = Colors.lightGreen;
        message = '${notification.userName}さんから参加リクエストが届いています';
      case NotificationType.votekick:
        icon = Icons.gavel;
        color = Colors.red;
        message = '${notification.userName}さんから投票キックがありました';
      case NotificationType.responseReceived:
        icon = Icons.feedback;
        color = Colors.blueGrey;
        message = '通知ID:${notification.userName}の応答を受信しました';
      case NotificationType.error:
        icon = Icons.error_outline;
        color = Colors.red;
        message = 'エラー: ${notification.worldName}';
      case NotificationType.system:
        icon = Icons.info_outline;
        color = Colors.grey;
        message = 'システム通知: ${notification.extraData ?? ""}';
    }

    final timeAgo = _getTimeAgo(notification.timestamp);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color:
          notification.isRead
              ? (isDarkMode ? Colors.grey[850] : Colors.white)
              : (isDarkMode ? Colors.grey[800] : Colors.blue[50]),
      child: ListTile(
        onTap: () {
          color.withValues(alpha: .2);
        },
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: .2),
          child: Icon(icon, color: color),
        ),
        title: Text(message),
        subtitle: Text(timeAgo),
        trailing:
            notification.isRead
                ? null
                : Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
      ),
    );
  }

  String _getTimeAgo(DateTime time) {
    final now = DateTime.timestamp();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}秒前';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}時間前';
    } else {
      final formatter = DateFormat('MM/dd HH:mm');
      return formatter.format(time);
    }
  }

  Widget _buildEmptyNotifications(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: isDarkMode ? Colors.grey[700] : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '通知はありません',
            style: GoogleFonts.notoSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'フレンドリクエストや招待など\n新しい通知がここに表示されます',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// 通知タイプ
enum NotificationType {
  friendRequest,
  invite,
  friendOnline,
  friendOffline,
  friendActive,
  friendAdd,
  friendRemove,
  statusUpdate,
  locationChange,
  userUpdate,
  myLocationChange,
  requestInvite,
  votekick,
  responseReceived,
  error,
  system,
}

// 通知アイテムモデル
@immutable
class NotificationItem {
  final NotificationType type;
  final String userName;
  final String? worldName;
  final DateTime timestamp;
  final bool isRead;
  final String? extraData; // 追加情報を保存できるようにする

  const NotificationItem({
    required this.type,
    required this.userName,
    this.worldName,
    required this.timestamp,
    required this.isRead,
    this.extraData,
  });
}
