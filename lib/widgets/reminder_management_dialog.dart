import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vrchat/provider/event_reminder_provider.dart';
import 'package:vrchat/theme/app_theme.dart';

class ReminderManagementDialog extends ConsumerWidget {
  const ReminderManagementDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(eventReminderProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 日付でグループ化
    final remindersByDate = <String, List<EventReminder>>{};
    final dateFormat = DateFormat('yyyy/MM/dd');

    for (final reminder in reminders) {
      final dateKey = dateFormat.format(reminder.eventTime);
      if (!remindersByDate.containsKey(dateKey)) {
        remindersByDate[dateKey] = [];
      }
      remindersByDate[dateKey]!.add(reminder);
    }

    // 日付でソート
    final sortedDates = remindersByDate.keys.toList()..sort();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: 500,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダー
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Icons.notifications_active,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '設定済みリマインダー',
                      style: GoogleFonts.notoSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // リマインダーリスト
            if (reminders.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off_outlined,
                        size: 48,
                        color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '設定済みのリマインダーはありません',
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'イベントページから通知を設定できます',
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          color:
                              isDarkMode ? Colors.grey[500] : Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: sortedDates.length,
                  itemBuilder: (context, index) {
                    final dateKey = sortedDates[index];
                    final dayReminders = remindersByDate[dateKey]!;

                    // 時間でソート
                    dayReminders.sort(
                      (a, b) => a.eventTime.compareTo(b.eventTime),
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 日付ヘッダー
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                          child: Text(
                            dateKey,
                            style: GoogleFonts.notoSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),

                        // リマインダーリスト
                        ...dayReminders.map(
                          (reminder) => _buildReminderItem(
                            context,
                            reminder,
                            isDarkMode,
                            ref,
                          ),
                        ),

                        if (index < sortedDates.length - 1)
                          const Divider(height: 24),
                      ],
                    );
                  },
                ),
              ),

            // 全削除ボタン
            if (reminders.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showClearAllDialog(context, ref);
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: Text('すべてのリマインダーを削除', style: GoogleFonts.notoSans()),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderItem(
    BuildContext context,
    EventReminder reminder,
    bool isDarkMode,
    WidgetRef ref,
  ) {
    final timeFormat = DateFormat('HH:mm');
    final eventTime = timeFormat.format(reminder.eventTime);
    final notificationTime = timeFormat.format(reminder.notificationTime);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        reminder.eventTitle,
        style: GoogleFonts.notoSans(fontWeight: FontWeight.w500),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Icon(
            Icons.access_time,
            size: 12,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            '$eventTime 開始',
            style: GoogleFonts.notoSans(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.notifications, size: 10, color: Colors.blue),
                const SizedBox(width: 2),
                Text(
                  '$notificationTime (${reminder.reminderTime.label})',
                  style: GoogleFonts.notoSans(
                    fontSize: 10,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, size: 20),
        splashRadius: 20,
        color: Colors.red,
        onPressed: () {
          ref
              .read(eventReminderProvider.notifier)
              .removeReminder(reminder.eventId, reminder.reminderTime);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('リマインダーを削除しました'),
              backgroundColor: Colors.red[700],
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'すべてのリマインダーを削除',
              style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
            ),
            content: Text(
              '設定したすべてのイベントリマインダーを削除します。この操作は元に戻せません。',
              style: GoogleFonts.notoSans(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('キャンセル', style: GoogleFonts.notoSans()),
              ),
              TextButton(
                onPressed: () {
                  ref
                      .read(eventReminderProvider.notifier)
                      .cancelAllNotifications();
                  Navigator.pop(context); // 確認ダイアログを閉じる
                  Navigator.pop(context); // 管理ダイアログも閉じる
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('すべてのリマインダーを削除しました'),
                      backgroundColor: Colors.red[700],
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text('削除する', style: GoogleFonts.notoSans()),
              ),
            ],
          ),
    );
  }
}
