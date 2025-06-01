import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/user_provider.dart';
import 'package:vrchat/theme/app_theme.dart';
import 'package:vrchat/utils/status_helpers.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class ProfileEditSheet extends ConsumerStatefulWidget {
  final CurrentUser user;

  const ProfileEditSheet({super.key, required this.user});

  @override
  ConsumerState<ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends ConsumerState<ProfileEditSheet>
    with SingleTickerProviderStateMixin {
  late TextEditingController _statusDescriptionController;
  late TextEditingController _bioController;
  List<TextEditingController> _bioLinkControllers = [];
  late TextEditingController _pronounsController;
  late UserStatus _selectedStatus;
  var _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // フォーカスノード
  final _bioFocusNode = FocusNode();
  final _statusDescriptionFocusNode = FocusNode();
  final _pronounsFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeControllers();

    // アニメーションコントローラの初期化
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  void _initializeControllers() {
    // 既存のコード
    _statusDescriptionController = TextEditingController(
      text: widget.user.statusDescription,
    );
    _bioController = TextEditingController(text: widget.user.bio);
    _bioLinkControllers =
        widget.user.bioLinks
            .map((link) => TextEditingController(text: link))
            .toList();
    if (_bioLinkControllers.isEmpty) {
      _bioLinkControllers.add(TextEditingController());
    }
    _pronounsController = TextEditingController(text: widget.user.pronouns);
    _selectedStatus = widget.user.status;
  }

  @override
  void dispose() {
    _statusDescriptionController.dispose();
    _bioController.dispose();
    for (final controller in _bioLinkControllers) {
      controller.dispose();
    }
    _pronounsController.dispose();
    _bioFocusNode.dispose();
    _statusDescriptionFocusNode.dispose();
    _pronounsFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final bioLinks =
          _bioLinkControllers
              .map((controller) => controller.text.trim())
              .where((link) => link.isNotEmpty)
              .toList();

      final updateRequest = UpdateUserRequest(
        status: _selectedStatus,
        statusDescription: _statusDescriptionController.text,
        bio: _bioController.text,
        bioLinks: bioLinks,
        pronouns: _pronounsController.text,
      );

      await ref.read(updateUserProvider(updateRequest).future);
      ref.invalidate(currentUserProvider);

      try {
        await ref.read(currentUserProvider.future);
      } catch (e) {
        debugPrint('ユーザー情報の再取得中にエラーが発生: $e');
      }

      if (mounted) {
        // 保存成功アニメーション
        setState(() {
          _isLoading = false;
        });

        // 成功メッセージ表示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('プロフィールを更新しました'),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );

        // 閉じるアニメーション
        await _animationController.reverse();
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Flexible(child: Text('更新に失敗しました: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const accentColor = AppTheme.primaryColor;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final backgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final secondaryColor =
        isDarkMode
            ? accentColor.withValues(alpha: 0.15)
            : accentColor.withValues(alpha: 0.08);

    return PopScope(
      canPop: !_hasUnsavedChanges(),
      onPopInvokedWithResult: (didPop, [dynamic result]) async {
        if (didPop) return;
        final shouldPop = await _showDiscardChangesDialog();
        if (shouldPop && context.mounted) {
          await _animationController.reverse();
          Navigator.of(context).pop();
        }
      },
      child: FadeTransition(
        opacity: _animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(_animation),
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Stack(
              children: [
                // 装飾的な背景エレメント
                Positioned(
                  top: -100,
                  right: -100,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -80,
                  left: -60,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withValues(alpha: 0.07),
                    ),
                  ),
                ),

                // メインコンテンツ
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ハンドル
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ヘッダー
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, color: accentColor),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'プロフィールを編集',
                              style: GoogleFonts.notoSans(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // ステータスセクション
                      _buildSectionHeader(
                        '現在のステータス',
                        Icons.mood,
                        accentColor,
                        isDarkMode,
                      ),
                      const SizedBox(height: 12),
                      _buildStatusSelector(isDarkMode, accentColor),
                      const SizedBox(height: 24),

                      // ステータスメッセージセクション
                      _buildSectionHeader(
                        'ステータスメッセージ',
                        Icons.chat_bubble_outline,
                        accentColor,
                        isDarkMode,
                      ),
                      const SizedBox(height: 12),
                      _buildStyledTextField(
                        controller: _statusDescriptionController,
                        focusNode: _statusDescriptionFocusNode,
                        hintText: 'あなたの今の状況やメッセージを入力',
                        maxLength: 100,
                        prefix: Icon(
                          Icons.short_text,
                          color: accentColor.withValues(alpha: 0.7),
                          size: 22,
                        ),
                        isDarkMode: isDarkMode,
                        accentColor: accentColor,
                      ),
                      const SizedBox(height: 24),

                      // 自己紹介セクション
                      _buildSectionHeader(
                        '自己紹介',
                        Icons.person_outline,
                        accentColor,
                        isDarkMode,
                      ),
                      const SizedBox(height: 12),
                      _buildStyledTextField(
                        controller: _bioController,
                        focusNode: _bioFocusNode,
                        hintText: 'あなた自身について書いてみましょう',
                        maxLength: 500,
                        maxLines: 5,
                        isDarkMode: isDarkMode,
                        accentColor: accentColor,
                      ),
                      const SizedBox(height: 24),

                      // リンクセクション
                      _buildBioLinksSection(
                        isDarkMode,
                        accentColor,
                        secondaryColor,
                      ),
                      const SizedBox(height: 24),

                      // 代名詞セクション
                      _buildSectionHeader(
                        '代名詞',
                        Icons.label_outline,
                        accentColor,
                        isDarkMode,
                      ),
                      const SizedBox(height: 12),
                      _buildStyledTextField(
                        controller: _pronounsController,
                        focusNode: _pronounsFocusNode,
                        hintText: '例: he/him, she/her, they/them',
                        maxLength: 50,
                        prefix: Icon(
                          Icons.person_pin,
                          color: accentColor.withValues(alpha: 0.7),
                          size: 22,
                        ),
                        isDarkMode: isDarkMode,
                        accentColor: accentColor,
                      ),
                      const SizedBox(height: 32),

                      // 保存ボタン
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            shadowColor: accentColor.withValues(alpha: 0.4),
                          ),
                          child:
                              _isLoading
                                  ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.check_circle),
                                      const SizedBox(width: 10),
                                      Text(
                                        '変更を保存',
                                        style: GoogleFonts.notoSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    IconData icon,
    Color accentColor,
    bool isDarkMode,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: accentColor.withValues(alpha: 0.8)),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.notoSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color:
                isDarkMode
                    ? Colors.white.withValues(alpha: 0.9)
                    : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required bool isDarkMode,
    required Color accentColor,
    int maxLength = 100,
    int maxLines = 1,
    Widget? prefix,
  }) {
    final borderColor = isDarkMode ? Colors.grey[700] : Colors.grey[300];
    final fillColor =
        isDarkMode ? Colors.grey[800]!.withValues(alpha: 0.3) : Colors.grey[50];

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor!, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: accentColor, width: 1.5),
        ),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        prefixIcon: prefix,
        counterStyle: TextStyle(
          color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
          fontSize: 12,
        ),
      ),
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
      maxLength: maxLength,
      maxLines: maxLines,
      cursorColor: accentColor,
    );
  }

  Widget _buildStatusSelector(bool isDarkMode, Color accentColor) {
    final statusOptions = [
      UserStatus.joinMe,
      UserStatus.active,
      UserStatus.askMe,
      UserStatus.busy,
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? Colors.grey[850]!.withValues(alpha: 0.5)
                : Colors.grey[100]!.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<UserStatus>(
            value: _selectedStatus,
            icon: Icon(
              Icons.arrow_drop_down_circle_outlined,
              color: accentColor.withValues(alpha: 0.7),
            ),
            isExpanded: true,
            dropdownColor: isDarkMode ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            items:
                statusOptions.map((status) {
                  final statusColor = StatusHelper.getStatusColor(status);
                  final statusText = StatusHelper.getStatusText(status);

                  return DropdownMenuItem<UserStatus>(
                    value: status,
                    child: Row(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: statusColor.withValues(alpha: 0.4),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          statusText,
                          style: GoogleFonts.notoSans(
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedStatus = newValue;
                });
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBioLinksSection(
    bool isDarkMode,
    Color accentColor,
    Color secondaryColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader('リンク', Icons.link, accentColor, isDarkMode),
            TextButton.icon(
              onPressed: _addLinkField,
              icon: const Icon(Icons.add_circle, size: 18),
              label: const Text('追加'),
              style: TextButton.styleFrom(
                foregroundColor: accentColor,
                backgroundColor: secondaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._bioLinkControllers.asMap().entries.map((entry) {
          final index = entry.key;
          final controller = entry.value;

          return _buildLinkField(
            controller: controller,
            index: index,
            isDarkMode: isDarkMode,
            accentColor: accentColor,
          );
        }),
      ],
    );
  }

  Widget _buildLinkField({
    required TextEditingController controller,
    required int index,
    required bool isDarkMode,
    required Color accentColor,
  }) {
    final focusNode = FocusNode();
    final borderColor = isDarkMode ? Colors.grey[700] : Colors.grey[300];
    final fillColor =
        isDarkMode ? Colors.grey[800]!.withValues(alpha: 0.3) : Colors.grey[50];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor!, width: 1.5),
          color: fillColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Icon(
                Icons.language,
                size: 20,
                color: accentColor.withValues(alpha: 0.6),
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: 'https://example.com',
                  hintStyle: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                ),
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
                cursorColor: accentColor,
              ),
            ),
            IconButton(
              icon: Icon(Icons.remove_circle, color: Colors.red[400], size: 22),
              onPressed: () => _removeLinkField(index),
              tooltip: '削除',
              style: IconButton.styleFrom(
                backgroundColor: Colors.red[50]?.withValues(alpha: 0.2),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  void _addLinkField() {
    setState(() {
      _bioLinkControllers.add(TextEditingController());
    });
  }

  void _removeLinkField(int index) {
    setState(() {
      _bioLinkControllers[index].dispose();
      _bioLinkControllers.removeAt(index);

      if (_bioLinkControllers.isEmpty) {
        _bioLinkControllers.add(TextEditingController());
      }
    });
  }

  // 変更があるかチェックする関数
  bool _hasUnsavedChanges() {
    // オリジナルの値と現在の値を比較
    if (_statusDescriptionController.text != widget.user.statusDescription) {
      return true;
    }
    if (_bioController.text != widget.user.bio) {
      return true;
    }
    if (_pronounsController.text != widget.user.pronouns) {
      return true;
    }
    if (_selectedStatus != widget.user.status) {
      return true;
    }

    // リンク数が変わっていれば変更あり
    if (_bioLinkControllers.length != widget.user.bioLinks.length) {
      return true;
    }

    // リンクの中身を比較
    for (var i = 0; i < _bioLinkControllers.length; i++) {
      if (i >= widget.user.bioLinks.length ||
          _bioLinkControllers[i].text.trim() != widget.user.bioLinks[i]) {
        return true;
      }
    }

    return false; // 変更なし
  }

  // 確認ダイアログを表示する関数
  Future<bool> _showDiscardChangesDialog() async {
    if (!mounted) return false;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => AlertDialog(
            // contextではなくdialogContextを使用
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.amber[700]),
                const SizedBox(width: 12),
                const Text('変更を破棄しますか？'),
              ],
            ),
            content: const Text('プロフィールに加えた変更は保存されません。'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor:
                Theme.of(dialogContext).brightness ==
                        Brightness
                            .dark // dialogContextを使用
                    ? Colors.grey[850]
                    : Colors.white,
            elevation: 8,
            actions: [
              TextButton(
                onPressed:
                    () => Navigator.of(
                      dialogContext,
                    ).pop(false), // dialogContextを使用
                child: const Text(
                  'キャンセル',
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
              ),
              ElevatedButton(
                onPressed:
                    () => Navigator.of(
                      dialogContext,
                    ).pop(true), // dialogContextを使用
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('破棄する'),
              ),
            ],
          ),
    );

    return result ?? false;
  }
}
