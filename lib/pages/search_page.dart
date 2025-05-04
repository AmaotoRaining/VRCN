import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/group_provider.dart';
import 'package:vrchat/provider/user_provider.dart';
import 'package:vrchat/provider/world_provider.dart';
import 'package:vrchat/utils/cache_manager.dart';
import 'package:vrchat/widgets/loading_indicator.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

// 検索クエリを管理するためのプロバイダー
final searchQueryProvider = StateProvider<String>((ref) => '');

// 検索中状態を管理するプロバイダー
final searchingProvider = StateProvider<bool>((ref) => false);

// 検索オフセットを各タブ用に分離
final userSearchOffsetProvider = StateProvider<int>((ref) => 0);
final worldSearchOffsetProvider = StateProvider<int>((ref) => 0);
final avatarSearchOffsetProvider = StateProvider<int>((ref) => 0);
final groupSearchOffsetProvider = StateProvider<int>((ref) => 0);

// 検索結果キャッシュを保持するためのプロバイダーを追加
final worldSearchResultsProvider = StateProvider<List<LimitedWorld>>(
  (ref) => [],
);
final userSearchResultsProvider = StateProvider<List<LimitedUser>>((ref) => []);
final groupSearchResultsProvider = StateProvider<List<LimitedGroup>>(
  (ref) => [],
);

// 検索ページの状態にアクセスするためのGlobalKey
final searchPageKeyProvider = Provider((ref) => GlobalKey<SearchPageState>());

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();

  // 検索コントローラーと検索メソッドを外部に公開
  static SearchPageController? of(BuildContext context) {
    final state = context.findAncestorStateOfType<SearchPageState>();
    if (state == null) return null;
    return SearchPageController(
      searchController: state._searchController,
      onSearchChanged: state._onSearchChanged,
    );
  }
}

@immutable
class SearchPageController {
  final TextEditingController searchController;
  final void Function(String) onSearchChanged;

  const SearchPageController({
    required this.searchController,
    required this.onSearchChanged,
  });
}

