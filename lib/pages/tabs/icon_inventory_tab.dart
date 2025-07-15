import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vrchat/provider/files_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/theme/app_theme.dart';
import 'package:vrchat/utils/cache_manager.dart';
import 'package:vrchat/widgets/error_container.dart';
import 'package:vrchat/widgets/loading_indicator.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class IconInventoryTab extends ConsumerStatefulWidget {
  const IconInventoryTab({super.key});

  @override
  ConsumerState<IconInventoryTab> createState() => _IconInventoryTabState();
}

class _IconInventoryTabState extends ConsumerState<IconInventoryTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<void> _refreshFiles() async {
    ref.invalidate(getIconFilesProvider);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconFilesAsync = ref.watch(getIconFilesProvider);
    final vrchatApi = ref.watch(vrchatProvider).value;

    final headers = <String, String>{
      'User-Agent': vrchatApi?.userAgent.toString() ?? 'VRChat/1.0',
    };

    return RefreshIndicator(
      onRefresh: _refreshFiles,
      child: iconFilesAsync.when(
        data: (files) {
          if (files.isEmpty) {
            return _buildEmptyState(isDarkMode);
          }

          return _buildFilesGrid(files, headers, isDarkMode);
        },
        loading: () => const LoadingIndicator(message: 'アイコンファイルを読み込み中...'),
        error:
            (error, stackTrace) => ErrorContainer(
              message: 'アイコンファイルの取得に失敗しました: $error',
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
                Icons.account_circle_outlined,
                size: 60,
                color: AppTheme.primaryColor.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'アイコンファイルがありません',
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
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
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
                child: _buildIconCard(file, headers, isDarkMode),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconCard(
    File file,
    Map<String, String> headers,
    bool isDarkMode,
  ) {

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.black26,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // アイコン画像
          Stack(
            children: [
              GestureDetector(
                onTap: () => _showFullScreenImage(file, headers),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors:
                          isDarkMode
                              ? [Colors.grey[800]!, Colors.grey[900]!]
                              : [Colors.grey[200]!, Colors.grey[300]!],
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: file.versions.last.file!.url.toString(),
                    fit: BoxFit.cover,
                    width: double.infinity,
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
                          child: Icon(
                            Icons.account_circle,
                            size: 40,
                            color:
                                isDarkMode
                                    ? Colors.grey[600]
                                    : Colors.grey[500],
                          ),
                        ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 作成日時
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 10,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        _formatDate(
                          file.versions.last.createdAt,
                        ),
                        style: GoogleFonts.notoSans(
                          fontSize: 10,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // フルスクリーン画像表示
  void _showFullScreenImage(File file, Map<String, String> headers) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                _FullScreenIconViewer(file: file, headers: headers),
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

  String _formatDate(DateTime date) {
    return DateFormat('MM/dd').format(date);
  }
}

// フルスクリーンアイコンビューアー
class _FullScreenIconViewer extends StatefulWidget {
  final File file;
  final Map<String, String> headers;

  const _FullScreenIconViewer({required this.file, required this.headers});

  @override
  _FullScreenIconViewerState createState() => _FullScreenIconViewerState();
}

class _FullScreenIconViewerState extends State<_FullScreenIconViewer>
    with TickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  late Animation<Matrix4> _animation;
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      // ズームアウト
      _animation = Matrix4Tween(
        begin: _transformationController.value,
        end: Matrix4.identity(),
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );
    } else {
      // ズームイン
      final position = _doubleTapDetails!.localPosition;
      const scale = 3.0; // アイコンは小さいので少し大きめにズーム
      final x = -position.dx * (scale - 1);
      final y = -position.dy * (scale - 1);
      final zoomed =
          Matrix4.identity()
            ..translate(x, y)
            ..scale(scale);

      _animation = Matrix4Tween(
        begin: _transformationController.value,
        end: zoomed,
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );
    }

    _animationController.reset();
    _animation.addListener(() {
      _transformationController.value = _animation.value;
    });
    _animationController.forward();
  }

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

          // 画像ビューアー
          Center(
            child: GestureDetector(
              onDoubleTapDown: _handleDoubleTapDown,
              onDoubleTap: _handleDoubleTap,
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.5,
                maxScale: 6.0,
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                    maxHeight: 400,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.file.versions.last.file!.url.toString(),
                    httpHeaders: widget.headers,
                    cacheManager: JsonCacheManager(),
                    fit: BoxFit.contain,
                    placeholder:
                        (context, url) => Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(16),
                          ),
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
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 100,
                          ),
                        ),
                  ),
                ),
              ),
            ),
          ),

          // ヘッダー（閉じるボタン）
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 閉じるボタン
                Material(
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

                // ズームヒント
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'ダブルタップでズーム',
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
