import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherUtils {
  UrlLauncherUtils._();

  static Future<bool> launchURL(
    String urlString, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    try {
      final url = Uri.parse(urlString);

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: mode);
        return true;
      } else {
        debugPrint('URLを開けませんでした: $urlString');
        return false;
      }
    } catch (e) {
      debugPrint('URL起動エラー: $e');
      return false;
    }
  }
}
