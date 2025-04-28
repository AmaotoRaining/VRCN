import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

final vrchatWorldProvider = FutureProvider((ref) async {
  final rawApi = await ref.watch(vrchatRawApiProvider);
  return rawApi.getWorldsApi();
});

// ワールド情報
final worldDetailProvider = FutureProvider.family<World, String>((
  ref,
  worldId,
) async {
  final worldsApi = ref.watch(vrchatWorldProvider).value;
  if (worldsApi == null) {
    throw Exception('ワールド情報を取得できませんでした');
  }
  final response = await worldsApi.getWorld(worldId: worldId);
  return response.data!;
});
