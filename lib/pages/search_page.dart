import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/user_provider.dart';
import 'package:vrchat/utils/cache_manager.dart';
import 'package:vrchat/widgets/custom_loading.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

// 検索クエリを管理するためのプロバイダー
final searchQueryProvider = StateProvider<String>((ref) => '');

// 検索中状態を管理するプロバイダー
final searchingProvider = StateProvider<bool>((ref) => false);

// 検索ページオフセット管理
final searchOffsetProvider = StateProvider<int>((ref) => 0);

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
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _searchController.addListener(
      () => _onSearchChanged(_searchController.text),
    );

    // スクロール検知でページネーション用
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.removeListener(
      () => _onSearchChanged(_searchController.text),
    );
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreResults();
    }
  }

  void _loadMoreResults() {
    // すでに検索中なら追加読み込みしない
    if (ref.read(searchingProvider)) return;

    final currentOffset = ref.read(searchOffsetProvider);
    ref.read(searchOffsetProvider.notifier).state = currentOffset + 60;

    // 検索実行のトリガー
    setState(() {});
  }

  void _onSearchChanged(String query) {
    // デバッグ出力を追加
    debugPrint('検索クエリ変更: "$query"');

    // 検索クエリが変わったらオフセットをリセット
    if (query != ref.read(searchQueryProvider)) {
      ref.read(searchOffsetProvider.notifier).state = 0;
    }

    ref.read(searchQueryProvider.notifier).state = query;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      // 空のAppBarを使用（実際のAppBarはnavigation_bar.dartで提供）
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
      ),
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
                _buildSearchResultTab('ワールド', Icons.public, isDarkMode),
                // アバター検索結果
                _buildSearchResultTab('アバター', Icons.person_outline, isDarkMode),
                // グループ検索結果
                _buildSearchResultTab('グループ', Icons.group, isDarkMode),
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
    final offset = ref.watch(searchOffsetProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final searchState = ref.watch(
      userSearchProvider(
        UserSearchParams(search: query, n: 60, offset: offset),
      ),
    );

    // searchStateが変化したときに適切なタイミングで状態を更新
    ref.listen<AsyncValue<List<LimitedUser>>>(
      userSearchProvider(
        UserSearchParams(search: query, n: 60, offset: offset),
      ),
      (_, state) {
        // マイクロタスクにスケジュールして、ビルド中の状態変更を回避
        Future.microtask(() {
          if (state.isLoading) {
            ref.read(searchingProvider.notifier).state = true;
          } else {
            ref.read(searchingProvider.notifier).state = false;
          }
        });
      },
    );

    if (query.isEmpty) {
      return _buildEmptySearchState('ユーザー', Icons.people, isDarkMode);
    }

    return searchState.when(
      data: (users) {
        if (users.isEmpty && offset == 0) {
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
          controller: _scrollController,
          itemCount: users.length + 1,
          itemBuilder: (context, index) {
            if (index == users.length) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child:
                      users.isEmpty
                          ? const SizedBox()
                          : const CustomLoading(message: '検索中...'),
                ),
              );
            }

            final user = users[index];
            return _buildUserListItem(user, isDarkMode);
          },
        );
      },
      loading: () {
        return const Center(child: CustomLoading(message: '検索中...'));
      },
      error: (error, stack) {
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
                error.toString(),
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ユーザーリストアイテムのウィジェト
  Widget _buildUserListItem(LimitedUser user, bool isDarkMode) {
    final headers = {'User-Agent': 'VRChat/1.0'};
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            user.userIcon != null && user.userIcon!.isNotEmpty
                ? CachedNetworkImageProvider(
                  user.userIcon.toString(),
                  headers: headers,
                  cacheManager: JsonCacheManager(),
                )
                : user.currentAvatarThumbnailImageUrl != null &&
                    user.currentAvatarThumbnailImageUrl!.isNotEmpty
                ? CachedNetworkImageProvider(
                  user.currentAvatarThumbnailImageUrl.toString(),
                  headers: headers,
                  cacheManager: JsonCacheManager(),
                )
                : const AssetImage('assets/images/default.png')
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
        context.push('/friends/${user.id}');
      },
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
