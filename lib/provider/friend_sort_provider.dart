import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrchat/provider/settings_provider.dart';

// 並び替えの種類を定義
enum FriendSortType {
  status,   // オンライン状態順
  name,     // 名前順
  lastLogin // 最終ログイン順
}

// 並び替えの方向を定義
enum SortDirection {
  ascending,  // 昇順
  descending  // 降順
}

// 現在の並び替え種類を管理するプロバイダー
final friendSortTypeProvider = StateNotifierProvider<FriendSortTypeNotifier, FriendSortType>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FriendSortTypeNotifier(prefs);
});

// 並び替えの方向を管理するプロバイダー
final friendSortDirectionProvider = StateNotifierProvider<FriendSortDirectionNotifier, SortDirection>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FriendSortDirectionNotifier(prefs);
});

// 並び替え種類の状態管理クラス
class FriendSortTypeNotifier extends StateNotifier<FriendSortType> {
  final SharedPreferences _prefs;
  static const _key = 'friend_sort_type';

  FriendSortTypeNotifier(this._prefs)
      : super(_getSavedSortType(_prefs));

  static FriendSortType _getSavedSortType(SharedPreferences prefs) {
    final index = prefs.getInt(_key) ?? 0;
    return FriendSortType.values[index];
  }

  void setSortType(FriendSortType type) {
    _prefs.setInt(_key, type.index);
    state = type;
  }
}

// 並び替え方向の状態管理クラス
class FriendSortDirectionNotifier extends StateNotifier<SortDirection> {
  final SharedPreferences _prefs;
  static const _key = 'friend_sort_direction';

  FriendSortDirectionNotifier(this._prefs)
      : super(_getSavedDirection(_prefs));

  static SortDirection _getSavedDirection(SharedPreferences prefs) {
    final index = prefs.getInt(_key) ?? 0;
    return SortDirection.values[index];
  }

  void setDirection(SortDirection direction) {
    _prefs.setInt(_key, direction.index);
    state = direction;
  }
}
