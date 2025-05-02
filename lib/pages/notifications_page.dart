import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return _buildEmptyNotifications(isDarkMode);
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
