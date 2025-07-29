import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
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

class BusinessCardPage extends ConsumerStatefulWidget {
  const BusinessCardPage({super.key});

  @override
  ConsumerState<BusinessCardPage> createState() => _BusinessCardPageState();
}

class _BusinessCardPageState extends ConsumerState<BusinessCardPage>
    with SingleTickerProviderStateMixin {
  double? _oldBrightness;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isBack = false;

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
    _setMaxBrightness();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_oldBrightness != null) {
      ScreenBrightness().setScreenBrightness(_oldBrightness!);
    }
    super.dispose();
  }

  void _flipCard() {
    setState(() {
      _isBack = !_isBack;
      if (_isBack) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Future<void> _setMaxBrightness() async {
    try {
      _oldBrightness = await ScreenBrightness().current;
      await ScreenBrightness().setScreenBrightness(1.0);
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
          IconButton(
            icon: Icon(_isBack ? Icons.flip_to_front : Icons.flip_to_back),
            onPressed: _flipCard,
            tooltip: _isBack ? '表面へ' : '裏面へ',
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
                            colors: [Colors.deepPurple, Colors.teal],
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
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32.0), // ← ここが必須
                    child: GestureDetector(
                      onDoubleTap: _flipCard,
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          final isBack = _animation.value >= 0.5;
                          final angle = _animation.value * 3.1415926535;
                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(angle),
                            child: isBack
                                ? Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()..rotateY(3.1415926535),
                                  child: _buildBusinessCardBack(
                                    context,
                                    user,
                                    headers,
                                    backgroundImage,
                                  ),
                                )
                                : _buildBusinessCardFront(
                                  context,
                                  user,
                                  headers,
                                  backgroundImage,
                                ),
                          );
                        },
                      ),
                    ),
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

  // 表面
  Widget _buildBusinessCardFront(
    BuildContext context,
    user,
    Map<String, String> headers,
    File? backgroundImage, // ← 使わない
  ) {
    return Container(
      width: 340,
      height: 480,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
                width: 1.8,
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.10),
                  Colors.blueGrey.withOpacity(0.18),
                  Colors.teal.withOpacity(0.13),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // カード内容（下部に横並びで配置）
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 32,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 36,
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
                      const SizedBox(width: 18),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user.displayName,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '@${user.username}',
                            style: GoogleFonts.notoSans(
                              fontSize: 14,
                              color: Colors.white70,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

      ),
    );
  }

  // 裏面
  Widget _buildBusinessCardBack(
    BuildContext context,
    user,
    Map<String, String> headers,
    File? backgroundImage, // ← 使わない
  ) {
    return Container(
      width: 340,
      height: 480,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
                width: 1.8,
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.10),
                  Colors.blueGrey.withOpacity(0.18),
                  Colors.teal.withOpacity(0.13),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    QrImageView(
                      data: 'vrcn_user:${user.id}',
                      version: QrVersions.auto,
                      size: 160.0,
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      user.displayName,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${user.username}',
                      style: GoogleFonts.notoSans(
                        fontSize: 13,
                        color: Colors.white70,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'User ID: ${user.id}',
                      style: GoogleFonts.notoSans(
                        fontSize: 11,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Status: ${user.status ?? "Unknown"}',
                      style: GoogleFonts.notoSans(
                        fontSize: 11,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
