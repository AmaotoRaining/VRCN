import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

final vrchatWorldProvider = FutureProvider((ref) async {
  try {
    final rawApi = await ref.watch(vrchatRawApiProvider);
    return rawApi.getWorldsApi();
  } catch (e) {
    throw Exception('WorldsAPIの初期化に失敗しました: $e');
  }
});

// ワールド情報
final worldDetailProvider = FutureProvider.family<World, String>((
  ref,
  worldId,
) async {
  final worldsApi = await ref.watch(vrchatWorldProvider.future);

  try {
    final response = await worldsApi.getWorld(worldId: worldId);
    if (response.data == null) {
      throw Exception('ワールドデータが取得できませんでした: $worldId');
    }
    return response.data!;
  } catch (e) {
    throw Exception('ワールド情報の取得に失敗しました: $e');
  }
});
