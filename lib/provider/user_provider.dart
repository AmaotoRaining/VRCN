import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

final vrchatUserProvider = FutureProvider((ref) async {
  try {
    final rawApi = await ref.watch(vrchatRawApiProvider);
    return rawApi.getUsersApi();
  } catch (e) {
    throw Exception('UserAPIの初期化に失敗しました: $e');
  }
});

// 特定のユーザーの詳細情報を取得するプロバイダー
final userDetailProvider = FutureProvider.family<User, String>((
  ref,
  userId,
) async {
  final usersApi = await ref.watch(vrchatUserProvider.future);
  try {
    final response = await usersApi.getUser(userId: userId);

    if (response.data == null) {
      throw Exception('ユーザーデータが取得できませんでした: $userId');
    }
    return response.data!;
  } catch (e) {
    throw Exception('ユーザー情報の取得に失敗しました: $e');
  }
});

// ユーザー検索パラメータクラス
@immutable
class UserSearchParams {
  final String? search;
  final int? n;
  final int? offset;

  const UserSearchParams({
    this.search,
    this.n = 60,
    this.offset = 0,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserSearchParams &&
        other.search == search &&
        other.n == n &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(search,  n, offset);
}

// ユーザー検索プロバイダー
final userSearchProvider =
    FutureProvider.family<List<LimitedUser>, UserSearchParams>((
      ref,
      params,
    ) async {
      final usersApi = await ref.watch(vrchatUserProvider.future);

      try {
        final response = await usersApi.searchUsers(
          search: params.search,
          n: params.n,
          offset: params.offset,
        );

        if (response.data == null) {
          return [];
        }
        return response.data!;
      } catch (e) {
        throw Exception('ユーザー検索に失敗しました: $e');
      }
    });
