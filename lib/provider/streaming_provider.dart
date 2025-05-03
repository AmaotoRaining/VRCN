import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrchat/provider/friends_provider.dart';
import 'package:vrchat/provider/user_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

// ストリーミング接続の状態を管理するプロバイダー
final streamingStateProvider = StateProvider<bool>((ref) => false);

// ストリーミング接続を管理するクラス用のプロバイダー
final streamingControllerProvider = Provider<StreamingController>((ref) {
  return StreamingController(ref);
});

// ストリーミング接続を制御するクラス
class StreamingController {
  final Ref ref;
  var _isInitialized = false;

  StreamingController(this.ref);

  // ストリーミング接続を開始するメソッド
  Future<void> startConnection() async {
    if (_isInitialized) return;

    final vrchatAsync = ref.read(vrchatProvider);

    // AsyncValueから安全に値を取得
    final api = vrchatAsync.valueOrNull;
    if (api == null) {
      debugPrint('API接続が初期化されていないため、ストリーミングを開始できません');
      return;
    }

    try {
      // すでに接続中なら何もしない
      if (ref.read(streamingStateProvider)) return;

      // イベントリスナーを設定
      api.streaming.vrcEventStream.listen((event) {
        _handleVrcEvent(event, ref);
      });

      // ストリーミング接続を開始
      // api.streaming.start();

      // 接続状態を更新（初期化後なので安全）
      ref.read(streamingStateProvider.notifier).state = true;
      _isInitialized = true;

      debugPrint('VRChatストリーミング接続を開始しました');
    } catch (e) {
      debugPrint('ストリーミング接続の開始に失敗しました: $e');
    }
  }

  // 接続を停止するメソッド
  void stopConnection() {
    final vrchatAsync = ref.read(vrchatProvider);
    final api = vrchatAsync.valueOrNull;
    if (api != null) {
      try {
        api.streaming.stop();
        ref.read(streamingStateProvider.notifier).state = false;
        debugPrint('VRChatストリーミング接続を停止しました');
      } catch (e) {
        debugPrint('ストリーミング接続の停止に失敗しました: $e');
      }
    }
  }
}

