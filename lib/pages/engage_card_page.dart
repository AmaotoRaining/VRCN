import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrchat/provider/user_provider.dart';
import 'package:vrchat/provider/vrchat_api_provider.dart';
import 'package:vrchat/utils/cache_manager.dart';
import 'package:vrchat/widgets/loading_indicator.dart';

const _backgroundImageKey = 'business_card_background_image';

final backgroundImageProvider = StateProvider<File?>((ref) => null);

enum CardExtraInfo { none, qr, userId }

class EngageCardPage extends ConsumerStatefulWidget {
  const EngageCardPage({super.key});

  @override
  ConsumerState<EngageCardPage> createState() => _EngageCardPageState();
}

class _EngageCardPageState extends ConsumerState<EngageCardPage>
    with SingleTickerProviderStateMixin {
  double? _oldBrightness;
  late AnimationController _controller;
  final _extraInfo = CardExtraInfo.none;

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
    _setMaxBrightness();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_oldBrightness != null) {
      ScreenBrightness().setApplicationScreenBrightness(_oldBrightness!);
    }
    super.dispose();
  }

  Future<void> _setMaxBrightness() async {
    try {
      _oldBrightness = await ScreenBrightness.instance.system;
      await ScreenBrightness().setApplicationScreenBrightness(1.0);
    } catch (_) {}
  }

  Future<void> _loadBackgroundImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_backgroundImageKey);
    if (path != null && mounted) {
      ref.read(backgroundImageProvider.notifier).state = File(path);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = p.basename(pickedFile.path);
      final savedImage = await File(
        pickedFile.path,
      ).copy('${appDir.path}/$fileName');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_backgroundImageKey, savedImage.path);

      if (mounted) {
        ref.read(backgroundImageProvider.notifier).state = savedImage;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final backgroundImage = ref.watch(backgroundImageProvider);
    final vrchatApi = ref.watch(vrchatProvider).value;
    final headers = {
      'User-Agent': vrchatApi?.userAgent.toString() ?? 'VRChat/1.0',
    };

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library_outlined),
            onPressed: _pickImage,
            tooltip: '背景画像を選択',
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => context.push('/qr_scanner'),
            tooltip: 'QRコードをスキャン',
          ),
        ],
      ),
      body: currentUserAsync.when(
        data: (user) {
          return Stack(
            children: [
              // 背景
              Container(
                decoration: BoxDecoration(
                  image:
                      backgroundImage != null
                          ? DecorationImage(
                            image: FileImage(backgroundImage),
                            fit: BoxFit.cover,
                          )
                          : null,
                  gradient:
                      backgroundImage == null
                          ? const LinearGradient(
                            colors: [Color(0xFF23243B), Color(0xFF3B8D99)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                          : null,
                ),
              ),
              // カード本体（画面下部に寄せる）
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildEngageCardFront(
                    context,
                    user,
                    headers,
                    backgroundImage,
                    _extraInfo,
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const LoadingIndicator(),
        error: (err, stack) => Center(child: Text('エラー: $err')),
      ),
    );
  }

  Widget _buildEngageCardFront(
    BuildContext context,
    user,
    Map<String, String> headers,
    File? backgroundImage,
    CardExtraInfo extraInfo,
  ) {
    return Container(
      width: 370,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 36,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: LiquidGlass(
          settings: const LiquidGlassSettings(
            thickness: 12,
            glassColor: Color(0x22FFFFFF),
            lightIntensity: 2.0,
            blend: 60,
          ),
          shape: const LiquidRoundedSuperellipse(
            borderRadius: Radius.circular(30),
          ),
          child: Stack(
            children: [
              // グラデーションオーバーレイ
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.08),
                        Colors.tealAccent.withValues(alpha: 0.08),
                        Colors.blue.withValues(alpha: 0.08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage:
                            user.userIcon.isNotEmpty
                                ? CachedNetworkImageProvider(
                                  user.userIcon,
                                  headers: headers,
                                  cacheManager: JsonCacheManager(),
                                )
                                : user.currentAvatarThumbnailImageUrl.isNotEmpty
                                ? CachedNetworkImageProvider(
                                  user.currentAvatarThumbnailImageUrl,
                                  headers: headers,
                                  cacheManager: JsonCacheManager(),
                                )
                                : const AssetImage('assets/icons/default.png')
                                    as ImageProvider,
                        backgroundColor: Colors.white24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FittedBox(
                              child: Text(
                                user.displayName,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              child: Text(
                                '@${user.username}',
                                style: GoogleFonts.notoSans(
                                  fontSize: 14,
                                  color: Colors.white70,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      QrImageView(
                        data: 'https://vrchat.com/home/user/${user.id}',
                        foregroundColor: Colors.white,
                        version: QrVersions.auto,
                        size: 80,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
