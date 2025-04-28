import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/friends_provider.dart';
import 'package:vrchat/widgets/error_container.dart';
import 'package:vrchat/widgets/loading_indicator.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class FriendDetailPage extends ConsumerWidget {
  final String userId;

  const FriendDetailPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendDetailAsync = ref.watch(friendDetailProvider(userId));

    return Scaffold(
      appBar: AppBar(title: Text('フレンド詳細', style: GoogleFonts.notoSans())),
      body: friendDetailAsync.when(
        data: (user) => _buildUserDetail(context, user),
        loading: () => const LoadingIndicator(message: 'ユーザー情報を読み込み中...'),
        error:
            (error, stackTrace) => ErrorContainer(
              message: 'ユーザー情報の取得に失敗しました: ${error.toString()}',
              onRetry: () => ref.refresh(friendDetailProvider(userId)),
            ),
      ),
    );
  }

  Widget _buildUserDetail(BuildContext context, User user) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // プロフィール画像とステータス
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 64,
                  backgroundImage:
                      user.currentAvatarThumbnailImageUrl.isEmpty
                          ? null
                          : CachedNetworkImageProvider(
                            user.currentAvatarThumbnailImageUrl,
                          ),
                  child:
                      user.currentAvatarThumbnailImageUrl.isEmpty
                          ? const Icon(Icons.person, size: 64)
                          : null,
                ),
                const SizedBox(height: 16),
                Text(
                  user.displayName,
                  style: GoogleFonts.notoSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(user.status),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _getStatusText(user.status),
                    style: GoogleFonts.notoSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ユーザー情報
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoSection(
                  title: '基本情報',
                  children: [
                    _buildInfoRow(
                      icon: Icons.badge,
                      label: 'ユーザーID',
                      value: user.id,
                    ),
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      label: '登録日',
                      value:
                          user.dateJoined !=
                                  DateTime.fromMillisecondsSinceEpoch(0)
                              ? _formatDate(user.dateJoined)
                              : 'Unknown',
                    ),
                    _buildInfoRow(
                      icon: Icons.timer,
                      label: '最終ログイン',
                      value: user.lastLogin,
                    ),
                    _buildInfoRow(
                      icon: Icons.verified_user,
                      label: 'ユーザータイプ',
                      value: _getUserTypeText(user.tags),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                if (user.statusDescription.isNotEmpty)
                  _buildInfoSection(
                    title: 'ステータスメッセージ',
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withValues(alpha: 0.5),
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

                if (user.location != 'offline')
                  _buildInfoSection(
                    title: '現在の場所',
                    children: [
                      _buildInfoRow(
                        icon: Icons.location_on,
                        label: 'ワールド',
                        value: user.worldId ?? 'Unknown',
                      ),
                      _buildInfoRow(
                        icon: Icons.public,
                        label: 'インスタンス',
                        value: user.instanceId ?? 'Unknown',
                      ),
                    ],
                  ),

                const SizedBox(height: 24),

                if (user.bio.isNotEmpty)
                  _buildInfoSection(
                    title: '自己紹介',
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withValues(alpha: 0.5),
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
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<Widget> children,
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
        ...children,
      ],
    );
  }

  Widget _buildInfoRow({
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

  Color _getStatusColor(UserStatus? status) {
    switch (status) {
      case UserStatus.active:
        return Colors.green;
      case UserStatus.joinMe:
        return Colors.blue;
      case UserStatus.askMe:
        return Colors.orange;
      case UserStatus.busy:
        return Colors.red;
      case UserStatus.offline:
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(UserStatus? status) {
    switch (status) {
      case UserStatus.active:
        return 'オンライン';
      case UserStatus.joinMe:
        return '参加してね';
      case UserStatus.askMe:
        return '誘ってね';
      case UserStatus.busy:
        return '取り込み中';
      case UserStatus.offline:
        return 'オフライン';
      default:
        return 'ステータス不明';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getUserTypeText(List<String>? tags) {
    if (tags == null) return 'Standard User';

    if (tags.contains('admin')) return 'Admin';
    if (tags.contains('system_trust_veteran')) return 'Trusted User';
    if (tags.contains('system_trust_trusted')) return 'Known User';
    if (tags.contains('system_trust_known')) return 'User';
    if (tags.contains('system_trust_basic')) return 'New User';

    return 'Visitor';
  }
}
