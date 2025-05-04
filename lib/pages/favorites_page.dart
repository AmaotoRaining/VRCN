import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/avatar_provider.dart';
import 'package:vrchat/provider/favorite_provider.dart';
import 'package:vrchat/provider/user_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/provider/world_provider.dart';
import 'package:vrchat/theme/app_theme.dart';
import 'package:vrchat/utils/cache_manager.dart';
import 'package:vrchat/widgets/error_container.dart';
import 'package:vrchat/widgets/loading_indicator.dart';
import 'package:vrchat_dart/vrchat_dart.dart' hide FavoriteType;

// お気に入り削除用のStateNotifierプロバイダー
final favoriteActionProvider =
    StateNotifierProvider<FavoriteActionNotifier, AsyncValue<void>>((ref) {
      final favoriteApi = ref.watch(vrchatFavoriteProvider).valueOrNull;
      return FavoriteActionNotifier(favoriteApi);
    });

// お気に入り操作の状態管理クラス
class FavoriteActionNotifier extends StateNotifier<AsyncValue<void>> {
  final FavoritesApi? _favoriteApi;

  FavoriteActionNotifier(this._favoriteApi)
    : super(const AsyncValue.data(null));

  Future<void> removeFavorite(String favoriteId) async {
    if (_favoriteApi == null) {
      state = const AsyncValue.error('お気に入りAPIが初期化されていません', StackTrace.empty);
      return;
    }

    state = const AsyncValue.loading();

    try {
      await _favoriteApi.removeFavorite(favoriteId: favoriteId);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error('お気に入り削除に失敗しました: $e', stack);
    }
  }
}

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? const Color(0xFF151515) : const Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'お気に入り',
          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.notoSans(),
          indicatorColor: AppTheme.primaryColor,
          labelColor: isDarkMode ? Colors.white : Colors.black87,
          unselectedLabelColor:
              isDarkMode ? Colors.grey[400] : Colors.grey[600],
          tabs: const [Tab(text: 'フレンド'), Tab(text: 'ワールド'), Tab(text: 'アバター')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // フレンド タブ
          _FavoriteFriendsTab(),
          // ワールド タブ
          _FavoriteWorldsTab(),
          // アバター タブ
          _FavoriteAvatarsTab(),
        ],
      ),
    );
  }
}

