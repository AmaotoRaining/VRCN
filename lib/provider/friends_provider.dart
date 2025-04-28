import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/router/app_router.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

// フレンド表示フィルター用の列挙型
enum FriendFilter {
  all, // すべてのフレンド
  online, // オンラインのみ
  offline, // オフラインのみ
}

// 現在のフィルター状態を管理するプロバイダー
final friendFilterProvider = StateProvider<FriendFilter>(
  (ref) => FriendFilter.all,
);

// すべてのフレンドリストを取得するプロバイダー
final friendsProvider = FutureProvider<List<LimitedUser>>((ref) async {
  try {
    // authRefreshProviderを監視してログイン状態の変更を検知
    ref.watch(authRefreshProvider);

    // 認証状態を確認 - ログインしていない場合は空リストを返す
    final authState = await ref.watch(authStateProvider.future);
    if (!authState) {
      debugPrint('ログインしていないため、フレンドリストは空です');
      return [];
    }

    // API取得を確認
    final rawApi = await ref.watch(vrchatRawApiProvider);

    // currentUserを確認（ログイン完了の確実な判断）
    final auth = await ref.watch(vrchatAuthProvider.future);
    if (auth.currentUser == null) {
      debugPrint('現在のユーザー情報がnullです - ログインが完全に完了していません');
      return [];
    }

    final filter = ref.watch(friendFilterProvider);
    List<LimitedUser> allFriends = [];

    // オンラインフレンド取得（filter.all または filter.online の場合）
    if (filter == FriendFilter.all || filter == FriendFilter.online) {
      try {
        List<LimitedUser> onlineFriends = [];
        int offset = 0;
        bool hasMore = true;

        // offsetを使ってすべてのオンラインフレンドを取得
        while (hasMore) {
          final response =
              await rawApi
                  .getFriendsApi()
                  .getFriends(offline: false, n: 100, offset: offset)
                  .validateVrc();

          if (response.success == null) {
            debugPrint('オンラインフレンド取得でnull結果: $response');
            break;
          }

          final batch = response.success!.data;
          onlineFriends.addAll(batch);

          // 100件未満なら終了、そうでなければ次の100件を取得
          if (batch.length < 100) {
            hasMore = false;
          } else {
            offset += 100;
          }
        }

        allFriends.addAll(onlineFriends);
        debugPrint('オンラインフレンド: ${onlineFriends.length}人');
      } catch (e) {
        debugPrint('オンラインフレンド取得エラー: $e');
        // エラーがあっても処理を続行（オフラインフレンドは取得できる可能性あり）
      }
    }

    // オフラインフレンド取得（filter.all または filter.offline の場合）
    if (filter == FriendFilter.all || filter == FriendFilter.offline) {
      try {
        List<LimitedUser> offlineFriends = [];
        int offset = 0;
        bool hasMore = true;

        // offsetを使ってすべてのオフラインフレンドを取得
        while (hasMore) {
          final response =
              await rawApi
                  .getFriendsApi()
                  .getFriends(offline: true, n: 100, offset: offset)
                  .validateVrc();

          if (response.success == null) {
            debugPrint('オフラインフレンド取得でnull結果: $response');
            break;
          }

          final batch = response.success!.data;
          offlineFriends.addAll(batch);

          // 100件未満なら終了、そうでなければ次の100件を取得
          if (batch.length < 100) {
            hasMore = false;
          } else {
            offset += 100;
          }
        }

        allFriends.addAll(offlineFriends);
        debugPrint('オフラインフレンド: ${offlineFriends.length}人');
      } catch (e) {
        debugPrint('オフラインフレンド取得エラー: $e');
      }
    }

    debugPrint('フレンド取得完了: 合計${allFriends.length}人');
    return allFriends;
  } catch (e, stack) {
    debugPrint('フレンドリスト取得中のエラー: $e');
    debugPrint('スタックトレース: $stack');
    rethrow;
  }
});

// 特定のフレンドの詳細情報を取得するプロバイダー
final friendDetailProvider = FutureProvider.family<User, String>((
  ref,
  userId,
) async {
  final rawApi = await ref.watch(vrchatRawApiProvider);
  final response = await rawApi.getUsersApi().getUser(userId: userId);
  return response.data!;
});

// 現在のユーザー（自分自身）の情報を取得するプロバイダー
final currentUserProvider = FutureProvider<CurrentUser>((ref) async {
  final auth = await ref.watch(vrchatAuthProvider.future);
  final currentUser = auth.currentUser;
  if (currentUser == null) {
    throw Exception('ユーザー情報を取得できませんでした');
  }
  return currentUser;
});

