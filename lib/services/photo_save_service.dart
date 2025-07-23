import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoSaveService {
  static const albumName = 'VRCN';

  /// 写真をVRCNアルバムに保存
  static Future<bool> saveToVRCNAlbum(File imageFile) async {
    try {
      // 権限をチェック
      final hasPermission = await _checkPermissions();
      if (!hasPermission) {
        debugPrint('写真保存権限がありません');
        return false;
      }

      // ファイルが存在するかチェック
      if (!await imageFile.exists()) {
        debugPrint('保存しようとしたファイルが存在しません: ${imageFile.path}');
        return false;
      }

      // galパッケージを使用してアルバムに保存
      await Gal.putImage(imageFile.path, album: albumName);

      debugPrint('写真をVRCNアルバムに保存しました: ${imageFile.path}');
      return true;
    } catch (e) {
      debugPrint('写真保存エラー: $e');
      return false;
    }
  }

  /// 一時的な受信ファイルをVRCNアルバムに保存してから削除
  static Future<bool> saveReceivedPhotoToAlbum(File tempFile) async {
    try {
      final success = await saveToVRCNAlbum(tempFile);

      if (success) {
        // アルバムに保存成功したら一時ファイルを削除
        try {
          if (await tempFile.exists()) {
            await tempFile.delete();
            debugPrint('一時ファイルを削除しました: ${tempFile.path}');
          }
        } catch (e) {
          debugPrint('一時ファイル削除エラー: $e');
          // 一時ファイル削除に失敗してもアルバム保存は成功
        }
      }

      return success;
    } catch (e) {
      debugPrint('受信写真のアルバム保存エラー: $e');
      return false;
    }
  }

  /// 写真保存に必要な権限をチェック・リクエスト
  static Future<bool> _checkPermissions() async {
    try {
      if (Platform.isAndroid) {
        // Android 13以降
        final deviceVersion = Platform.version;
        if (deviceVersion.contains('API 33') ||
            deviceVersion.contains('API 34')) {
          // Android 13以降では特定の写真権限
          final status = await Permission.photos.request();
          return status.isGranted;
        } else {
          // Android 12以前
          final status = await Permission.storage.request();
          return status.isGranted;
        }
      } else if (Platform.isIOS) {
        // iOSでは写真ライブラリ追加権限
        final status = await Permission.photosAddOnly.request();
        return status.isGranted || status.isLimited;
      }
      return false;
    } catch (e) {
      debugPrint('権限チェックエラー: $e');
      return false;
    }
  }

  /// フォトアプリを開く
  static Future<void> openPhotoApp() async {
    try {
      await Gal.open();
      debugPrint('フォトアプリを開きました');
    } catch (e) {
      debugPrint('フォトアプリを開けませんでした: $e');
      throw Exception('フォトアプリを開けませんでした');
    }
  }
}
