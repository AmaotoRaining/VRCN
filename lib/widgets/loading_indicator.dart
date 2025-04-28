import 'dart:math' as math;

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
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _opacityAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // テーマカラーの取得
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[850] : Colors.grey[100];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // アニメーション付きのローディングインジケーター
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // 回転する外側の円
                  Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            primaryColor.withValues(alpha:0.0),
                            primaryColor.withValues(alpha:0.8),
                          ],
                          stops: const [0.7, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // 内側の円
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha:0.3),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.people_alt_rounded,
                        color: primaryColor,
                        size: 30,
                      ),
                    ),
                  ),
                  // ドットのアニメーション
                  ...List.generate(8, (index) {
                    final angle = (index / 8) * 2 * math.pi;
                    final delay = index / 8;
                    final delayedAnimation = _controller.value - delay;
                    final adjustedValue =
                        delayedAnimation < 0
                            ? 1.0 + delayedAnimation
                            : delayedAnimation;
                    final pulsatingValue = math.sin(adjustedValue * math.pi);

                    return Positioned(
                      left: 40 + 45 * math.cos(angle),
                      top: 40 + 45 * math.sin(angle),
                      child: Opacity(
                        opacity: pulsatingValue.clamp(0.2, 1.0),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          ),

          const SizedBox(height: 32),

          // 脈打つメッセージ
          AnimatedBuilder(
            animation: _opacityAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimation.value,
                child: Text(
                  widget.message,
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // 小さなドットインジケーター
          SizedBox(
            width: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final delay = index * 0.3;
                    final delayedValue = (_controller.value + delay) % 1.0;
                    final bounceValue = math.sin(delayedValue * math.pi);

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 8,
                      height: 8 + (bounceValue * 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha:
                          0.6 + bounceValue * 0.4,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
