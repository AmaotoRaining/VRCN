import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrchat/analytics_repository.dart';
import 'package:vrchat/firebase_options.dart';
import 'package:vrchat/provider/event_reminder_provider.dart';
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

  // 通知の初期化
  final notifications = await initializeNotifications();

  // デバッグ用.envファイルの読み込み
  if (kDebugMode) {
    await dotenv.load(fileName: '.env');
  } else {
    await dotenv.load(fileName: '.env.demo');
  }

  // 前回表示された通知の履歴を確認
  final launchDetails = await notifications.getNotificationAppLaunchDetails();
  if (launchDetails != null && launchDetails.didNotificationLaunchApp) {
    // 通知によってアプリが起動された場合
    debugPrint('通知からアプリが起動されました');
    if (launchDetails.notificationResponse != null) {
      _handleNotificationResponse(launchDetails.notificationResponse!);
    }
  }

  // ProviderContainerを正しく初期化
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      localNotificationsProvider.overrideWithValue(notifications),
    ],
  );

  try {
    await container.read(eventReminderProvider.notifier).cleanupOldReminders();
  } catch (e) {
    debugPrint('リマインダーのクリーンアップ中にエラーが発生しました: $e');
  }

  runApp(
    UncontrolledProviderScope(container: container, child: const VRChatApp()),
  );
}

/// 通知の初期化
Future<FlutterLocalNotificationsPlugin> initializeNotifications() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Android設定
  const initializationSettingsAndroid = AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  // iOS設定
  const initializationSettingsIOS = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  // 初期化設定
  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  // 通知が届いたときやタップされたときの処理を設定
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: _handleNotificationResponse,
  );

  return flutterLocalNotificationsPlugin;
}

/// 通知応答ハンドラ
void _handleNotificationResponse(NotificationResponse details) {
  final notificationId = details.id ?? -1;
  if (notificationId != -1) {
    // プロバイダーコンテナを取得し、リマインダーを削除
    final container = ProviderContainer();
    container
        .read(eventReminderProvider.notifier)
        .removeReminderByNotificationId(notificationId);
  }
}

class VRChatApp extends ConsumerStatefulWidget {
  const VRChatApp({super.key});

  @override
  ConsumerState<VRChatApp> createState() => _VRChatAppState();
}

class _VRChatAppState extends ConsumerState<VRChatApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // ライフサイクルオブザーバーとして登録
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // ライフサイクルオブザーバーの登録解除
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // アプリのライフサイクル状態変化を監視
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // アプリがフォアグラウンドに戻ったらバッジをクリア
      FlutterAppBadger.removeBadge();
      debugPrint('アプリがフォアグラウンドに戻りました: 通知バッジをクリア');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isInitializing = ref.watch(apiInitializingProvider);
    final themeMode = ref.watch(themeModeProvider);

    final analytics = ref.watch(analyticsRepository);

    // アプリ起動時の分析記録
    if (!kDebugMode) {
      // アプリ開いたとき
      analytics.logAppOpen();

      Future.microtask(() async {
        final packageInfo = await PackageInfo.fromPlatform();
        await FirebaseAnalytics.instance.setUserProperty(
          name: 'app_version',
          value: packageInfo.version,
        );
      });
    }

    // APIの初期化を開始
    ref.watch(vrchatProvider);

    // 認証状態を監視してストリーミング接続を開始
    final authState = ref.watch(authStateProvider);
    authState.whenData((isLoggedIn) {
      if (isLoggedIn) {
        // ログイン済みならストリーミングコントローラーを使用して接続を開始
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
