import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

/// ユーザーの代表グループを取得するプロバイダー
final userRepresentedGroupProvider =
    FutureProvider.family<RepresentedGroup?, String>((ref, userId) async {
      try {
        final rawApi = await ref.watch(vrchatRawApiProvider);
        final response = await rawApi.getUsersApi().getUserRepresentedGroup(
          userId: userId,
        );
        return response.data;
      } catch (e) {
        return null;
      }
    });
