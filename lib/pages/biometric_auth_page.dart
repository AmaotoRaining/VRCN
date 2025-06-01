import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vrchat/provider/biometric_auth_provider.dart';
import 'package:vrchat/theme/app_theme.dart';

// アプリの状態（バックグラウンド/フォアグラウンド）を監視するためのプロバイダー
final appResumedProvider = StateProvider<bool>((ref) => false);

class BiometricAuthPage extends ConsumerStatefulWidget {
  const BiometricAuthPage({super.key});

  @override
  ConsumerState<BiometricAuthPage> createState() => _BiometricAuthPageState();
}

class _BiometricAuthPageState extends ConsumerState<BiometricAuthPage>
    with WidgetsBindingObserver {
  var _isAuthenticating = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // アプリのライフサイクルイベントを監視
    WidgetsBinding.instance.addObserver(this);
    _authenticate();
  }

  @override
  void dispose() {
    // 監視を解除
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // アプリのライフサイクルイベントを処理
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // アプリがバックグラウンドから復帰した場合
      debugPrint('アプリがバックグラウンドから復帰しました - 再認証を実行');
      ref.read(appResumedProvider.notifier).state = true;
      _authenticate();
    } else if (state == AppLifecycleState.paused) {
      // アプリがバックグラウンドに移動した場合
      debugPrint('アプリがバックグラウンドに移動しました');
    }
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
      _errorMessage = null;
    });

    try {
      final service = ref.read(biometricAuthServiceProvider);
      final isEnabled = await service.isBiometricEnabled();

      // 認証の有効期間をチェック（アプリ再起動の場合は常に認証要求）
      final lastValid = await service.isAuthenticationValid();
      debugPrint('前回の認証状態: ${lastValid ? "有効" : "期限切れまたは未認証"}');

      // 生体認証が有効でない場合はスキップ
      if (!isEnabled) {
        if (mounted) {
          debugPrint('生体認証が無効なため、認証をスキップします');
          ref.read(shouldCheckBiometricsProvider.notifier).state = false;
          _navigateToHome();
        }
        return;
      }

      debugPrint('生体認証を開始します');
      final success = await service.authenticate();
      debugPrint('生体認証結果: $success');

      if (mounted) {
        if (success) {
          debugPrint('認証成功: ホーム画面に遷移します');
          ref.read(shouldCheckBiometricsProvider.notifier).state = false;
          _navigateToHome();
        } else {
          setState(() {
            _errorMessage = '認証に失敗しました。もう一度お試しください。';
            _isAuthenticating = false;
          });
        }
      }
    } catch (e) {
      debugPrint('認証エラー: $e');
      if (mounted) {
        setState(() {
          _errorMessage = '認証中にエラーが発生しました: $e';
          _isAuthenticating = false;
        });
      }
    }
  }

  // ホーム画面への遷移メソッド
  void _navigateToHome() {
    if (!mounted) return;

    try {
      // GoRouterでのナビゲーション（popではなくGoメソッドを使用）
      context.go('/');
    } catch (e) {
      debugPrint('ナビゲーションエラー: $e');
      // フォールバック: context.replaceNamed
      try {
        context.replace('/');
      } catch (e2) {
        debugPrint('代替ナビゲーションでもエラー: $e2');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final availableBiometricsAsync = ref.watch(availableBiometricsProvider);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isDarkMode
                    ? [const Color(0xFF1C1C1E), const Color(0xFF121214)]
                    : [Colors.white, const Color(0xFFF8F9FA)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // アプリロゴ
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/default.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    '続行するには生体認証が必要です',
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // 生体認証アイコン
                  availableBiometricsAsync.when(
                    data: (biometrics) {
                      IconData icon;
                      String text;

                      if (biometrics.contains(BiometricType.face)) {
                        icon = Icons.face;
                        text = 'Face IDで認証';
                      } else if (biometrics.contains(
                        BiometricType.fingerprint,
                      )) {
                        icon = Icons.fingerprint;
                        text = '指紋認証';
                      } else {
                        icon = Icons.security;
                        text = '生体認証';
                      }

                      return GestureDetector(
                        onTap: _isAuthenticating ? null : _authenticate,
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.primaryColor.withValues(
                                  alpha: .1,
                                ),
                              ),
                              child: Icon(
                                icon,
                                size: 40,
                                color: AppTheme.primaryColor,
                              ),
                            ),

                            const SizedBox(height: 16),

                            Text(
                              text,
                              style: GoogleFonts.notoSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error:
                        (_, _) => const Icon(
                          Icons.error_outline,
                          size: 40,
                          color: Colors.red,
                        ),
                  ),

                  const SizedBox(height: 24),

                  // エラーメッセージ
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: GoogleFonts.notoSans(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 40),

                  // 再試行ボタン
                  if (_errorMessage != null)
                    ElevatedButton(
                      onPressed: _isAuthenticating ? null : _authenticate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        '再試行',
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
