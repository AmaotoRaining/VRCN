import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  final Color? color;

  const AppBackButton({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios_rounded, color: color ?? Colors.white),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
