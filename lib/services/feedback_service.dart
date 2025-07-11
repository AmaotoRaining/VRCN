import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

final feedbackServiceProvider = Provider<FeedbackService>((ref) {
  return FeedbackService(ref);
});

class FeedbackService {
  final Ref ref;

  // Discord Webhook URLを直接定義
  static const _webhookUrl = 'https://canary.discord.com/api/webhooks/1393323914767106220/npDoNdq4BxpNiv6NzvVOG3Z6WC__zEUDSG3_fmGqH7ehblvxvQgcsslECNnYgsuub7N_';

  FeedbackService(this.ref);

  Future<bool> sendFeedback({
    required String type,
    required String title,
    required String description,
    String? additionalInfo,
  }) async {
    try {
      // アプリ情報を取得
      final packageInfo = await PackageInfo.fromPlatform();

      // Discord Embedを作成
      final embed = {
        'title': '🎯 新しいフィードバック: $title',
        'description': description,
        'color': _getColorForType(type),
        'timestamp': DateTime.now().toIso8601String(),
        'fields': [
          {'name': '📋 フィードバックタイプ', 'value': type, 'inline': true},
          {
            'name': '📱 アプリバージョン',
            'value': '${packageInfo.version} (${packageInfo.buildNumber})',
            'inline': true,
          },
          {
            'name': '🖥️ プラットフォーム',
            'value': defaultTargetPlatform.name,
            'inline': true,
          },
          if (additionalInfo != null && additionalInfo.isNotEmpty)
            {'name': '📝 追加情報', 'value': additionalInfo, 'inline': false},
        ],
        'footer': {'text': 'VRCN Feedback System'},
      };

      final payload = {
        'embeds': [embed],
        'username': 'VRCN Feedback Bot',
      };

      final response = await http.post(
        Uri.parse(_webhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 204) {
        debugPrint('フィードバック送信成功');
        return true;
      } else {
        debugPrint('フィードバック送信失敗: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('フィードバック送信エラー: $e');
      return false;
    }
  }

  int _getColorForType(String type) {
    switch (type) {
      case 'バグ報告':
        return 0xFF0000; // 赤
      case '機能要望':
        return 0x00FF00; // 緑
      case '改善提案':
        return 0x0099FF; // 青
      case 'その他':
        return 0xFFFF00; // 黄
      default:
        return 0x808080; // グレー
    }
  }
}
