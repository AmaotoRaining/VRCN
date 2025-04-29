import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrchat/provider/friends_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/provider/world_provider.dart';
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
  bool _isInitialized = false;

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
      api.streaming.start();

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
  final String eventType = event.type.toString().split('.').last;

  // イベント受信のログ
  debugPrint('======= VRC EVENT RECEIVED: $eventType =======');

  // イベントタイプ別に詳細を表示
  switch (event.type) {
    case VrcStreamingEventType.friendOnline:
      final friendOnlineEvent = event as FriendOnlineEvent;
      debugPrint('フレンドオンライン: ${friendOnlineEvent.userId}');
      debugPrint('詳細: ${_formatEventDetails(friendOnlineEvent)}');

      ref.read(friendStateUpdaterProvider)(
        friendOnlineEvent.userId,
        isOnline: true,
      );
      break;

    case VrcStreamingEventType.friendOffline:
      final friendOfflineEvent = event as FriendOfflineEvent;
      debugPrint('フレンドオフライン: ${friendOfflineEvent.userId}');
      debugPrint('詳細: ${_formatEventDetails(friendOfflineEvent)}');

      ref.read(friendStateUpdaterProvider)(
        friendOfflineEvent.userId,
        isOnline: false,
      );
      break;

    case VrcStreamingEventType.friendLocation:
      final friendLocationEvent = event as FriendLocationEvent;
      debugPrint('フレンド位置変更: ${friendLocationEvent.userId}');
      debugPrint('ロケーション: ${friendLocationEvent.location}');
      debugPrint('詳細: ${_formatEventDetails(friendLocationEvent)}');

      ref.read(friendLocationUpdaterProvider)(
        friendLocationEvent.userId,
        friendLocationEvent.location ?? 'unknown',
        null,
      );

      if (friendLocationEvent.location != null &&
          friendLocationEvent.location!.startsWith('wrld_')) {
        final worldId = friendLocationEvent.location!.split(':')[0];
        _fetchWorldNameIfNeeded(ref, worldId);
      }
      break;

    case VrcStreamingEventType.friendUpdate:
      final friendUpdateEvent = event as FriendUpdateEvent;
      debugPrint('フレンド情報更新: ${friendUpdateEvent.userId}');
      debugPrint('ステータス: ${friendUpdateEvent.user.status}');
      debugPrint('ステータス説明: ${friendUpdateEvent.user.statusDescription}');
      debugPrint('詳細: ${_formatEventDetails(friendUpdateEvent)}');

      ref.read(friendInfoUpdaterProvider)(
        friendUpdateEvent.userId,
        status: friendUpdateEvent.user.status.toString(),
        statusDescription: friendUpdateEvent.user.statusDescription,
      );
      break;

    case VrcStreamingEventType.friendAdd:
      final friendAddEvent = event as FriendAddEvent;
      debugPrint('フレンド追加: ${friendAddEvent.userId}');
      debugPrint('詳細: ${_formatEventDetails(friendAddEvent)}');

      ref.read(friendAddHandlerProvider)(friendAddEvent.userId);
      break;

    case VrcStreamingEventType.friendDelete:
      final friendDeleteEvent = event as FriendDeleteEvent;
      debugPrint('フレンド削除: ${friendDeleteEvent.userId}');
      debugPrint('詳細: ${_formatEventDetails(friendDeleteEvent)}');

      ref.read(friendDeleteHandlerProvider)(friendDeleteEvent.userId);
      break;

    case VrcStreamingEventType.notificationReceived:
      final notificationEvent = event as NotificationReceivedEvent;
      debugPrint('通知受信: タイプ=${notificationEvent.notification.type}');
      debugPrint('送信者: ${notificationEvent.notification.senderUserId}');
      debugPrint('詳細: ${_formatEventDetails(notificationEvent)}');

      ref.read(notificationHandlerProvider)(notificationEvent.notification);
      break;

    case VrcStreamingEventType.userUpdate:
      debugPrint('ユーザー更新イベント');
      debugPrint('詳細: ${_formatEventDetails(event)}');
      break;

    case VrcStreamingEventType.userLocation:
      debugPrint('ユーザー位置変更イベント');
      debugPrint('詳細: ${_formatEventDetails(event)}');
      break;

    case VrcStreamingEventType.error:
      final errorEvent = event as ErrorEvent;
      debugPrint('エラーイベント: ${errorEvent.message}');
      debugPrint('詳細: ${_formatEventDetails(errorEvent)}');
      break;

    case VrcStreamingEventType.unknown:
      final unknownEvent = event as UnknownEvent;
      debugPrint('不明なイベント');
      debugPrint('生データ: ${unknownEvent.rawString}');
      break;

    default:
      // その他のイベントは詳細をログに記録
      try {
        debugPrint('その他イベント: ${event.type}');
        debugPrint('詳細: ${_formatEventDetails(event)}');
      } catch (e) {
        debugPrint('イベント情報の取得に失敗: $e');
      }
      break;
  }

  debugPrint('=========================================');
}

