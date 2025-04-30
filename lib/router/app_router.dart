import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vrchat/pages/friend_detail_page.dart';
import 'package:vrchat/pages/friends_page.dart';
import 'package:vrchat/pages/login_page.dart';
import 'package:vrchat/pages/profile_page.dart';
import 'package:vrchat/pages/settings_page.dart'; // 追加
import 'package:vrchat/provider/vrchat_api_provider.dart';

// 認証状態の変更を監視するためのStateProviderを追加
final authRefreshProvider = StateProvider<int>((ref) => 0);

// 自動ログイン状態を追跡するプロバイダー（初期値: 処理中）
final autoLoginStateProvider = StateProvider<AutoLoginState>(
  (ref) => AutoLoginState.inProgress,
);

// 自動ログイン状態の列挙型
enum AutoLoginState {
  inProgress, // 自動ログイン処理中
  success, // 自動ログイン成功
  failed, // 自動ログイン失敗
}

// 認証状態を明示的に提供するプロバイダー
final authStateProvider = FutureProvider<bool>((ref) async {
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
  } catch (e) {
    ref.read(autoLoginStateProvider.notifier).state = AutoLoginState.failed;
  }
});

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
            return '/login';
          }

          // ログイン済みでログイン画面にいる場合のみホーム画面へ
          if (isLoggedIn && isLoginRoute) {
            return '/';
          }

          // それ以外の場合はリダイレクト不要
          return null;
        },
        loading: () => null, // ロード中はリダイレクトしない
        error: (_, _) => isLoginRoute ? null : '/login', // エラー時はログイン画面へ
      );
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const FriendsPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      // ロード画面のルートを追加
      GoRoute(
        path: '/loading',
        builder:
            (context, state) =>
                const Scaffold(body: Center(child: Text('ログイン状態を確認中...'))),
      ),
      // 設定画面のルートを追加
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/friends/:id',
        builder: (context, state) {
          final userId = state.pathParameters['id']!;
          return FriendDetailPage(userId: userId);
        },
      ),
    ],
  );
});

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
