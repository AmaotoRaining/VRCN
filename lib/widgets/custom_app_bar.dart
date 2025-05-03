import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/friends_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/utils/cache_manager.dart';

/// アプリ共通のカスタムAppBarウィジェット
class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool showAvatar;
  final VoidCallback? onAvatarPressed;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.showAvatar = true,
    this.onAvatarPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final vrchatApi = ref.watch(vrchatProvider).value;
    final headers = {
      'User-Agent': vrchatApi?.userAgent.toString() ?? 'VRChat/1.0',
    };

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      centerTitle: true,
      title: title != null
          ? Text(
              title!,
              style: GoogleFonts.notoSans(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )
          : const CircleAvatar(
              backgroundImage: AssetImage('assets/images/default.png'),
            ),
      iconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      actions: actions,
      leading: showAvatar
          ? Builder(
              builder: (context) => currentUserAsync.when(
                data: (currentUser) => IconButton(
                  icon: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: currentUser.currentAvatarThumbnailImageUrl.isNotEmpty
                        ? CachedNetworkImageProvider(
                            currentUser.currentAvatarThumbnailImageUrl,
                            headers: headers,
                            cacheManager: JsonCacheManager(),
                          )
                        : const AssetImage('assets/images/default.png') as ImageProvider,
                  ),
                  onPressed: onAvatarPressed ?? () => Scaffold.of(context).openDrawer(),
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
                loading: () => IconButton(
                  icon: const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  onPressed: onAvatarPressed ?? () => Scaffold.of(context).openDrawer(),
                ),
                error: (_, _) => IconButton(
                  icon: const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey,
                    backgroundImage: AssetImage('assets/images/default.png'),
                  ),
                  onPressed: onAvatarPressed ?? () => Scaffold.of(context).openDrawer(),
                ),
              ),
            )
          : null,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Container(
          height: 0.5,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[900]
              : Colors.grey[200],
        ),
      ),
    );
  }
}
