import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

final vrchatInstanceProvider = FutureProvider((ref) async {
  try {
    final rawApi = await ref.watch(vrchatRawApiProvider);
    return rawApi.getInstancesApi();
  } catch (e) {
    throw Exception('InstanceAPIの初期化に失敗しました: $e');
  }
});

// インスタンスのパラメータを格納するクラス
@immutable
class InstanceParams {
  final String worldId;
  final String instanceId;

  const InstanceParams({required this.worldId, required this.instanceId});

  // インスタンス文字列（location）をパースするファクトリメソッド
  factory InstanceParams.fromLocation(String location) {
    // 基本的な検証
    if (location.isEmpty) {
      throw Exception('空のインスタンス文字列です');
    }

    // 'private'や'offline'などの特殊な場合をハンドリング
    if (location == 'private' || location == 'offline') {
      throw Exception('プライベートまたはオフラインのインスタンスです: $location');
    }

    final parts = location.split(':');
    if (parts.length < 2) {
      throw Exception('無効なインスタンス文字列です: $location');
    }

    final worldId = parts[0];

    // ワールドIDの基本的な検証
    if (!worldId.startsWith('wrld_')) {
      throw Exception('無効なワールドIDです: $worldId');
    }

    // コロン以降をすべてinstanceIdとして扱う（複数のコロンがある場合に対応）
    final instanceId = parts.sublist(1).join(':');

    if (instanceId.isEmpty) {
      throw Exception('インスタンスIDが空です');
    }

    return InstanceParams(worldId: worldId, instanceId: instanceId);
  }

  @override
  String toString() {
    return '$worldId:$instanceId';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InstanceParams &&
        other.worldId == worldId &&
        other.instanceId == instanceId;
  }

  @override
  int get hashCode => Object.hash(worldId, instanceId);
}

// インスタンス情報 - 文字列から直接パース
final instanceDetailProvider = FutureProvider.family<Instance, String>((
  ref,
  location,
) async {
  try {
    // 入力値の検証
    if (location.isEmpty) {
      throw Exception('インスタンス文字列が空です');
    }

    // 特殊なケースのハンドリング
    if (location == 'private' || location == 'offline') {
      throw Exception('プライベートまたはオフラインのインスタンスは取得できません');
    }

    // インスタンス文字列をパース
    final params = InstanceParams.fromLocation(location);

    // APIを取得（.valueではなく.futureを使用）
    final instanceApi = await ref.watch(vrchatInstanceProvider.future);

    debugPrint('インスタンス情報を取得中: ${params.worldId}:${params.instanceId}');

    // APIを使用してインスタンス情報を取得
    final response = await instanceApi.getInstance(
      worldId: params.worldId,
      instanceId: params.instanceId,
    );

    if (response.data == null) {
      throw Exception('インスタンスデータが見つかりません: $location');
    }

    debugPrint('インスタンス情報取得成功: ${response.data!.name}');
    return response.data!;
  } catch (e) {
    debugPrint('インスタンス情報取得エラー: $e');
    if (e is Exception) {
      rethrow;
    }
    throw Exception('インスタンス情報の取得中にエラーが発生しました: $e');
  }
});

// パラメータクラスを直接使用するバージョン
final instanceDetailWithParamsProvider =
    FutureProvider.family<Instance, InstanceParams>((ref, params) async {
      try {
        // APIを取得（.valueではなく.futureを使用）
        final instanceApi = await ref.watch(vrchatInstanceProvider.future);

        debugPrint('インスタンス情報を取得中: ${params.worldId}:${params.instanceId}');

        final response = await instanceApi.getInstance(
          worldId: params.worldId,
          instanceId: params.instanceId,
        );

        if (response.data == null) {
          throw Exception('インスタンスデータが見つかりません: ${params.toString()}');
        }

        debugPrint('インスタンス情報取得成功: ${response.data!.name}');
        return response.data!;
      } catch (e) {
        debugPrint('インスタンス情報取得エラー: $e');
        if (e is Exception) {
          rethrow;
        }
        throw Exception('インスタンス情報の取得中にエラーが発生しました: $e');
      }
    });

// インスタンスの基本情報のみを取得するプロバイダー（軽量版）
final instanceBasicInfoProvider = FutureProvider.family<String?, String>((
  ref,
  location,
) async {
  try {
    if (location.isEmpty || location == 'private' || location == 'offline') {
      return null;
    }

    final params = InstanceParams.fromLocation(location);
    final instance = await ref.watch(instanceDetailProvider(location).future);

    return instance.name;
  } catch (e) {
    // エラーの場合はnullを返す（UI側でハンドリング）
    debugPrint('インスタンス基本情報取得失敗: $e');
    return null;
  }
});

// インスタンスが存在するかどうかをチェックするプロバイダー
final instanceExistsProvider = FutureProvider.family<bool, String>((
  ref,
  location,
) async {
  try {
    if (location.isEmpty || location == 'private' || location == 'offline') {
      return false;
    }

    await ref.watch(instanceDetailProvider(location).future);
    return true;
  } catch (e) {
    debugPrint('インスタンス存在確認失敗: $e');
    return false;
  }
});
