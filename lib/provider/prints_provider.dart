import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

final vrchatPrintProvider = FutureProvider((ref) async {
  final rawApi = await ref.watch(vrchatRawApiProvider);
  return rawApi.getPrintsApi();
});

// プリント取得プロバイダー
final getPrintProvider = FutureProvider.family<Print, String>((
  ref,
  printId,
) async {
  final printApi = await ref.watch(vrchatPrintProvider.future);

  try {
    final response = await printApi.getPrint(printId: printId);

    if (response.data == null) {
      throw Exception('プリントの取得結果がnullでした');
    }

    return response.data!;
  } catch (e) {
    throw Exception('プリントの取得に失敗しました: $e');
  }
});

// ユーザーのプリント一覧を取得するプロバイダー
final getUserPrintsProvider = FutureProvider.family<List<Print>, String>((
  ref,
  userId,
) async {
  final printApi = await ref.watch(vrchatPrintProvider.future);

  try {
    final response = await printApi.getUserPrints(userId: userId);

    if (response.data == null) {
      return []; // データがない場合は空リストを返す
    }

    return response.data!;
  } catch (e) {
    throw Exception('ユーザーのプリント一覧の取得に失敗しました: $e');
  }
});

// プリント削除プロバイダー
final deletePrintProvider = FutureProvider.family<void, String>((
  ref,
  printId,
) async {
  final printApi = await ref.watch(vrchatPrintProvider.future);

  try {
    await printApi.deletePrint(printId: printId);
  } catch (e) {
    throw Exception('プリントの削除に失敗しました: $e');
  }
});

// プリント編集用のパラメータクラス
@immutable
class EditPrintParams {
  final String printId;
  final dio.MultipartFile image;
  final String? note;

  const EditPrintParams({
    required this.printId,
    required this.image,
    this.note,
  });
}

// プリント編集プロバイダー
final editPrintProvider = FutureProvider.family<Print, EditPrintParams>((
  ref,
  params,
) async {
  final printApi = await ref.watch(vrchatPrintProvider.future);

  try {
    final response = await printApi.editPrint(
      printId: params.printId,
      image: params.image,
      note: params.note,
    );

    if (response.data == null) {
      throw Exception('プリントの編集結果がnullでした');
    }

    return response.data!;
  } catch (e) {
    throw Exception('プリントの編集に失敗しました: $e');
  }
});

// プリントアップロード用のパラメータクラス
@immutable
class UploadPrintParams {
  final dio.MultipartFile image;
  final DateTime timestamp;
  final String? note;
  final String? worldId;
  final String? worldName;

  const UploadPrintParams({
    required this.image,
    required this.timestamp,
    this.note,
    this.worldId,
    this.worldName,
  });
}

// プリントアップロードプロバイダー
final uploadPrintProvider = FutureProvider.family<Print, UploadPrintParams>((
  ref,
  params,
) async {
  final printApi = await ref.watch(vrchatPrintProvider.future);

  try {
    final response = await printApi.uploadPrint(
      image: params.image,
      timestamp: params.timestamp,
      note: params.note,
      worldId: params.worldId,
      worldName: params.worldName,
    );

    if (response.data == null) {
      throw Exception('プリントのアップロード結果がnullでした');
    }

    return response.data!;
  } catch (e) {
    throw Exception('プリントのアップロードに失敗しました: $e');
  }
});
