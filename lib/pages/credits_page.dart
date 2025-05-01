import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'クレジット',
          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCreditSection(
            title: '開発',
            credits: [
              CreditItem(
                name: 'null_base',
                role: '人生つかれた',
                icon: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/default.png'),
                ),
                onTap: () {
                  context.push(
                    '/friends/usr_1d67de93-8afb-48dc-af7d-da7a33834f52',
                  );
                },
              ),
            ],
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 12),
          _buildCreditSection(
            title: '愉快なアイコン',
            credits: [
              CreditItem(
                name: 'annobu',
                role: 'のっぶのお店 店長',
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
            ],
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 12),
          _buildCreditSection(
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
          ),
          const SizedBox(height: 12),
          _buildCreditSection(
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
            ],
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildCreditSection({
    required String title,
    required List<CreditItem> credits,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.notoSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.green[300] : Colors.green[800],
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
        const SizedBox(height: 8),
        ...credits.map((credit) => _buildCreditItem(credit, isDarkMode)),
      ],
    );
  }

  Widget _buildCreditItem(CreditItem credit, bool isDarkMode) {
    final Widget itemContent = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        credit.icon != null
            ? SizedBox(width: 40, height: 40, child: credit.icon)
            : CircleAvatar(
              backgroundColor:
                  isDarkMode ? Colors.green[900] : Colors.green[100],
              child: Text(
                credit.name.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  color: isDarkMode ? Colors.green[300] : Colors.green[800],
                  fontWeight: FontWeight.bold,
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                credit.role,
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        if (credit.onTap != null)
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
          ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child:
          credit.onTap != null
              ? InkWell(
                onTap: credit.onTap,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0), // タップ領域を広げる
                  child: itemContent,
                ),
              )
              : Padding(padding: const EdgeInsets.all(8.0), child: itemContent),
    );
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
    this.onTap, // タップ時の動作
  });
}
