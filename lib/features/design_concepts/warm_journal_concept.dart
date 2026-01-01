import 'package:flutter/material.dart';

/// Konsept: Warm Journal
/// Sıcak toprak tonları, günlük teması, duygu takibi ve mindfulness odaklı
class WarmJournalConceptScreen extends StatelessWidget {
  const WarmJournalConceptScreen({super.key});

  // Renk paleti - Sıcak, toprak tonları
  static const Color _bgColor = Color(0xFFF5F2EE);
  static const Color _cardBg = Color(0xFFFFFFFF);
  static const Color _warmBeige = Color(0xFFE8DDD4);
  static const Color _mustard = Color(0xFFE5A94C);
  static const Color _darkMustard = Color(0xFFCF9236);
  static const Color _olive = Color(0xFF8B8B6E);
  static const Color _coral = Color(0xFFE07B54);
  static const Color _warmGray = Color(0xFF6B6B6B);
  static const Color _darkText = Color(0xFF2D2D2D);
  static const Color _teal = Color(0xFF4A8C8C);
  static const Color _sage = Color(0xFF9BB09B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 100), // Konsept seçici için boşluk
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Üst başlık - Kullanıcı selamlama
                    _buildHeader(),
                    const SizedBox(height: 24),

                    // Haftalık takvim
                    _buildWeeklyCalendar(),
                    const SizedBox(height: 24),

                    // Günlük kartı (My Journal)
                    _buildSectionHeader('My Journal', 'See all'),
                    const SizedBox(height: 12),
                    _buildJournalCard(),
                    const SizedBox(height: 24),

                    // Hızlı günlük seçenekleri
                    _buildSectionHeader('Quick Journal', 'See all'),
                    const SizedBox(height: 12),
                    _buildQuickJournalRow(),
                    const SizedBox(height: 24),

                    // Duygu takibi kartı
                    _buildEmotionTracker(),
                    const SizedBox(height: 24),

                    // Günlük özeti kartı
                    _buildDailySummaryCard(),
                  ],
                ),
              ),
            ),
            // Alt navigasyon
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, Jose Maria',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: _darkText,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [_coral.withValues(alpha: 0.8), _mustard],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Text('😊', style: TextStyle(fontSize: 24)),
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyCalendar() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dates = [7, 8, 9, 10, 11, 12, 13];
    const selectedIndex = 3; // Perşembe

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final isSelected = index == selectedIndex;
        return Column(
          children: [
            Text(
              days[index],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? _darkText : _warmGray,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? _darkText : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  dates[index].toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : _darkText,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _darkText,
          ),
        ),
        Text(
          action,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _warmGray,
          ),
        ),
      ],
    );
  }

  Widget _buildJournalCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Arka plan - Gradient sky
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color(0xFFB5D8E8), const Color(0xFFE8D8C8)],
                ),
              ),
            ),
            // Güneş
            Positioned(
              left: 40,
              top: 60,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _mustard,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _mustard.withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('😊', style: TextStyle(fontSize: 28)),
                ),
              ),
            ),
            // Ağaçlar silüeti
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, _sage.withValues(alpha: 0.3)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildTree(30),
                    _buildTree(45),
                    _buildTree(35),
                    _buildTree(50),
                    _buildTree(40),
                  ],
                ),
              ),
            ),
            // Metin içeriği
            Positioned(
              top: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Evening',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _darkText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 50,
              left: 120,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let's start your day",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _darkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Begin with a mindful morning\nreflections.',
                    style: TextStyle(
                      fontSize: 13,
                      color: _warmGray,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTree(double height) {
    return Container(
      width: 20,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF5A7A5A),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  Widget _buildQuickJournalRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildQuickJournalCard(
            emoji: '🌿',
            title: 'Pause & reflect',
            subtitle: 'What are you grateful\nfor today?',
            tags: ['Today', 'Personal'],
            bgColor: _warmBeige.withValues(alpha: 0.5),
            tagColor: _coral,
          ),
          const SizedBox(width: 12),
          _buildQuickJournalCard(
            emoji: '🌟',
            title: 'Set Intentions',
            subtitle: 'How do you want to\nfeel?',
            tags: ['Today', 'Family'],
            bgColor: const Color(0xFFFFF8E7),
            tagColor: _teal,
          ),
          const SizedBox(width: 12),
          _buildQuickJournalCard(
            emoji: '💭',
            title: 'Emotions',
            subtitle: 'Let your feelings\nflow.',
            tags: ['Today'],
            bgColor: const Color(0xFFE8F0F0),
            tagColor: _olive,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickJournalCard({
    required String emoji,
    required String title,
    required String subtitle,
    required List<String> tags,
    required Color bgColor,
    required Color tagColor,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _darkText,
                ),
              ),
              const SizedBox(width: 4),
              Text(emoji, style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: _warmGray, height: 1.4),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tags
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: tag == 'Today'
                          ? Colors.white
                          : tagColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: tag == 'Today'
                          ? null
                          : Border.all(color: tagColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: tag == 'Today' ? _warmGray : tagColor,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionTracker() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emotions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _darkText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Here are four core emotions for your journal',
            style: TextStyle(fontSize: 13, color: _warmGray),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildEmotionBar('Happy', 0.48, _mustard, '48%'),
              _buildEmotionBar('Sad', 0.33, _coral, '33%'),
              _buildEmotionBar('Calm', 0.27, _olive, '27%'),
              _buildEmotionBar('Anxious', 0.40, _teal, '40%'),
            ],
          ),
          const SizedBox(height: 20),
          // Yeni günlük oluştur butonu
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: _mustard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'Create a New Journal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionBar(
    String label,
    double value,
    Color color,
    String percentage,
  ) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 120 * value + 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                percentage,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _warmGray,
          ),
        ),
      ],
    );
  }

  Widget _buildDailySummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '420',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: _darkText,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _warmBeige.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.more_horiz, color: Color(0xFF6B6B6B)),
              ),
            ],
          ),
          Text(
            'Celebrate what made you smile today.',
            style: TextStyle(fontSize: 14, color: _warmGray),
          ),
          const SizedBox(height: 16),
          // Mini günlük girişleri
          _buildMiniJournalEntry('Morning Reflection', 'March 22, 2025', [
            'Personal',
            'Calm',
            'Motivation',
          ]),
        ],
      ),
    );
  }

  Widget _buildMiniJournalEntry(String title, String date, List<String> tags) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _warmBeige.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              color: _mustard,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _darkText,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _warmBeige),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _warmGray,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          // Ses kaydı göstergesi
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _mustard,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ses dalgası simülasyonu
                      Row(
                        children: List.generate(20, (index) {
                          final height = (index % 3 == 0)
                              ? 16.0
                              : (index % 2 == 0)
                              ? 10.0
                              : 6.0;
                          return Container(
                            width: 3,
                            height: height,
                            margin: const EdgeInsets.only(right: 3),
                            decoration: BoxDecoration(
                              color: _warmGray.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Text(
                  '00:32',
                  style: TextStyle(
                    fontSize: 12,
                    color: _warmGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home_rounded, 'Home', true),
          _buildNavItem(Icons.explore_outlined, 'Explore', false),
          _buildCenterNavItem(),
          _buildNavItem(Icons.calendar_today_outlined, 'Journey', false),
          _buildNavItem(Icons.person_outline, 'Profile', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 24,
          color: isActive ? _darkText : _warmGray.withValues(alpha: 0.5),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? _darkText : _warmGray.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildCenterNavItem() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: _warmBeige, shape: BoxShape.circle),
      child: Icon(Icons.add, color: _darkText, size: 24),
    );
  }
}
