import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/group_provider.dart' as gp;
import 'package:vrchat/provider/search_providers.dart';
import 'package:vrchat/utils/cache_manager.dart';
import 'package:vrchat/widgets/loading_indicator.dart';
import 'package:vrchat/widgets/search_widgets.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class GroupSearchTab extends ConsumerStatefulWidget {
  const GroupSearchTab({super.key});

  @override
  ConsumerState<GroupSearchTab> createState() => _GroupSearchTabState();
}

class _GroupSearchTabState extends ConsumerState<GroupSearchTab> {
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

    final currentOffset = ref.read(groupSearchOffsetProvider);
    ref.read(groupSearchOffsetProvider.notifier).state = currentOffset + 60;

    // 検索実行のトリガー
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final offset = ref.watch(groupSearchOffsetProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 検索機能に関連するプロバイダーなので、search_providersからのものを使用
    final cachedResults = ref.watch(groupSearchResultsProvider);

    final searchState = ref.watch(
      gp.groupSearchProvider(
        gp.GroupSearchParams(query: query, n: 60, offset: offset),
      ),
    );

    // searchStateが変化したときの処理
    ref.listen<AsyncValue<List<LimitedGroup>>>(
      gp.groupSearchProvider(
        gp.GroupSearchParams(query: query, n: 60, offset: offset),
      ),
      (previous, current) {
        Future.microtask(() {
          if (current.isLoading) {
            ref.read(searchingProvider.notifier).state = true;
          } else if (current.hasValue) {
            ref.read(searchingProvider.notifier).state = false;

            final newResults = current.value ?? [];

            if (offset == 0) {
              ref.read(groupSearchResultsProvider.notifier).state = newResults;
            } else if (newResults.isNotEmpty) {
              final combinedResults = <LimitedGroup>[...cachedResults];

              // 重複を避けるために既存のIDをチェック
              final existingIds = cachedResults.map((g) => g.id).toSet();
              for (final group in newResults) {
                if (!existingIds.contains(group.id)) {
                  combinedResults.add(group);
                }
              }

              ref.read(groupSearchResultsProvider.notifier).state =
                  combinedResults;
            }
          } else {
            ref.read(searchingProvider.notifier).state = false;
          }
        });
      },
    );

    if (query.isEmpty) {
      // 検索クエリがない場合は結果をクリア
      if (cachedResults.isNotEmpty) {
        // ビルド後にマイクロタスクとして実行
        Future.microtask(() {
          ref.read(groupSearchResultsProvider.notifier).state = [];
        });
      }
      return buildEmptySearchState('グループ', Icons.group, isDarkMode);
    }

    // 検索クエリが変わった場合、ローディング状態を優先表示
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

        final group = cachedResults[index];
        return _buildGroupListItem(group, isDarkMode);
      },
    );
  }

  // グループリストアイテムのウィジェット
  Widget _buildGroupListItem(LimitedGroup group, bool isDarkMode) {
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
          context.push('/group/${group.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // グループアイコン
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child:
                      group.iconUrl != null && group.iconUrl!.isNotEmpty
                          ? CachedNetworkImage(
                            imageUrl: group.iconUrl!,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  color:
                                      isDarkMode
                                          ? Colors.grey[800]
                                          : Colors.grey[300],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  color:
                                      isDarkMode
                                          ? Colors.grey[800]
                                          : Colors.grey[300],
                                  child: const Icon(Icons.group),
                                ),
                            cacheManager: JsonCacheManager(),
                            httpHeaders: headers,
                          )
                          : Container(
                            color:
                                isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[300],
                            child: const Icon(Icons.group, size: 30),
                          ),
                ),
              ),
              const SizedBox(width: 12),

              // グループ情報
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // グループ名
                    Text(
                      group.name.toString(),
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // グループ説明
                    if (group.shortCode != null) ...[
                      Text(
                        '${group.shortCode}',
                        style: GoogleFonts.notoSans(
                          fontSize: 13,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                    ],

                    // メンバー数
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 16,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${group.memberCount ?? "?"} メンバー',
                          style: GoogleFonts.notoSans(
                            fontSize: 13,
                            color:
                                isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
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
      ),
    );
  }
}
