import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrchat/provider/settings_provider.dart';
import 'package:vrchat/theme/app_theme.dart';
import 'package:vrchat/widgets/error_container.dart';
import 'package:vrchat/widgets/loading_indicator.dart';

// イベントデータを取得するためのプロバイダー
final eventDataProvider = FutureProvider<EventData>((ref) async {
  final response = await http.get(Uri.parse('https://vrceve.poly.jp/events'));
  if (response.statusCode == 200) {
    return EventData.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('イベントデータの取得に失敗しました');
  }
});

// イベントデータモデル
@immutable
class EventData {
  final Map<String, int> genres;
  final List<Event> events;

  const EventData({required this.genres, required this.events});

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      genres: Map<String, int>.from(json['genres'] ?? {}),
      events:
          (json['events'] as List? ?? [])
              .map((event) => Event.fromJson(event))
              .toList(),
    );
  }
}

// イベントモデル
@immutable
class Event {
  final String id;
  final bool quest;
  final String title;
  final DateTime start;
  final DateTime end;
  final String author;
  final String body;
  final List<String> genres;
  final String condition;
  final String way;
  final String note;

  const Event({
    required this.id,
    required this.quest,
    required this.title,
    required this.start,
    required this.end,
    required this.author,
    required this.body,
    required this.genres,
    required this.condition,
    required this.way,
    required this.note,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      quest: json['quest'] ?? false,
      title: json['title'] ?? '',
      start: DateTime.parse(
        json['start'] ?? DateTime.timestamp().toIso8601String(),
      ),
      end: DateTime.parse(
        json['end'] ?? DateTime.timestamp().toIso8601String(),
      ),
      author: json['author'] ?? '',
      body: json['body'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),
      condition: json['condition'] ?? '',
      way: json['way'] ?? '',
      note: json['note'] ?? '',
    );
  }
}

class EventCalendarPage extends ConsumerStatefulWidget {
  const EventCalendarPage({super.key});

  @override
  ConsumerState<EventCalendarPage> createState() => _EventCalendarPageState();
}

