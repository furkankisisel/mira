import 'package:flutter/material.dart';

/// Konsept 4: Cotton Candy
/// Pamuk şeker gibi tatlı, pembe-mavi pastel tonlarda eğlenceli tema
class CottonCandyConceptScreen extends StatelessWidget {
  const CottonCandyConceptScreen({super.key});

  // Renk paleti
  static const Color _pinkLight = Color(0xFFFFF0F5);
  static const Color _pinkBg = Color(0xFFFFD6E8);
  static const Color _pink = Color(0xFFFF6B9D);
  static const Color _pinkDark = Color(0xFFE91E63);
  static const Color _blueLight = Color(0xFFE8F4FF);
  static const Color _blue = Color(0xFF64B5F6);
  static const Color _blueDark = Color(0xFF2196F3);
  static const Color _yellow = Color(0xFFFFE082);
  static const Color _mint = Color(0xFF81E6D9);
  static const Color _purple = Color(0xFFB39DDB);
  static const Color _white = Color(0xFFFFFAFC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_pinkBg, _blueLight, _pinkLight],
            stops: [0.0, 0.5, 1.0],
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
                      // Eğlenceli karşılama
                      _buildGreetingCard(),
                      const SizedBox(height: 24),

                      // Eğlenceli istatistikler
                      _buildFunStats(),
                      const SizedBox(height: 24),

                      // Alışkanlık başlığı
                      _buildSectionTitle('Bugünkü Maceralar ✨'),
                      const SizedBox(height: 16),

                      // Renkli alışkanlık kartları
                      _buildHabitBubble(
                        emoji: '💧',
                        title: 'Su İç',
                        subtitle: '6/8 bardak',
                        color: _blue,
                        progress: 0.75,
                      ),
                      const SizedBox(height: 14),
                      _buildHabitBubble(
                        emoji: '🎨',
                        title: 'Yaratıcı Zaman',
                        subtitle: '30 dakika',
                        color: _purple,
                        progress: 1.0,
                      ),
                      const SizedBox(height: 14),
                      _buildHabitBubble(
                        emoji: '🏃‍♀️',
                        title: 'Hareket Et',
                        subtitle: '5000 adım',
                        color: _pink,
                        progress: 0.4,
                      ),
                      const SizedBox(height: 14),
                      _buildHabitBubble(
                        emoji: '📚',
                        title: 'Kitap Oku',
                        subtitle: '10 sayfa',
                        color: _mint,
                        progress: 0.0,
                      ),
                      const SizedBox(height: 24),

                      // Seri kartı
                      _buildStreakBanner(),
                      const SizedBox(height: 24),

                      // Mood seçici
                      _buildMoodPicker(),
                    ],
                  ),
                ),
              ),
              // Eğlenceli alt navigasyon
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
        color: _white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: _pink.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: _blue.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(-8, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Cute avatar
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _pink.withValues(alpha: 0.3),
                      _blue.withValues(alpha: 0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text('🌈', style: TextStyle(fontSize: 36)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Merhaba Yıldız! ⭐',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF4A4A5A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Bugün muhteşem olacak!',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Progress bar cute
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _pink.withValues(alpha: 0.1),
                  _blue.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Text('🎯', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Günlük Hedef',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5A5A6A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.65,
                          backgroundColor: _white,
                          valueColor: AlwaysStoppedAnimation(_pink),
                          minHeight: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '65%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4A5A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunStats() {
    return Row(
      children: [
        Expanded(child: _buildStatBubble('🔥', '14', 'Gün Seri', _pink)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatBubble('⭐', '156', 'Yıldız', _yellow)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatBubble('💎', '23', 'Rozet', _blue)),
      ],
    );
  }

  Widget _buildStatBubble(
    String emoji,
    String value,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xFF4A4A5A),
      ),
    );
  }

  Widget _buildHabitBubble({
    required String emoji,
    required String title,
    required String subtitle,
    required Color color,
    required double progress,
  }) {
    final isComplete = progress >= 1.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: color.withValues(alpha: isComplete ? 0.5 : 0.2),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          // Emoji bubble
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
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
                    color: const Color(0xFF4A4A5A),
                    decoration: isComplete ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
                const SizedBox(height: 10),
                // Cute progress bar
                Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withValues(alpha: 0.7)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Cute action button
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isComplete ? color : Colors.transparent,
              border: isComplete ? null : Border.all(color: color, width: 2.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: isComplete
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 24)
                : Icon(Icons.add_rounded, color: color, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_pink, _purple, _blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _pink.withValues(alpha: 0.4),
            blurRadius: 20,
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
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🌟', style: TextStyle(fontSize: 32)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '14 Gün Seri! 🎉',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Harika gidiyorsun, devam et!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          const Text('💪', style: TextStyle(fontSize: 28)),
        ],
      ),
    );
  }

  Widget _buildMoodPicker() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _purple.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nasıl hissediyorsun? 💭',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4A4A5A),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMoodBubble('😢', _blue, false),
              _buildMoodBubble('😕', _purple, false),
              _buildMoodBubble('😊', _yellow, true),
              _buildMoodBubble('😄', _mint, false),
              _buildMoodBubble('🥳', _pink, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodBubble(String emoji, Color color, bool isSelected) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: isSelected ? color : color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(18),
        border: isSelected ? Border.all(color: color, width: 3) : null,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28))),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: _pink.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavIcon(Icons.home_rounded, true, _pink),
          _buildNavIcon(Icons.bar_chart_rounded, false, _blue),
          _buildAddButton(),
          _buildNavIcon(Icons.emoji_events_rounded, false, _yellow),
          _buildNavIcon(Icons.person_rounded, false, _purple),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, bool isActive, Color color) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, size: 28, color: isActive ? color : Colors.grey[400]),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_pink, _purple, _blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _pink.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
    );
  }
}