// イベント詳細をフォーマットして文字列にする
String _formatEventDetails(dynamic event) {
  try {
    // eventをJSONに変換しようとする
    final Map<String, dynamic> eventMap = _eventToMap(event);
    // 整形してJSON文字列に戻す
    return const JsonEncoder.withIndent('  ').convert(eventMap);
  } catch (e) {
    // 変換に失敗した場合は基本的な文字列表現を返す
    return event.toString();
  }
}

// イベントをMap形式に変換する補助メソッド
Map<String, dynamic> _eventToMap(dynamic event) {
  final map = <String, dynamic>{'type': event.type.toString()};

  // イベントタイプごとに必要な情報を追加
  switch (event.type) {
    case VrcStreamingEventType.friendOnline:
      final e = event as FriendOnlineEvent;
      map['userId'] = e.userId;
      break;

    case VrcStreamingEventType.friendOffline:
      final e = event as FriendOfflineEvent;
      map['userId'] = e.userId;
      break;

    case VrcStreamingEventType.friendLocation:
      final e = event as FriendLocationEvent;
      map['userId'] = e.userId;
      map['location'] = e.location;
      break;

    case VrcStreamingEventType.friendUpdate:
      final e = event as FriendUpdateEvent;
      map['userId'] = e.userId;
      map['user'] = {
        'status': e.user.status.toString(),
        'statusDescription': e.user.statusDescription,
        'displayName': e.user.displayName,
        'currentAvatarImageUrl': e.user.currentAvatarImageUrl,
      };
      break;

    case VrcStreamingEventType.notificationReceived:
      final e = event as NotificationReceivedEvent;
      map['notification'] = {
        'id': e.notification.id,
        'type': e.notification.type.toString(),
        'senderUserId': e.notification.senderUserId,
        'receiverUserId': e.notification.receiverUserId,
        'message': e.notification.message,
        'created_at': e.notification.createdAt.toIso8601String(),
      };
      break;

    // その他のイベントタイプも必要に応じて追加
  }

  return map;
}

// ワールド名を必要に応じて取得する補助メソッド
Future<void> _fetchWorldNameIfNeeded(ref, String worldId) async {
  try {
    // 既にキャッシュされているか確認
    final cachedNames = ref.read(worldNamesProvider);
    if (cachedNames.containsKey(worldId)) return;

    // キャッシュにない場合は、ワールド情報を取得
    final vrchatAsync = ref.read(vrchatWorldProvider);
    final api = vrchatAsync.value;
    if (api == null) return;

    // ワールド情報をAPIから取得
    final worldResponse = await api.getWorld(worldId: worldId);
    if (worldResponse.data != null) {
      final world = worldResponse.data!;

      // 取得したワールド情報もログに出力
      debugPrint('ワールド情報取得成功: $worldId');
      debugPrint('ワールド名: ${world.name}');
      debugPrint('作者: ${world.authorName}');
      debugPrint('訪問者数: ${world.visits}');

      // ワールド名をキャッシュに追加
      ref
          .read(worldNamesProvider.notifier)
          .update((state) => {...state, worldId: world.name});
    }
  } catch (e) {
    debugPrint('ワールド情報の取得に失敗: $e');
  }
}
