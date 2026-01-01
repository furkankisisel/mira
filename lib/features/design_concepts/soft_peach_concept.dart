import 'package:flutter/material.dart';

/// Konsept 1: Soft Peach & Cream
/// Sıcak, şeftali tonlarında yumuşak ve davetkar bir tema
class SoftPeachConceptScreen extends StatelessWidget {
  const SoftPeachConceptScreen({super.key});

  // Renk paleti
  static const Color _peachLight = Color(0xFFFFF5F0);
  static const Color _peachBg = Color(0xFFFFE5DC);
  static const Color _peachAccent = Color(0xFFFF9B7C);
  static const Color _peachDark = Color(0xFFE67E5E);
  static const Color _cream = Color(0xFFFFFAF5);
  static const Color _coral = Color(0xFFFF7B5C);
  static const Color _warmBrown = Color(0xFF8B6655);
  static const Color _softOrange = Color(0xFFFFB087);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_peachBg, _peachLight],
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
                      // Karşılama kartı
                      _buildGreetingCard(),
                      const SizedBox(height: 20),

                      // Günlük özet
                      _buildDailySummary(),
                      const SizedBox(height: 20),

                      // Alışkanlık kartları
                      _buildSectionTitle('Bugünkü Alışkanlıklar'),
                      const SizedBox(height: 12),
                      _buildHabitCard(
                        emoji: '💧',
                        title: 'Su İç',
                        subtitle: '6/8 bardak',
                        progress: 0.75,
                        color: const Color(0xFF88C5E0),
                      ),
                      const SizedBox(height: 12),
                      _buildHabitCard(
                        emoji: '🧘',
                        title: 'Meditasyon',
                        subtitle: '10 dakika',
                        progress: 1.0,
                        color: _peachAccent,
                      ),
                      const SizedBox(height: 12),
                      _buildHabitCard(
                        emoji: '📚',
                        title: 'Kitap Oku',
                        subtitle: '15/30 sayfa',
                        progress: 0.5,
                        color: _softOrange,
                      ),
                      const SizedBox(height: 20),

                      // Mood tracker
                      _buildMoodCard(),
                      const SizedBox(height: 20),

                      // Seri takibi
                      _buildStreakCard(),
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

  Widget _buildGreetingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _cream,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _peachDark.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _peachAccent.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🌸', style: TextStyle(fontSize: 32)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Günaydın! ☀️',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _warmBrown,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bugün harika bir gün, başaracaksın!',
                  style: TextStyle(
                    fontSize: 14,
                    color: _warmBrown.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailySummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cream,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _peachDark.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSummaryItem('✅', '5/7', 'Tamamlanan'),
          _buildDivider(),
          _buildSummaryItem('🔥', '12', 'Gün Seri'),
          _buildDivider(),
          _buildSummaryItem('⭐', '85%', 'Oran'),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _warmBrown,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: _warmBrown.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: _peachAccent.withValues(alpha: 0.3),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: _warmBrown,
      ),
    );
  }

  Widget _buildHabitCard({
    required String emoji,
    required String title,
    required String subtitle,
    required double progress,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cream,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
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
                    fontWeight: FontWeight.w600,
                    color: _warmBrown,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: _warmBrown.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: color.withValues(alpha: 0.15),
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (progress >= 1.0)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Colors.white, size: 20),
            )
          else
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: color, size: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildMoodCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cream,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _peachDark.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bugün nasıl hissediyorsun?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _warmBrown,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMoodOption('😔', false),
              _buildMoodOption('😐', false),
              _buildMoodOption('🙂', true),
              _buildMoodOption('😊', false),
              _buildMoodOption('🥰', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodOption(String emoji, bool isSelected) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: isSelected ? _peachAccent : _peachAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28))),
    );
  }

  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_peachAccent, _coral],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _coral.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 48)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '12 Gün Seri!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Harikasın! Devam et! 💪',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
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
        color: _cream,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _peachDark.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home_rounded, true),
          _buildNavItem(Icons.bar_chart_rounded, false),
          _buildNavItem(Icons.add_circle_rounded, false, isCenter: true),
          _buildNavItem(Icons.calendar_today_rounded, false),
          _buildNavItem(Icons.person_rounded, false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive, {bool isCenter = false}) {
    if (isCenter) {
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_peachAccent, _coral],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _coral.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      );
    }
    return Icon(
      icon,
      size: 28,
      color: isActive ? _peachAccent : _warmBrown.withValues(alpha: 0.4),
    );
  }
}
