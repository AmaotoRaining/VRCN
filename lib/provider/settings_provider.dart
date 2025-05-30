import 'package:flutter/material.dart';
import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// アプリテーマ設定の列挙型
enum AppThemeMode {
  light, // ライトテーマ
  dark, // ダークテーマ
  system, // システム設定に従う
}

// アプリアイコンタイプ
enum AppIconType {
  nullbase,
  annobu,
  kazkiller,
  miyamoto,
  le0yuki,
  ray,
  hare,
  aihuru,
  rea,
}

// アイコン名のマッピング
Map<AppIconType, String> appIconNameMap = {
  AppIconType.nullbase: 'default',
  AppIconType.annobu: 'annobu',
  AppIconType.kazkiller: 'kazkiller',
  AppIconType.miyamoto: 'miyamoto',
  AppIconType.le0yuki: 'le0yuki',
  AppIconType.ray: 'ray',
  AppIconType.hare: 'hare',
  AppIconType.aihuru: 'aihuru',
  AppIconType.rea: 'rea',
};

// 設定データモデル
@immutable
class AppSettings {
  final AppThemeMode themeMode;
  final bool loadImageOnWifi;
  final bool notifyNewFriendRequests;
  final bool notifyFriendOnline;
  final int maxFriendCache;
  final AppIconType appIcon;
  final String avatarSearchApiUrl;
  final bool allowNsfw;

  const AppSettings({
    this.themeMode = AppThemeMode.system,
    this.loadImageOnWifi = true,
    this.notifyNewFriendRequests = true,
    this.notifyFriendOnline = true,
    this.maxFriendCache = 500,
    this.appIcon = AppIconType.nullbase,
    this.avatarSearchApiUrl = '',
    this.allowNsfw = false,
  });

  // コピーと一部更新のためのメソッド
  AppSettings copyWith({
    AppThemeMode? themeMode,
    bool? loadImageOnWifi,
    bool? notifyNewFriendRequests,
    bool? notifyFriendOnline,
    int? maxFriendCache,
    AppIconType? appIcon,
    String? avatarSearchApiUrl,
    bool? allowNsfw,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      loadImageOnWifi: loadImageOnWifi ?? this.loadImageOnWifi,
      notifyNewFriendRequests:
          notifyNewFriendRequests ?? this.notifyNewFriendRequests,
      notifyFriendOnline: notifyFriendOnline ?? this.notifyFriendOnline,
      maxFriendCache: maxFriendCache ?? this.maxFriendCache,
      appIcon: appIcon ?? this.appIcon,
      avatarSearchApiUrl: avatarSearchApiUrl ?? this.avatarSearchApiUrl,
      allowNsfw: allowNsfw ?? this.allowNsfw,
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
      'appIcon': appIcon.index,
      'avatarSearchApiUrl': avatarSearchApiUrl,
      'allowNsfw': allowNsfw,
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
      appIcon:
          json['appIcon'] != null
              ? AppIconType.values[json['appIcon']]
              : AppIconType.nullbase,
      avatarSearchApiUrl: json['avatarSearchApiUrl'] ?? '',
      allowNsfw: json['allowNsfw'] ?? false,
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

      // アバター検索APIのURLを取得
      final avatarSearchApiUrl = prefs.getString('avatarSearchApiUrl') ?? '';

      // 現在のアプリアイコン名を取得
      final appIconIndex = prefs.getInt('appIcon') ?? 0;
      final appIcon =
          appIconIndex < AppIconType.values.length
              ? AppIconType.values[appIconIndex]
              : AppIconType.nullbase;

      // 不快なコンテンツ表示の同意を取得
      final allowNsfw = prefs.getBool('allowNsfw') ?? false;

      state = AppSettings(
        themeMode: AppThemeMode.values[themeMode],
        loadImageOnWifi: loadImageOnWifi,
        notifyNewFriendRequests: notifyNewFriendRequests,
        notifyFriendOnline: notifyFriendOnline,
        maxFriendCache: maxFriendCache,
        appIcon: appIcon,
        avatarSearchApiUrl: avatarSearchApiUrl, // 追加
        allowNsfw: allowNsfw,
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

  // アプリアイコン変更
  Future<bool> setAppIcon(AppIconType iconType) async {
    try {
      // アイコン変更がサポートされているか確認
      final isSupported = await FlutterDynamicIconPlus.supportsAlternateIcons;
      if (!isSupported) {
        return false;
      }

      // デフォルトアイコンの場合は元に戻す
      if (iconType == AppIconType.nullbase) {
        await FlutterDynamicIconPlus.setAlternateIconName(
          iconName: null,
          // Android用
          blacklistBrands: ['Redmi'],
          blacklistManufactures: ['Xiaomi'],
          blacklistModels: ['Redmi 200A'],
        );
      } else {
        // 指定されたアイコンに変更
        final iconName = appIconNameMap[iconType];
        if (iconName != null) {
          await FlutterDynamicIconPlus.setAlternateIconName(
            iconName: iconName,
            // Android用
            blacklistBrands: ['Redmi'],
            blacklistManufactures: ['Xiaomi'],
            blacklistModels: ['Redmi 200A'],
          );
        }
      }

      // 状態を更新
      await prefs.setInt('appIcon', iconType.index);
      state = state.copyWith(appIcon: iconType);
      return true;
    } catch (e) {
      // エラー発生時
      return false;
    }
  }

  // アバター検索APIのURL変更
  Future<void> setAvatarSearchApiUrl(String url) async {
    await prefs.setString('avatarSearchApiUrl', url);
    state = state.copyWith(avatarSearchApiUrl: url);
  }

  // 不快なコンテンツ表示の同意設定変更
  Future<void> setAllowNsfw(bool allow) async {
    await prefs.setBool('allowNsfw', allow);
    state = state.copyWith(allowNsfw: allow);
  }

  // アイコン変更がサポートされているか確認
  Future<bool> isAppIconChangeSupported() async {
    try {
      final isSupported = await FlutterDynamicIconPlus.supportsAlternateIcons;
      debugPrint('アイコン変更サポート状態: $isSupported'); // デバッグ用
      return isSupported;
    } catch (e) {
      debugPrint('アイコン変更サポート確認中にエラー: $e'); // デバッグ用
      return false;
    }
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
