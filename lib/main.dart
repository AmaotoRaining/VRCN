import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrchat/firebase_options.dart';
import 'package:vrchat/provider/settings_provider.dart';
import 'package:vrchat/provider/streaming_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/router/app_router.dart';
import 'package:vrchat/theme/app_theme.dart';
import 'package:vrchat/widgets/loading_indicator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // スプラッシュ画面
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!kDebugMode) {
    // Firebase Analysis
    await FirebaseAnalytics.instance.logAppOpen();
  }

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

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Android通知権限のリクエスト
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();

  // 通知の初期化
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ),
  );

  // デバッグ用.envファイルの読み込み
  if (kDebugMode) {
    await dotenv.load();
  }

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const VRChatApp(),
    ),
  );
}

class VRChatApp extends ConsumerWidget {
  const VRChatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInitializing = ref.watch(apiInitializingProvider);
    final themeMode = ref.watch(themeModeProvider);

    // APIの初期化を開始
    ref.watch(vrchatProvider);

    // 認証状態を監視してストリーミング接続を開始
    final authState = ref.watch(authStateProvider);
    authState.whenData((isLoggedIn) {
      if (isLoggedIn) {
        // ログイン済みならストリーミングコントローラーを使用して接続を開始
        // Future.microtaskを使用して初期化後に接続開始
        Future.microtask(
          () => ref.read(streamingControllerProvider).startConnection(),
        );
      }
    });

    // 初期化中はローディング画面、完了後は通常のルーターを使用
    if (isInitializing) {
      return _buildApp(themeMode: themeMode, home: const LoadingIndicator());
    }

    // 自動ログイン試行
    ref.watch(autoLoginProvider);

    // ルーターベースのアプリを構築
    final router = ref.watch(routerProvider);
    return _buildApp(themeMode: themeMode, useRouter: true, router: router);
  }

  /// アプリの共通設定を構築
  MaterialApp _buildApp({
    required ThemeMode themeMode,
    Widget? home,
    bool useRouter = false,
    GoRouter? router,
  }) {
    // 共通の設定
    MediaQuery appBuilder(BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: const TextScaler.linear(1.0)),
        child: child!,
      );
    }

    // ルーター使用かホーム画面使用かで分岐
    if (useRouter && router != null) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        routerConfig: router,
        builder: appBuilder,
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: SafeArea(child: home ?? const SizedBox.shrink()),
      builder: appBuilder,
    );
  }
}
