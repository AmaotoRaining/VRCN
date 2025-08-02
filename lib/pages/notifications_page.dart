import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vrchat/i18n/gen/strings.g.dart';
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
        message = t.notifications.friendRequest(
          userName: notification.userName,
        );
      case NotificationType.invite:
        icon = Icons.insert_invitation;
        color = Colors.green;
        message = t.notifications.invite(
          userName: notification.userName,
          worldName: notification.worldName ?? 'ワールド',
        );
      case NotificationType.friendOnline:
        icon = Icons.login;
        color = Colors.amber;
        message = t.notifications.friendOnline(userName: notification.userName);
      case NotificationType.friendOffline:
        icon = Icons.logout;
        color = Colors.grey;
        message = t.notifications.friendOffline(
          userName: notification.userName,
        );
      case NotificationType.friendActive:
        icon = Icons.schedule;
        color = Colors.teal;
        message = t.notifications.friendActive(userName: notification.userName);
      case NotificationType.friendAdd:
        icon = Icons.person_add_alt_1;
        color = Colors.indigo;
        message = t.notifications.friendAdd(userName: notification.userName);
      case NotificationType.friendRemove:
        icon = Icons.person_remove;
        color = Colors.red;
        message = t.notifications.friendRemove(userName: notification.userName);
      case NotificationType.statusUpdate:
        icon = Icons.update;
        color = Colors.purple;
        final status = notification.extraData ?? t.worldDetail.unknown;
        final world =
            (notification.worldName != null &&
                    notification.worldName!.isNotEmpty)
                ? ' (${notification.worldName})'
                : '';
        message = t.notifications.statusUpdate(
          userName: notification.userName,
          status: status,
          world: world,
        );
      case NotificationType.locationChange:
        icon = Icons.location_on;
        color = Colors.orange;
        message = t.notifications.locationChange(
          userName: notification.userName,
          worldName: notification.worldName ?? t.worldDetail.unknown,
        );
      case NotificationType.userUpdate:
        icon = Icons.person_outline;
        color = Colors.cyan;
        final world =
            (notification.worldName != null &&
                    notification.worldName!.isNotEmpty)
                ? ': ${notification.worldName}'
                : '';
        message = t.notifications.userUpdate(world: world);
      case NotificationType.myLocationChange:
        icon = Icons.my_location;
        color = Colors.deepOrange;
        message = t.notifications.myLocationChange(
          worldName: notification.worldName ?? t.worldDetail.unknown,
        );
      case NotificationType.requestInvite:
        icon = Icons.directions_run;
        color = Colors.lightGreen;
        message = t.notifications.requestInvite(
          userName: notification.userName,
        );
      case NotificationType.votekick:
        icon = Icons.gavel;
        color = Colors.red;
        message = t.notifications.votekick(userName: notification.userName);
      case NotificationType.responseReceived:
        icon = Icons.feedback;
        color = Colors.blueGrey;
        message = t.notifications.responseReceived(
          userName: notification.userName,
        );
      case NotificationType.error:
        icon = Icons.error_outline;
        color = Colors.red;
        message = t.notifications.error(
          worldName: notification.worldName ?? '',
        );
      case NotificationType.system:
        icon = Icons.info_outline;
        color = Colors.grey;
        message = t.notifications.system(
          extraData: notification.extraData ?? '',
        );
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
      return t.notifications.secondsAgo(
        seconds: difference.inSeconds.toString(),
      );
    } else if (difference.inMinutes < 60) {
      return t.notifications.minutesAgo(
        minutes: difference.inMinutes.toString(),
      );
    } else if (difference.inHours < 24) {
      return t.notifications.hoursAgo(hours: difference.inHours.toString());
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
            t.notifications.emptyTitle,
            style: GoogleFonts.notoSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            t.notifications.emptyDescription,
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
