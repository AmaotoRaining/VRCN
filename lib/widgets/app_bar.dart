import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrchat/provider/friends_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';

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

    // ドロワーを開くための関数
    void openDrawer() {
      // 重要: ScaffoldMessengerではなくScaffoldを直接取得
      final scaffold = Scaffold.maybeOf(context);
      if (scaffold != null && scaffold.hasDrawer) {
        scaffold.openDrawer();
      }
    }

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      centerTitle: true,
      title:
          title != null
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
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
      actions: actions,
      leadingWidth: 56, // 適切な幅を設定
      leading:
          showAvatar
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: currentUserAsync.when(
                  data:
                      (currentUser) => GestureDetector(
                        onTap: onAvatarPressed ?? openDrawer,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                              currentUser
                                      .currentAvatarThumbnailImageUrl
                                      .isNotEmpty
                                  ? CachedNetworkImageProvider(
                                    currentUser.currentAvatarThumbnailImageUrl,
                                    headers: headers,
                                  )
                                  : const AssetImage(
                                        'assets/images/default.png',
                                      )
                                      as ImageProvider,
                        ),
                      ),
                  loading:
                      () => GestureDetector(
                        onTap: onAvatarPressed ?? openDrawer,
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                  error:
                      (_, _) => GestureDetector(
                        onTap: onAvatarPressed ?? openDrawer,
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey,
                          backgroundImage: AssetImage(
                            'assets/images/default.png',
                          ),
                        ),
                      ),
                ),
              )
              : null,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Container(
          height: 0.5,
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]
                  : Colors.grey[200],
        ),
      ),
    );
  }
}
