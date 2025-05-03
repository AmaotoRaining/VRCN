import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/instance_provider.dart';
import 'package:vrchat/provider/user_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/provider/world_provider.dart';
import 'package:vrchat/theme/app_theme.dart';
import 'package:vrchat/utils/cache_manager.dart';
import 'package:vrchat/utils/date_formatter.dart';
import 'package:vrchat/utils/status_helpers.dart';
import 'package:vrchat/utils/user_type_helpers.dart';
import 'package:vrchat/widgets/error_container.dart';
import 'package:vrchat/widgets/info_card.dart';
import 'package:vrchat/widgets/info_row.dart';
import 'package:vrchat/widgets/loading_indicator.dart';
import 'package:vrchat/widgets/location_info_card.dart';
import 'package:vrchat/widgets/user_badges_view.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class FriendDetailPage extends ConsumerWidget {
  final String userId;

  const FriendDetailPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendDetailAsync = ref.watch(userDetailProvider(userId));
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: friendDetailAsync.when(
        data: (user) => _buildUserDetail(context, user, ref, isDarkMode),
        loading: () => const LoadingIndicator(message: 'ユーザー情報を読み込み中...'),
        error:
            (error, stackTrace) => ErrorContainer(
              message: 'ユーザー情報の取得に失敗しました: ${error.toString()}',
              onRetry: () => ref.refresh(userDetailProvider(userId)),
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
    // locationがオフラインの場合はグレー系のカラーを使用
    final Color statusColor;
    if (user.location == 'offline') {
      statusColor = isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400;
    } else {
      statusColor = StatusHelper.getStatusColor(user.status);
    }

    final vrchatApi = ref.watch(vrchatProvider).value;
    final headers = {
      'User-Agent': vrchatApi?.userAgent.toString() ?? 'VRChat/1.0',
    };

    final userRepresentedGroupAsync = ref.watch(
      userRepresentedGroupProvider(user.id),
    );

    return RefreshIndicator(
      onRefresh: () async {
        ref.refresh(userDetailProvider(userId));
        if (user.worldId != null) {
          ref.refresh(worldDetailProvider(user.worldId!));
        }
        if (user.worldId != null && user.instanceId != null) {
          ref.refresh(
            instanceDetailProvider(
              InstanceParams(
                worldId: user.worldId!,
                instanceId: user.instanceId!,
              ),
            ),
          );
        }
        ref.refresh(userRepresentedGroupProvider(user.id));
      },
      color: statusColor,
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
      strokeWidth: 2.5,
      displacement: 40,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            backgroundColor:
                isDarkMode
                    ? AppTheme.primaryColor.withValues(alpha: .8)
                    : AppTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  userRepresentedGroupAsync.when(
                    data: (group) {
                      if (group != null && group.bannerUrl != null) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: group.bannerUrl!,
                              fit: BoxFit.cover,
                              httpHeaders: headers,
                              cacheManager: JsonCacheManager(),
                              placeholder:
                                  (context, url) =>
                                      Container(color: AppTheme.primaryColor),
                              errorWidget:
                                  (context, url, error) =>
                                      Container(color: AppTheme.primaryColor),
                            ),
                            Container(
                              color: Colors.black.withValues(alpha: 0.2),
                            ),
                            Positioned(
                              left: 16,
                              bottom: 16,
                              child: _buildUserTypeContainer(user, isDarkMode),
                            ),
                            if (user.badges != null && user.badges!.isNotEmpty)
                              Positioned(
                                right: 16,
                                bottom: 16,
                                child: UserBadgesView(
                                  user: user,
                                  isDarkMode: isDarkMode,
                                ),
                              ),
                          ],
                        );
                      } else {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            _buildGradientBackground(statusColor),
                            Positioned(
                              left: 16,
                              bottom: 16,
                              child: _buildUserTypeContainer(user, isDarkMode),
                            ),
                            if (user.badges != null && user.badges!.isNotEmpty)
                              Positioned(
                                right: 16,
                                bottom: 16,
                                child: UserBadgesView(
                                  user: user,
                                  isDarkMode: isDarkMode,
                                ),
                              ),
                          ],
                        );
                      }
                    },
                    loading:
                        () => Stack(
                          fit: StackFit.expand,
                          children: [
                            _buildGradientBackground(statusColor),
                            Positioned(
                              left: 16,
                              bottom: 16,
                              child: _buildUserTypeContainer(user, isDarkMode),
                            ),
                          ],
                        ),
                    error:
                        (_, _) => Stack(
                          fit: StackFit.expand,
                          children: [
                            _buildGradientBackground(statusColor),
                            Positioned(
                              left: 16,
                              bottom: 16,
                              child: _buildUserTypeContainer(user, isDarkMode),
                            ),
                          ],
                        ),
                  ),
                  _buildUserHeader(user, statusColor),
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
                  if (user.location != 'offline' && user.location != null)
                    InfoCard(
                      title: '現在の場所',
                      icon: Icons.location_on_outlined,
                      isDarkMode: isDarkMode,
                      customColor: Colors.green,
                      children: [
                        LocationInfoCard(user: user, isDarkMode: isDarkMode),
                      ],
                    ),
                  const SizedBox(height: 24),
                  InfoCard(
                    title: '基本情報',
                    icon: Icons.person_outline,
                    isDarkMode: isDarkMode,
                    children: [
                      InfoRow(
                        icon: Icons.badge,
                        label: 'ユーザーID',
                        value: user.id,
                        isDarkMode: isDarkMode,
                      ),
                      InfoRow(
                        icon: Icons.calendar_today,
                        label: '登録日',
                        value:
                            user.dateJoined !=
                                    DateTime.fromMillisecondsSinceEpoch(0)
                                ? DateFormatter.formatDate(user.dateJoined)
                                : 'Unknown',
                        isDarkMode: isDarkMode,
                      ),
                      InfoRow(
                        icon: Icons.timer,
                        label: '最終ログイン',
                        value: DateFormatter.formatDate(user.lastLogin),
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildUserBioCard(user, isDarkMode),
                  const SizedBox(height: 16),
                  _buildUserGroupCard(
                    context,
                    user,
                    userRepresentedGroupAsync,
                    headers,
                    isDarkMode,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTypeContainer(User user, bool isDarkMode) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ユーザータイプを表示
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: UserTypeHelper.getUserTypeColor(user.tags),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                UserTypeHelper.getUserTypeText(user.tags),
                style: GoogleFonts.notoSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        // プラットフォーム表示
        if (_getUserPlatform(user.lastPlatform) != null)
          Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _getPlatformColor(_getUserPlatform(user.lastPlatform)),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 2),
                Text(
                  _getUserPlatform(user.lastPlatform).toString(),
                  style: GoogleFonts.notoSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

        // 18+
        if (user.ageVerified)
          Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF596bdb), width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 2),
                Text(
                  '18+',
                  style: GoogleFonts.notoSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // プラットフォーム情報取得
  String? _getUserPlatform(String? lastPlatform) {
    if (lastPlatform == null) return null;

    switch (lastPlatform) {
      case 'standalonewindows':
        return 'PC';
      case 'android':
        return 'android';
      case 'ios':
        return 'iOS';
      default:
        return null;
    }
  }

  // プラットフォームに対応する色を取得
  Color _getPlatformColor(String? platform) {
    switch (platform) {
      case 'PC':
        return Colors.blue;
      case 'Android':
        return Colors.green;
      case 'iOS':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Widget _buildUserHeader(User user, Color statusColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
          tag: 'avatar-${user.id}',
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: statusColor, width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(child: _buildUserAvatar(user)),
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
              const Shadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (user.statusDescription.isNotEmpty)
          _buildStatusDescription(user, statusColor),
      ],
    );
  }

  Widget _buildUserAvatar(User user) {
    final headers = {'User-Agent': 'VRChat/1.0'};

    if (user.userIcon.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: user.userIcon,
        fit: BoxFit.cover,
        httpHeaders: headers,
        cacheManager: JsonCacheManager(),
        placeholder: (context, url) => Container(color: Colors.grey[300]),
        errorWidget:
            (context, url, error) =>
                const Icon(Icons.person, size: 80, color: Colors.white70),
      );
    } else if (user.currentAvatarThumbnailImageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: user.currentAvatarThumbnailImageUrl,
        fit: BoxFit.cover,
        httpHeaders: headers,
        cacheManager: JsonCacheManager(),
        placeholder: (context, url) => Container(color: Colors.grey[300]),
        errorWidget:
            (context, url, error) =>
                const Icon(Icons.person, size: 80, color: Colors.white70),
      );
    } else {
      return Container(
        color: Colors.grey[800],
        child: const Icon(Icons.person, size: 80, color: Colors.white70),
      );
    }
  }

  Widget _buildStatusDescription(User user, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            user.statusDescription,
            style: GoogleFonts.notoSans(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserBioCard(User user, bool isDarkMode) {
    if (user.bio.isEmpty) return const SizedBox.shrink();

    return InfoCard(
      title: '自己紹介',
      icon: Icons.info_outline,
      isDarkMode: isDarkMode,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[850] : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
            ),
          ),
          child: Text(
            user.bio,
            style: GoogleFonts.notoSans(
              fontSize: 16,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserGroupCard(
    BuildContext context,
    User user,
    AsyncValue<RepresentedGroup?> userGroupAsync,
    Map<String, String> headers,
    bool isDarkMode,
  ) {
    return userGroupAsync.when(
      data: (group) {
        if (group?.groupId != null) {
          return InfoCard(
            title: '所属グループ',
            icon: Icons.group_outlined,
            isDarkMode: isDarkMode,
            customColor: Colors.indigo,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (group?.iconUrl != null)
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
                          imageUrl: group!.iconUrl!,
                          httpHeaders: headers,
                          cacheManager: JsonCacheManager(),
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
                          group?.name ?? 'Unknown Group',
                          style: GoogleFonts.notoSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (group?.shortCode != null) ...[
                          Text(
                            'グループコード: ${group?.shortCode}',
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
                        if (group?.memberCount != null)
                          Text(
                            'メンバー数: ${group?.memberCount}人',
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
                label: Text('グループ詳細を表示', style: GoogleFonts.notoSans()),
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
      error: (_, _) => const SizedBox.shrink(),
    );
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
