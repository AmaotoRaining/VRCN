import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/avatar_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/utils/cache_manager.dart';
import 'package:vrchat/widgets/error_container.dart';
import 'package:vrchat/widgets/loading_indicator.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class AvatarsPage extends ConsumerStatefulWidget {
  const AvatarsPage({super.key});

  @override
  ConsumerState<AvatarsPage> createState() => _AvatarsPageState();
}

class _AvatarsPageState extends ConsumerState<AvatarsPage> {
  // スクロールコントローラー
  final _scrollController = ScrollController();
  var _currentOffset = 0;
  final _pageSize = 100;
  var _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    // スクロールイベントのリスナーを追加
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // スクロールイベントのハンドラー
  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore) {
      _loadMoreAvatars();
    }
  }

  // 追加のアバターをロード
  Future<void> _loadMoreAvatars() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
      _currentOffset += _pageSize;
    });

    // ロードが終わったら状態を更新
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  // リストを更新
  Future<void> _refreshAvatars() async {
    setState(() {
      _currentOffset = 0;
    });
    ref.refresh(
      avatarSearchProvider(AvatarSearchParams(n: _pageSize, offset: 0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? const Color(0xFF151515) : const Color(0xFFF5F5F5);
    final vrchatApi = ref.watch(vrchatProvider).value;

    // API呼び出し用のヘッダー
    final headers = <String, String>{
      'User-Agent': vrchatApi?.userAgent.toString() ?? 'VRChat/1.0',
    };

    // アバター一覧を取得（パラメータを調整）
    final avatarsAsync = ref.watch(
      avatarSearchProvider(
        AvatarSearchParams(
          n: 100, // 取得数を増やす
          offset: _currentOffset,
          sort: SortOption.updated, // 更新日でソートに変更
          // releaseStatusはnullのままで全て取得
        ),
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'アバター',
          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshAvatars,
            tooltip: 'リロード',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAvatars,
        child: avatarsAsync.when(
          data: (avatars) {
            if (avatars.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.face_outlined,
                      size: 70,
                      color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'アバターが見つかりませんでした',
                      style: GoogleFonts.notoSans(
                        fontSize: 18,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // アバターグリッド
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: avatars.length + (_isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == avatars.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final avatar = avatars[index];
                      return _buildAvatarItem(avatar, isDarkMode, headers);
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => const LoadingIndicator(message: 'アバターを読み込み中...'),
          error:
              (error, stack) => ErrorContainer(
                message: 'アバター情報の取得に失敗しました: $error',
                onRetry: _refreshAvatars,
              ),
        ),
      ),
    );
  }

  // アバター表示アイテム
  Widget _buildAvatarItem(
    Avatar avatar,
    bool isDarkMode,
    Map<String, String> headers,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDarkMode ? const Color(0xFF222222) : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.push('/avatar/${avatar.id}');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // アバター画像
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // アバター画像
                    CachedNetworkImage(
                      imageUrl: avatar.thumbnailImageUrl,
                      httpHeaders: headers,
                      cacheManager: JsonCacheManager(),
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Container(
                            color:
                                isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            color:
                                isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[200],
                            child: Icon(
                              Icons.broken_image,
                              color:
                                  isDarkMode
                                      ? Colors.grey[600]
                                      : Colors.grey[400],
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
                            color: Colors.green.withOpacity(.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '使用中',
                            style: GoogleFonts.notoSans(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // アバター情報
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    avatar.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    avatar.releaseStatus.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
