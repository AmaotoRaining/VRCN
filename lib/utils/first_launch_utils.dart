import 'package:shared_preferences/shared_preferences.dart';

/// 初回起動管理ユーティリティ
class FirstLaunchUtils {
  static const _firstLaunchKey = 'is_first_launch';
  static const _termsAcceptedKey = 'terms_accepted';
  static const _termsVersionKey = 'terms_version';

  /// 現在の利用規約バージョン
  static const currentTermsVersion = '1.0.0';

  /// 初回起動かどうかを確認
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstLaunchKey) ?? true;
  }

  /// 初回起動フラグを設定
  static Future<void> setFirstLaunchCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, false);
  }

  /// 利用規約に同意したかどうかを確認
  static Future<bool> isTermsAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    final accepted = prefs.getBool(_termsAcceptedKey) ?? false;
    final version = prefs.getString(_termsVersionKey) ?? '';

    // 利用規約に同意済みかつ、バージョンが最新の場合のみtrue
    return accepted && version == currentTermsVersion;
  }

  /// 利用規約への同意を記録
  static Future<void> acceptTerms() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_termsAcceptedKey, true);
    await prefs.setString(_termsVersionKey, currentTermsVersion);
  }

  /// 利用規約の同意をリセット（新バージョン時など）
  static Future<void> resetTermsAcceptance() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_termsAcceptedKey, false);
    await prefs.remove(_termsVersionKey);
  }

  /// 初回起動に必要な全ての条件をチェック
  static Future<bool> shouldShowOnboarding() async {
    final isFirst = await isFirstLaunch();
    final termsAccepted = await isTermsAccepted();

    // 初回起動または利用規約未同意の場合は表示
    return isFirst || !termsAccepted;
  }
}
