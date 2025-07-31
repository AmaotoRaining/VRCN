import 'dart:convert';
import 'dart:io';

import 'package:apple_product_name/apple_product_name.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vrchat/config/app_config.dart';

final feedbackServiceProvider = Provider<FeedbackService>((ref) {
  return FeedbackService(ref);
});

@immutable
class FeedbackService {
  final Ref ref;

  const FeedbackService(this.ref);

  Future<bool> sendFeedback({
    required String type,
    required String title,
    required String description,
    String? additionalInfo,
  }) async {
    try {
      // アプリ情報を取得
      final packageInfo = await PackageInfo.fromPlatform();
      // デバイス情報を取得
      final deviceInfo = await _getPlatformInfo();

      // Discord Embedを作成
      final embed = {
        'title': '🎯 新しいフィードバック: $title',
        'description': description,
        'color': _getColorForType(type),
        'timestamp': DateTime.timestamp().toIso8601String(),
        'fields': [
          {'name': '📋 フィードバックタイプ', 'value': type, 'inline': true},
          {
            'name': '📱 アプリバージョン',
            'value': '${packageInfo.version} (${packageInfo.buildNumber})',
            'inline': false,
          },
          {'name': '🖥️ プラットフォーム', 'value': deviceInfo, 'inline': true},
          if (additionalInfo != null && additionalInfo.isNotEmpty)
            {'name': '📝 追加情報', 'value': additionalInfo, 'inline': false},
        ],
      };

      final payload = {
        'embeds': [embed],
      };

      final response = await http.post(
        Uri.parse(AppConfig.discordWebhookUrl),
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

  Future<String> _getPlatformInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return 'OS: Android ${androidInfo.version.release}\n'
            '端末: ${androidInfo.model}\n';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return 'OS: iOS ${iosInfo.systemVersion}\n'
            '端末: ${iosInfo.utsname.productName}\n';
      } else {
        return 'OS: ${defaultTargetPlatform.name}\n'
            'バージョン: ${Platform.operatingSystemVersion}';
      }
    } catch (e) {
      return '${defaultTargetPlatform.name}\n'
          'プラットフォーム情報取得エラー: ${e.toString()}';
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
