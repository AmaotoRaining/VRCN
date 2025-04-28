import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/friends_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/widgets/error_container.dart';
import 'package:vrchat/widgets/loading_indicator.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final vrchatApi = ref.watch(vrchatProvider).value;
    final Map<String, String> headers = {
      'User-Agent': vrchatApi?.userAgent.toString() ?? 'VRChat/1.0',
    };

    return Scaffold(
      appBar: AppBar(title: Text('マイプロフィール', style: GoogleFonts.notoSans())),
      body: currentUserAsync.when(
        data:
            (user) => SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 64,
                          backgroundImage:
                              user.currentAvatarThumbnailImageUrl.isNotEmpty
                                  ? CachedNetworkImageProvider(
                                    user.currentAvatarThumbnailImageUrl,
                                    headers: headers,
                                  )
                                  : null,
                          child:
                              user.currentAvatarThumbnailImageUrl.isEmpty
                                  ? const Icon(Icons.person, size: 64)
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.displayName.isNotEmpty
                              ? user.displayName
                              : 'Unknown',
                          style: GoogleFonts.notoSans(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '@${user.displayName}',
                          style: GoogleFonts.notoSans(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileSection(
                          title: '基本情報',
                          items: [
                            _buildProfileItem(
                              icon: Icons.badge,
                              label: 'ユーザーID',
                              value: user.id,
                            ),
                            _buildProfileItem(
                              icon: Icons.calendar_today,
                              label: '登録日',
                              value:
                                  user.dateJoined !=
                                          DateTime.fromMillisecondsSinceEpoch(0)
                                      ? _formatDate(user.dateJoined)
                                      : '不明',
                            ),
                            _buildProfileItem(
                              icon: Icons.people,
                              label: 'フレンド数',
                              value: user.friendCount?.toString() ?? '0',
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        if (user.statusDescription.isNotEmpty)
                          _buildProfileSection(
                            title: 'ステータスメッセージ',
                            items: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.outline
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Text(
                                  user.statusDescription,
                                  style: GoogleFonts.notoSans(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 24),
                        if (user.bio.isNotEmpty)
                          _buildProfileSection(
                            title: '自己紹介',
                            items: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.outline
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Text(
                                  user.bio,
                                  style: GoogleFonts.notoSans(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        loading: () => const LoadingIndicator(message: 'プロフィール情報を読み込み中...'),
        error:
            (error, stackTrace) => ErrorContainer(
              message: 'プロフィール情報の取得に失敗しました: ${error.toString()}',
              onRetry: () => ref.refresh(currentUserProvider),
            ),
      ),
    );
  }

  Widget _buildProfileSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.notoSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...items,
      ],
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.notoSans(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(value, style: GoogleFonts.notoSans(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }
}

extension on CurrentUser {
  int? get friendCount => null;
}
