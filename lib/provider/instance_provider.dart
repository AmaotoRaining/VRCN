import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

final vrchatInstanceProvider = FutureProvider((ref) async {
  final rawApi = await ref.watch(vrchatRawApiProvider);
  return rawApi.getInstancesApi();
});

// インスタンスのパラメータを格納するクラス
@immutable
class InstanceParams {
  final String worldId;
  final String instanceId;

  const InstanceParams({required this.worldId, required this.instanceId});

  // インスタンス文字列（location）をパースするファクトリメソッド
  factory InstanceParams.fromLocation(String location) {
    final parts = location.split(':');
    if (parts.length < 2) {
      throw Exception('無効なインスタンス文字列です: $location');
    }

    final worldId = parts[0];
    // コロン以降をすべてinstanceIdとして扱う（複数のコロンがある場合に対応）
    final instanceId = parts.sublist(1).join(':');

    return InstanceParams(worldId: worldId, instanceId: instanceId);
  }

  @override
  String toString() {
    return '$worldId:$instanceId';
  }
}

// インスタンス情報 - 文字列から直接パース
final instanceDetailProvider = FutureProvider.family<Instance, String>((
  ref,
  location,
) async {
  try {
    final instanceApi = ref.watch(vrchatInstanceProvider).value;
    if (instanceApi == null) {
      throw Exception('インスタンス情報を取得できませんでした');
    }

    // インスタンス文字列をパース
    final params = InstanceParams.fromLocation(location);

    // APIを使用してインスタンス情報を取得
    final response = await instanceApi.getInstance(
      worldId: params.worldId,
      instanceId: params.instanceId,
    );

    return response.data!;
  } catch (e) {
    throw Exception('インスタンス情報の取得中にエラーが発生しました: $e');
  }
});

// パラメータクラスを直接使用するバージョン
final instanceDetailWithParamsProvider =
    FutureProvider.family<Instance, InstanceParams>((ref, params) async {
      final instanceApi = ref.watch(vrchatInstanceProvider).value;
      if (instanceApi == null) {
        throw Exception('インスタンス情報を取得できませんでした');
      }

      final response = await instanceApi.getInstance(
        worldId: params.worldId,
        instanceId: params.instanceId,
      );

      return response.data!;
    });
