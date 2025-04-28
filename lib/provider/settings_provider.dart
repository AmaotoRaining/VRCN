import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// アプリテーマ設定の列挙型
enum AppThemeMode {
  light, // ライトテーマ
  dark, // ダークテーマ
  system, // システム設定に従う
}

// 設定データモデル
class AppSettings {
  final AppThemeMode themeMode;
  final bool loadImageOnWifi;
  final bool notifyNewFriendRequests;
  final bool notifyFriendOnline;
  final int maxFriendCache;

  const AppSettings({
    this.themeMode = AppThemeMode.system,
    this.loadImageOnWifi = true,
    this.notifyNewFriendRequests = true,
    this.notifyFriendOnline = true,
    this.maxFriendCache = 500,
  });

  // コピーと一部更新のためのメソッド
  AppSettings copyWith({
    AppThemeMode? themeMode,
    bool? loadImageOnWifi,
    bool? notifyNewFriendRequests,
    bool? notifyFriendOnline,
    int? maxFriendCache,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      loadImageOnWifi: loadImageOnWifi ?? this.loadImageOnWifi,
      notifyNewFriendRequests:
          notifyNewFriendRequests ?? this.notifyNewFriendRequests,
      notifyFriendOnline: notifyFriendOnline ?? this.notifyFriendOnline,
      maxFriendCache: maxFriendCache ?? this.maxFriendCache,
    );
  }

  // SharedPreferencesへの保存用
  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.index,
      'loadImageOnWifi': loadImageOnWifi,
      'notifyNewFriendRequests': notifyNewFriendRequests,
      'notifyFriendOnline': notifyFriendOnline,
      'maxFriendCache': maxFriendCache,
    };
  }

  // SharedPreferencesからの読み込み用
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      themeMode: AppThemeMode.values[json['themeMode'] ?? 2],
      loadImageOnWifi: json['loadImageOnWifi'] ?? true,
      notifyNewFriendRequests: json['notifyNewFriendRequests'] ?? true,
      notifyFriendOnline: json['notifyFriendOnline'] ?? true,
      maxFriendCache: json['maxFriendCache'] ?? 500,
    );
  }
}

// 設定管理クラス
class SettingsNotifier extends StateNotifier<AppSettings> {
  final SharedPreferences prefs;

  SettingsNotifier(this.prefs) : super(const AppSettings()) {
    _loadSettings();
  }

  // 設定の読み込み
  Future<void> _loadSettings() async {
    try {
      final themeMode = prefs.getInt('themeMode') ?? 2;
      final loadImageOnWifi = prefs.getBool('loadImageOnWifi') ?? true;
      final notifyNewFriendRequests =
          prefs.getBool('notifyNewFriendRequests') ?? true;
      final notifyFriendOnline = prefs.getBool('notifyFriendOnline') ?? true;
      final maxFriendCache = prefs.getInt('maxFriendCache') ?? 500;

      state = AppSettings(
        themeMode: AppThemeMode.values[themeMode],
        loadImageOnWifi: loadImageOnWifi,
        notifyNewFriendRequests: notifyNewFriendRequests,
        notifyFriendOnline: notifyFriendOnline,
        maxFriendCache: maxFriendCache,
      );
    } catch (e) {
      // エラー時はデフォルト設定を使用
      state = const AppSettings();
    }
  }

  // テーマモード変更
  Future<void> setThemeMode(AppThemeMode mode) async {
    await prefs.setInt('themeMode', mode.index);
    state = state.copyWith(themeMode: mode);
  }

  // Wi-Fi接続時のみ画像読み込み設定変更
  Future<void> setLoadImageOnWifi(bool value) async {
    await prefs.setBool('loadImageOnWifi', value);
    state = state.copyWith(loadImageOnWifi: value);
  }

  // フレンドリクエスト通知設定変更
  Future<void> setNotifyNewFriendRequests(bool value) async {
    await prefs.setBool('notifyNewFriendRequests', value);
    state = state.copyWith(notifyNewFriendRequests: value);
  }

  // フレンドオンライン通知設定変更
  Future<void> setNotifyFriendOnline(bool value) async {
    await prefs.setBool('notifyFriendOnline', value);
    state = state.copyWith(notifyFriendOnline: value);
  }

  // キャッシュ最大数変更
  Future<void> setMaxFriendCache(int value) async {
    await prefs.setInt('maxFriendCache', value);
    state = state.copyWith(maxFriendCache: value);
  }
}

// SharedPreferencesプロバイダー
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Providerが初期化されていません');
});

// 設定プロバイダー
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsNotifier(prefs);
});

// ThemeModeプロバイダー（Flutterのテーマ設定に使用）
final themeModeProvider = Provider<ThemeMode>((ref) {
  final settings = ref.watch(settingsProvider);
  switch (settings.themeMode) {
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
      return ThemeMode.dark;
    case AppThemeMode.system:
      return ThemeMode.system;
  }
});
