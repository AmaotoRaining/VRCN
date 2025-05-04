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

class _ProfileEditSheetState extends ConsumerState<ProfileEditSheet> {
  late TextEditingController _statusDescriptionController;
  late TextEditingController _bioController;
  List<TextEditingController> _bioLinkControllers = [];
  late TextEditingController _pronounsController;
  late UserStatus _selectedStatus;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _statusDescriptionController = TextEditingController(
      text: widget.user.statusDescription,
    );
    _bioController = TextEditingController(text: widget.user.bio);

    // 既存のコントローラがあれば破棄
    for (final controller in _bioLinkControllers) {
      controller.dispose();
    }

    // 新しいリストを作成
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
  void didUpdateWidget(ProfileEditSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user != widget.user) {
      _statusDescriptionController.text = widget.user.statusDescription;
      _bioController.text = widget.user.bio;
      _pronounsController.text = widget.user.pronouns;
      _selectedStatus = widget.user.status;
      _updateBioLinkControllers();
    }
  }

  void _updateBioLinkControllers() {
    final currentControllers = List<TextEditingController>.from(
      _bioLinkControllers,
    );
    _bioLinkControllers = [];

    for (var i = 0; i < widget.user.bioLinks.length; i++) {
      if (i < currentControllers.length) {
        currentControllers[i].text = widget.user.bioLinks[i];
        _bioLinkControllers.add(currentControllers[i]);
      } else {
        _bioLinkControllers.add(
          TextEditingController(text: widget.user.bioLinks[i]),
        );
      }
    }

    for (
      var i = widget.user.bioLinks.length;
      i < currentControllers.length;
      i++
    ) {
      currentControllers[i].dispose();
    }

    if (_bioLinkControllers.isEmpty) {
      _bioLinkControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _statusDescriptionController.dispose();
    _bioController.dispose();
    for (final controller in _bioLinkControllers) {
      controller.dispose();
    }
    _pronounsController.dispose();
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
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('更新に失敗しました: ${e.toString()}')));
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'プロフィールを編集',
              style: GoogleFonts.notoSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'ステータス',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            _buildStatusSelector(isDarkMode),
            const SizedBox(height: 16),
            Text(
              'ステータスメッセージ',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _statusDescriptionController,
              decoration: InputDecoration(
                hintText: 'ステータスメッセージを入力',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLength: 100,
            ),
            const SizedBox(height: 16),
            Text(
              '自己紹介',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _bioController,
              decoration: InputDecoration(
                hintText: '自己紹介を入力',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              maxLines: 5,
              maxLength: 500,
            ),
            const SizedBox(height: 16),
            _buildBioLinksSection(),
            const SizedBox(height: 16),
            Text(
              '代名詞',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _pronounsController,
              decoration: InputDecoration(
                hintText: '例: he/him, she/her, they/them',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLength: 50,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Text(
                          '保存する',
                          style: GoogleFonts.notoSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSelector(bool isDarkMode) {
    final statusOptions = [
      UserStatus.joinMe,
      UserStatus.active,
      UserStatus.askMe,
      UserStatus.busy,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<UserStatus>(
          value: _selectedStatus,
          icon: const Icon(Icons.arrow_drop_down),
          isExpanded: true,
          dropdownColor: isDarkMode ? Colors.grey[850] : Colors.white,
          items:
              statusOptions.map((status) {
                return DropdownMenuItem<UserStatus>(
                  value: status,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: StatusHelper.getStatusColor(status),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(StatusHelper.getStatusText(status)),
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
    );
  }

  Widget _buildBioLinksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'リンク',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton.icon(
              onPressed: _addLinkField,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('追加'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ..._bioLinkControllers.asMap().entries.map((entry) {
          final index = entry.key;
          final controller = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'https://example.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => _removeLinkField(index),
                  color: Colors.red[400],
                  tooltip: '削除',
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
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
}
