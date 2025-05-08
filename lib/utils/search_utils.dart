class SearchUtils {
  // 数字をフォーマットするヘルパーメソッド (1000 → 1K)
  static String formatNumber(int number) {
    if (number < 1000) return number.toString();
    if (number < 1000000) return '${(number / 1000).toStringAsFixed(1)}K';
    return '${(number / 1000000).toStringAsFixed(1)}M';
  }

  // タグをフォーマットするヘルパーメソッド
  static String formatTag(String tag) {
    // system_*の部分を削除
    if (tag.startsWith('system_')) {
      tag = tag.substring(7);
    }

    // アンダースコアをスペースに置換して先頭を大文字に
    final words = tag
        .split('_')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');

    return words;
  }
}
