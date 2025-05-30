import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/pages/tabs/avatar_search_tab.dart';
import 'package:vrchat/pages/tabs/group_search_tab.dart';
import 'package:vrchat/pages/tabs/user_search_tab.dart';
import 'package:vrchat/pages/tabs/world_search_tab.dart';
import 'package:vrchat/provider/search_providers.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _searchController.addListener(
      () => _onSearchChanged(_searchController.text),
    );

    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _searchController.removeListener(
      () => _onSearchChanged(_searchController.text),
    );
    _searchController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {});
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
      ref.read(groupSearchResultsProvider.notifier).state = [];
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
          // タブバー
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
              children: const [
                UserSearchTab(),
                WorldSearchTab(),
                AvatarSearchTab(),
                GroupSearchTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
