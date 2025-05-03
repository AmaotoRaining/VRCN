import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vrchat/pages/avatars_page.dart';
import 'package:vrchat/pages/credits_page.dart';
import 'package:vrchat/pages/favorites_page.dart';
import 'package:vrchat/pages/friend_detail_page.dart';
import 'package:vrchat/pages/friends_page.dart';
import 'package:vrchat/pages/group_detail_page.dart';
import 'package:vrchat/pages/groups_page.dart';
import 'package:vrchat/pages/login_page.dart';
import 'package:vrchat/pages/notifications_page.dart';
import 'package:vrchat/pages/profile_page.dart';
import 'package:vrchat/pages/search_page.dart';
import 'package:vrchat/pages/settings_page.dart';
import 'package:vrchat/pages/world_detail_page.dart';
import 'package:vrchat/provider/navigation_provider.dart';
import 'package:vrchat/provider/user_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/widgets/loading_indicator.dart';
import 'package:vrchat/widgets/navigation_bar.dart';

// スプラッシュ画面が表示されているかを追跡
final splashActiveProvider = StateProvider<bool>((ref) => true);

// 認証状態の変更を監視するためのStateProvider
final authRefreshProvider = StateProvider<int>((ref) => 0);

// 自動ログイン状態を追跡するプロバイダー
final autoLoginStateProvider = StateProvider<AutoLoginState>(
  (ref) => AutoLoginState.inProgress,
);

// 自動ログイン状態の列挙型
enum AutoLoginState {
  inProgress, // 自動ログイン処理中
  success, // 自動ログイン成功
  failed, // 自動ログイン失敗
}

// スプラッシュ画面を削除するプロバイダー（一定時間後に強制削除）
final removeSplashProvider = Provider<void>((ref) {
  // スプラッシュ画面を削除するタイマーを設定（最大5秒後）
  if (ref.read(splashActiveProvider)) {
    Future.delayed(const Duration(seconds: 5), () {
      // スプラッシュ画面をまだ削除していなければ削除
      if (ref.read(splashActiveProvider)) {
        FlutterNativeSplash.remove();
        ref.read(splashActiveProvider.notifier).state = false;
      }
    });
  }
});

// 認証状態を明示的に提供するプロバイダー
final authStateProvider = FutureProvider<bool>((ref) async {
  // スプラッシュ削除プロバイダーを監視
  ref.watch(removeSplashProvider);

  // 認証状態更新用トリガーを監視（ログイン/ログアウト時に変更）
  ref.watch(authRefreshProvider);

  try {
    final auth = await ref.watch(vrchatAuthProvider.future);
    return auth.currentUser != null;
  } catch (e) {
    return false;
  }
});

// 自動ログイン実行プロバイダー（結果を追跡状態にセットする）
final performAutoLoginProvider = FutureProvider<void>((ref) async {
  try {
    // 既に成功・失敗状態なら何もしない
    final currentState = ref.read(autoLoginStateProvider);
    if (currentState != AutoLoginState.inProgress) return;

    final autoLoginResult = await ref.watch(autoLoginProvider.future);

    // 結果に基づいて状態を更新
    if (autoLoginResult) {
      ref.read(autoLoginStateProvider.notifier).state = AutoLoginState.success;
    } else {
      ref.read(autoLoginStateProvider.notifier).state = AutoLoginState.failed;
    }

    // 自動ログイン処理が完了したら、スプラッシュ画面を確実に削除
    _removeSplashScreen(ref);
  } catch (e) {
    ref.read(autoLoginStateProvider.notifier).state = AutoLoginState.failed;
    // エラー時もスプラッシュ画面を削除
    _removeSplashScreen(ref);
  }
});

