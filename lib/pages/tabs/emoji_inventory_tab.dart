import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/files_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/theme/app_theme.dart';
import 'package:vrchat/utils/cache_manager.dart';
import 'package:vrchat/widgets/error_container.dart';
import 'package:vrchat/widgets/loading_indicator.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class EmojiInventoryTab extends ConsumerStatefulWidget {
  const EmojiInventoryTab({super.key});

  @override
  ConsumerState<EmojiInventoryTab> createState() => _EmojiInventoryTabState();
}

class _EmojiInventoryTabState extends ConsumerState<EmojiInventoryTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<void> _refreshFiles() async {
    ref.invalidate(getFilesByTagProvider('emoji'));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final emojiFilesAsync = ref.watch(getEmojiFilesProvider);
    final vrchatApi = ref.watch(vrchatProvider).value;

    final headers = <String, String>{
      'User-Agent': vrchatApi?.userAgent.toString() ?? 'VRChat/1.0',
    };

    return RefreshIndicator(
      onRefresh: _refreshFiles,
      child: emojiFilesAsync.when(
        data: (files) {
          if (files.isEmpty) {
            return _buildEmptyState(isDarkMode);
          }

          return _buildFilesGrid(files, headers, isDarkMode);
        },
        loading: () => const LoadingIndicator(message: '絵文字ファイルを読み込み中...'),
        error:
            (error, stackTrace) => ErrorContainer(
              message: '絵文字ファイルの取得に失敗しました: $error',
              onRetry: _refreshFiles,
            ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.emoji_emotions_outlined,
                size: 60,
                color: AppTheme.primaryColor.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '絵文字ファイルがありません',
              style: GoogleFonts.notoSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilesGrid(
    List<File> files,
    Map<String, String> headers,
    bool isDarkMode,
  ) {
    return AnimationLimiter(
      child: MasonryGridView.count(
        crossAxisCount: 3,
        padding: const EdgeInsets.all(16),
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 600),
            columnCount: 3,
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildEmojiCard(file, headers, isDarkMode),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmojiCard(
    File file,
    Map<String, String> headers,
    bool isDarkMode,
  ) {

    // URLが空の場合はカードを表示しない
    if (file.versions.last.file!.url.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: () => _showFullScreenEmoji(file, headers),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: file.versions.last.file!.url.toString(),
                  fit: BoxFit.cover,
                  httpHeaders: headers,
                  cacheManager: JsonCacheManager(),
                  placeholder:
                      (context, url) => Container(
                        color:
                            isDarkMode ? Colors.grey[800] : Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        color:
                            isDarkMode ? Colors.grey[800] : Colors.grey[300],
                        child: const Icon(Icons.emoji_emotions),
                      ),
                ),
              ),

          ],
        ),
      ),
    );
  }

  // フルスクリーン絵文字表示
  void _showFullScreenEmoji(File file, Map<String, String> headers) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                _FullScreenEmojiViewer(file: file, headers: headers),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

// フルスクリーン絵文字ビューアー
class _FullScreenEmojiViewer extends StatelessWidget {
  final File file;
  final Map<String, String> headers;

  const _FullScreenEmojiViewer({required this.file, required this.headers});



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 背景タップで閉じる
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),

          // 絵文字表示
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child:
                    file.versions.last.file!.url.isNotEmpty
                        ? CachedNetworkImage(
                          imageUrl: file.versions.last.file!.url.toString(),
                          httpHeaders: headers,
                          cacheManager: JsonCacheManager(),
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Container(
                                color: Colors.grey[800],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                color: Colors.grey[800],
                                child: const Icon(
                                  Icons.emoji_emotions,
                                  color: Colors.white,
                                  size: 64,
                                ),
                              ),
                        )
                        : Container(
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.emoji_emotions,
                            color: Colors.white,
                            size: 64,
                          ),
                        ),
              ),
            ),
          ),

          // 閉じるボタン
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: Material(
              elevation: 4,
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(25),
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () => Navigator.of(context).pop(),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
