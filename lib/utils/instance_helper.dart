import 'package:flutter/material.dart';

class InstanceHelper {
  static IconData getInstanceTypeIcon(String? type) {
    if (type == null) return Icons.question_mark;

    if (type.contains('public')) {
      return Icons.public;
    } else if (type.contains('hidden') || type.contains('friends+')) {
      return Icons.people;
    } else if (type.contains('friends')) {
      return Icons.person_add;
    } else if (type.contains('invite+')) {
      return Icons.lock_open;
    } else if (type.contains('invite') || type.contains('private')) {
      return Icons.lock;
    } else {
      return Icons.question_mark;
    }
  }

  static Color getInstanceTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'public':
        return Colors.green;
      case 'friends':
      case 'hidden':
        return Colors.orange;
      case 'private':
        return Colors.redAccent;
      default:
        return Colors.blue;
    }
  }

  static String getInstanceTypeText(String? type) {
    switch (type?.toLowerCase()) {
      case 'public':
        return 'パプリック';
      case 'hidden':
        return 'フレンド+';
      case 'friends':
        return 'フレンド';
      case 'private':
        return 'インバイト+';
      default:
        return type ?? '不明';
    }
  }

  static String regionEmoji(String region) {
    switch (region.toLowerCase()) {
      case 'us':
        return '🇺🇸';
      case 'use':
        return '🇺🇸';
      case 'eu':
        return '🇪🇺';
      case 'jp':
        return '🇯🇵';
      default:
        return '';
    }
  }
}
