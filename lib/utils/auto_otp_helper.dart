import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:otp/otp.dart';

/// 二段階認証用のOTPコードを自動生成するヘルパークラス
///
/// 注意: この機能は一時的な開発用途のみを想定しています。
/// 実運用環境では使用しないでください。
class AutoOtpHelper {
  /// 指定されたユーザー名がOTP自動入力対象かどうかを判断
  static bool isEligibleForAutoOtp(String username) {
    // .envファイルから開発者アカウント名を取得
    final demoUsername = dotenv.env['VRCHAT_USERNAME_DEMO'];

    // ユーザー名が開発者アカウントと一致するか確認
    return username == demoUsername;
  }

  /// OTPコードを生成
  ///
  /// 指定されたユーザー名が開発者アカウントの場合のみOTPを生成
  static String? generateOtp(String username) {
    // 対象ユーザーでなければnullを返す
    if (!isEligibleForAutoOtp(username)) {
      debugPrint('OTP自動入力: $usernameは対象外のユーザーです');
      return null;
    }

    // .envファイルからOTPシークレットを取得
    final secretKey = dotenv.env['DEMO_OTP_SECRET'];
    if (secretKey == null || secretKey.isEmpty) {
      debugPrint('OTP生成エラー: シークレットキーが設定されていません');
      return null;
    }

    try {
      // OTPコードを生成（TOTPアルゴリズム使用）
      final otpCode = OTP.generateTOTPCodeString(
        secretKey,
        DateTime.timestamp().millisecondsSinceEpoch,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      );

      debugPrint('OTP生成成功: $username 用のコード生成完了');
      return otpCode;
    } catch (e) {
      debugPrint('OTP生成エラー: $e');
      return null;
    }
  }
}
