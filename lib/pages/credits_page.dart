import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? const Color(0xFF151515) : const Color(0xFFF7F9FA);
    final accentColor =
        isDarkMode ? const Color(0xFF4CAF50) : const Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'クレジット',
          style: GoogleFonts.notoSans(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 装飾的な背景要素
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withValues(alpha: 0.08),
              ),
            ),
          ),
          // クレジットリスト
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 20),
                _buildCreditSection(
                  context: context,
                  title: '開発',
                  credits: [
                    CreditItem(
                      name: 'null_base',
                      role: 'merry bad end',
                      icon: const CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/images/default.png',
                        ),
                      ),
                      onTap: () {
                        context.push(
                          '/user/usr_1d67de93-8afb-48dc-af7d-da7a33834f52',
                        );
                      },
                    ),
                  ],
                  isDarkMode: isDarkMode,
                  delay: 0,
                ),
                const SizedBox(height: 24),
                _buildCreditSection(
                  context: context,
                  title: '愉快なアイコン',
                  credits: [
                    CreditItem(
                      name: 'annobu',
                      role: '店長',
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('assets/images/annobu@3x.png'),
                      ),
                    ),
                    CreditItem(
                      name: 'kazkiller',
                      role: 'キチ顔',
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('assets/images/kazkiller@3x.png'),
                      ),
                    ),
                    CreditItem(
                      name: 'Miyamoto_',
                      role: 'いびき💤',
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('assets/images/miyamoto@3x.png'),
                      ),
                    ),
                    CreditItem(
                      name: 'Le0yuki',
                      role: 'ピアス',
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('assets/images/le0yuki@3x.png'),
                      ),
                    ),
                    CreditItem(
                      name: 'Ray',
                      role: '能面',
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('assets/images/ray@3x.png'),
                      ),
                    ),
                    CreditItem(
                      name: 'Hare',
                      role: 'Abysswalker',
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('assets/images/hare@3x.png'),
                      ),
                    ),
                    CreditItem(
                      name: '愛が一番アイフル',
                      role: 'ペアマッチング公式',
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('assets/images/aihuru@3x.png'),
                      ),
                    ),
                    CreditItem(
                      name: 'Rea',
                      role: 'ここはひとつ',
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('assets/images/rea@3x.png'),
                      ),
                    ),
                    CreditItem(
                      name: 'ますかわ',
                      role: 'ぼくせいだいすきだからねー',
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('assets/images/masukawa@3x.png'),
                      ),
                    ),
                    CreditItem(
                      name: 'Abuki',
                      role: '緑の窓口',
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('assets/images/abuki@3x.png'),
                      ),
                    ),
                    CreditItem(
                      name: 'エナドリ',
                      role: 'valorant',
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('assets/images/enadori@3x.png'),
                      ),
                    ),
                  ],
                  isDarkMode: isDarkMode,
                  delay: 0.2,
                ),
                const SizedBox(height: 24),
                _buildCreditSection(
                  context: context,
                  title: 'テスト・フィードバック',
                  credits: [
                    const CreditItem(
                      name: 'のっぷのお店',
                      role: '最初の犠牲たち',
                      icon: CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://cdn.discordapp.com/icons/1289569604967862295/d0d3cc644b9a47cf6ae35b4b2a2c2ab6.webp',
                        ),
                      ),
                    ),
                  ],
                  isDarkMode: isDarkMode,
                  delay: 0.4,
                ),
                const SizedBox(height: 24),
                _buildCreditSection(
                  context: context,
                  title: 'スペシャルサンクス',
                  credits: [
                    const CreditItem(
                      name: 'VRChat API コミュニティ',
                      role: '非公式VRChat APIの提供',
                      icon: CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://avatars.githubusercontent.com/u/36933130',
                        ),
                      ),
                    ),
                    CreditItem(
                      name: 'あのめあ',
                      role: 'あのめあちゃん買え',
                      icon: const CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://booth.pximg.net/9c55fea2-2854-4e53-9a97-6c2c086c37c9/i/5020157/25c1f1fa-4929-4a6c-a424-ede13c90a5b9.png',
                        ),
                      ),
                      onTap: () {
                        launchUrl(
                          Uri.parse('https://booth.pm/ja/items/5020157'),
                        );
                      },
                    ),

                    CreditItem(
                      name: 'あのめあ ﾁｬﾝSDイラスト',
                      role: 'ローディングアニメーション',
                      icon: const CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://booth.pximg.net/bab5ce08-f39a-40f4-a708-ba7b04332682/i/6567379/c4b6914c-225d-4926-8550-ff81b6717037.png',
                        ),
                      ),
                      onTap: () {
                        launchUrl(
                          Uri.parse('https://triples.booth.pm/items/6567379'),
                        );
                      },
                    ),
                  ],
                  isDarkMode: isDarkMode,
                  delay: 0.6,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditSection({
    required BuildContext context,
    required String title,
    required List<CreditItem> credits,
    required bool isDarkMode,
    required double delay,
  }) {
    final accentColor =
        isDarkMode ? const Color(0xFF4CAF50) : const Color(0xFF2E7D32);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
              title,
              style: GoogleFonts.notoSans(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: accentColor,
                letterSpacing: 0.5,
              ),
            )
            .animate()
            .fadeIn(
              delay: Duration(milliseconds: (delay * 1000).toInt()),
              duration: const Duration(milliseconds: 500),
            )
            .slideX(begin: -0.2, end: 0),
        const SizedBox(height: 12),
        Container(height: 2, width: 60, color: accentColor)
            .animate()
            .fadeIn(
              delay: Duration(milliseconds: (delay * 1000 + 200).toInt()),
              duration: const Duration(milliseconds: 400),
            )
            .slideX(begin: -0.5, end: 0),
        const SizedBox(height: 16),
        ...credits.asMap().entries.map((entry) {
          final index = entry.key;
          final credit = entry.value;
          return _buildCreditItem(
            context,
            credit,
            isDarkMode,
            delay + 0.3 + (index * 0.1),
          );
        }),
      ],
    );
  }

  Widget _buildCreditItem(
    BuildContext context,
    CreditItem credit,
    bool isDarkMode,
    double delay,
  ) {
    final cardColor = isDarkMode ? const Color(0xFF222222) : Colors.white;
    final cardShadowColor = isDarkMode ? Colors.black54 : Colors.black12;

    final Widget creditCard = Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cardShadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: credit.onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.1),
          highlightColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: cardShadowColor,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child:
                      credit.icon ??
                      CircleAvatar(
                        backgroundColor:
                            isDarkMode ? Colors.green[900] : Colors.green[100],
                        child: Text(
                          credit.name.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color:
                                isDarkMode
                                    ? Colors.green[300]
                                    : Colors.green[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        credit.name,
                        style: GoogleFonts.notoSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        credit.role,
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[700],
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
                if (credit.onTap != null)
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isDarkMode
                              ? Colors.green.withValues(alpha: .1)
                              : Colors.green.withValues(alpha: .08),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color:
                            isDarkMode ? Colors.green[300] : Colors.green[700],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    return creditCard
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: (delay * 1000).toInt()),
          duration: const Duration(milliseconds: 600),
        )
        .slideY(begin: 0.2, end: 0);
  }
}

@immutable
class CreditItem {
  final String name;
  final String role;
  final Widget? icon;
  final VoidCallback? onTap;

  const CreditItem({
    required this.name,
    required this.role,
    this.icon,
    this.onTap,
  });
}
