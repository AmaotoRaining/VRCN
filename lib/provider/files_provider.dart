import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat_dart/vrchat_dart.dart' hide Response;

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
      // ignore: deprecated_member_use
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

// プリントファイルを取得するプロバイダー
final getPrintFilesProvider = FutureProvider<List<File>>((ref) {
  return ref.watch(getFilesByTagProvider('print').future);
});

// 画像アップロード用のパラメータクラス
@immutable
class UploadImageParams {
  final MultipartFile file;
  final String tag;
  final int? frames;
  final int? framesOverTime;
  final String? animationStyle;
  final String? maskTag;

  const UploadImageParams({
    required this.file,
    required this.tag,
    this.frames,
    this.framesOverTime,
    this.animationStyle,
    this.maskTag,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UploadImageParams &&
        other.file == file &&
        other.tag == tag &&
        other.frames == frames &&
        other.framesOverTime == framesOverTime &&
        other.animationStyle == animationStyle &&
        other.maskTag == maskTag;
  }

  @override
  int get hashCode =>
      Object.hash(file, tag, frames, framesOverTime, animationStyle, maskTag);
}

// ギャラリー画像アップロード用のパラメータクラス
@immutable
class UploadGalleryImageParams {
  final MultipartFile file;

  const UploadGalleryImageParams({required this.file});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UploadGalleryImageParams && other.file == file;
  }

  @override
  int get hashCode => file.hashCode;
}

// アイコンアップロード用のパラメータクラス
@immutable
class UploadIconParams {
  final MultipartFile file;

  const UploadIconParams({required this.file});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UploadIconParams && other.file == file;
  }

  @override
  int get hashCode => file.hashCode;
}

// 汎用画像アップロードプロバイダー
final uploadImageProvider = FutureProvider.family<File, UploadImageParams>((
  ref,
  params,
) async {
  final filesApi = await ref.watch(vrchatFilesProvider.future);

  try {
    // タグに応じて適切なAPIエンドポイントを呼び出す
    Response<File> response;

    switch (params.tag) {
      case 'gallery':
        // ギャラリー専用エンドポイント
        response = await filesApi.uploadGalleryImage(file: params.file);

      case 'icon':
        // アイコン専用エンドポイント
        response = await filesApi.uploadIcon(file: params.file);

      case 'emoji':
      case 'sticker':
      case 'print':
      default:
        // 汎用エンドポイント（追加パラメータ付き）
        response = await filesApi.uploadImage(
          file: params.file,
          tag: params.tag,
        );
    }

    if (response.data == null) {
      throw Exception('画像のアップロードレスポンスがnullでした');
    }

    // アップロード成功後、対応するファイル一覧を更新
    switch (params.tag) {
      case 'icon':
        ref.invalidate(getIconFilesProvider);
      case 'gallery':
        ref.invalidate(getGalleryFilesProvider);
      case 'emoji':
        ref.invalidate(getEmojiFilesProvider);
      case 'sticker':
        ref.invalidate(getStickerFilesProvider);
      case 'print':
        ref.invalidate(getPrintFilesProvider);
    }

    return response.data!;
  } catch (e) {
    // より詳細なエラー情報を提供
    if (e is DioException) {
      final errorDetails = e.response?.data;
      throw Exception('画像のアップロードに失敗しました: ${e.message} - $errorDetails');
    }
    throw Exception('画像のアップロードに失敗しました: $e');
  }
});

// ギャラリー画像をアップロードするプロバイダー - 修正版
final uploadGalleryImageProvider =
    FutureProvider.family<File, UploadGalleryImageParams>((ref, params) async {
      final filesApi = await ref.watch(vrchatFilesProvider.future);

      try {
        final response = await filesApi.uploadGalleryImage(file: params.file);

        if (response.data == null) {
          throw Exception('ギャラリー画像のアップロードレスポンスがnullでした');
        }

        // アップロード成功後、ギャラリーファイル一覧を更新
        ref.invalidate(getGalleryFilesProvider);

        return response.data!;
      } catch (e) {
        if (e is DioException) {
          final errorDetails = e.response?.data;
          throw Exception(
            'ギャラリー画像のアップロードに失敗しました: ${e.message} - $errorDetails',
          );
        }
        throw Exception('ギャラリー画像のアップロードに失敗しました: $e');
      }
    });

