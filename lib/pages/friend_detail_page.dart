import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/friends_provider.dart';
import 'package:vrchat/provider/group_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/provider/world_provider.dart';
import 'package:vrchat/theme/app_theme.dart';
import 'package:vrchat/utils/status_helpers.dart';
import 'package:vrchat/utils/user_type_helpers.dart';
import 'package:vrchat/widgets/error_container.dart';
import 'package:vrchat/widgets/loading_indicator.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class FriendDetailPage extends ConsumerWidget {
  final String userId;

  const FriendDetailPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendDetailAsync = ref.watch(friendDetailProvider(userId));
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: friendDetailAsync.when(
        data: (user) => _buildUserDetail(context, user, ref, isDarkMode),
        loading: () => const LoadingIndicator(message: 'ユーザー情報を読み込み中...'),
        error:
            (error, stackTrace) => ErrorContainer(
              message: 'ユーザー情報の取得に失敗しました: ${error.toString()}',
              onRetry: () => ref.refresh(friendDetailProvider(userId)),
            ),
      ),
    );
  }

  Widget _buildUserDetail(
    BuildContext context,
    User user,
    WidgetRef ref,
    bool isDarkMode,
  ) {
    final statusColor = StatusHelper.getStatusColor(user.status);
    final statusText = StatusHelper.getStatusText(user.status);

    final vrchatApi = ref.watch(vrchatProvider).value;
    final headers = {
      'User-Agent': vrchatApi?.userAgent.toString() ?? 'VRChat/1.0',
    };

    // ユーザーの代表グループ情報を取得
    final userRepresentedGroupAsync = ref.watch(
      userRepresentedGroupProvider(user.id),
    );

    if (user.worldId != null) {
      ref.watch(worldDetailProvider(user.worldId!));
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          stretch: true,
          backgroundColor:
              isDarkMode
                  ? AppTheme.primaryColor.withValues(alpha: 0.8)
                  : AppTheme.primaryColor,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                userRepresentedGroupAsync.when(
                  data: (group) {
                    // グループがあり、バナー画像がある場合はそれを表示
                    if (group != null && group.bannerUrl != null) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          // グループバナー画像 - フィルタなしでクリアに表示
                          CachedNetworkImage(
                            imageUrl: group.bannerUrl!,
                            fit: BoxFit.cover,
                            httpHeaders: headers,
                            placeholder:
                                (context, url) => Container(
                                  // 単色のプレースホルダー（グラデーションなし）
                                  color: AppTheme.primaryColor,
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  // 単色のエラー表示（グラデーションなし）
                                  color: AppTheme.primaryColor,
                                ),
                          ),
                          Container(color: Colors.black.withValues(alpha: 0.2)),
                        ],
                      );
                    } else {
                      // グループがない場合は既存のグラデーション背景を使用
                      return _buildGradientBackground(statusColor);
                    }
                  },
                  loading: () => _buildGradientBackground(statusColor),
                  error: (_, __) => _buildGradientBackground(statusColor),
                ),

                // 装飾用の円（既存のコード）
                Positioned(
                  top: -50,
                  right: -50,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -80,
                  left: -20,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),

                // ユーザー情報（既存のコード）
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'avatar-${user.id}',
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child:
                              user.userIcon.isNotEmpty
                                  ? CachedNetworkImage(
                                    imageUrl: user.userIcon,
                                    fit: BoxFit.cover,
                                    httpHeaders: headers,
                                    placeholder:
                                        (context, url) =>
                                            Container(color: Colors.grey[300]),
                                    errorWidget:
                                        (context, url, error) => const Icon(
                                          Icons.person,
                                          size: 80,
                                          color: Colors.white70,
                                        ),
                                  )
                                  : (user
                                          .currentAvatarThumbnailImageUrl
                                          .isNotEmpty
                                      ? CachedNetworkImage(
                                        imageUrl:
                                            user.currentAvatarThumbnailImageUrl,
                                        fit: BoxFit.cover,
                                        httpHeaders: headers,
                                        placeholder:
                                            (context, url) => Container(
                                              color: Colors.grey[300],
                                            ),
                                        errorWidget:
                                            (context, url, error) => const Icon(
                                              Icons.person,
                                              size: 80,
                                              color: Colors.white70,
                                            ),
                                      )
                                      : Container(
                                        color: Colors.grey[800],
                                        child: const Icon(
                                          Icons.person,
                                          size: 80,
                                          color: Colors.white70,
                                        ),
                                      )),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.displayName,
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor, width: 1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            statusText,
                            style: GoogleFonts.notoSans(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
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
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // if (isOnline) _buildActionButtons(context),
                const SizedBox(height: 24),
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
                              : 'Unknown',
                      isDarkMode: isDarkMode,
                    ),
                    _buildInfoRow(
                      icon: Icons.timer,
                      label: '最終ログイン',
                      value: _formatDate(user.lastLogin),
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
                const SizedBox(height: 16),
                if (user.statusDescription.isNotEmpty)
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
                const SizedBox(height: 16),
                if (user.location != 'offline' && user.location != null)
                  _buildInfoCard(
                    context: context,
                    title: '現在の場所',
                    icon: Icons.location_on_outlined,
                    isDarkMode: isDarkMode,
                    customColor: Colors.green,
                    children: [
                      _buildLocationInfo(context, user, isDarkMode, ref),
                    ],
                  ),
                const SizedBox(height: 16),
                if (user.bio.isNotEmpty)
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
                const SizedBox(height: 16),
                userRepresentedGroupAsync.when(
                  data: (group) {
                    if (group != null) {
                      return _buildInfoCard(
                        context: context,
                        title: '所属グループ',
                        icon: Icons.group_outlined,
                        isDarkMode: isDarkMode,
                        customColor: Colors.indigo,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                          (context, url, error) => Container(
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
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('グループ詳細機能は準備中です')),
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
                      );
                    } else {
                      return const SizedBox.shrink();
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
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
    required bool isDarkMode,
    Color? customColor,
  }) {
    final color = customColor ?? AppTheme.primaryColor;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              border: Border(
                bottom: BorderSide(color: color.withValues(alpha: 0.2)),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.notoSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
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

  Widget _buildLocationInfo(
    BuildContext context,
    User user,
    bool isDarkMode,
    WidgetRef ref,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A3320) : const Color(0xFFE0F5E6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.public, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'ワールド : ${(user.worldId)}',
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.green[100] : Colors.green[900],
                  ),
                ),
              ),
            ],
          ),
          if (user.instanceId != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 28),
              child: Text(
                'Instance: ${user.instanceId}',
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  color: isDarkMode ? Colors.green[200] : Colors.green[800],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('準備中: この機能は開発中です')));
            },
            icon: const Icon(Icons.login),
            label: Text('自分に招待を送信', style: GoogleFonts.notoSans()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic dateInput) {
    if (dateInput is DateTime) {
      return '${dateInput.year}/${dateInput.month}/${dateInput.day} ${dateInput.hour}:${dateInput.minute.toString().padLeft(2, '0')}';
    } else if (dateInput is String) {
      try {
        final date = DateTime.parse(dateInput);
        return '${date.year}/${date.month}/${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      } catch (e) {
        return dateInput;
      }
    }

    // その他の型の場合は文字列変換
    return dateInput?.toString() ?? '不明';
  }

  Widget _buildGradientBackground(Color statusColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            statusColor.withValues(alpha: 0.7),
            AppTheme.primaryColor.withValues(alpha: 0.9),
          ],
        ),
      ),
    );
  }
}
