import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/world_provider.dart';
import 'package:vrchat/provider/search_providers.dart';
import 'package:vrchat/utils/search_utils.dart';
import 'package:vrchat/widgets/search_widgets.dart';
import 'package:vrchat/utils/cache_manager.dart';
import 'package:vrchat/widgets/loading_indicator.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class WorldSearchTab extends ConsumerStatefulWidget {
  const WorldSearchTab({super.key});

  @override
  ConsumerState<WorldSearchTab> createState() => _WorldSearchTabState();
}

class _WorldSearchTabState extends ConsumerState<WorldSearchTab> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreResults();
    }
  }

  void _loadMoreResults() {
    if (ref.read(searchingProvider)) return;

    final currentOffset = ref.read(worldSearchOffsetProvider);
    ref.read(worldSearchOffsetProvider.notifier).state = currentOffset + 60;

    // 検索実行のトリガー
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final offset = ref.watch(worldSearchOffsetProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 累積された結果を取得
    final cachedResults = ref.watch(worldSearchResultsProvider);

    final searchState = ref.watch(
      worldSearchProvider(
        WorldSearchParams(search: query, n: 60, offset: offset),
      ),
    );

    // クエリが空の場合は、遅延して結果をクリア
    if (query.isEmpty) {
      if (cachedResults.isNotEmpty) {
        // ビルド後にマイクロタスクとして実行
        Future.microtask(() {
          ref.read(worldSearchResultsProvider.notifier).state = [];
        });
      }
      return buildEmptySearchState('ワールド', Icons.public, isDarkMode);
    }

    // searchStateが変化したときの処理
    ref.listen<AsyncValue<List<LimitedWorld>>>(
      worldSearchProvider(
        WorldSearchParams(search: query, n: 60, offset: offset),
      ),
      (previous, current) {
        // マイクロタスクにスケジュールして、ビルド中の状態変更を回避
        Future.microtask(() {
          if (current.isLoading) {
            ref.read(searchingProvider.notifier).state = true;
          } else if (current.hasValue) {
            ref.read(searchingProvider.notifier).state = false;

            final newResults = current.value ?? [];

            // 検索クエリが変わった場合はリセット、ページネーションの場合は追加
            if (offset == 0) {
              ref.read(worldSearchResultsProvider.notifier).state = newResults;
            } else if (newResults.isNotEmpty) {
              final combinedResults = <LimitedWorld>[...cachedResults];

              // 重複を避けるために既存のIDをチェック
              final existingIds = cachedResults.map((w) => w.id).toSet();
              for (final world in newResults) {
                if (!existingIds.contains(world.id)) {
                  combinedResults.add(world);
                }
              }

              ref.read(worldSearchResultsProvider.notifier).state = combinedResults;
            }
          } else {
            ref.read(searchingProvider.notifier).state = false;
          }
        });
      },
    );

    if (searchState.isLoading && offset == 0) {
      return const Center(child: LoadingIndicator(message: '検索中...'));
    }

    // エラー状態の処理
    if (searchState.hasError && cachedResults.isEmpty) {
      return buildErrorState(searchState.error.toString(), isDarkMode);
    }

    // 空の検索結果
    if (cachedResults.isEmpty && !searchState.isLoading) {
      return buildNoResultsState(query, isDarkMode);
    }

    // キャッシュされた結果を表示
    return ListView.builder(
      controller: _scrollController,
      itemCount: cachedResults.length + 1,
      itemBuilder: (context, index) {
        if (index == cachedResults.length) {
          // 最後の項目の場合、ローディングインジケータを表示
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child:
                  searchState.isLoading
                      ? const CircularProgressIndicator()
                      : const SizedBox(height: 40), // スペースを確保
            ),
          );
        }

        final world = cachedResults[index];
        return _buildWorldListItem(world, isDarkMode);
      },
    );
  }

  // ワールドリストアイテムのウィジェト
  Widget _buildWorldListItem(LimitedWorld world, bool isDarkMode) {
    final headers = {'User-Agent': 'VRChat/1.0'};
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.push('/world/${world.id}');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ワールドのサムネイル画像
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child:
                    world.thumbnailImageUrl.isNotEmpty
                        ? CachedNetworkImage(
                          imageUrl: world.thumbnailImageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                            child: const Icon(Icons.error),
                          ),
                          cacheManager: JsonCacheManager(),
                          httpHeaders: headers,
                        )
                        : Container(
                          color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                          child: const Icon(Icons.image, size: 48),
                        ),
              ),
            ),

            // ワールド情報
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ワールド名とお気に入り数
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          world.name,
                          style: GoogleFonts.notoSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 16,
                            color: Colors.red[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            SearchUtils.formatNumber(world.popularity),
                            style: GoogleFonts.notoSans(
                              fontSize: 14,
                              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // 作者名
                  if (world.authorName.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'by ${world.authorName}',
                      style: GoogleFonts.notoSans(
                        fontSize: 13,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  // タグ
                  if (world.tags.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: world.tags.take(3).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            SearchUtils.formatTag(tag),
                            style: GoogleFonts.notoSans(
                              fontSize: 12,
                              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
