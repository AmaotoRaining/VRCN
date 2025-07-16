import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vrchat/utils/cache_manager.dart';

class DownloadUtils {
  static Future<void> downloadFile({
    required BuildContext context,
    required String url,
    required String fileName,
    required Map<String, String> headers,
  }) async {
    try {
      // Android 13以上では権限不要、それ以下では権限チェック
      if (Platform.isAndroid) {
        final androidInfo = await _getAndroidInfo();
        if (androidInfo.version.sdkInt < 33) {
          final permission = await Permission.storage.request();
          if (!permission.isGranted) {
            _showErrorSnackBar(context, 'ストレージへのアクセス権限が必要です');
            return;
          }
        }
      }

      // ダウンロード進行状況を表示
      _showDownloadDialog(context, fileName);

      // キャッシュから取得を試行
      final cachedFile = await JsonCacheManager().getFileFromCache(url);
      Uint8List? fileBytes;

      if (cachedFile != null) {
        fileBytes = await cachedFile.file.readAsBytes();
      } else {
        // キャッシュにない場合はダウンロード
        final dio = Dio();
        final response = await dio.get(
          url,
          options: Options(headers: headers, responseType: ResponseType.bytes),
        );
        fileBytes = Uint8List.fromList(response.data);
      }

      // ファイルを保存
      await _saveFile(fileBytes, fileName);

      if (context.mounted) {
        Navigator.of(context).pop(); // ダウンロードダイアログを閉じる
        _showSuccessSnackBar(context, 'ダウンロードが完了しました');
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // ダウンロードダイアログを閉じる
        _showErrorSnackBar(context, 'ダウンロードに失敗しました: $e');
      }
    }
  }

  static Future<void> shareFile({
    required BuildContext context,
    required String url,
    required String fileName,
    required Map<String, String> headers,
  }) async {
    try {
      _showDownloadDialog(context, fileName, isShare: true);

      // キャッシュから取得を試行
      final cachedFile = await JsonCacheManager().getFileFromCache(url);
      File? fileToShare;

      if (cachedFile != null) {
        fileToShare = cachedFile.file;
      } else {
        // キャッシュにない場合は一時ファイルとしてダウンロード
        final dio = Dio();
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$fileName');

        await dio.download(
          url,
          tempFile.path,
          options: Options(headers: headers),
        );
        fileToShare = tempFile;
      }

      if (context.mounted) {
        Navigator.of(context).pop(); // ダウンロードダイアログを閉じる
        await Share.shareXFiles([XFile(fileToShare.path)], text: fileName);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // ダウンロードダイアログを閉じる
        _showErrorSnackBar(context, '共有に失敗しました: $e');
      }
    }
  }

  static Future<void> _saveFile(Uint8List fileBytes, String fileName) async {
    if (Platform.isAndroid) {
      // Android: Downloads フォルダに保存
      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (await downloadsDir.exists()) {
        final file = File('${downloadsDir.path}/$fileName');
        await file.writeAsBytes(fileBytes);
      } else {
        // フォールバック: アプリのディレクトリに保存
        final appDir = await getExternalStorageDirectory();
        final file = File('${appDir!.path}/$fileName');
        await file.writeAsBytes(fileBytes);
      }
    } else if (Platform.isIOS) {
      // iOS: Documents フォルダに保存
      final documentsDir = await getApplicationDocumentsDirectory();
      final file = File('${documentsDir.path}/$fileName');
      await file.writeAsBytes(fileBytes);
    }
  }

  static void _showDownloadDialog(
    BuildContext context,
    String fileName, {
    bool isShare = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  isShare ? '$fileName を共有準備中...' : '$fileName をダウンロード中...',
                  style: GoogleFonts.notoSans(),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
    );
  }

  static void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(message, style: GoogleFonts.notoSans()),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: GoogleFonts.notoSans())),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static Future<dynamic> _getAndroidInfo() async {
    // device_info_plus パッケージを使用してAndroid情報を取得
    // この部分は実際の実装では device_info_plus を使用してください
    return {
      'version': {'sdkInt': 33},
    }; // ダミーデータ
  }

  static String getFileExtension(String url) {
    if (url.contains('.png')) return '.png';
    if (url.contains('.jpg') || url.contains('.jpeg')) return '.jpg';
    if (url.contains('.gif')) return '.gif';
    if (url.contains('.webp')) return '.webp';
    return '.png'; // デフォルト
  }
}
