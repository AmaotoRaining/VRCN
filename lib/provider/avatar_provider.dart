import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

final vrchatAvatarProvider = FutureProvider((ref) async {
  final rawApi = await ref.watch(vrchatRawApiProvider);
  return rawApi.getAvatarsApi();
});

// 自分のアバター情報
final ownAvatarProvider = FutureProvider.family<Avatar, String>((
  ref,
  userId,
) async {
  final worldsApi = ref.watch(vrchatAvatarProvider).value;
  if (worldsApi == null) {
    throw Exception('アバター情報を取得できませんでした');
  }
  final response = await worldsApi.getOwnAvatar(userId: userId);
  return response.data!;
});
