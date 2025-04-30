import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/router/app_router.dart';
import 'package:vrchat/utils/auto_otp_helper.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _twoFactorCodeController = TextEditingController();
  final List<String> _twoFactorCodeValue = List.filled(6, '');
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final _hiddenController = TextEditingController();
  final _hiddenFocusNode = FocusNode();
  var _isLoading = false;
  String? _errorMessage;
  var _obscurePassword = true;
  var _showTwoFactorAuth = false;

  // アニメーション用コントローラー
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // アニメーションコントローラーの初期化
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // アニメーション開始
    _animationController.forward();

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
    for (final node in _focusNodes) {
      node.dispose();
    }
    _hiddenFocusNode.dispose();
    _animationController.dispose();
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
        // 新しい画面のアニメーションをリセットして再生
        _animationController.reset();
        await _animationController.forward();

        // 自動OTP入力を試行
        _tryAutoOtpInput();
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

      if (!mounted) return;

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

  // 自動OTP入力を試行するメソッド
  void _tryAutoOtpInput() {
    if (_showTwoFactorAuth) {
      final username = _usernameController.text;

      // 開発者アカウントの場合のみOTPを生成
      final otpCode = AutoOtpHelper.generateOtp(username);

      if (otpCode != null && otpCode.length == 6) {
        debugPrint('OTP自動入力: コード=$otpCode');

        // OTPコードを各桁に分解して入力
        setState(() {
          for (var i = 0; i < 6; i++) {
            _twoFactorCodeValue[i] = otpCode[i];
          }
          _twoFactorCodeController.text = otpCode;
        });

        // 自動認証を少し遅延して実行（UIの更新が完了するように）
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _verifyTwoFactorCode();
        });
      } else {
        debugPrint('OTP自動入力: 対象外のユーザーまたは生成失敗');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    // テキストカラーをモードに応じて設定
    final subtitleColor = isDarkMode ? Colors.grey[300] : Colors.grey[600];

    return Scaffold(
      body: DecoratedBox(
        // グラデーション背景
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDarkMode
                    ? [Colors.grey[900]!, Colors.black, Colors.grey[850]!]
                    : [
                      Colors.blue[50]!,
                      Colors.indigo[50]!,
                      Colors.purple[50]!,
                    ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Form(
                    key: _formKey,
                    child: AutofillGroup(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ロゴとタイトル
                          Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: Image.asset(
                                    'assets/images/splash.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  _showTwoFactorAuth ? '二段階認証' : 'VRCN',
                                  style: GoogleFonts.notoSans(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isDarkMode
                                            ? Colors.white
                                            : secondaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _showTwoFactorAuth
                                      ? '認証コードを入力してください'
                                      : 'VRChatのアカウント情報でログイン',
                                  style: GoogleFonts.notoSans(
                                    fontSize: 16,
                                    color: subtitleColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 48),

                          // ログインフォーム または 2FA フォーム
                          if (!_showTwoFactorAuth) ...[
                            // ユーザー名フィールド
                            _buildTextField(
                              controller: _usernameController,
                              labelText: 'メールアドレス',
                              hintText: 'メールまたはユーザー名を入力',
                              prefixIcon: Icons.person_outline_rounded,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'ユーザー名またはメールアドレスを入力してください';
                                }
                                return null;
                              },
                              autofillHints: const [
                                AutofillHints.username,
                                AutofillHints.email,
                              ],
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20),

                            // パスワードフィールド
                            _buildTextField(
                              controller: _passwordController,
                              labelText: 'パスワード',
                              hintText: 'パスワードを入力',
                              prefixIcon: Icons.lock_outline_rounded,
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  color: primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'パスワードを入力してください';
                                }
                                return null;
                              },
                              autofillHints: const [AutofillHints.password],
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) {
                                if (!_isLoading) _login();
                              },
                            ),

                            const SizedBox(height: 16),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  final url = Uri.parse(
                                    'https://vrchat.com/home/password',
                                  );
                                  launchUrl(url);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: primaryColor,
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'パスワードをお忘れですか？',
                                  style: GoogleFonts.notoSans(fontSize: 14),
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),

                            // ログインボタン
                            _buildGradientButton(
                              onPressed: _isLoading ? null : _login,
                              text: 'ログイン',
                              isLoading: _isLoading,
                            ),
                          ] else ...[
                            // 二段階認証画面
                            Text(
                              '認証アプリに表示されている\n6桁のコードを入力してください',
                              style: GoogleFonts.notoSans(
                                fontSize: 16,
                                color: subtitleColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 36),

                            // OTP入力フィールド
                            _buildOtpInputField(),
                            const SizedBox(height: 40),

                            // 認証ボタン
                            _buildGradientButton(
                              onPressed:
                                  _isLoading ? null : _verifyTwoFactorCode,
                              text: '認証',
                              isLoading: _isLoading,
                            ),

                            const SizedBox(height: 16),

                            // ログイン画面に戻るボタン
                            Center(
                              child: TextButton.icon(
                                onPressed:
                                    !_isLoading
                                        ? () {
                                          setState(() {
                                            _showTwoFactorAuth = false;
                                            _errorMessage = null;
                                          });

                                          // アニメーションをリセットして再生
                                          _animationController.reset();
                                          _animationController.forward();
                                        }
                                        : null,
                                icon: const Icon(Icons.arrow_back_rounded),
                                label: Text(
                                  'ログイン画面に戻る',
                                  style: GoogleFonts.notoSans(),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: primaryColor,
                                ),
                              ),
                            ),
                          ],

                          // エラーメッセージ
                          if (_errorMessage != null) ...[
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                    isDarkMode
                                        ? Colors.red.shade900.withAlpha(50)
                                        : Colors.red.withAlpha(25),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      isDarkMode
                                          ? Colors.red.shade800
                                          : Colors.red.withAlpha(75),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline_rounded,
                                    color:
                                        isDarkMode
                                            ? Colors.red.shade300
                                            : Colors.red,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: GoogleFonts.notoSans(
                                        fontSize: 14,
                                        color:
                                            isDarkMode
                                                ? Colors.red.shade200
                                                : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // デバッグ情報
                          if (kDebugMode && !_showTwoFactorAuth) ...[
                            const SizedBox(height: 32),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.black.withAlpha(10),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.bug_report_rounded,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'デバッグモード：.env認証情報を使用',
                                    style: GoogleFonts.notoSans(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // OTP入力フィールドを構築
  Widget _buildOtpInputField() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 非表示のマスターフィールド（これまでと同じ）
        Offstage(
          child: TextField(
            controller: _hiddenController,
            focusNode: _hiddenFocusNode,
            keyboardType: TextInputType.number,
            autofillHints: const [AutofillHints.oneTimeCode],
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  for (var i = 0; i < 6; i++) {
                    if (i < value.length) {
                      _twoFactorCodeValue[i] = value[i];
                    } else {
                      _twoFactorCodeValue[i] = '';
                    }
                  }
                });

                if (value.length == 6) {
                  _twoFactorCodeController.text = value;
                  _verifyTwoFactorCode();
                } else if (value.isNotEmpty) {
                  _focusNodes[value.length - 1].requestFocus();
                }

                Future.delayed(Duration.zero, _hiddenController.clear);
              }
            },
          ),
        ),

        // OTP入力フィールド
        GestureDetector(
          onTap: _hiddenFocusNode.requestFocus,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDarkMode ? 75 : 13),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, _buildDigitBox),
            ),
          ),
        ),

        // ペーストボタンを追加
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Center(
            child: TextButton.icon(
              onPressed: _pasteFromClipboard,
              icon: const Icon(Icons.content_paste_rounded),
              label: Text('コードをペースト', style: GoogleFonts.notoSans()),
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // OTP入力の各桁用ボックス
  Widget _buildDigitBox(int index) {
    final hasValue = _twoFactorCodeValue[index].isNotEmpty;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 40,
      height: 50,
      decoration: BoxDecoration(
        color:
            hasValue
                ? primaryColor.withAlpha(isDarkMode ? 75 : 25)
                : (isDarkMode ? Colors.grey[700] : Colors.grey[100]),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              hasValue
                  ? primaryColor
                  : (isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey.withAlpha(75)),
          width: hasValue ? 2 : 1,
        ),
      ),
      child: TextField(
        focusNode: _focusNodes[index],
        enabled: !_isLoading,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        controller: TextEditingController(text: _twoFactorCodeValue[index]),
        style: GoogleFonts.robotoMono(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : primaryColor,
        ),
        decoration: const InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          if (value.isNotEmpty) {
            _twoFactorCodeValue[index] = value;
            if (index < 5) {
              FocusScope.of(context).nextFocus();
            } else {
              if (_twoFactorCodeValue.join().length == 6) {
                _twoFactorCodeController.text = _twoFactorCodeValue.join();
                _verifyTwoFactorCode();
              }
            }
          }
        },
      ),
    );
  }

  // グラデーションボタンを構築
  Widget _buildGradientButton({
    required VoidCallback? onPressed,
    required String text,
    required bool isLoading,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              onPressed == null
                  ? [Colors.grey, Colors.grey.shade400]
                  : [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withAlpha(75),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child:
            isLoading
                ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : Text(
                  text,
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }

  // カスタムテキストフィールドを構築
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    required String? Function(String?) validator,
    bool obscureText = false,
    Widget? suffixIcon,
    List<String> autofillHints = const [],
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDarkMode ? 75 : 13),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        autofillHints: autofillHints,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        enabled: !_isLoading,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(
            prefixIcon,
            color: Theme.of(context).colorScheme.primary,
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: isDarkMode ? Colors.grey[600]! : Colors.grey.withAlpha(75),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: isDarkMode ? Colors.redAccent : Colors.red,
              width: 1.0,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          labelStyle: GoogleFonts.notoSans(
            color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
          ),
          hintStyle: GoogleFonts.notoSans(
            color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
          ),
          floatingLabelStyle: GoogleFonts.notoSans(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: GoogleFonts.notoSans(
          fontSize: 16,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
        validator: validator,
      ),
    );
  }

  // クリップボードからのペースト機能を追加
  Future<void> _pasteFromClipboard() async {
    // クリップボードからテキストを取得
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final text = clipboardData?.text;

    if (text != null && text.isNotEmpty) {
      // 数字のみを抽出
      final digitsOnly = text.replaceAll(RegExp(r'[^0-9]'), '');

      if (digitsOnly.isNotEmpty) {
        // 各桁に値を設定
        setState(() {
          for (var i = 0; i < 6; i++) {
            if (i < digitsOnly.length) {
              _twoFactorCodeValue[i] = digitsOnly[i];
            } else {
              _twoFactorCodeValue[i] = '';
            }
          }
        });

        // 6桁のコードを変数に設定
        if (digitsOnly.length >= 6) {
          final otpCode = digitsOnly.substring(0, 6);
          _twoFactorCodeController.text = otpCode;

          // 少し遅延してから認証処理を実行
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) _verifyTwoFactorCode();
          });
        }
      }
    }
  }
}