// ストリーミングイベントハンドラー
void _handleVrcEvent(VrcStreamingEvent event, ref) {
  final eventType = event.type.toString().split('.').last;

  // イベント受信のログ
  debugPrint('======= VRC EVENT RECEIVED: $eventType =======');

  // イベントタイプ別に詳細を表示
  switch (event.type) {
    case VrcStreamingEventType.friendOnline:
      final friendOnlineEvent = event as FriendOnlineEvent;
      debugPrint('フレンドオンライン: ${friendOnlineEvent.user.displayName}');
      debugPrint('詳細: ${jsonEncode(event)}');

      var friendStateUpdaterProvider;
      ref.read(friendStateUpdaterProvider)(
        friendOnlineEvent.userId,
        isOnline: true,
      );

    case VrcStreamingEventType.friendOffline:
      final friendOfflineEvent = event as FriendOfflineEvent;
      debugPrint('フレンドオフライン: ${friendOfflineEvent.userId}');

      var friendStateUpdaterProvider;
      ref.read(friendStateUpdaterProvider)(
        friendOfflineEvent.userId,
        isOnline: false,
      );

    case VrcStreamingEventType.friendLocation:
      final friendLocationEvent = event as FriendLocationEvent;
      debugPrint('フレンド位置変更: ${friendLocationEvent.user.displayName}');
      debugPrint('ロケーション: ${friendLocationEvent.location}');
      debugPrint('詳細: ${jsonEncode(event)}');

      ref.read(friendLocationUpdaterProvider)(
        friendLocationEvent.userId,
        friendLocationEvent.location ?? 'unknown',
        null,
      );

    case VrcStreamingEventType.friendUpdate:
      final friendUpdateEvent = event as FriendUpdateEvent;
      debugPrint('フレンド情報更新: ${friendUpdateEvent.user.displayName}');
      debugPrint('ステータス: ${friendUpdateEvent.user.status}');
      debugPrint('ステータス説明: ${friendUpdateEvent.user.statusDescription}');
      debugPrint('詳細: ${jsonEncode(event)}');

      ref.read(friendInfoUpdaterProvider)(
        friendUpdateEvent.userId,
        status: friendUpdateEvent.user.status,
        statusDescription: friendUpdateEvent.user.statusDescription,
      );

    case VrcStreamingEventType.friendAdd:
      final friendAddEvent = event as FriendAddEvent;
      debugPrint('フレンド追加: ${friendAddEvent.user.displayName}');
      debugPrint('詳細: ${jsonEncode(event)}');

      ref.read(friendAddHandlerProvider)(friendAddEvent.userId);

    case VrcStreamingEventType.friendDelete:
      final friendDeleteEvent = event as FriendDeleteEvent;
      debugPrint('フレンド削除: ${friendDeleteEvent.userId}');
      debugPrint('詳細: ${jsonEncode(event)}');

      ref.read(friendDeleteHandlerProvider)(friendDeleteEvent.userId);

    case VrcStreamingEventType.notificationReceived:
      final notificationEvent = event as NotificationReceivedEvent;
      debugPrint('通知受信: タイプ=${notificationEvent.notification.type}');
      debugPrint('送信者: ${notificationEvent.notification.senderUserId}');
      debugPrint('詳細: ${jsonEncode(event)}');

      ref.read(notificationHandlerProvider)(notificationEvent.notification);

    case VrcStreamingEventType.userUpdate:
      try {
        final userUpdateEvent = event as UserUpdateEvent;
        debugPrint('ユーザー更新イベント: ${userUpdateEvent.user.displayName}');

        // currentUserProviderの更新が必要な場合はここで実装
        ref.refresh(currentUserProvider);

        // ユーザーのステータス情報を取得
        final status = userUpdateEvent.user.status;
        final statusDescription = userUpdateEvent.user.statusDescription;

        // フレンドリストの更新（自分自身の更新も含む）
        ref.read(friendInfoUpdaterProvider)(
          userUpdateEvent.userId,
          status: status,
          statusDescription: statusDescription,
        );
      } catch (e) {
        debugPrint('UserUpdateEventの処理中にエラーが発生: $e');
        debugPrint('生データ: ${event is UnknownEvent ? event.rawString : "不明"}');
      }

    case VrcStreamingEventType.userLocation:
      try {
        final userLocationEvent = event as UserLocationEvent;

        debugPrint('ユーザー位置変更イベント: ${userLocationEvent.userId}');
        debugPrint('新しい位置: ${userLocationEvent.location}');
      } catch (e) {
        // パースエラーの場合は詳細をログに記録
        debugPrint('UserLocationEventの処理中にエラーが発生: $e');
        debugPrint('生データ: ${event is UnknownEvent ? event.rawString : "不明"}');
      }

    case VrcStreamingEventType.error:
      final errorEvent = event as ErrorEvent;
      debugPrint('エラーイベント: ${errorEvent.message}');
      debugPrint('詳細: ${jsonEncode(event)}');

    case VrcStreamingEventType.unknown:
      final unknownEvent = event as UnknownEvent;
      debugPrint('不明なイベント');
      debugPrint('生データ: ${unknownEvent.rawString}');

    default:
      // その他のイベントタイプが安全に処理できるよう保護
      try {
        debugPrint('その他イベント: ${event.type}');
        if (event is! UnknownEvent) {
          debugPrint('詳細: ${jsonEncode(event)}');
        } else {
          debugPrint('未知のイベント形式: ${event.rawString}');
        }
      } catch (e) {
        debugPrint('イベント処理中にエラーが発生: $e');
      }
  }

  debugPrint('=========================================');
}
