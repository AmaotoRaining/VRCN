import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

// 検索クエリを管理するためのプロバイダー
final searchQueryProvider = StateProvider<String>((ref) => '');

// 検索中状態を管理するプロバイダー
final searchingProvider = StateProvider<bool>((ref) => false);

// 検索オフセットを各タブ用に分離
final userSearchOffsetProvider = StateProvider<int>((ref) => 0);
final worldSearchOffsetProvider = StateProvider<int>((ref) => 0);
final avatarSearchOffsetProvider = StateProvider<int>((ref) => 0);
final groupSearchOffsetProvider = StateProvider<int>((ref) => 0);

// 検索結果キャッシュを保持するためのプロバイダー
final worldSearchResultsProvider = StateProvider<List<LimitedWorld>>(
  (ref) => [],
);
final userSearchResultsProvider = StateProvider<List<LimitedUser>>((ref) => []);
final groupSearchResultsProvider = StateProvider<List<LimitedGroup>>(
  (ref) => [],
);

// 検索ページの状態にアクセスするためのGlobalKey
final searchPageKeyProvider = Provider((ref) => GlobalKey());
