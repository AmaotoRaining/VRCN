import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

// インスタンス情報のリクエストパラメータ用クラス
class InstanceParams {
  final String worldId;
  final String instanceId;

  const InstanceParams({required this.worldId, required this.instanceId});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InstanceParams &&
        other.worldId == worldId &&
        other.instanceId == instanceId;
  }

  @override
  int get hashCode => worldId.hashCode ^ instanceId.hashCode;
}

final vrchatInstanceProvider = FutureProvider((ref) async {
  final rawApi = await ref.watch(vrchatRawApiProvider);
  return rawApi.getInstancesApi();
});

// インスタンス情報 - パラメータクラスを使用
final instanceDetailProvider = FutureProvider.family<Instance, InstanceParams>((
  ref,
  params,
) async {
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
