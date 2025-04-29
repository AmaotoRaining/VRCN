import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingIndicator extends StatefulWidget {
  final String message;

  const LoadingIndicator({super.key, this.message = '読み込み中...'});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showFirstImage = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    // アニメーション完了時に画像を切り替え
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showFirstImage = !_showFirstImage;
        });
        _controller.reset();
        _controller.forward();
      }
    });

    // アニメーションを開始
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // キャラクターのアニメーション部分
          Stack(
            alignment: Alignment.center,
            children: [
              // 影のエフェクト
              Positioned(
                bottom: 10,
                child: Container(
                  width: 60,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),

              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: .1),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Image.asset(
                  _showFirstImage
                      ? "assets/images/anomea_walk.png"
                      : "assets/images/anomea_walk2.png",
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // メッセージテキスト
          Text(
            widget.message,
            style: GoogleFonts.notoSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: primaryColor,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // プログレスインジケーター
          SizedBox(
            width: 180,
            child: LinearProgressIndicator(
              backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}
