import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/widgets/app_drawer.dart';

// 検索クエリを管理するためのプロバイダー
final searchQueryProvider = StateProvider<String>((ref) => '');

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage>
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.removeListener(
      () => _onSearchChanged(_searchController.text),
    );
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // タブバー
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                  width: 0.5,
                ),
              ),
            ),
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
                Tab(text: 'ワールド'),
                Tab(text: 'ユーザー'),
                Tab(text: 'アバター'),
                Tab(text: 'グループ'),
              ],
            ),
          ),

          // 検索結果 - タブビュー
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  // 検索結果表示
  Widget _buildSearchResults() {
    final query = ref.watch(searchQueryProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TabBarView(
      controller: _tabController,
      children: [
        // ワールド検索結果
        _buildSearchResultTab('ワールド', query, Icons.public, isDarkMode),

        // ユーザー検索結果
        _buildSearchResultTab('ユーザー', query, Icons.people, isDarkMode),

        // アバター検索結果
        _buildSearchResultTab('アバター', query, Icons.person_outline, isDarkMode),

        // グループ検索結果
        _buildSearchResultTab('グループ', query, Icons.group, isDarkMode),
      ],
    );
  }

  Widget _buildSearchResultTab(
    String type,
    String query,
    IconData icon,
    bool isDarkMode,
  ) {
    final hasQuery = query.isNotEmpty;

    if (!hasQuery) {
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
            const SizedBox(height: 8),
            Text(
              '検索ボックスに入力してください',
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

    // TODO: 実際のAPI接続
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
}
