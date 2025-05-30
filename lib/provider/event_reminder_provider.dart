import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:vrchat/provider/settings_provider.dart';

// リマインダーの時間オプション
enum ReminderTime {
  fifteenMinutes(15, '15分前'),
  thirtyMinutes(30, '30分前'),
  oneHour(60, '1時間前'),
  threeHours(180, '3時間前'),
  oneDay(1440, '1日前');

  final int minutes;
  final String label;
  const ReminderTime(this.minutes, this.label);
}

// イベントリマインダーモデル
@immutable
class EventReminder {
  final String eventId;
  final String eventTitle;
  final DateTime eventTime;
  final ReminderTime reminderTime;
  final int notificationId;

  const EventReminder({
    required this.eventId,
    required this.eventTitle,
    required this.eventTime,
    required this.reminderTime,
    required this.notificationId,
  });

  DateTime get notificationTime {
    return eventTime.subtract(Duration(minutes: reminderTime.minutes));
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'eventTitle': eventTitle,
      'eventTime': eventTime.millisecondsSinceEpoch,
      'reminderTime': reminderTime.index,
      'notificationId': notificationId,
    };
  }

  factory EventReminder.fromJson(Map<String, dynamic> json) {
    return EventReminder(
      eventId: json['eventId'],
      eventTitle: json['eventTitle'],
      eventTime: DateTime.fromMillisecondsSinceEpoch(json['eventTime']),
      reminderTime: ReminderTime.values[json['reminderTime']],
      notificationId: json['notificationId'],
    );
  }
}

// イベントリマインダー管理クラス
class EventReminderNotifier extends StateNotifier<List<EventReminder>> {
  final SharedPreferences prefs;
  final FlutterLocalNotificationsPlugin notifications;

  EventReminderNotifier(this.prefs, this.notifications) : super([]) {
    _loadReminders();
    _initializeTimezone();
  }

  // タイムゾーンの初期化
  void _initializeTimezone() {
    tz_data.initializeTimeZones();
  }

  // リマインダーをロード
  Future<void> _loadReminders() async {
    final reminderJson = prefs.getStringList('event_reminders') ?? [];
    final reminders =
        reminderJson
            .map((json) => EventReminder.fromJson(jsonDecode(json)))
            .toList();

    // 過去の通知をフィルタリング
    final now = DateTime.timestamp();
    final validReminders =
        reminders.where((reminder) => reminder.eventTime.isAfter(now)).toList();

    // 無効になった通知を削除
    if (validReminders.length != reminders.length) {
      await _saveReminders(validReminders);
    }

    state = validReminders;
  }

  // リマインダーを保存
  Future<void> _saveReminders(List<EventReminder> reminders) async {
    final reminderJson =
        reminders.map((reminder) => jsonEncode(reminder.toJson())).toList();
    await prefs.setStringList('event_reminders', reminderJson);
  }

  // 新しいリマインダーを追加
  Future<void> addReminder(EventReminder reminder) async {
    // 重複チェック
    if (state.any(
      (r) =>
          r.eventId == reminder.eventId &&
          r.reminderTime == reminder.reminderTime,
    )) {
      return;
    }

    // 通知をスケジュール
    await _scheduleNotification(reminder);

    // 状態を更新
    final newState = [...state, reminder];
    state = newState;
    await _saveReminders(newState);
  }

  // リマインダーを削除
  Future<void> removeReminder(
    String eventId,
    ReminderTime? reminderTime,
  ) async {
    final remindersToRemove =
        state
            .where(
              (r) =>
                  r.eventId == eventId &&
                  (reminderTime == null || r.reminderTime == reminderTime),
            )
            .toList();

    // 通知をキャンセル
    for (final reminder in remindersToRemove) {
      await notifications.cancel(reminder.notificationId);
    }

    // 状態を更新
    final newState =
        state
            .where(
              (r) =>
                  !(r.eventId == eventId &&
                      (reminderTime == null || r.reminderTime == reminderTime)),
            )
            .toList();

    state = newState;
    await _saveReminders(newState);
  }

  // イベントの通知をスケジュール
  Future<void> _scheduleNotification(EventReminder reminder) async {
    final notificationTime = reminder.notificationTime;

    // 過去の時間の場合はスケジュールしない
    if (notificationTime.isBefore(DateTime.timestamp())) {
      debugPrint('通知をスキップ: 過去の時間のため - ${reminder.eventTitle}');
      return;
    }

    try {
      // 通知の詳細を設定
      const androidDetails = AndroidNotificationDetails(
        'event_reminder_channel',
        'イベントリマインダー',
        channelDescription: 'VRChatのイベント開始前の通知',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'イベントリマインダー',
        color: Colors.purple,
        sound: RawResourceAndroidNotificationSound('notification_sound'),
        enableVibration: true,
        enableLights: true,
        visibility: NotificationVisibility.public,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'notification_sound.aiff',
        badgeNumber: 1,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      debugPrint(
        '通知をスケジュール: 「${reminder.eventTitle}」${reminder.reminderTime.label} - ${notificationTime.toString()}',
      );

      // サンプルコードに従って修正
      await notifications.zonedSchedule(
        reminder.notificationId,
        'イベント開始まもなく',
        '「${reminder.eventTitle}」が${reminder.reminderTime.label}に始まります',
        tz.TZDateTime.from(notificationTime, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      debugPrint('通知スケジュール成功: ID=${reminder.notificationId}');
    } catch (e) {
      debugPrint('通知スケジュールエラー: $e');
    }
  }

  // すべてのリマインダーを再スケジュール（アプリ起動時などに使用）
  Future<void> rescheduleAllNotifications() async {
    // すべての通知をキャンセル
    await notifications.cancelAll();

    // 現在の時刻より後の通知だけを再スケジュール
    final now = DateTime.timestamp();
    for (final reminder in state) {
      if (reminder.notificationTime.isAfter(now)) {
        await _scheduleNotification(reminder);
      }
    }
  }

  // イベントIDに関連するすべてのリマインダーを取得
  List<EventReminder> getRemindersForEvent(String eventId) {
    return state.where((r) => r.eventId == eventId).toList();
  }

  // すべての通知をキャンセル
  Future<void> cancelAllNotifications() async {
    try {
      await notifications.cancelAll();
      debugPrint('すべての通知をキャンセルしました');
    } catch (e) {
      debugPrint('通知キャンセルエラー: $e');
    }
  }

  // テスト通知を即時送信するメソッド
  Future<bool> sendImmediateTestNotification() async {
    try {
      // 基本的な通知設定
      const androidDetails = AndroidNotificationDetails(
        'test_channel',
        'テスト通知',
        channelDescription: 'デバッグ用のテスト通知',
        importance: Importance.high,
        priority: Priority.high,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // 即時通知を送信
      await notifications.show(
        999999, // テスト用ID
        'テスト通知',
        'これはテスト通知です (${DateTime.timestamp().toString()})',
        notificationDetails,
      );

      debugPrint('テスト通知を送信しました');
      return true;
    } catch (e) {
      debugPrint('テスト通知エラー: $e');
      return false;
    }
  }
}

// プロバイダー
final eventReminderProvider =
    StateNotifierProvider<EventReminderNotifier, List<EventReminder>>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      final notifications = FlutterLocalNotificationsPlugin();
      return EventReminderNotifier(prefs, notifications);
    });

// 通知IDを生成するヘルパー関数
int generateNotificationId(String eventId, ReminderTime reminderTime) {
  // 衝突しにくいようにハッシュとインデックスを組み合わせる
  return eventId.hashCode + reminderTime.index;
}