// フレンドお気に入りタブ
class _FavoriteFriendsTab extends ConsumerWidget {
  const _FavoriteFriendsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteFriendsAsync = ref.watch(favoriteFriendsProvider);
    final favoriteGroupsAsync = ref.watch(myFavoriteGroupsProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return favoriteFriendsAsync.when(
      data: (favorites) {
        return favoriteGroupsAsync.when(
          data: (groups) {
            // フィルタリングしてフレンドタイプのグループだけを取得
            final friendGroups =
                groups
                    .where(
                      (group) =>
                          group.type.toString() == FavoriteType.friend.value,
                    )
                    .toList();

            // フレンドグループが一つもない場合だけ空の状態を表示
            if (friendGroups.isEmpty) {
              return _buildEmptyState(
                context,
                'お気に入りフォルダがありません',
                'VRChat内でお気に入りフォルダを作成してください',
                Icons.folder_outlined,
                isDarkMode,
              );
            }

            // お気に入りが空でも各フォルダを表示する
            // グループ別にフレンドお気に入りを整理
            final groupedFavorites = _groupFavoritesByFolder(
              favorites: favorites,
              groups: groups,
              type: FavoriteType.friend,
            );

            // フォルダがあっても、お気に入りがない場合の追加処理
            // すべてのフレンドフォルダが存在することを確認
            for (final group in friendGroups) {
              final displayName = group.displayName ?? group.name;
              if (!groupedFavorites.containsKey(displayName)) {
                groupedFavorites[displayName] = [];
              }
            }

            // グループごとにセクションを作成
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: groupedFavorites.length,
              itemBuilder: (context, index) {
                final folderName = groupedFavorites.keys.elementAt(index);
                final folderFavorites = groupedFavorites[folderName]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // フォルダ名を表示
                    _FolderHeader(
                      folderName: folderName,
                      isDarkMode: isDarkMode,
                    ),

                    // フォルダ内のフレンド一覧
                    if (folderFavorites.isEmpty)
                      // 空のフォルダの場合
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 40,
                                color:
                                    isDarkMode
                                        ? Colors.grey[600]
                                        : Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'このフォルダにはフレンドがいません',
                                style: GoogleFonts.notoSans(
                                  fontSize: 14,
                                  color:
                                      isDarkMode
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Column(
                        children:
                            folderFavorites.map((favorite) {
                              final userAsync = ref.watch(
                                userDetailProvider(favorite.favoriteId),
                              );

                              return userAsync.when(
                                data:
                                    (user) => _buildFriendItem(
                                      context,
                                      user,
                                      favorite.id,
                                      ref,
                                      isDarkMode,
                                    ),
                                loading:
                                    () => const Card(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                                error:
                                    (_, _) => Card(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          'ID: ${favorite.favoriteId}',
                                        ),
                                        subtitle: const Text('情報の取得に失敗しました'),
                                        trailing: IconButton(
                                          icon: const Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          ),
                                          onPressed:
                                              () => _removeFavorite(
                                                context,
                                                ref,
                                                favorite.id,
                                                '友達',
                                              ),
                                        ),
                                      ),
                                    ),
                              );
                            }).toList(),
                      ),
                  ],
                );
              },
            );
          },
          loading: () => const LoadingIndicator(message: 'フォルダ情報を読み込み中...'),
          error:
              (_, _) => ErrorContainer(
                message: '情報の取得に失敗しました',
                onRetry: () {
                  ref.refresh(myFavoriteGroupsProvider);
                  ref.refresh(favoriteFriendsProvider);
                },
              ),
        );
      },
      loading: () => const LoadingIndicator(message: 'お気に入りを読み込み中...'),
      error:
          (error, stack) => ErrorContainer(
            message: 'お気に入りの読み込みに失敗しました: $error',
            onRetry: () => ref.refresh(favoriteFriendsProvider),
          ),
    );
  }
}