class SearchPageState extends ConsumerState<SearchPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  // 各タブ用のスクロールコントローラーを分離
  final _userScrollController = ScrollController();
  final _worldScrollController = ScrollController();
  final _avatarScrollController = ScrollController();
  final _groupScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _searchController.addListener(
      () => _onSearchChanged(_searchController.text),
    );

    // タブ変更時の処理を追加
    _tabController.addListener(_onTabChanged);

    // 各スクロールコントローラーにリスナーを設定
    _userScrollController.addListener(() => _onScroll(0));
    _worldScrollController.addListener(() => _onScroll(1));
    _avatarScrollController.addListener(() => _onScroll(2));
    _groupScrollController.addListener(() => _onScroll(3));
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _searchController.removeListener(
      () => _onSearchChanged(_searchController.text),
    );

    // 各スクロールコントローラーのリスナーを解除
    _userScrollController.removeListener(() => _onScroll(0));
    _worldScrollController.removeListener(() => _onScroll(1));
    _avatarScrollController.removeListener(() => _onScroll(2));
    _groupScrollController.removeListener(() => _onScroll(3));

    // すべてのスクロールコントローラーを破棄
    _userScrollController.dispose();
    _worldScrollController.dispose();
    _avatarScrollController.dispose();
    _groupScrollController.dispose();

    _searchController.dispose();
    super.dispose();
  }

  // タブ変更時の処理
  void _onTabChanged() {
    // タブが変わったときにスクロール位置をリセットしない
    setState(() {});
  }

  // タブインデックスに応じたスクロール処理
  void _onScroll(int tabIndex) {
    if (tabIndex != _tabController.index) return;

    // 現在のタブに応じたスクロールコントローラーを取得
    final controller = _getScrollController(tabIndex);
    if (controller.position.pixels >=
        controller.position.maxScrollExtent * 0.8) {
      _loadMoreResults(tabIndex);
    }
  }

  // タブインデックスに応じたスクロールコントローラーを取得
  ScrollController _getScrollController(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return _userScrollController;
      case 1:
        return _worldScrollController;
      case 2:
        return _avatarScrollController;
      case 3:
        return _groupScrollController;
      default:
        return _userScrollController;
    }
  }

  // タブ別に追加結果を読み込む
  void _loadMoreResults(int tabIndex) {
    // すでに検索中なら追加読み込みしない
    if (ref.read(searchingProvider)) return;

    // タブに応じたオフセットプロバイダーを取得
    final offsetProvider = _getOffsetProvider(tabIndex);
    final currentOffset = ref.read(offsetProvider);
    ref.read(offsetProvider.notifier).state = currentOffset + 60;

    // 検索実行のトリガー
    setState(() {});
  }

  // タブインデックスに応じたオフセットプロバイダーを取得
  StateProvider<int> _getOffsetProvider(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return userSearchOffsetProvider;
      case 1:
        return worldSearchOffsetProvider;
      case 2:
        return avatarSearchOffsetProvider;
      case 3:
        return groupSearchOffsetProvider;
      default:
        return userSearchOffsetProvider;
    }
  }

  void _onSearchChanged(String query) {
    // デバッグ出力を追加
    debugPrint('検索クエリ変更: "$query"');

    // 検索クエリが変わったら各タブのオフセットをリセットし、キャッシュをクリア
    if (query != ref.read(searchQueryProvider)) {
      ref.read(userSearchOffsetProvider.notifier).state = 0;
      ref.read(worldSearchOffsetProvider.notifier).state = 0;
      ref.read(avatarSearchOffsetProvider.notifier).state = 0;
      ref.read(groupSearchOffsetProvider.notifier).state = 0;

      // 結果キャッシュもクリア
      ref.read(worldSearchResultsProvider.notifier).state = [];
      ref.read(userSearchResultsProvider.notifier).state = [];
      ref.read(groupSearchResultsProvider.notifier).state = []; // これを追加
    }

    ref.read(searchQueryProvider.notifier).state = query;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Column(
        children: [
          // タブバーのみを表示し、検索バーは表示しない
          ColoredBox(
            color: Theme.of(context).colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: primaryColor,
              unselectedLabelColor:
                  isDarkMode ? Colors.grey[400] : Colors.grey[600],
              indicatorColor: primaryColor,
              labelStyle: GoogleFonts.notoSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.notoSans(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: 'ユーザー'),
                Tab(text: 'ワールド'),
                Tab(text: 'アバター'),
                Tab(text: 'グループ'),
              ],
            ),
          ),

          // 検索結果 - タブビュー
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // ユーザー検索結果
                _buildUserSearchResults(),
                // ワールド検索結果
                _buildWorldSearchResults(),
                // アバター検索結果
                _buildSearchResultTab('アバター', Icons.person_outline, isDarkMode),
                // グループ検索結果
                _buildGroupSearchResults(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ユーザー検索結果表示（userSearchProviderを使用）
  Widget _buildUserSearchResults() {
    final query = ref.watch(searchQueryProvider);
    final offset = ref.watch(userSearchOffsetProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 累積された結果を取得
    final cachedResults = ref.watch(userSearchResultsProvider);

    final searchState = ref.watch(
      userSearchProvider(
        UserSearchParams(search: query, n: 60, offset: offset),
      ),
    );

    // searchStateが変化したときの処理（前述のワールド検索と同様）
    ref.listen<AsyncValue<List<LimitedUser>>>(
      userSearchProvider(
        UserSearchParams(search: query, n: 60, offset: offset),
      ),
      (previous, current) {
        Future.microtask(() {
          if (current.isLoading) {
            ref.read(searchingProvider.notifier).state = true;
          } else if (current.hasValue) {
            ref.read(searchingProvider.notifier).state = false;

            final newResults = current.value ?? [];

            if (offset == 0) {
              ref.read(userSearchResultsProvider.notifier).state = newResults;
            } else if (newResults.isNotEmpty) {
              final combinedResults = <LimitedUser>[...cachedResults];

              final existingIds = cachedResults.map((u) => u.id).toSet();
              for (final user in newResults) {
                if (!existingIds.contains(user.id)) {
                  combinedResults.add(user);
                }
              }

              ref.read(userSearchResultsProvider.notifier).state =
                  combinedResults;
            }
          } else {
            ref.read(searchingProvider.notifier).state = false;
          }
        });
      },
    );

    if (query.isEmpty) {
      return _buildEmptySearchState('ユーザー', Icons.people, isDarkMode);
    }

    if (searchState.isLoading && offset == 0) {
      return const Center(child: LoadingIndicator(message: '検索中...'));
    }

    if (searchState.hasError && cachedResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'エラーが発生しました',
              style: GoogleFonts.notoSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.red[300] : Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              searchState.error.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    if (cachedResults.isEmpty && !searchState.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '「$query」の検索結果はありません',
              style: GoogleFonts.notoSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _userScrollController,
      itemCount: cachedResults.length + 1,
      itemBuilder: (context, index) {
        if (index == cachedResults.length) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child:
                  searchState.isLoading
                      ? const CircularProgressIndicator()
                      : const SizedBox(height: 40),
            ),
          );
        }

        final user = cachedResults[index];
        return _buildUserListItem(user, isDarkMode);
      },
    );
  }

  // ユーザーリストアイテムのウィジェト
  Widget _buildUserListItem(LimitedUser user, bool isDarkMode) {
    final headers = {'User-Agent': 'VRChat/1.0'};
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            user.currentAvatarThumbnailImageUrl != null &&
                    user.currentAvatarThumbnailImageUrl!.isNotEmpty
                ? CachedNetworkImageProvider(
                  user.currentAvatarThumbnailImageUrl!,
                  headers: headers,
                  cacheManager: JsonCacheManager(),
                )
                : const AssetImage('assets/images/default_avatar.png')
                    as ImageProvider,
        backgroundColor: Colors.grey[300],
      ),
      title: Text(
        user.displayName,
        style: GoogleFonts.notoSans(
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      subtitle:
          user.statusDescription.isNotEmpty
              ? Text(
                user.statusDescription,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              )
              : null,
      onTap: () {
        context.push('/user/${user.id}');
      },
    );
  }

  // ワールド検索結果表示（worldSearchProviderを使用）
  Widget _buildWorldSearchResults() {
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
      return _buildEmptySearchState('ワールド', Icons.public, isDarkMode);
    }

    // searchStateが変化したときに適切なタイミングで状態を更新
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

              ref.read(worldSearchResultsProvider.notifier).state =
                  combinedResults;
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'エラーが発生しました',
              style: GoogleFonts.notoSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.red[300] : Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              searchState.error.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    // 空の検索結果
    if (cachedResults.isEmpty && !searchState.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '「$query」の検索結果はありません',
              style: GoogleFonts.notoSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
          ],
        ),
      );
    }

    // キャッシュされた結果を表示
    return ListView.builder(
      controller: _worldScrollController, // ワールドタブ用のスクロールコントローラー
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
                                child: const Icon(Icons.error),
                              ),
                          cacheManager: JsonCacheManager(),
                          httpHeaders: headers,
                        )
                        : Container(
                          color:
                              isDarkMode ? Colors.grey[800] : Colors.grey[300],
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
                            _formatNumber(world.popularity),
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
                      children:
                          world.tags.take(3).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isDarkMode
                                        ? Colors.grey[800]
                                        : Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _formatTag(tag),
                                style: GoogleFonts.notoSans(
                                  fontSize: 12,
                                  color:
                                      isDarkMode
                                          ? Colors.grey[300]
                                          : Colors.grey[700],
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

  // 数字をフォーマットするヘルパーメソッド (1000 → 1K)
  String _formatNumber(int number) {
    if (number < 1000) return number.toString();
    if (number < 1000000) return '${(number / 1000).toStringAsFixed(1)}K';
    return '${(number / 1000000).toStringAsFixed(1)}M';
  }

  // タグをフォーマットするヘルパーメソッド
  String _formatTag(String tag) {
    // system_*の部分を削除
    if (tag.startsWith('system_')) {
      tag = tag.substring(7);
    }

    // アンダースコアをスペースに置換して先頭を大文字に
    final words = tag
        .split('_')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');

    return words;
  }

  // グループ検索結果表示（groupSearchProviderを使用）
  Widget _buildGroupSearchResults() {
    final query = ref.watch(searchQueryProvider);
    final offset = ref.watch(groupSearchOffsetProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 累積された結果を取得
    final cachedResults = ref.watch(groupSearchResultsProvider);

    final searchState = ref.watch(
      groupSearchProvider(
        GroupSearchParams(query: query, n: 60, offset: offset),
      ),
    );

    // searchStateが変化したときに適切なタイミングで状態を更新
    ref.listen<AsyncValue<List<LimitedGroup>>>(
      groupSearchProvider(
        GroupSearchParams(query: query, n: 60, offset: offset),
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
      return _buildEmptySearchState('グループ', Icons.group, isDarkMode);
    }

    // 検索クエリが変わった場合、ローディング状態を優先表示
    if (searchState.isLoading && offset == 0) {
      return const Center(child: LoadingIndicator(message: '検索中...'));
    }

    // エラー状態の処理
    if (searchState.hasError && cachedResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'エラーが発生しました',
              style: GoogleFonts.notoSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.red[300] : Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              searchState.error.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    // 空の検索結果
    if (cachedResults.isEmpty && !searchState.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '「$query」の検索結果はありません',
              style: GoogleFonts.notoSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
          ],
        ),
      );
    }

    // キャッシュされた結果を表示
    return ListView.builder(
      controller: _groupScrollController, // グループタブ用のスクロールコントローラー
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

  // 検索結果のプレースホルダー（他のタブ用）
  Widget _buildSearchResultTab(String type, IconData icon, bool isDarkMode) {
    final query = ref.watch(searchQueryProvider);

    if (query.isEmpty) {
      return _buildEmptySearchState(type, icon, isDarkMode);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '「$query」の$type検索結果',
            style: GoogleFonts.notoSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '検索結果は実装中です',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // 検索前の空の状態
  Widget _buildEmptySearchState(String type, IconData icon, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '$typeを検索',
            style: GoogleFonts.notoSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
