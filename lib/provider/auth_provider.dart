import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';

// 認証状態を管理するプロバイダー
final authStateProvider = FutureProvider<bool>((ref) async {
  try {
    final api = await ref.read(vrchatAuthProvider.future);
    api.currentUser;
    return true;
  } catch (e) {
    return false;
  }
});

// ログイン処理を行うプロバイダー
final loginProvider =
    FutureProvider.family<bool, ({String username, String password})>((
      ref,
      credentials,
    ) async {
      try {
        final auth = await ref.read(vrchatAuthProvider.future);
        await auth.login(
          username: credentials.username,
          password: credentials.password,
        );
        ref.invalidate(authStateProvider);
        return true;
      } catch (e) {
        return false;
      }
    });

// ログアウト処理を行うプロバイダー
final logoutProvider = FutureProvider<bool>((ref) async {
  try {
    final auth = await ref.read(vrchatAuthProvider.future);
    await auth.logout();
    ref.invalidate(authStateProvider);
    return true;
  } catch (e) {
    return false;
  }
});
