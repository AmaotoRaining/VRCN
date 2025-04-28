import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/router/app_router.dart';
import 'package:vrchat/widgets/error_container.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _twoFactorCodeController = TextEditingController();
  final List<String> _twoFactorCodeValue = List.filled(6, '');
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final _hiddenController = TextEditingController();
  final _hiddenFocusNode = FocusNode();
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _showTwoFactorAuth = false;

  @override
  void initState() {
    super.initState();

    // デバッグモードの場合は環境変数から認証情報を読み込む
    if (kDebugMode) {
      _loadCredentialsFromEnv();
    }
  }

  // 環境変数から認証情報を読み込む
  void _loadCredentialsFromEnv() {
    try {
      final username = dotenv.env['VRCHAT_USERNAME'];
      final password = dotenv.env['VRCHAT_PASSWORD'];

      if (username != null && username.isNotEmpty) {
        _usernameController.text = username;
      }

      if (password != null && password.isNotEmpty) {
        _passwordController.text = password;
      }
    } catch (e) {
      if (kDebugMode) {
        print('環境変数からの認証情報読み込みに失敗しました: $e');
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _twoFactorCodeController.dispose();
    _hiddenController.dispose();
    for (var node in _focusNodes) {
      node.dispose();
    }
    _hiddenFocusNode.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final auth = ref.watch(vrchatAuthProvider).value!;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await auth.login(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (result.failure != null) {
        setState(() {
          _errorMessage = 'ログインに失敗しました。メールアドレスとパスワードを確認してください。';
        });
      } else if (result.success?.data.requiresTwoFactorAuth == true) {
        // 二段階認証が必要な場合
        setState(() {
          _showTwoFactorAuth = true;
        });
      } else {
        // 認証状態を更新
        ref.read(authRefreshProvider.notifier).state++;
        context.go('/');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'エラーが発生しました: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _verifyTwoFactorCode() async {
    if (_twoFactorCodeController.text.isEmpty) {
      setState(() {
        _errorMessage = '認証コードを入力してください';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final auth = ref.watch(vrchatAuthProvider).value!;
      final result = await auth.verify2fa(_twoFactorCodeController.text);

      if (!mounted) return; // この行はtry内で問題なし

      if (result.failure != null) {
        setState(() {
          _errorMessage = '二段階認証に失敗しました。コードが正しいか確認してください。';
        });
      } else {
        // 認証状態を更新
        ref.read(authRefreshProvider.notifier).state++;
        // ホーム画面に遷移
        context.go('/');
      }
    } catch (e) {
      if (!mounted) return; // この行はcatch内で問題なし
      setState(() {
        _errorMessage = 'エラーが発生しました: ${e.toString()}';
      });
    } finally {
      // ここの条件を変更して問題を解決
      if (mounted) {
        // 条件を反転させる
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset("assets/images/splash.png"),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _showTwoFactorAuth ? '二段階認証' : 'ログイン',
                          style: GoogleFonts.notoSans(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 既存のフォーム部分
                  if (!_showTwoFactorAuth) ...[
                    // 通常ログイン画面
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'メールアドレス',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'メールアドレスを入力してください';
                        }
                        return null;
                      },
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'パスワード',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'パスワードを入力してください';
                        }
                        return null;
                      },
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                ),
                              )
                              : Text(
                                'ログイン',
                                style: GoogleFonts.notoSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ] else ...[
                    // 二段階認証画面
                    Text(
                      '認証アプリに表示されている6桁のコードを入力してください',
                      style: GoogleFonts.notoSans(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // 修正: 認証コード入力欄を改善
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            bottom: 8.0,
                          ),
                          child: Text(
                            '認証コード',
                            style: GoogleFonts.notoSans(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                        // 非表示のマスターフィールド（ペースト用）
                        Offstage(
                          child: TextField(
                            controller: _hiddenController,
                            focusNode: _hiddenFocusNode,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            onChanged: (value) {
                              // ペーストされた6桁コードを各フィールドに分配
                              if (value.isNotEmpty) {
                                setState(() {
                                  for (int i = 0; i < 6; i++) {
                                    if (i < value.length) {
                                      _twoFactorCodeValue[i] = value[i];
                                    } else {
                                      _twoFactorCodeValue[i] = '';
                                    }
                                  }
                                });

                                // 自動的に検証へ進む
                                if (value.length == 6) {
                                  _twoFactorCodeController.text = value;
                                  _verifyTwoFactorCode();
                                } else if (value.isNotEmpty) {
                                  // フォーカスを適切なフィールドに移動
                                  _focusNodes[value.length - 1].requestFocus();
                                }

                                // 入力後、非表示フィールドをクリア
                                Future.delayed(Duration.zero, () {
                                  _hiddenController.clear();
                                });
                              }
                            },
                          ),
                        ),
                        // 入力フィールドを含むGestureDetector
                        GestureDetector(
                          // タップでペースト用フィールドにフォーカスを移動
                          onTap: () {
                            _hiddenFocusNode.requestFocus();
                          },
                          child: AbsorbPointer(
                            absorbing: false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                6,
                                (index) => SizedBox(
                                  width: 45,
                                  child: TextField(
                                    focusNode: _focusNodes[index],
                                    enabled: !_isLoading,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    controller: TextEditingController(
                                      text: _twoFactorCodeValue[index],
                                    ),
                                    style: GoogleFonts.robotoMono(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: InputDecoration(
                                      counterText: '',
                                      contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.outline,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        // 現在のフィールドを更新
                                        _twoFactorCodeValue[index] = value;

                                        // 次のフィールドにフォーカスを移動（最後のフィールド以外）
                                        if (index < 5) {
                                          FocusScope.of(context).nextFocus();
                                        } else {
                                          // 6桁すべて入力された場合は認証処理を開始
                                          if (_twoFactorCodeValue
                                                  .join()
                                                  .length ==
                                              6) {
                                            _twoFactorCodeController.text =
                                                _twoFactorCodeValue.join();
                                            _verifyTwoFactorCode();
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _verifyTwoFactorCode,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                ),
                              )
                              : Text(
                                '認証',
                                style: GoogleFonts.notoSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed:
                          !_isLoading
                              ? () {
                                setState(() {
                                  _showTwoFactorAuth = false;
                                  _errorMessage = null;
                                });
                              }
                              : null,
                      child: Text('ログイン画面に戻る', style: GoogleFonts.notoSans()),
                    ),
                  ],
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    ErrorContainer(message: _errorMessage!),
                  ],
                  if (kDebugMode && !_showTwoFactorAuth) ...[
                    const SizedBox(height: 16),
                    Text(
                      'デバッグモード: .envファイルから認証情報を読み込みました',
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
