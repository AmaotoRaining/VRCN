import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBox(context, isDarkMode),
            const SizedBox(height: 16),
            Expanded(child: _buildSearchPlaceholder(context, isDarkMode)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'ユーザー、ワールド、アバターを検索',
          prefixIcon: Icon(
            Icons.search,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
          filled: true,
          fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
        ),
        style: GoogleFonts.notoSans(fontSize: 16),
        // TODO: 検索機能の実装
        onChanged: (value) {
          // 検索クエリの処理
        },
      ),
    );
  }

  Widget _buildSearchPlaceholder(BuildContext context, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: isDarkMode ? Colors.grey[700] : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'VRChatを検索',
            style: GoogleFonts.notoSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ユーザー、ワールド、アバターなどを\n検索して見つけることができます',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
