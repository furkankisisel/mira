import 'package:flutter/material.dart';

/// Konsept 3: Mint Fresh
/// Taze, ferah, nane yeşili tonlarında minimalist ve wellness odaklı tema
class MintFreshConceptScreen extends StatelessWidget {
  const MintFreshConceptScreen({super.key});

  // Renk paleti
  static const Color _mintLight = Color(0xFFF0FFFA);
  static const Color _mintBg = Color(0xFFE0FFF4);
  static const Color _mintAccent = Color(0xFF10B981);
  static const Color _mintDark = Color(0xFF059669);
  static const Color _teal = Color(0xFF14B8A6);
  static const Color _aqua = Color(0xFF5EEAD4);
  static const Color _white = Color(0xFFFDFFFE);
  static const Color _darkText = Color(0xFF134E4A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_mintBg, _mintLight],
            stops: [0.0, 0.6],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 100), // Konsept seçici için boşluk
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Minimal karşılama
                      _buildGreetingSection(),
                      const SizedBox(height: 32),

                      // Progress circles
                      _buildProgressCircles(),
                      const SizedBox(height: 32),

                      // Alışkanlıklar
                      _buildSectionHeader('Bugün'),
                      const SizedBox(height: 16),
                      _buildHabitItem(
                        emoji: '🌅',
                        title: 'Erken Kalk',
                        time: '06:00',
                        isCompleted: true,
                      ),
                      _buildHabitItem(
                        emoji: '💧',
                        title: 'Su İç',
                        time: '2L hedef',
                        isCompleted: true,
                      ),
                      _buildHabitItem(
                        emoji: '🏃',
                        title: 'Koşu',
                        time: '30 dakika',
                        isCompleted: false,
                      ),
                      _buildHabitItem(
                        emoji: '🥗',
                        title: 'Sağlıklı Öğün',
                        time: '3 öğün',
                        isCompleted: false,
                      ),
                      const SizedBox(height: 32),

                      // Wellness kartı
                      _buildWellnessCard(),
                      const SizedBox(height: 24),

                      // Haftalık özet
                      _buildWeeklySummary(),
                    ],
                  ),
                ),
              ),
              // Alt navigasyon
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Merhaba 🌿',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    color: _darkText,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pazartesi, 30 Aralık',
                  style: TextStyle(
                    fontSize: 14,
                    color: _darkText.withValues(alpha: 0.5),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _mintDark.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: _mintAccent,
                size: 26,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCircles() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: _mintDark.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCircularProgress(0.75, '75%', 'Tamamlanan', _mintAccent),
          _buildCircularProgress(0.6, '18', 'Gün Seri', _teal),
          _buildCircularProgress(0.9, '90%', 'Haftalık', _aqua),
        ],
      ),
    );
  }

  Widget _buildCircularProgress(
    double value,
    String label,
    String subtitle,
    Color color,
  ) {
    return Column(
      children: [
        SizedBox(
          width: 72,
          height: 72,
          child: Stack(
            children: [
              SizedBox.expand(
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 6,
                  backgroundColor: color.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation(color),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _darkText,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: _darkText.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _darkText,
            letterSpacing: -0.3,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _mintAccent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '2/4',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _mintAccent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHabitItem({
    required String emoji,
    required String title,
    required String time,
    required bool isCompleted,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _mintDark.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isCompleted
                  ? _mintAccent.withValues(alpha: 0.15)
                  : _mintBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _darkText,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    decorationColor: _darkText.withValues(alpha: 0.3),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 13,
                    color: _darkText.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted ? _mintAccent : Colors.transparent,
              border: isCompleted
                  ? null
                  : Border.all(
                      color: _mintAccent.withValues(alpha: 0.4),
                      width: 2,
                    ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: isCompleted
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildWellnessCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_mintAccent, _teal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _mintDark.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nefes Al',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '5 dakikalık rahatlama',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildWellnessTag('🧘 Meditasyon'),
              const SizedBox(width: 8),
              _buildWellnessTag('✨ Mindfulness'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWellnessTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildWeeklySummary() {
    final days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final completed = [true, true, true, true, false, false, false];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _mintDark.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bu Hafta',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _darkText,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(days.length, (index) {
              return Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: completed[index] ? _mintAccent : _mintBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: completed[index]
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    days[index],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: index == 0
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: _darkText.withValues(
                        alpha: index == 0 ? 0.9 : 0.5,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _mintDark.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home_rounded, true, 'Ana'),
          _buildNavItem(Icons.show_chart_rounded, false, 'İstatistik'),
          _buildAddButton(),
          _buildNavItem(Icons.access_time_rounded, false, 'Zamanlayıcı'),
          _buildNavItem(Icons.settings_outlined, false, 'Ayarlar'),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 26,
          color: isActive ? _mintAccent : _darkText.withValues(alpha: 0.3),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive ? _mintAccent : _darkText.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: _mintAccent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _mintAccent.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
    );
  }
}
