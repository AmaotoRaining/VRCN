import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/models/avtrdb_search_result.dart';
import 'package:vrchat/provider/avtrdb_provider.dart';
import 'package:vrchat/provider/search_providers.dart';
import 'package:vrchat/utils/cache_manager.dart';
import 'package:vrchat/widgets/error_container.dart';
import 'package:vrchat/widgets/loading_indicator.dart';
import 'package:vrchat/widgets/search_widgets.dart';

class AvatarSearchTab extends ConsumerWidget {
  const AvatarSearchTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (query.isEmpty) {
      return buildEmptySearchState('アバター', Icons.person_outline, isDarkMode);
    }

    final searchResultAsync = ref.watch(avtrDbSearchProvider(query));

    return searchResultAsync.when(
      data: (avatars) {
        if (avatars.isEmpty) {
          return _buildNoResultsFound(isDarkMode);
        }

        return _buildSearchResults(context, avatars, isDarkMode);
      },
      loading: () => const LoadingIndicator(message: 'アバターを検索中...'),
      error:
          (error, stack) => ErrorContainer(
            message: '検索エラー: ${error.toString()}',
            onRetry: () => ref.refresh(avtrDbSearchProvider(query)),
          ),
    );
  }

  Widget _buildNoResultsFound(bool isDarkMode) {
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
            '検索結果が見つかりませんでした',
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

  Widget _buildSearchResults(
    BuildContext context,
    List<AvtrDbSearchResult> avatars,
    bool isDarkMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '検索結果: ${avatars.length}件',
            style: GoogleFonts.notoSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: avatars.length,
            itemBuilder: (context, index) {
              final avatar = avatars[index];
              return _buildAvatarItem(context, avatar, isDarkMode);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarItem(
    BuildContext context,
    AvtrDbSearchResult avatar,
    bool isDarkMode,
  ) {
    final headers = {'User-Agent': 'VRChat/1.0'};
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: () => context.push('/avatar/${avatar.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // アバター画像
            Expanded(
              child: CachedNetworkImage(
                imageUrl: avatar.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,

                httpHeaders: headers,
                cacheManager: JsonCacheManager(),
                placeholder:
                    (context, url) => Container(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                      child: const Icon(Icons.broken_image),
                    ),
              ),
            ),

            // アバター情報
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    avatar.name,
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    avatar.authorName,
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
