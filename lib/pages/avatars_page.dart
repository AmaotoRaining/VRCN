import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/avatar_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/theme/app_theme.dart';
import 'package:vrchat/utils/cache_manager.dart';
import 'package:vrchat/widgets/error_container.dart';
import 'package:vrchat/widgets/loading_indicator.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class AvatarsPage extends ConsumerStatefulWidget {
  const AvatarsPage({super.key});

  @override
  ConsumerState<AvatarsPage> createState() => _AvatarsPageState();
}

class _AvatarsPageState extends ConsumerState<AvatarsPage>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  var _currentOffset = 0;
  final _pageSize = 100;
  var _isLoadingMore = false;

  AvatarViewMode _viewMode = AvatarViewMode.grid;

  SortOption _sortOption = SortOption.updated;
  final _orderOption = OrderOption.descending;
  var _sortByName = false;

  late AnimationController _animationController;

  List<Avatar> _avatarList = [];
  var _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshAvatars();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore) {
      _loadMoreAvatars();
    }
  }

  Future<void> _loadMoreAvatars() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
      _currentOffset += _pageSize;
    });

    try {
      final params = _getSearchParams();
      var newAvatars = await ref.read(avatarSearchProvider(params).future);

      if (_sortByName) {
        final allAvatars = [..._avatarList, ...newAvatars];
        final sortedAvatars = _sortAvatarsByName(allAvatars);

        newAvatars = sortedAvatars.sublist(_avatarList.length);
      }

      if (mounted) {
        setState(() {
          _avatarList.addAll(newAvatars);
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  AvatarSearchParams _getSearchParams() {
    return AvatarSearchParams(
      n: _pageSize,
      offset: _currentOffset,
      sort: _sortOption,
      order: _orderOption,
      user: 'me',
      releaseStatus: null,
    );
  }

  // リストを更新
  Future<void> _refreshAvatars() async {
    setState(() {
      _currentOffset = 0;
      _avatarList = [];
      _isInitialized = false;
    });

    if (_animationController.isAnimating) {
      await _animationController.forward(from: 0);
    } else {
      _animationController.reset();
    }

    try {
      final params = _getSearchParams();

      var avatars = await ref.read(avatarSearchProvider(params).future);

      if (_sortByName) {
        avatars = _sortAvatarsByName(avatars);
      }

      if (mounted) {
        setState(() {
          _avatarList = avatars;
          _isInitialized = true;
        });
        await _animationController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
      debugPrint('アバターの更新に失敗: $e');
    }
  }

  // 名前順でソートするヘルパーメソッド
  List<Avatar> _sortAvatarsByName(List<Avatar> avatars) {
    final sortedList = List<Avatar>.from(avatars);
    sortedList.sort((a, b) => a.name.compareTo(b.name));
    return sortedList;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F8F8);
    final vrchatApi = ref.watch(vrchatProvider).value;

    // API呼び出し用のヘッダー
    final headers = <String, String>{
      'User-Agent': vrchatApi?.userAgent.toString() ?? 'VRChat/1.0',
    };

    // 初期ロード用のプロバイダー - キャッシュは使うが状態管理は手動で行う
    final avatarsAsync = ref.watch(avatarSearchProvider(_getSearchParams()));

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(isDarkMode),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshAvatars,
                child: Builder(
                  builder: (context) {
                    // 初期化前ならプロバイダーの状態を使用
                    if (!_isInitialized) {
                      return avatarsAsync.when(
                        data: (avatars) {
                          if (avatars.isEmpty) {
                            return _buildEmptyState(isDarkMode);
                          }

                          // データが取得できたら状態も更新
                          if (mounted && _avatarList.isEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                _avatarList = avatars;
                                _isInitialized = true;
                              });
                              _animationController.forward();
                            });
                          }

                          return _viewMode == AvatarViewMode.grid
                              ? _buildMasonryGrid(isDarkMode, headers)
                              : _buildListView(isDarkMode, headers);
                        },
                        loading:
                            () => const LoadingIndicator(
                              message: 'アバターを読み込み中...',
                            ),
                        error:
                            (error, stack) => ErrorContainer(
                              message: 'アバター情報の取得に失敗しました: $error',
                              onRetry: _refreshAvatars,
                            ),
                      );
                    }

                    // 初期化後は内部状態を使用
                    if (_avatarList.isEmpty) {
                      return _buildEmptyState(isDarkMode);
                    }

                    return _viewMode == AvatarViewMode.grid
                        ? _buildMasonryGrid(isDarkMode, headers)
                        : _buildListView(isDarkMode, headers);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // AppBarの並び替えメニューを修正
  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      // foregroundColorを追加して、すべてのアイコンとテキストの色を指定
      foregroundColor: isDarkMode ? Colors.white : Colors.black87,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color:
                  isDarkMode
                      ? Colors.black.withValues(alpha: 0.5)
                      : Colors.white.withValues(alpha: 0.6),
              border: Border(
                bottom: BorderSide(
                  color:
                      isDarkMode
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.05),
                  width: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
      title: Text(
        'アバター',
        style: GoogleFonts.notoSans(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          // タイトルの色を明示的に指定
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            _viewMode == AvatarViewMode.grid
                ? Icons.view_list_rounded
                : Icons.grid_view_rounded,
            color: AppTheme.primaryColor,
          ),
          onPressed: () {
            setState(() {
              _viewMode =
                  _viewMode == AvatarViewMode.grid
                      ? AvatarViewMode.list
                      : AvatarViewMode.grid;
            });
          },
          tooltip: '表示モード切替',
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.sort, color: AppTheme.primaryColor),
          tooltip: '並び替え',
          onSelected: (value) {
            setState(() {
              switch (value) {
                case 'updated':
                  _sortOption = SortOption.updated;
                  _sortByName = false;
                case 'name':
                  _sortOption = SortOption.updated;
                  _sortByName = true;
              }
            });
            _refreshAvatars();
          },
          itemBuilder:
              (context) => [
                const PopupMenuItem(value: 'updated', child: Text('更新順')),
                const PopupMenuItem(value: 'name', child: Text('名前順')),
              ],
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 80,
            color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            'アップロードしたアバターがありません',
            style: GoogleFonts.notoSans(
              fontSize: 18,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasonryGrid(bool isDarkMode, Map<String, String> headers) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: MasonryGridView.count(
        controller: _scrollController,
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: _avatarList.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _avatarList.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final avatar = _avatarList[index];

          final animation = CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              (index / 20).clamp(0.0, 1.0),
              ((index + 5) / 20).clamp(0.1, 1.0),
              curve: Curves.easeInOut,
            ),
          );

          final heightFactor = 0.9 + ((avatar.id.hashCode % 30) / 100);

          return SizeTransition(
            sizeFactor: animation,
            child: FadeTransition(
              opacity: animation,
              child: _buildAvatarCard(
                avatar: avatar,
                isDarkMode: isDarkMode,
                headers: headers,
                heightFactor: heightFactor,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView(bool isDarkMode, Map<String, String> headers) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: _avatarList.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _avatarList.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final avatar = _avatarList[index];

        final animation = CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            (index / 20).clamp(0.0, 1.0),
            ((index + 5) / 20).clamp(0.1, 1.0),
            curve: Curves.easeInOut,
          ),
        );

        return SizeTransition(
          sizeFactor: animation,
          child: FadeTransition(
            opacity: animation,
            child: _buildListItem(avatar, isDarkMode, headers),
          ),
        );
      },
    );
  }

  Widget _buildAvatarCard({
    required Avatar avatar,
    required bool isDarkMode,
    required Map<String, String> headers,
    required double heightFactor,
  }) {
    return GestureDetector(
      onTap: () => context.push('/avatar/${avatar.id}'),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black26 : Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: ColoredBox(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.0 * heightFactor,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'avatar-${avatar.id}',
                        child: CachedNetworkImage(
                          imageUrl: avatar.thumbnailImageUrl,
                          httpHeaders: headers,
                          cacheManager: JsonCacheManager(),
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Container(
                                color:
                                    isDarkMode
                                        ? Colors.grey[850]
                                        : Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                color:
                                    isDarkMode
                                        ? Colors.grey[850]
                                        : Colors.grey[200],
                                child: const Icon(Icons.broken_image),
                              ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.7),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (avatar.tags.contains('currentAvatar'))
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 4),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '使用中',
                                  style: GoogleFonts.notoSans(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(avatar.releaseStatus),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 4),
                            ],
                          ),
                          child: Text(
                            _getReleaseStatusText(avatar.releaseStatus),
                            style: GoogleFonts.notoSans(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 10,
                        right: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              avatar.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.notoSans(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  const Shadow(
                                    color: Colors.black,
                                    offset: Offset(0, 1),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: Colors.white70,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    avatar.authorName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.notoSans(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      shadows: [
                                        const Shadow(
                                          color: Colors.black,
                                          offset: Offset(0, 1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(
    Avatar avatar,
    bool isDarkMode,
    Map<String, String> headers,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: isDarkMode ? Colors.black : Colors.black26,
      child: InkWell(
        onTap: () => context.push('/avatar/${avatar.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Hero(
                tag: 'avatar-list-${avatar.id}',
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: avatar.thumbnailImageUrl,
                          httpHeaders: headers,
                          cacheManager: JsonCacheManager(),
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Container(
                                color:
                                    isDarkMode
                                        ? Colors.grey[850]
                                        : Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                color:
                                    isDarkMode
                                        ? Colors.grey[850]
                                        : Colors.grey[200],
                                child: const Icon(Icons.broken_image),
                              ),
                        ),
                      ),
                      if (avatar.tags.contains('currentAvatar'))
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      avatar.name,
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 14,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            avatar.authorName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.notoSans(
                              fontSize: 14,
                              color:
                                  isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(avatar.releaseStatus),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getReleaseStatusText(avatar.releaseStatus),
                            style: GoogleFonts.notoSans(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(ReleaseStatus status) {
    switch (status) {
      case ReleaseStatus.public:
        return const Color(0xFF4CAF50);
      case ReleaseStatus.private:
        return const Color(0xFFF9A825);
      case ReleaseStatus.hidden:
        return const Color(0xFF9E9E9E);
      default:
        return const Color(0xFF607D8B);
    }
  }

  String _getReleaseStatusText(ReleaseStatus status) {
    switch (status) {
      case ReleaseStatus.public:
        return '公開';
      case ReleaseStatus.private:
        return '非公開';
      case ReleaseStatus.hidden:
        return '非表示';
      default:
        return status.toString();
    }
  }
}

enum AvatarViewMode { grid, list }
