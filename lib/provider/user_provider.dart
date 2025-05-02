import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';

final vrchatUserProvider = FutureProvider((ref) async {
  try {
    final rawApi = await ref.watch(vrchatRawApiProvider);
    return rawApi.getUsersApi();
  } catch (e) {
    throw Exception('UserAPIの初期化に失敗しました: $e');
  }
});
