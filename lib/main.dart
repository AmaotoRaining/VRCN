import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrchat/provider/settings_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/router/app_router.dart';
import 'package:vrchat/theme/app_theme.dart';
import 'package:vrchat/widgets/custom_loading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // システムUIの設定
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  // システムの向き指定 - 縦向きに固定
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // SharedPreferencesの初期化
  final prefs = await SharedPreferences.getInstance();

  // .envファイルの読み込み（デバッグモードのみ）
  if (kDebugMode) {
    await dotenv.load();
  }

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 必要なプロバイダーを監視
    final isInitializing = ref.watch(apiInitializingProvider);
    final themeMode = ref.watch(themeModeProvider);

    // APIの初期化を開始
    ref.watch(vrchatProvider);

    // 初期化中またはAPI準備中はローディング画面、完了後は通常のルーターを使用
    if (isInitializing) {
      return _buildLoadingApp(themeMode);
    }

    // 自動ログイン試行
    ref.watch(autoLoginProvider);

    // ルーターベースのアプリを構築
    return _buildRouterApp(ref, themeMode);
  }

  /// ローディング中に表示するアプリ
  MaterialApp _buildLoadingApp(ThemeMode themeMode) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // デバッグバナーを非表示
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: const Scaffold(body: SafeArea(child: CustomLoading())),
    );
  }

  /// ルーターベースのメインアプリ
  MaterialApp _buildRouterApp(WidgetRef ref, ThemeMode themeMode) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false, // デバッグバナーを非表示
      title: 'VRChat',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) {
        // 全体のフォントサイズを適用
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