// ワールドお気に入りタブ
class _FavoriteWorldsTab extends ConsumerWidget {
  const _FavoriteWorldsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteWorldsAsync = ref.watch(favoriteWorldsProvider);
    final favoriteGroupsAsync = ref.watch(myFavoriteGroupsProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return favoriteWorldsAsync.when(
      data: (favorites) {
        if (favorites.isEmpty) {
          return _buildEmptyState(
            context,
            'お気に入りのワールドがありません',
            'ワールド詳細画面からお気に入りに登録できます',
            Icons.public,
            isDarkMode,
          );
        }

        return favoriteGroupsAsync.when(
          data: (groups) {
            // グループ別にワールドお気に入りを整理
            final groupedFavorites = _groupFavoritesByFolder(
              favorites: favorites,
              groups: groups,
              type: FavoriteType.world,
            );

            // フォルダごとのリストを構築
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: groupedFavorites.length,
              itemBuilder: (context, index) {
                final folderName = groupedFavorites.keys.elementAt(index);
                final folderFavorites = groupedFavorites[folderName]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // フォルダ名を表示
                    _FolderHeader(
                      folderName: folderName,
                      isDarkMode: isDarkMode,
                    ),

                    // フォルダ内のワールドをグリッドで表示
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount:
                          folderFavorites.isEmpty
                              ? 1 // 空の場合は1つのセルにメッセージを表示
                              : folderFavorites.length,
                      itemBuilder: (context, itemIndex) {
                        // 空のフォルダの場合はメッセージを表示
                        if (folderFavorites.isEmpty) {
                          return Card(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      size: 40,
                                      color:
                                          isDarkMode
                                              ? Colors.grey[600]
                                              : Colors.grey[400],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'このフォルダには\nアイテムがありません',
                                      style: GoogleFonts.notoSans(
                                        fontSize: 12,
                                        color:
                                            isDarkMode
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        // 通常のアイテム表示（既存のコード）
                        final favorite = folderFavorites[itemIndex];
                        final worldAsync = ref.watch(
                          worldDetailProvider(favorite.favoriteId),
                        );

                        return worldAsync.when(
                          data:
                              (world) => _buildWorldItem(
                                context,
                                world,
                                favorite.id,
                                ref,
                                isDarkMode,
                              ),
                          loading:
                              () => const Card(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          error:
                              (_, _) => Card(
                                child: Center(
                                  child: Text(
                                    'ワールド情報の取得に失敗しました\nID: ${favorite.favoriteId}',
                                  ),
                                ),
                              ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
          loading: () => const LoadingIndicator(message: 'フォルダ情報を読み込み中...'),
          error:
              (_, _) => GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final favorite = favorites[index];
                  final worldAsync = ref.watch(
                    worldDetailProvider(favorite.favoriteId),
                  );

                  return worldAsync.when(
                    data:
                        (world) => _buildWorldItem(
                          context,
                          world,
                          favorite.id,
                          ref,
                          isDarkMode,
                        ),
                    loading:
                        () => const Card(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    error:
                        (_, _) => Card(
                          child: Center(
                            child: Text(
                              'ワールド情報の取得に失敗しました\nID: ${favorite.favoriteId}',
                            ),
                          ),
                        ),
                  );
                },
              ),
        );
      },
      loading: () => const LoadingIndicator(message: 'お気に入りを読み込み中...'),
      error:
          (error, stack) => ErrorContainer(
            message: 'お気に入りの読み込みに失敗しました: $error',
            onRetry: () => ref.refresh(favoriteWorldsProvider),
          ),
    );
  }

  // ワールドアイテム表示用のウィジェット
  Widget _buildWorldItem(
    BuildContext context,
    World world,
    String favoriteId,
    WidgetRef ref,
    bool isDarkMode,
  ) {
    final vrchatApi = ref.watch(vrchatProvider).value;
    final headers = <String, String>{
      'User-Agent': vrchatApi?.userAgent.toString() ?? 'VRChat/1.0',
    };

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => context.push('/world/${world.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ワールド画像
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: world.imageUrl,
                    fit: BoxFit.cover,
                    httpHeaders: headers,
                    cacheManager: JsonCacheManager(),
                    placeholder:
                        (context, url) => Container(
                          color:
                              isDarkMode ? Colors.grey[800] : Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          color:
                              isDarkMode ? Colors.grey[800] : Colors.grey[300],
                          child: const Icon(Icons.broken_image),
                        ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(153),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed:
                          () => _removeFavorite(
                            context,
                            ref,
                            favoriteId,
                            world.name,
                          ),
                      tooltip: 'お気に入りから削除',
                      iconSize: 20,
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    world.name,
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '作者: ${world.authorName}',
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

  // お気に入り削除処理
  Future<void> _removeFavorite(
    BuildContext context,
    WidgetRef ref,
    String favoriteId,
    String name,
  ) async {
    try {
      await ref
          .read(favoriteActionProvider.notifier)
          .removeFavorite(favoriteId);
      ref.invalidate(favoriteWorldsProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$nameをお気に入りから削除しました')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('削除に失敗しました: $e')));
      }
    }
  }
}

// アバターお気に入りタブ（フォルダ対応版）
class _FavoriteAvatarsTab extends ConsumerWidget {
  const _FavoriteAvatarsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteAvatarsAsync = ref.watch(favoriteAvatarsProvider);
    final favoriteGroupsAsync = ref.watch(myFavoriteGroupsProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return favoriteAvatarsAsync.when(
      data: (favorites) {
        if (favorites.isEmpty) {
          return _buildEmptyState(
            context,
            'お気に入りのアバターがありません',
            'アバター詳細画面からお気に入りに登録できます',
            Icons.face,
            isDarkMode,
          );
        }

        return favoriteGroupsAsync.when(
          data: (groups) {
            // グループ別にアバターお気に入りを整理
            final groupedFavorites = _groupFavoritesByFolder(
              favorites: favorites,
              groups: groups,
              type: FavoriteType.avatar,
            );

            // フォルダごとのリストを構築
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: groupedFavorites.length,
              itemBuilder: (context, index) {
                final folderName = groupedFavorites.keys.elementAt(index);
                final folderFavorites = groupedFavorites[folderName]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // フォルダ名を表示
                    _FolderHeader(
                      folderName: folderName,
                      isDarkMode: isDarkMode,
                    ),

                    // フォルダ内のアバターをグリッドで表示
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount:
                          folderFavorites.isEmpty
                              ? 1 // 空の場合は1つのセルにメッセージを表示
                              : folderFavorites.length,
                      itemBuilder: (context, itemIndex) {
                        // 空のフォルダの場合はメッセージを表示
                        if (folderFavorites.isEmpty) {
                          return Card(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      size: 40,
                                      color:
                                          isDarkMode
                                              ? Colors.grey[600]
                                              : Colors.grey[400],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'このフォルダには\nアイテムがありません',
                                      style: GoogleFonts.notoSans(
                                        fontSize: 12,
                                        color:
                                            isDarkMode
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        // 通常のアイテム表示（既存のコード）
                        final favorite = folderFavorites[itemIndex];
                        final avatarAsync = ref.watch(
                          avatarDetailProvider(favorite.favoriteId),
                        );

                        return avatarAsync.when(
                          data:
                              (avatar) => _buildAvatarItem(
                                context,
                                avatar,
                                favorite.id,
                                ref,
                                isDarkMode,
                              ),
                          loading:
                              () => const Card(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          error:
                              (_, _) => Card(
                                child: Center(
                                  child: Text(
                                    'アバター情報の取得に失敗しました\nID: ${favorite.favoriteId}',
                                  ),
                                ),
                              ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
          loading: () => const LoadingIndicator(message: 'フォルダ情報を読み込み中...'),
          error:
              (_, _) => GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final favorite = favorites[index];
                  final avatarAsync = ref.watch(
                    avatarDetailProvider(favorite.favoriteId),
                  );

                  return avatarAsync.when(
                    data:
                        (avatar) => _buildAvatarItem(
                          context,
                          avatar,
                          favorite.id,
                          ref,
                          isDarkMode,
                        ),
                    loading:
                        () => const Card(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    error:
                        (_, _) => Card(
                          child: Center(
                            child: Text(
                              'アバター情報の取得に失敗しました\nID: ${favorite.favoriteId}',
                            ),
                          ),
                        ),
                  );
                },
              ),
        );
      },
      loading: () => const LoadingIndicator(message: 'お気に入りを読み込み中...'),
      error:
          (error, stack) => ErrorContainer(
            message: 'お気に入りの読み込みに失敗しました: $error',
            onRetry: () => ref.refresh(favoriteAvatarsProvider),
          ),
    );
  }

  // お気に入り削除処理のメソッドを _FavoriteAvatarsTab クラス内に移動
}

// フォルダヘッダーコンポーネント
class _FolderHeader extends StatelessWidget {
  final String folderName;
  final Color? color;
  final bool isDarkMode;

  const _FolderHeader({
    required this.folderName,
    this.color,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color ?? (isDarkMode ? Colors.grey[800] : Colors.grey[200]),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.folder,
            size: 18,
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
          const SizedBox(width: 8),
          Text(
            folderName,
            style: GoogleFonts.notoSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// お気に入りをフォルダ別にグループ化する関数
Map<String, List<Favorite>> _groupFavoritesByFolder({
  required List<Favorite> favorites,
  required List<FavoriteGroup> groups,
  required FavoriteType type,
}) {
  // デバッグ情報を出力
  debugPrint('=== デバッグ情報 ===');
  debugPrint('タイプ: ${type.value}');
  debugPrint('グループ数: ${groups.length}');
  debugPrint('お気に入り数: ${favorites.length}');

  // タイプでフィルタリングしたグループを取得
  final typeGroups =
      groups.where((group) => group.type.toString() == type.value).toList();

  debugPrint('フィルタリング後のグループ数: ${typeGroups.length}');

  // 結果を格納するMap（キー：表示名、値：お気に入りリスト）
  final result = <String, List<Favorite>>{};

  final groupTagToNameMap = <String, String>{};

  // まずすべてのフォルダを初期化する
  for (final group in typeGroups) {
    // displayNameがある場合はそれを使い、なければnameを使用
    final displayName = group.displayName;

    // 空のリストでフォルダ初期化
    result[displayName] = [];

    // 名前 → 表示名のマッピングも作成（タグとの照合用）
    groupTagToNameMap[group.name] = displayName;
  }

  // 各お気に入りを適切なフォルダに振り分け
  for (final favorite in favorites) {
    for (final tag in favorite.tags) {
      if (groupTagToNameMap.containsKey(tag)) {
        final displayName = groupTagToNameMap[tag]!;
        result[displayName]!.add(favorite);
        break;
      }
    }
  }

  // 分類結果をデバッグ出力
  debugPrint('=== 分類結果 ===');
  for (final folderName in result.keys) {
    debugPrint('$folderName: ${result[folderName]!.length}件');
  }

  return result;
}

Widget _buildEmptyState(
  BuildContext context,
  String title,
  String subtitle,
  IconData icon,
  bool isDarkMode,
) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 70,
            color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: GoogleFonts.notoSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

// フレンド表示用のウィジェット
Widget _buildFriendItem(
  BuildContext context,
  User friend,
  String favoriteId,
  WidgetRef ref,
  bool isDarkMode,
) {
  final vrchatApi = ref.watch(vrchatProvider).value;
  final headers = <String, String>{
    'User-Agent': vrchatApi?.userAgent.toString() ?? 'VRChat/1.0',
  };

  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.push('/user/${friend.id}'),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // プロフィール画像
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                ),
              ),
              child: CircleAvatar(
                backgroundImage:
                    friend.userIcon.isNotEmpty
                        ? CachedNetworkImageProvider(
                          friend.userIcon,
                          headers: headers,
                          cacheManager: JsonCacheManager(),
                        )
                        : null,
                child:
                    friend.userIcon.isEmpty
                        ? const Icon(Icons.person, color: Colors.white70)
                        : null,
              ),
            ),

            const SizedBox(width: 16),

            // ユーザー情報
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.displayName,
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (friend.statusDescription.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      friend.statusDescription,
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // お気に入り解除ボタン
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed:
                  () => _removeFavorite(
                    context,
                    ref,
                    favoriteId,
                    friend.displayName,
                  ),
              tooltip: 'お気に入りから削除',
            ),
          ],
        ),
      ),
    ),
  );
}

// お気に入り削除処理
Future<void> _removeFavorite(
  BuildContext context,
  WidgetRef ref,
  String favoriteId,
  String name,
) async {
  try {
    await ref.read(favoriteActionProvider.notifier).removeFavorite(favoriteId);
    ref.invalidate(favoriteFriendsProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$nameをお気に入りから削除しました')));
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('削除に失敗しました: $e')));
    }
  }
}

// アバターアイテム表示用のウィジェット
Widget _buildAvatarItem(
  BuildContext context,
  Avatar avatar,
  String favoriteId,
  WidgetRef ref,
  bool isDarkMode,
) {
  final vrchatApi = ref.watch(vrchatProvider).value;
  final headers = <String, String>{
    'User-Agent': vrchatApi?.userAgent.toString() ?? 'VRChat/1.0',
  };

  return Card(
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: InkWell(
      onTap: () => context.push('/avatar/${avatar.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // アバター画像
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: CachedNetworkImage(
                  imageUrl: avatar.imageUrl,
                  fit: BoxFit.cover,
                  httpHeaders: headers,
                  cacheManager: JsonCacheManager(),
                  placeholder:
                      (context, url) => Container(
                        color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                        child: const Icon(Icons.broken_image),
                      ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(153),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 20,
                    ),
                    onPressed:
                        () => _removeFavorite(
                          context,
                          ref,
                          favoriteId,
                          avatar.name,
                        ),
                    tooltip: 'お気に入りから削除',
                    iconSize: 20,
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                  '作者: ${avatar.authorName}',
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
