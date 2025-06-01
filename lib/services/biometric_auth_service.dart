import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final _localAuth = LocalAuthentication();
  final _secureStorage = const FlutterSecureStorage();

  static const _biometricsEnabledKey = 'biometrics_enabled';
  static const _lastAuthTimeKey = 'last_auth_time';
  static const _authValidityMinutes = 1; // 認証の有効期間（分）

  // 生体認証が利用可能かチェック
  Future<bool> isBiometricAvailable() async {
    try {
      // デバイスが生体認証をサポートしているか確認
      final canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      final canAuthenticate =
          canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();

      // サポートされている生体認証の種類を取得
      if (canAuthenticate) {
        final availableBiometrics = await _localAuth.getAvailableBiometrics();

        // 少なくとも1つの生体認証方法が利用可能
        return availableBiometrics.isNotEmpty;
      }

      return false;
    } on PlatformException catch (e) {
      debugPrint('生体認証チェックエラー: $e');
      return false;
    }
  }

  // 利用可能な生体認証の種類を取得
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      debugPrint('生体認証の種類取得エラー: $e');
      return [];
    }
  }

  // 生体認証の有効/無効の状態を取得
  Future<bool> isBiometricEnabled() async {
    final value = await _secureStorage.read(key: _biometricsEnabledKey);
    return value == 'true';
  }

  // 生体認証の有効/無効を設定
  Future<void> setBiometricEnabled(bool enabled) async {
    await _secureStorage.write(
      key: _biometricsEnabledKey,
      value: enabled.toString(),
    );
  }

  // 前回の認証からの有効期間をチェック
  Future<bool> isAuthenticationValid() async {
    try {
      final lastAuthTimeStr = await _secureStorage.read(key: _lastAuthTimeKey);
      if (lastAuthTimeStr == null) return false;

      final lastAuthTime = DateTime.parse(lastAuthTimeStr);
      final now = DateTime.timestamp();
      final difference = now.difference(lastAuthTime);

      // 設定した有効期間内なら再認証不要
      return difference.inMinutes < _authValidityMinutes;
    } catch (e) {
      debugPrint('認証有効期間チェックエラー: $e');
      return false;
    }
  }

  // 認証時刻を記録
  Future<void> saveAuthenticationTime() async {
    await _secureStorage.write(
      key: _lastAuthTimeKey,
      value: DateTime.timestamp().toIso8601String(),
    );
  }

  // 認証記録をクリア（ログアウト時など）
  Future<void> clearAuthenticationCache() async {
    await _secureStorage.delete(key: _lastAuthTimeKey);
  }

  // 生体認証を実行
  Future<bool> authenticate() async {
    try {
      // 生体認証が有効かどうかを確認
      final isEnabled = await isBiometricEnabled();
      if (!isEnabled) {
        return true; // 生体認証が無効の場合は常に成功
      }

      // 直近の認証が有効期間内かチェック
      final isValid = await isAuthenticationValid();
      if (isValid) {
        debugPrint('前回の認証が有効期間内のため、認証をスキップします');
        return true;
      }

      // 生体認証が利用可能かを確認
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        return true; // 生体認証が利用できない場合は常に成功
      }

      final result = await _localAuth.authenticate(
        localizedReason: 'アプリを使用するには生体認証が必要です',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (result) {
        // 認証成功時、時刻を記録
        await saveAuthenticationTime();
      }

      return result;
    } on PlatformException catch (e) {
      debugPrint('認証エラー: $e');

      // 特定のエラーコードに対する処理
      if (e.code == auth_error.notAvailable) {
        return true; // 生体認証が利用できない場合は常に成功
      } else if (e.code == auth_error.notEnrolled) {
        // 生体情報が登録されていない場合
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('予期せぬエラー: $e');
      return false;
    }
  }
}