// アイコンをアップロードするプロバイダー
final uploadIconProvider = FutureProvider.family<File, UploadIconParams>((
  ref,
  params,
) async {
  final filesApi = await ref.watch(vrchatFilesProvider.future);

  try {
    final response = await filesApi.uploadIcon(file: params.file);

    if (response.data == null) {
      throw Exception('アイコンのアップロードレスポンスがnullでした');
    }

    // アップロード成功後、アイコンファイル一覧を更新
    ref.invalidate(getIconFilesProvider);

    return response.data!;
  } catch (e) {
    if (e is DioException) {
      final errorDetails = e.response?.data;
      throw Exception('アイコンのアップロードに失敗しました: ${e.message} - $errorDetails');
    }
    throw Exception('アイコンのアップロードに失敗しました: $e');
  }
});

// ファイルパスからMultipartFileを作成するヘルパープロバイダー
final createMultipartFileProvider =
    FutureProvider.family<MultipartFile, String>((ref, filePath) async {
      try {
        // ファイル拡張子を確認してMIMEタイプを設定
        final extension = filePath.split('.').last.toLowerCase();
        String? contentType;

        switch (extension) {
          case 'png':
            contentType = 'image/png';
          case 'jpg':
          case 'jpeg':
            contentType = 'image/jpeg';
          case 'gif':
            contentType = 'image/gif';
          default:
            contentType = 'image/png'; // デフォルトはPNG
        }

        return await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
          contentType: MediaType.parse(contentType),
        );
      } catch (e) {
        throw Exception('ファイルの読み込みに失敗しました: $e');
      }
    });

// 汎用画像アップロード用のパラメータクラス（ファイルパス用）
@immutable
class UploadImageFromPathParams {
  final String filePath;
  final String tag;
  final int? frames;
  final int? framesOverTime;
  final String? animationStyle;
  final String? maskTag;

  const UploadImageFromPathParams({
    required this.filePath,
    required this.tag,
    this.frames,
    this.framesOverTime,
    this.animationStyle,
    this.maskTag,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UploadImageFromPathParams &&
        other.filePath == filePath &&
        other.tag == tag &&
        other.frames == frames &&
        other.framesOverTime == framesOverTime &&
        other.animationStyle == animationStyle &&
        other.maskTag == maskTag;
  }

  @override
  int get hashCode => Object.hash(
    filePath,
    tag,
    frames,
    framesOverTime,
    animationStyle,
    maskTag,
  );
}

// ファイルパスから汎用画像をアップロードするヘルパープロバイダー
final uploadImageFromPathProvider =
    FutureProvider.family<File, UploadImageFromPathParams>((ref, params) async {
      // ファイルパスからMultipartFileを作成
      final multipartFile = await ref.watch(
        createMultipartFileProvider(params.filePath).future,
      );

      // アップロードパラメータを作成
      final uploadParams = UploadImageParams(
        file: multipartFile,
        tag: params.tag,
      );

      // アップロードを実行
      return ref.watch(uploadImageProvider(uploadParams).future);
    });

// 簡単にギャラリー画像をアップロードするヘルパープロバイダー
final uploadGalleryImageFromPathProvider = FutureProvider.family<File, String>((
  ref,
  filePath,
) async {
  // ファイルパスからMultipartFileを作成
  final multipartFile = await ref.watch(
    createMultipartFileProvider(filePath).future,
  );

  // アップロードパラメータを作成
  final params = UploadGalleryImageParams(file: multipartFile);

  // アップロードを実行
  return ref.watch(uploadGalleryImageProvider(params).future);
});

// 簡単にアイコンをアップロードするヘルパープロバイダー
final uploadIconFromPathProvider = FutureProvider.family<File, String>((
  ref,
  filePath,
) async {
  // ファイルパスからMultipartFileを作成
  final multipartFile = await ref.watch(
    createMultipartFileProvider(filePath).future,
  );

  // アップロードパラメータを作成
  final params = UploadIconParams(file: multipartFile);

  // アップロードを実行
  return ref.watch(uploadIconProvider(params).future);
});