// スプラッシュ画面を削除するヘルパー関数
void _removeSplashScreen(Ref ref) async {
  // スプラッシュが表示されている場合
  if (ref.read(splashActiveProvider)) {
    // ユーザー情報を先に取得しておく（エラー時も続行）
    try {
      await ref.read(currentUserProvider.future);
    } catch (e) {
      debugPrint('初期ユーザー情報取得でエラー: $e');
      // エラーがあってもスプラッシュは消す
    }

    FlutterNativeSplash.remove();
    ref.read(splashActiveProvider.notifier).state = false;
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final isInitializing = ref.watch(apiInitializingProvider);
  final authState = ref.watch(authStateProvider);
  final autoLoginState = ref.watch(autoLoginStateProvider);

  // 自動ログイン処理を開始（状態を監視）
  ref.watch(performAutoLoginProvider);

  return GoRouter(
    refreshListenable: GoRouterRefreshStream(
      ref.read(authRefreshProvider.notifier).stream,
    ),
    initialLocation: '/',
    routerNeglect: true, // 同じパスへの遷移をスキップ
    redirect: (context, state) {
      final isLoginRoute = state.uri.toString() == '/login';

      // API初期化中は何もしない
      if (isInitializing) {
        return null;
      }

      // 自動ログイン処理中は特別処理
      if (autoLoginState == AutoLoginState.inProgress) {
        // 一時的なロード画面を表示（/loadingパスを追加）
        return state.uri.toString() == '/loading' ? null : '/loading';
      }

      // 認証状態に基づいてリダイレクト
      return authState.when(
        data: (isLoggedIn) {
          // ログインしていない場合はログイン画面へ
          if (!isLoggedIn && !isLoginRoute) {
            FlutterNativeSplash.remove();
            return '/login';
          }

          // ログイン済みでログイン画面にいる場合のみホーム画面へ
          if (isLoggedIn && isLoginRoute) {
            FlutterNativeSplash.remove();
            return '/';
          }

          return null;
        },
        loading: () => null,
        error: (_, _) => isLoginRoute ? null : '/login',
      );
    },
    routes: [
      // ナビゲーションバーを持つシェルルート
      ShellRoute(
        builder: (context, state, child) {
          // 現在のパスに基づいて適切なタブインデックスを設定
          final location = state.uri.toString();
          var currentIndex = 0;

          if (location == '/search') {
            currentIndex = 1;
          } else if (location == '/notifications') {
            currentIndex = 2;
          }

          // プロバイダーの状態も更新
          ref.read(navigationIndexProvider.notifier).state = currentIndex;

          return Navigation(currentIndex: currentIndex, child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) {
              // 即時遷移フラグがある場合はNoTransitionPageを使用
              final immediate =
                  (state.extra as Map<String, dynamic>?)?['immediate'] == true;
              if (immediate) {
                return const NoTransitionPage(child: FriendsPage());
              }
              return const MaterialPage(child: FriendsPage());
            },
          ),
          GoRoute(
            path: '/search',
            pageBuilder: (context, state) {
              return MaterialPage(
                child: SearchPage(key: ref.read(searchPageKeyProvider)),
              );
            },
          ),
          GoRoute(
            path: '/notifications',
            pageBuilder: (context, state) {
              final immediate =
                  (state.extra as Map<String, dynamic>?)?['immediate'] == true;
              if (immediate) {
                return const NoTransitionPage(child: NotificationsPage());
              }
              return const MaterialPage(child: NotificationsPage());
            },
          ),
        ],
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingIndicator(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/user/:id',
        builder: (context, state) {
          final userId = state.pathParameters['id']!;
          return FriendDetailPage(userId: userId);
        },
      ),
      GoRoute(
        path: '/world/:worldId',
        builder: (context, state) {
          final worldId = state.pathParameters['worldId']!;
          return WorldDetailPage(worldId: worldId);
        },
      ),
      GoRoute(
        path: '/group/:groupId',
        builder: (context, state) {
          final groupId = state.pathParameters['groupId']!;
          return GroupDetailPage(groupId: groupId);
        },
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesPage(),
      ),
      GoRoute(path: '/groups', builder: (context, state) => const GroupsPage()),
      GoRoute(
        path: '/avatars',
        builder: (context, state) => const AvatarsPage(),
      ),
      GoRoute(
        path: '/credits',
        builder: (context, state) => const CreditsPage(),
      ),
    ],
  );
});

// NoTransitionPageクラス - アニメーションなしの遷移ページ
class NoTransitionPage<T> extends Page<T> {
  final Widget child;

  const NoTransitionPage({required this.child, super.key});

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (_, _, _) => child,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }
}

// GoRouterのリフレッシュを行うためのヘルパークラス
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
