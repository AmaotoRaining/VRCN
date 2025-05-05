import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/user_provider.dart';
import 'package:vrchat/provider/search_providers.dart';
import 'package:vrchat/widgets/search_widgets.dart';
import 'package:vrchat/utils/cache_manager.dart';
import 'package:vrchat/widgets/loading_indicator.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class UserSearchTab extends ConsumerStatefulWidget {
  const UserSearchTab({super.key});

  @override
  ConsumerState<UserSearchTab> createState() => _UserSearchTabState();
}

class _UserSearchTabState extends ConsumerState<UserSearchTab> {
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

    final currentOffset = ref.read(userSearchOffsetProvider);
    ref.read(userSearchOffsetProvider.notifier).state = currentOffset + 60;

    // 検索実行のトリガー
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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

    // 検索状態が変化したときのリスナー
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
      return buildEmptySearchState('ユーザー', Icons.people, isDarkMode);
    }

    if (searchState.isLoading && offset == 0) {
      return const Center(child: LoadingIndicator(message: '検索中...'));
    }

    if (searchState.hasError && cachedResults.isEmpty) {
      return buildErrorState(searchState.error.toString(), isDarkMode);
    }

    if (cachedResults.isEmpty && !searchState.isLoading) {
      return buildNoResultsState(query, isDarkMode);
    }

    return ListView.builder(
      controller: _scrollController,
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
}
