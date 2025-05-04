import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

final vrchatFavoriteProvider = FutureProvider((ref) async {
  final rawApi = await ref.watch(vrchatRawApiProvider);
  return rawApi.getFavoritesApi();
});

// お気に入りの検索パラメータを定義
@immutable
class FavoriteSearchParams {
  final int? n;
  final int? offset;
  final String? type;
  final String? tag;

  const FavoriteSearchParams({this.n = 100, this.offset, this.type, this.tag});

  // パラメータの比較用
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteSearchParams &&
        other.n == n &&
        other.offset == offset &&
        other.type == type &&
        other.tag == tag;
  }

  @override
  int get hashCode => Object.hash(n, offset, type, tag);
}

// お気に入り一覧を取得するプロバイダー
final favoritesListProvider =
    FutureProvider.family<List<Favorite>, FavoriteSearchParams>((
      ref,
      params,
    ) async {
      final favoriteApi = ref.watch(vrchatFavoriteProvider).value;
      if (favoriteApi == null) {
        throw Exception('お気に入りAPIを初期化できませんでした');
      }

      try {
        final response = await favoriteApi.getFavorites(
          n: params.n,
          offset: params.offset,
          type: params.type,
          tag: params.tag,
        );

        if (response.data == null) {
          return []; // データがない場合は空リストを返す
        }

        return response.data!;
      } catch (e) {
        throw Exception('お気に入りの取得に失敗しました: $e');
      }
    });

// お気に入りの種類を定義する列挙型（使いやすさ向上）
enum FavoriteType { world, friend, avatar }

// 列挙型を文字列に変換する拡張メソッド
extension FavoriteTypeExtension on FavoriteType {
  String get value {
    switch (this) {
      case FavoriteType.world:
        return 'world';
      case FavoriteType.friend:
        return 'friend';
      case FavoriteType.avatar:
        return 'avatar';
    }
  }
}

// タイプ別にお気に入りを簡単に取得するヘルパープロバイダー
final typedFavoritesProvider =
    FutureProvider.family<List<Favorite>, FavoriteType>((ref, type) {
      final params = FavoriteSearchParams(type: type.value);
      return ref.watch(favoritesListProvider(params).future);
    });

// すべてのお気に入りを再帰的に取得するプロバイダー
final allFavoritesProvider =
    FutureProvider.family<List<Favorite>, FavoriteType>((ref, type) async {
      final favoriteApi = ref.watch(vrchatFavoriteProvider).value;
      if (favoriteApi == null) {
        throw Exception('お気に入りAPIを初期化できませんでした');
      }

      final allFavorites = <Favorite>[];
      var offset = 0;
      var hasMore = true;

      // すべてのページを取得するまで繰り返し
      while (hasMore) {
        try {
          final response = await favoriteApi.getFavorites(
            n: 100, // 最大数
            offset: offset,
            type: type.value,
          );

          if (response.data == null || response.data!.isEmpty) {
            hasMore = false;
          } else {
            allFavorites.addAll(response.data!);
            offset += response.data!.length;

            // 取得数が100未満ならこれ以上のデータはない
            if (response.data!.length < 100) {
              hasMore = false;
            }

            // デバッグ情報
            debugPrint('${type.value}のお気に入りを$offset件取得中...');
          }
        } catch (e) {
          throw Exception('お気に入りの取得に失敗しました: $e');
        }
      }

      debugPrint('${type.value}のお気に入りを合計${allFavorites.length}件取得しました');
      return allFavorites;
    });

// お気に入りアバターを全件取得するプロバイダー
final favoriteAvatarsProvider = FutureProvider<List<Favorite>>((ref) {
  return ref.watch(allFavoritesProvider(FavoriteType.avatar).future);
});

// お気に入りワールドを全件取得するプロバイダー
final favoriteWorldsProvider = FutureProvider<List<Favorite>>((ref) {
  return ref.watch(allFavoritesProvider(FavoriteType.world).future);
});

// お気に入りフレンドを全件取得するプロバイダー
final favoriteFriendsProvider = FutureProvider<List<Favorite>>((ref) {
  return ref.watch(allFavoritesProvider(FavoriteType.friend).future);
});

// お気に入りグループの検索パラメータを定義
@immutable
class FavoriteGroupSearchParams {
  final int? n;
  final int? offset;
  final String? ownerId;

  const FavoriteGroupSearchParams({
    this.n = 60, // デフォルト値は60件
    this.offset,
    this.ownerId, // 省略時は自分自身のお気に入りグループを取得
  });

  // パラメータの比較用
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteGroupSearchParams &&
        other.n == n &&
        other.offset == offset &&
        other.ownerId == ownerId;
  }

  @override
  int get hashCode => Object.hash(n, offset, ownerId);
}

// お気に入りグループ一覧を取得するプロバイダー
final favoriteGroupsListProvider =
    FutureProvider.family<List<FavoriteGroup>, FavoriteGroupSearchParams>((
      ref,
      params,
    ) async {
      final favoriteApi = ref.watch(vrchatFavoriteProvider).value;
      if (favoriteApi == null) {
        throw Exception('お気に入りAPIを初期化できませんでした');
      }

      try {
        final response = await favoriteApi.getFavoriteGroups(
          n: params.n,
          offset: params.offset,
          ownerId: params.ownerId,
        );

        if (response.data == null) {
          return []; // データがない場合は空リストを返す
        }

        return response.data!;
      } catch (e) {
        throw Exception('お気に入りグループの取得に失敗しました: $e');
      }
    });

// 自分自身のお気に入りグループを簡単に取得するプロバイダー
final myFavoriteGroupsProvider = FutureProvider<List<FavoriteGroup>>((ref) {
  const params = FavoriteGroupSearchParams(); // デフォルトパラメータ（自分自身）
  return ref.watch(favoriteGroupsListProvider(params).future);
});

// 特定のタイプのお気に入りグループを取得するプロバイダー
final typedFavoriteGroupsProvider =
    FutureProvider.family<List<FavoriteGroup>, FavoriteType>((ref, type) async {
      final allGroups = await ref.watch(myFavoriteGroupsProvider.future);
      // グループタイプでフィルタリング
      return allGroups
          .where((group) => group.type.toString() == type.value)
          .toList();
    });

// お気に入りグループを取得して、そのグループに所属するお気に入りを取得するプロバイダー
final favoritesByGroupIdProvider =
    FutureProvider.family<List<Favorite>, String>((ref, groupId) {
      // グループIDに指定したタグのついたお気に入りを検索
      final params = FavoriteSearchParams(tag: groupId);
      return ref.watch(favoritesListProvider(params).future);
    });
