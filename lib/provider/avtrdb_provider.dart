import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:vrchat/models/avtrdb_search_result.dart';
import 'package:vrchat/provider/settings_provider.dart';

final avtrDbSearchProvider =
    FutureProvider.family<List<AvtrDbSearchResult>, String>((ref, query) async {
      if (query.isEmpty) {
        return [];
      }

      // 設定からAPIのURLを取得
      final settings = ref.watch(settingsProvider);
      final baseUrl = settings.avatarSearchApiUrl;

      // ユーザーが URL を設定していない場合はエラーを返す
      if (baseUrl.isEmpty) {
        throw Exception('アバター検索APIのURLが設定されていません。設定画面から入力してください。');
      }

      final encodedQuery = Uri.encodeComponent(query);
      final url = Uri.parse('$baseUrl?search=$encodedQuery&n=5000');

      try {
        final response = await http.get(
          url,
          headers: {
            'Accept': 'application/json; charset=utf-8',
            'Accept-Charset': 'utf-8',
          },
        );

        if (response.statusCode == 200) {
          final decodedResponse = utf8.decode(response.bodyBytes);
          final List<dynamic> jsonList = jsonDecode(decodedResponse);
          return jsonList
              .map((json) => AvtrDbSearchResult.fromJson(json))
              .toList();
        } else {
          debugPrint('アバター検索APIエラー: ${response.statusCode}');
          throw Exception('アバター検索に失敗しました: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint('アバター検索例外: $e');
        throw Exception('アバター検索中にエラーが発生しました: $e');
      }
    });
