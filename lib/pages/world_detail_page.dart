import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/provider/world_provider.dart';
import 'package:vrchat/utils/cache_manager.dart';
import 'package:vrchat/widgets/app_back_button.dart';
import 'package:vrchat/widgets/error_view.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class WorldDetailPage extends ConsumerWidget {
  final String worldId;

  const WorldDetailPage({super.key, required this.worldId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final worldDetailAsync = ref.watch(worldDetailProvider(worldId));
    final vrchatApi = ref.watch(vrchatProvider).value;

    final headers = <String, String>{
      'User-Agent': vrchatApi?.userAgent.toString() ?? 'VRChat/1.0',
    };

    return Scaffold(
      body: worldDetailAsync.when(
        data:
            (world) =>
                _buildWorldDetailView(context, world, isDarkMode, headers, ref),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(message: 'ワールド情報の取得に失敗しました: $error'),
      ),
    );
  }

  Widget _buildWorldDetailView(
    BuildContext context,
    World world,
    bool isDarkMode,
    Map<String, String> headers,
    WidgetRef ref,
  ) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, world, isDarkMode, headers),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWorldInfo(context, world, isDarkMode),
                const SizedBox(height: 24),
                _buildWorldStats(context, world, isDarkMode),
                const SizedBox(height: 24),
                _buildDescription(context, world, isDarkMode),
                const SizedBox(height: 24),
                _buildTags(context, world, isDarkMode),
                const SizedBox(height: 32),
                // _buildActionButtons(context, world, isDarkMode, ref),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    World world,
    bool isDarkMode,
    Map<String, String> headers,
  ) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      leading: const AppBackButton(),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // ワールド画像
            Hero(
              tag: 'world-${world.id}',
              child: CachedNetworkImage(
                imageUrl: world.imageUrl,
                fit: BoxFit.cover,
                httpHeaders: headers,
                cacheManager: JsonCacheManager(),
                placeholder:
                    (context, url) => Container(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green,
                          ),
                        ),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),
              ),
            ),
            // グラデーションオーバーレイ
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ],
        ),
        title: Text(
          world.name,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.8),
                blurRadius: 5,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.public, color: Colors.white),
          tooltip: 'VRChat公式サイトで開く',
          onPressed: () => _launchVRChatWebsite(world.id),
        ),
      ],
    );
  }

  Widget _buildWorldInfo(BuildContext context, World world, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 作成者情報
        Row(
          children: [
            Text(
              '作成者: ',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
            Text(
              world.authorName,
              style: GoogleFonts.notoSans(
                fontSize: 16,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // 作成日と更新日
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 16),
            const SizedBox(width: 8),
            Text(
              '作成: ${_formatDate(world.createdAt)}',
              style: GoogleFonts.notoSans(fontSize: 14),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.update, size: 16),
            const SizedBox(width: 8),
            Text(
              '更新: ${_formatDate(world.updatedAt)}',
              style: GoogleFonts.notoSans(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWorldStats(BuildContext context, World world, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? Colors.grey[850]!.withValues(alpha: .5)
                : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            Icons.favorite,
            _formatNumber(world.favorites),
            'お気に入り',
            Colors.red,
          ),
          _buildStatItem(
            context,
            Icons.visibility,
            _formatNumber(world.visits),
            '訪問数',
            Colors.blue,
          ),
          _buildStatItem(
            context,
            Icons.public,
            _formatNumber(world.occupants),
            '現在の人数',
            Colors.green,
          ),
          _buildStatItem(
            context,
            Icons.favorite,
            world.popularity.toString(),
            '評価',
            Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: GoogleFonts.notoSans(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context, World world, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '説明',
          style: GoogleFonts.notoSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                isDarkMode
                    ? Colors.grey[850]!.withValues(alpha: 0.5)
                    : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
            ),
          ),
          child: Text(
            world.description.isNotEmpty ? world.description : '説明はありません',
            style: GoogleFonts.notoSans(fontSize: 14, height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildTags(BuildContext context, World world, bool isDarkMode) {
    if (world.tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'タグ',
          style: GoogleFonts.notoSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              world.tags.map((tag) => _buildTagChip(tag, isDarkMode)).toList(),
        ),
      ],
    );
  }

  Widget _buildTagChip(String tag, bool isDarkMode) {
    return Chip(
      label: Text(
        tag.replaceAll('author_tag_', ''),
        style: GoogleFonts.notoSans(
          fontSize: 12,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    World world,
    bool isDarkMode,
    WidgetRef ref,
  ) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: ワールドへの参加処理
              _joinWorld(context, world, ref);
            },
            icon: const Icon(Icons.public),
            label: Text(
              'パブリックで招待を送信',
              style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: () {
            // TODO: お気に入り登録処理
            _toggleFavorite(context, world, ref);
          },
          icon: const Icon(Icons.favorite_border),
          style: IconButton.styleFrom(
            backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
            foregroundColor: Colors.red,
            padding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.red.withValues(alpha: 0.5)),
            ),
          ),
        ),
      ],
    );
  }

  void _joinWorld(BuildContext context, World world, WidgetRef ref) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${world.name}へ参加しようとしています...実装中')));

    // TODO:ここに実際のワールド参加ロジックを実装
    // 例: ref.read(joinWorldProvider)(world.id);
  }

  void _toggleFavorite(BuildContext context, World world, WidgetRef ref) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${world.name}をお気に入りに追加しました。実装中')));

    // TODO:ここに実際のお気に入り登録/解除ロジックを実装
    // 例: ref.read(favoriteWorldProvider)(world.id);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '不明';
    return DateFormat('yyyy/MM/dd').format(date);
  }

  String _formatNumber(int? number) {
    if (number == null) return '0';
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

// ブラウザでVRChatウェブサイトを開くメソッド
Future<void> _launchVRChatWebsite(String worldId) async {
  final url = Uri.parse('https://vrchat.com/home/world/$worldId');
  try {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  } catch (e) {
    debugPrint('Error launching URL: $e');
  }
}
