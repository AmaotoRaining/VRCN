import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/friends_provider.dart';
import 'package:vrchat/provider/group_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/theme/app_theme.dart';
import 'package:vrchat/utils/status_helpers.dart';
import 'package:vrchat/utils/user_type_helpers.dart';
import 'package:vrchat/widgets/error_container.dart';
import 'package:vrchat/widgets/loading_indicator.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final vrchatApi = ref.watch(vrchatProvider).value;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Map<String, String> headers = {
      'User-Agent': vrchatApi?.userAgent.toString() ?? 'VRChat/1.0',
    };

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // TODO: プロフィール編集機能の実装
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('この機能は準備中です')));
            },
          ),
        ],
      ),
      body: currentUserAsync.when(
        data:
            (user) =>
                _buildProfileContent(context, ref, user, headers, isDarkMode),
        loading: () => const LoadingIndicator(message: 'プロフィール情報を読み込み中...'),
        error:
            (error, stackTrace) => ErrorContainer(
              message: 'プロフィール情報の取得に失敗しました: ${error.toString()}',
              onRetry: () => ref.refresh(currentUserProvider),
            ),
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    WidgetRef ref,
    CurrentUser user,
    Map<String, String> headers,
    bool isDarkMode,
  ) {
    final statusColor = StatusHelper.getStatusColor(user.status);
    final userRepresentedGroupAsync = ref.watch(
      userRepresentedGroupProvider(user.id),
    );

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ヘッダー部分
        SliverToBoxAdapter(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 260,
                decoration: BoxDecoration(
                  color:
                      userRepresentedGroupAsync.valueOrNull?.bannerUrl == null
                          ? AppTheme.primaryColor
                          : null,
                ),
                child: Stack(
                  children: [
                    if (userRepresentedGroupAsync.valueOrNull?.bannerUrl !=
                        null)
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl:
                              userRepresentedGroupAsync.valueOrNull!.bannerUrl!,
                          httpHeaders: headers,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) =>
                                  Container(color: AppTheme.primaryColor),
                          errorWidget:
                              (context, url, error) =>
                                  Container(color: AppTheme.primaryColor),
                        ),
                      ),
                    if (userRepresentedGroupAsync.valueOrNull?.bannerUrl !=
                        null)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.3),
                        ),
                      ),
                  ],
                ),
              ),

              // プロフィールカード
              Positioned(
                bottom: -60,
                left: 20,
                right: 20,
                child: Container(
                  height: 125, 
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF262626) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 120), // アバター用のスペース
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user.displayName,
                                style: GoogleFonts.poppins(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                // ignore: deprecated_member_use
                                '@${user.username}',
                                style: GoogleFonts.notoSans(
                                  fontSize: 14,
                                  color:
                                      isDarkMode
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: statusColor.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: statusColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          StatusHelper.getStatusText(
                                            user.status,
                                          ),
                                          style: GoogleFonts.notoSans(
                                            fontSize: 12,
                                            color: statusColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // アバター画像
              Positioned(
                bottom: 0,
                left: 40,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          isDarkMode ? const Color(0xFF262626) : Colors.white,
                      width: 5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        user.currentAvatarThumbnailImageUrl.isNotEmpty
                            ? CachedNetworkImageProvider(
                              user.currentAvatarThumbnailImageUrl,
                              headers: headers,
                            )
                            : null,
                    child:
                        user.currentAvatarThumbnailImageUrl.isEmpty
                            ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white70,
                            )
                            : null,
                  ),
                ),
              ),
            ],
          ),
        ),

        // プロフィール情報
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 統計情報カード
                _buildStatsCard(context, user, isDarkMode),

                const SizedBox(height: 24),

                // 基本情報セクション
                _buildInfoCard(
                  context: context,
                  title: '基本情報',
                  icon: Icons.person_outline,
                  isDarkMode: isDarkMode,
                  children: [
                    _buildInfoRow(
                      icon: Icons.badge,
                      label: 'ユーザーID',
                      value: user.id,
                      isDarkMode: isDarkMode,
                    ),
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      label: '登録日',
                      value:
                          user.dateJoined !=
                                  DateTime.fromMillisecondsSinceEpoch(0)
                              ? _formatDate(user.dateJoined)
                              : '不明',
                      isDarkMode: isDarkMode,
                    ),
                    _buildInfoRow(
                      icon: Icons.verified_user,
                      label: 'ユーザータイプ',
                      value: UserTypeHelper.getUserTypeText(user.tags),
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),

                // ステータスメッセージ（存在する場合）
                if (user.statusDescription.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildInfoCard(
                    context: context,
                    title: 'ステータスメッセージ',
                    icon: Icons.message_outlined,
                    isDarkMode: isDarkMode,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              isDarkMode ? Colors.grey[850] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isDarkMode
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!,
                          ),
                        ),
                        child: Text(
                          user.statusDescription,
                          style: GoogleFonts.notoSans(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color:
                                isDarkMode
                                    ? Colors.grey[300]
                                    : Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // 自己紹介（存在する場合）
                if (user.bio.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildInfoCard(
                    context: context,
                    title: '自己紹介',
                    icon: Icons.info_outline,
                    isDarkMode: isDarkMode,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              isDarkMode ? Colors.grey[850] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isDarkMode
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!,
                          ),
                        ),
                        child: Text(
                          user.bio,
                          style: GoogleFonts.notoSans(
                            fontSize: 16,
                            color:
                                isDarkMode
                                    ? Colors.grey[300]
                                    : Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // グループ情報（新規追加）
                userRepresentedGroupAsync.when(
                  data: (group) {
                    if (group != null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _buildInfoCard(
                            context: context,
                            title: '所属グループ',
                            icon: Icons.group_outlined,
                            isDarkMode: isDarkMode,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // グループアイコン（ある場合）
                                  if (group.iconUrl != null)
                                    Container(
                                      width: 60,
                                      height: 60,
                                      margin: const EdgeInsets.only(right: 16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color:
                                              isDarkMode
                                                  ? Colors.grey[700]!
                                                  : Colors.grey[300]!,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: group.iconUrl!,
                                          httpHeaders: headers,
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) => Container(
                                                color:
                                                    isDarkMode
                                                        ? Colors.grey[800]
                                                        : Colors.grey[200],
                                                child: Icon(
                                                  Icons.group,
                                                  color:
                                                      isDarkMode
                                                          ? Colors.grey[600]
                                                          : Colors.grey[400],
                                                  size: 30,
                                                ),
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
                                                  Container(
                                                    color:
                                                        isDarkMode
                                                            ? Colors.grey[800]
                                                            : Colors.grey[200],
                                                    child: Icon(
                                                      Icons.group,
                                                      color:
                                                          isDarkMode
                                                              ? Colors.grey[600]
                                                              : Colors
                                                                  .grey[400],
                                                      size: 30,
                                                    ),
                                                  ),
                                        ),
                                      ),
                                    ),

                                  // グループ詳細情報
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // グループ名
                                        Text(
                                          group.name ?? 'Unknown Group',
                                          style: GoogleFonts.notoSans(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                isDarkMode
                                                    ? Colors.white
                                                    : Colors.black87,
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        // グループコード（短縮コード）
                                        if (group.shortCode != null) ...[
                                          Text(
                                            'グループコード: ${group.shortCode}',
                                            style: GoogleFonts.notoSans(
                                              fontSize: 14,
                                              color:
                                                  isDarkMode
                                                      ? Colors.grey[300]
                                                      : Colors.grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                        ],

                                        // メンバー数（APIが提供していれば）
                                        if (group.memberCount != null)
                                          Text(
                                            'メンバー数: ${group.memberCount}人',
                                            style: GoogleFonts.notoSans(
                                              fontSize: 14,
                                              color:
                                                  isDarkMode
                                                      ? Colors.grey[300]
                                                      : Colors.grey[700],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // グループ詳細ボタン
                              const SizedBox(height: 16),
                              OutlinedButton.icon(
                                onPressed: () {
                                  // TODO: グループ詳細画面への遷移
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('グループ詳細機能は準備中です'),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.visibility_outlined),
                                label: Text(
                                  'グループ詳細を表示',
                                  style: GoogleFonts.notoSans(),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.indigo,
                                  side: const BorderSide(color: Colors.indigo),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink(); // グループがない場合は何も表示しない
                    }
                  },
                  loading:
                      () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 統計情報カード
  Widget _buildStatsCard(
    BuildContext context,
    CurrentUser user,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF262626) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.people_alt_rounded,
            value: user.friends.length.toString(),
            label: 'フレンド',
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  // 統計アイテム
  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required bool isDarkMode,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: GoogleFonts.notoSans(
            fontSize: 12,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // 情報カード
  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
    required bool isDarkMode,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF262626) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // カードヘッダー
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppTheme.primaryColor, size: 22),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.notoSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // カードコンテンツ
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  // 情報行アイテム
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    color: isDarkMode ? Colors.grey[200] : Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 日付フォーマット
  String _formatDate(DateTime? date) {
    if (date == null) return '不明';
    return '${date.year}/${date.month}/${date.day}';
  }
}
