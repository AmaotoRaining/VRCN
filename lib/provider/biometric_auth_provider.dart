import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vrchat/services/biometric_auth_service.dart';

// 生体認証サービスのプロバイダー
final biometricAuthServiceProvider = Provider<BiometricAuthService>((ref) {
  return BiometricAuthService();
});

// 生体認証が有効かどうかを管理するプロバイダー
final biometricEnabledProvider = FutureProvider<bool>((ref) {
  final service = ref.watch(biometricAuthServiceProvider);
  return service.isBiometricEnabled();
});

// 生体認証が利用可能かどうかを確認するプロバイダー
final biometricAvailableProvider = FutureProvider<bool>((ref) {
  final service = ref.watch(biometricAuthServiceProvider);
  return service.isBiometricAvailable();
});

// 利用可能な生体認証の種類を提供するプロバイダー
final availableBiometricsProvider = FutureProvider<List<BiometricType>>((ref) {
  final service = ref.watch(biometricAuthServiceProvider);
  return service.getAvailableBiometrics();
});

// 生体認証チェックの状態を管理する
// アプリ起動時はtrueに設定され、認証成功後にfalseになる
final shouldCheckBiometricsProvider = StateProvider<bool>((ref) => true);

// アプリ起動時の生体認証チェックを処理する
final performBiometricCheckProvider = FutureProvider<void>((ref) async {
  final service = ref.read(biometricAuthServiceProvider);
  final isEnabled = await service.isBiometricEnabled();

  // 生体認証が有効でない場合はチェックを無効化
  if (!isEnabled) {
    ref.read(shouldCheckBiometricsProvider.notifier).state = false;
    return;
  }

  // 生体認証が利用可能かチェック
  final isAvailable = await service.isBiometricAvailable();
  if (!isAvailable) {
    ref.read(shouldCheckBiometricsProvider.notifier).state = false;
    return;
  }

  // 毎回チェックするため、常にtrueに設定
  ref.read(shouldCheckBiometricsProvider.notifier).state = true;
});

// アプリ起動状態をリセットするプロバイダー
final resetBiometricCheckProvider = Provider<void>((ref) {
  // アプリ起動時に認証フラグをリセット
  ref.read(shouldCheckBiometricsProvider.notifier).state = true;
});
