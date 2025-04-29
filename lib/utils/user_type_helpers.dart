import 'package:flutter/material.dart';

/// VRChatのユーザータイプに関するヘルパー関数を提供するクラス
class UserTypeHelper {
  // インスタンス化を防止
  UserTypeHelper._();

  /// ユーザータグからユーザータイプを判定
  static String getUserTypeText(List<String>? tags) {
    if (tags == null) return 'Visitor';

    if (tags.contains('admin')) return 'Admin';
    if (tags.contains('system_trust_veteran')) return 'Trusted User';
    if (tags.contains('system_trust_trusted')) return 'Known User';
    if (tags.contains('system_trust_known')) return 'User';
    if (tags.contains('system_trust_basic')) return 'New User';

    return 'Visitor';
  }

  /// ユーザータグに基づいて色を返す
  static Color getUserTypeColor(List<String>? tags) {
    if (tags == null) return Colors.grey;

    if (tags.contains('admin')) return Colors.red;
    if (tags.contains('system_trust_veteran')) {
      return Colors.deepPurpleAccent; // Trusted
    }
    if (tags.contains('system_trust_trusted')) return Colors.orange; // Known
    if (tags.contains('system_trust_known')) return Colors.green; // User
    if (tags.contains('system_trust_basic')) return Colors.blue; // New User

    return Colors.grey; // Visitor
  }
}

extension UserTagsExtension on List<String>? {
  /// ユーザータイプのテキスト表現を取得
  String get userTypeText => UserTypeHelper.getUserTypeText(this);

  /// ユーザータイプの色を取得
  Color get userTypeColor => UserTypeHelper.getUserTypeColor(this);
}
