import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/pages/tabs/emoji_inventory_tab.dart';
import 'package:vrchat/pages/tabs/gallery_inventory_tab.dart';
import 'package:vrchat/pages/tabs/icon_inventory_tab.dart';
import 'package:vrchat/pages/tabs/print_inventory_tab.dart';
import 'package:vrchat/pages/tabs/sticker_inventory_tab.dart';
import 'package:vrchat/theme/app_theme.dart';

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF151515) : Colors.grey[50],
      body: NestedScrollView(
        headerSliverBuilder:
            (context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: 100.0,
                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                backgroundColor:
                    isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
                title: Text(
                  'インベントリ',
                  style: GoogleFonts.notoSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors:
                            isDarkMode
                                ? [
                                  Colors.deepPurple.withValues(alpha: 0.3),
                                  Colors.indigo.withValues(alpha: 0.2),
                                ]
                                : [
                                  Colors.deepPurple.withValues(alpha: 0.1),
                                  Colors.indigo.withValues(alpha: 0.05),
                                ],
                      ),
                    ),
                  ),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  labelStyle: GoogleFonts.notoSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  unselectedLabelStyle: GoogleFonts.notoSans(fontSize: 12),
                  indicatorColor: AppTheme.primaryColor,
                  indicatorWeight: 3,
                  labelColor: isDarkMode ? Colors.white : Colors.black87,
                  unselectedLabelColor:
                      isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  indicatorSize: TabBarIndicatorSize.label,
                  isScrollable: true,
                  tabs: const [
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.photo_library, size: 18),
                          SizedBox(width: 4),
                          Text('ギャラリー'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.account_circle, size: 18),
                          SizedBox(width: 4),
                          Text('アイコン'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.emoji_emotions, size: 18),
                          SizedBox(width: 4),
                          Text('絵文字'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.sticky_note_2, size: 18),
                          SizedBox(width: 4),
                          Text('ステッカー'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.print, size: 18),
                          SizedBox(width: 4),
                          Text('プリント'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
        body: TabBarView(
          controller: _tabController,
          children: const [
            GalleryInventoryTab(),
            IconInventoryTab(),
            EmojiInventoryTab(),
            StickerInventoryTab(),
            PrintInventoryTab(),
          ],
        ),
      ),
    );
  }
}
