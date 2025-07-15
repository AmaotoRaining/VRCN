import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

final vrchatFilesProvider = FutureProvider((ref) async {
  final rawApi = await ref.watch(vrchatRawApiProvider);
  return rawApi.getFilesApi();
});

// ファイル検索パラメータクラス
@immutable
class FileSearchParams {
  final String? tag;
  final String? userId;
  final int? n;
  final int? offset;

  const FileSearchParams({this.tag, this.userId, this.n = 60, this.offset = 0});

  // パラメータの比較用
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FileSearchParams &&
        other.tag == tag &&
        other.userId == userId &&
        other.n == n &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(tag, userId, n, offset);
}

// ファイル一覧を取得するプロバイダー
final getFilesProvider = FutureProvider.family<List<File>, FileSearchParams>((
  ref,
  params,
) async {
  final filesApi = await ref.watch(vrchatFilesProvider.future);

  try {
    final response = await filesApi.getFiles(
      tag: params.tag,
      userId: params.userId,
      n: params.n,
      offset: params.offset,
    );

    if (response.data == null) {
      return []; // データがない場合は空リストを返す
    }

    return response.data!;
  } catch (e) {
    throw Exception('ファイル一覧の取得に失敗しました: $e');
  }
});

// 特定のタグのファイルを取得するヘルパープロバイダー
final getFilesByTagProvider = FutureProvider.family<List<File>, String>((
  ref,
  tag,
) {
  final params = FileSearchParams(tag: tag);
  return ref.watch(getFilesProvider(params).future);
});

// アイコンファイルを取得するプロバイダー
final getIconFilesProvider = FutureProvider<List<File>>((ref) {
  return ref.watch(getFilesByTagProvider('icon').future);
});

// ギャラリーファイルを取得するプロバイダー
final getGalleryFilesProvider = FutureProvider<List<File>>((ref) {
  return ref.watch(getFilesByTagProvider('gallery').future);
});

// 絵文字ファイルを取得するプロバイダー
final getEmojiFilesProvider = FutureProvider<List<File>>((ref) {
  return ref.watch(getFilesByTagProvider('emoji').future);
});

// ステッカーファイルを取得するプロバイダー
final getStickerFilesProvider = FutureProvider<List<File>>((ref) {
  return ref.watch(getFilesByTagProvider('sticker').future);
});
