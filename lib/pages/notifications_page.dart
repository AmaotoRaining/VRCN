import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 仮の通知リスト
    final notifications = [
      NotificationItem(
        type: NotificationType.friendRequest,
        userName: 'annobu',
        timestamp: DateTime.timestamp().subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
      NotificationItem(
        type: NotificationType.invite,
        userName: 'kazkiller',
        worldName: 'The Great Pug',
        timestamp: DateTime.timestamp().subtract(const Duration(hours: 1)),
        isRead: true,
      ),
      NotificationItem(
        type: NotificationType.friendOnline,
        userName: 'Miyamoto_',
        timestamp: DateTime.timestamp().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
    ];

    return notifications.isEmpty
        ? _buildEmptyNotifications(isDarkMode)
        : _buildNotificationsList(notifications, isDarkMode);
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

  Widget _buildNotificationsList(
    List<NotificationItem> notifications,
    bool isDarkMode,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationItem(notification, isDarkMode);
      },
    );
  }

  Widget _buildNotificationItem(
    NotificationItem notification,
    bool isDarkMode,
  ) {
    final bgColor =
        isDarkMode
            ? notification.isRead
                ? Colors.transparent
                : Colors.blue.withOpacity(0.1)
            : notification.isRead
            ? Colors.transparent
            : Colors.blue.withOpacity(0.05);

    // アイコン設定
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case NotificationType.friendRequest:
        iconData = Icons.person_add;
        iconColor = Colors.blue;
      case NotificationType.invite:
        iconData = Icons.mail;
        iconColor = Colors.green;
      case NotificationType.friendOnline:
        iconData = Icons.login;
        iconColor = Colors.orange;
    }

    // 通知テキスト作成
    String notificationText;
    switch (notification.type) {
      case NotificationType.friendRequest:
        notificationText = '${notification.userName}さんからフレンドリクエストが届きました';
      case NotificationType.invite:
        notificationText =
            '${notification.userName}さんから${notification.worldName}への招待が届きました';
      case NotificationType.friendOnline:
        notificationText = '${notification.userName}さんがオンラインになりました';
    }

    // 時間表示
    final timeText = _formatTimestamp(notification.timestamp);

    return ColoredBox(
      color: bgColor,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(iconData, color: iconColor),
        ),
        title: Text(
          notificationText,
          style: GoogleFonts.notoSans(
            fontWeight:
                notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Text(
          timeText,
          style: GoogleFonts.notoSans(
            fontSize: 12,
            color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
          ),
        ),
        trailing:
            notification.isRead
                ? null
                : Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
        onTap: () {
          // 通知タップ時の処理
        },
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.timestamp();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}時間前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}日前';
    } else {
      return '${timestamp.month}/${timestamp.day}';
    }
  }
}

// 通知タイプ
enum NotificationType { friendRequest, invite, friendOnline }

// 通知アイテムモデル
@immutable
class NotificationItem {
  final NotificationType type;
  final String userName;
  final String? worldName;
  final DateTime timestamp;
  final bool isRead;

  const NotificationItem({
    required this.type,
    required this.userName,
    this.worldName,
    required this.timestamp,
    required this.isRead,
  });
}