class _EventCalendarPageState extends ConsumerState<EventCalendarPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  var _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // 日本語ロケールを初期化
    initializeDateFormatting('ja', null);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // リフレッシュアクション
  Future<void> _refreshEvents() async {
    setState(() {
      _isRefreshing = true;
    });

    // アニメーションを開始
    await _animationController.forward(from: 0);

    // データをリフレッシュ
    final _ = ref.refresh(eventDataProvider);

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventDataAsync = ref.watch(eventDataProvider);
    final isDarkMode = ref.watch(themeModeProvider) == ThemeMode.dark;

    // 背景グラデーション
    final backgroundColor =
        isDarkMode ? const Color(0xFF121212) : const Color(0xFFF9F9F9);

    const accentColor = AppTheme.primaryColor;
    final secondaryColor =
        isDarkMode
            ? HSLColor.fromColor(accentColor).withLightness(0.3).toColor()
            : HSLColor.fromColor(accentColor).withLightness(0.8).toColor();

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'イベントカレンダー',
          style: GoogleFonts.notoSans(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color:
                    isDarkMode
                        ? Colors.black.withValues(alpha: .2)
                        : Colors.white.withValues(alpha: 0.8),
                border: Border(
                  bottom: BorderSide(
                    color:
                        isDarkMode
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.05),
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [
          // リフレッシュボタン
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animationController.value * 2 * 3.14159,
                child: IconButton(
                  icon: Icon(
                    Icons.refresh_rounded,
                    color:
                        _isRefreshing
                            ? accentColor
                            : isDarkMode
                            ? Colors.white
                            : Colors.black87,
                  ),
                  onPressed: _isRefreshing ? null : _refreshEvents,
                ),
              );
            },
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backgroundColor,
              isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: eventDataAsync.when(
            data:
                (eventData) => _buildEventList(
                  context,
                  eventData,
                  isDarkMode,
                  accentColor,
                  secondaryColor,
                ),
            loading: () => const LoadingIndicator(message: 'イベント情報を取得中...'),
            error:
                (error, stack) => ErrorContainer(
                  message: 'イベント情報の取得に失敗しました: $error',
                  onRetry: _refreshEvents,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventList(
    BuildContext context,
    EventData eventData,
    bool isDarkMode,
    Color accentColor,
    Color secondaryColor,
  ) {
    // イベントを日付ごとにグループ化
    final eventsByDate = <String, List<Event>>{};
    final dateFormat = DateFormat('yyyy-MM-dd');

    for (final event in eventData.events) {
      final dateKey = dateFormat.format(event.start);
      if (!eventsByDate.containsKey(dateKey)) {
        eventsByDate[dateKey] = [];
      }
      eventsByDate[dateKey]!.add(event);
    }

    // 日付でソート
    final sortedDates = eventsByDate.keys.toList()..sort();

    return Column(
      children: [
        _buildGenreSummary(eventData.genres, isDarkMode, accentColor)
            .animate()
            .fadeIn(duration: const Duration(milliseconds: 600))
            .slideY(begin: -0.2, end: 0, curve: Curves.easeOutQuad),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              final dateKey = sortedDates[index];
              final events = eventsByDate[dateKey]!;

              // 日付ごとのイベントを時間順にソート
              events.sort((a, b) => a.start.compareTo(b.start));

              return _buildDateSection(
                context,
                dateKey,
                events,
                isDarkMode,
                accentColor,
                secondaryColor,
                index,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGenreSummary(
    Map<String, int> genres,
    bool isDarkMode,
    Color accentColor,
  ) {
    final sortedGenres =
        genres.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black.withValues(alpha: 0.3) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color:
              isDarkMode
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Icon(Icons.bar_chart_rounded, color: accentColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'ジャンル別イベント数',
                  style: GoogleFonts.notoSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                sortedGenres.take(10).map((entry) {
                  // ジャンルごとに異なる色を割り当てる
                  final color = _getGenreColor(
                    entry.key,
                    accentColor,
                    isDarkMode,
                  );

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: isDarkMode ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: color.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          entry.key,
                          style: GoogleFonts.notoSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color:
                                isDarkMode
                                    ? color.withValues(alpha: 0.9)
                                    : color,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${entry.value}',
                            style: GoogleFonts.notoSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color:
                                  isDarkMode
                                      ? color.withValues(alpha: 0.9)
                                      : color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(
    BuildContext context,
    String dateKey,
    List<Event> events,
    bool isDarkMode,
    Color accentColor,
    Color secondaryColor,
    int index,
  ) {
    // 日付をフォーマット
    final date = DateFormat('yyyy-MM-dd').parse(dateKey);
    final now = DateTime.timestamp();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    final displayDate = DateFormat('yyyy年MM月dd日 (E)', 'ja').format(date);

    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color:
                isDarkMode ? Colors.black.withValues(alpha: 0.3) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color:
                  isToday
                      ? accentColor.withValues(alpha: isDarkMode ? 0.5 : 0.3)
                      : isDarkMode
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.2),
              width: isToday ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              // 日付ヘッダー
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:
                        isToday
                            ? [
                              accentColor.withValues(alpha: 0.8),
                              accentColor.withValues(alpha: 0.6),
                            ]
                            : isDarkMode
                            ? [
                              Colors.grey[850]!.withValues(alpha: 0.5),
                              Colors.grey[900]!.withValues(alpha: 0.5),
                            ]
                            : [
                              secondaryColor.withValues(alpha: 0.3),
                              secondaryColor.withValues(alpha: 0.1),
                            ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isToday ? Icons.calendar_today : Icons.calendar_month,
                      size: 18,
                      color:
                          isToday
                              ? (isDarkMode ? Colors.white : accentColor)
                              : (isDarkMode
                                  ? Colors.grey[300]
                                  : Colors.grey[700]),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      displayDate,
                      style: GoogleFonts.notoSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color:
                            isToday
                                ? (isDarkMode ? Colors.white : accentColor)
                                : (isDarkMode ? Colors.white : Colors.black87),
                      ),
                    ),
                    if (isToday) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '今日',
                          style: GoogleFonts.notoSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: isDarkMode ? Colors.white : accentColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // イベントリスト
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: events.length,
                itemBuilder: (context, eventIndex) {
                  return _buildEventCard(
                        context,
                        events[eventIndex],
                        isDarkMode,
                        accentColor,
                        eventIndex,
                      )
                      .animate()
                      .fadeIn(
                        delay: Duration(milliseconds: 100 * eventIndex),
                        duration: const Duration(milliseconds: 500),
                      )
                      .slideX(
                        begin: 0.1,
                        end: 0,
                        curve: Curves.easeOutQuad,
                        delay: Duration(milliseconds: 100 * eventIndex),
                      );
                },
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 150 * index),
          duration: const Duration(milliseconds: 800),
        )
        .slideY(
          begin: 0.1,
          end: 0,
          curve: Curves.easeOutQuad,
          delay: Duration(milliseconds: 150 * index),
        );
  }

  Widget _buildEventCard(
    BuildContext context,
    Event event,
    bool isDarkMode,
    Color accentColor,
    int index,
  ) {
    // 時間をフォーマット
    final startTime = DateFormat('HH:mm').format(event.start);
    final endTime = DateFormat('HH:mm').format(event.end);

    // イベントの種類に基づいて色を選択
    final eventColor =
        event.genres.isNotEmpty
            ? _getGenreColor(event.genres.first, accentColor, isDarkMode)
            : accentColor;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color:
              isDarkMode
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      color: isDarkMode ? Colors.black.withValues(alpha: 0.2) : Colors.white,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.all(0),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: Text(
          event.title,
          style: GoogleFonts.notoSans(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 14,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                '$startTime〜$endTime',
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
              const SizedBox(width: 12),
              if (event.quest) _buildQuestBadge(isDarkMode),
            ],
          ),
        ),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                eventColor.withValues(alpha: 0.8),
                eventColor.withValues(alpha: 0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: eventColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              startTime,
              style: GoogleFonts.notoSans(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 区切り線
                Container(
                  height: 1,
                  color:
                      isDarkMode
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                  margin: const EdgeInsets.only(bottom: 16),
                ),

                _buildInfoSection(
                  '主催者',
                  event.author,
                  Icons.person_outline_rounded,
                  isDarkMode,
                  eventColor,
                ),
                const SizedBox(height: 16),

                _buildInfoSection(
                  '説明',
                  event.body,
                  Icons.description_outlined,
                  isDarkMode,
                  eventColor,
                ),
                const SizedBox(height: 16),

                _buildGenreChips(event.genres, isDarkMode, eventColor),
                const SizedBox(height: 16),

                _buildInfoSection(
                  '参加条件',
                  event.condition,
                  Icons.verified_user_outlined,
                  isDarkMode,
                  eventColor,
                ),
                const SizedBox(height: 16),

                _buildInfoSection(
                  '参加方法',
                  event.way,
                  Icons.login_rounded,
                  isDarkMode,
                  eventColor,
                ),

                if (event.note.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildInfoWithLink(
                    '備考',
                    event.note,
                    Icons.sticky_note_2_outlined,
                    isDarkMode,
                    eventColor,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestBadge(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: isDarkMode ? 0.3 : 0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.green.withValues(alpha: isDarkMode ? 0.5 : 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.headset_rounded,
            size: 10,
            color: isDarkMode ? Colors.green[300] : Colors.green[700],
          ),
          const SizedBox(width: 3),
          Text(
            'Quest対応',
            style: GoogleFonts.notoSans(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.green[300] : Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    String title,
    String content,
    IconData icon,
    bool isDarkMode,
    Color accentColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: accentColor.withValues(alpha: isDarkMode ? 0.8 : 1.0),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.notoSans(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            content,
            style: GoogleFonts.notoSans(
              fontSize: 14,
              height: 1.5,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoWithLink(
    String title,
    String content,
    IconData icon,
    bool isDarkMode,
    Color accentColor,
  ) {
    // URLを検出する正規表現
    final urlRegExp = RegExp(r'https?://[^\s]+', caseSensitive: false);

    final matches = urlRegExp.allMatches(content);
    if (matches.isEmpty) {
      return _buildInfoSection(title, content, icon, isDarkMode, accentColor);
    }

    // URLを含むテキストをリッチテキストに変換
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: accentColor.withValues(alpha: isDarkMode ? 0.8 : 1.0),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.notoSans(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: GestureDetector(
            onTap: () {
              final url = matches.first.group(0);
              if (url != null) {
                _launchUrl(url);
              }
            },
            child: Text(
              content,
              style: GoogleFonts.notoSans(
                fontSize: 14,
                height: 1.5,
                color: Colors.blue[400],
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenreChips(
    List<String> genres,
    bool isDarkMode,
    Color baseColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.category_outlined,
              size: 16,
              color: baseColor.withValues(alpha: isDarkMode ? 0.8 : 1.0),
            ),
            const SizedBox(width: 8),
            Text(
              'ジャンル',
              style: GoogleFonts.notoSans(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                genres.map((genre) {
                  final color = _getGenreColor(genre, baseColor, isDarkMode);

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: isDarkMode ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: color.withValues(alpha: isDarkMode ? 0.4 : 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      genre,
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color:
                            isDarkMode ? color.withValues(alpha: 0.9) : color,
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  // ジャンル名から色を取得するヘルパーメソッド
  Color _getGenreColor(String genre, Color defaultColor, bool isDarkMode) {
    final genreColors = <String, MaterialColor>{
      'トーク': Colors.blue,
      'ゲーム': Colors.green,
      'ライブ': Colors.purple,
      'お祭り': Colors.orange,
      'クラブ': Colors.pink,
      'アート': Colors.teal,
      'レース': Colors.red,
      'セミナー': Colors.indigo,
      '初心者歓迎': Colors.cyan,
      'フリー': Colors.amber,
      'お酒': Colors.deepOrange,
      '音楽': Colors.deepPurple,
      'アニメ': Colors.lightBlue,
      'ビジネス': Colors.blueGrey,
      'コスプレ': Colors.lightGreen,
    };

    // ジャンル名に部分一致する色を探す
    for (final entry in genreColors.entries) {
      if (genre.contains(entry.key)) {
        return isDarkMode ? entry.value[300]! : entry.value[600]!;
      }
    }

    // マッチしない場合はハッシュ値をもとに色を生成
    final hash = genre.hashCode.abs() % 5;
    final fallbackColors = <Color>[
      Colors.blue[isDarkMode ? 300 : 600]!,
      Colors.purple[isDarkMode ? 300 : 600]!,
      Colors.orange[isDarkMode ? 300 : 600]!,
      Colors.teal[isDarkMode ? 300 : 600]!,
      Colors.pink[isDarkMode ? 300 : 600]!,
    ];

    return fallbackColors[hash];
  }

  void _launchUrl(String urlString) async {
    final url = Uri.tryParse(urlString);
    if (url != null) {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    }
  }
}
