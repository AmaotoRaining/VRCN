import 'package:flutter/material.dart';

extension ColorsExtension on Color {
  Color withValues({double? red, double? green, double? blue, double? alpha}) {
    return Color.fromRGBO(
      red != null ? (red * 255).round() : this.red,
      green != null ? (green * 255).round() : this.green,
      blue != null ? (blue * 255).round() : this.blue,
      alpha ?? opacity,
    );
  }
}
