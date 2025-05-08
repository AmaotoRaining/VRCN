import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:vrchat/models/avtrdb_search_result.dart';

final avtrDbSearchProvider = FutureProvider.family<
  List<AvtrDbSearchResult>,
  String
>((ref, query) async {
  if (query.isEmpty) {
    return [];
  }

  final encodedQuery = Uri.encodeComponent(query);
  final url = Uri.parse(
    'https://api.avtrdb.com/v2/avatar/search/vrcx?search=$encodedQuery&n=5000',
  );

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
      return jsonList.map((json) => AvtrDbSearchResult.fromJson(json)).toList();
    } else {
      debugPrint('アバター検索APIエラー: ${response.statusCode}');
      throw Exception('アバター検索に失敗しました: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('アバター検索例外: $e');
    throw Exception('アバター検索中にエラーが発生しました: $e');
  }
});
