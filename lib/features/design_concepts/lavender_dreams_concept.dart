import 'package:flutter/material.dart';

/// Konsept 2: Lavender Dreams
/// Zarif, lavanta tonlarında rüya gibi ve sakin bir tema
class LavenderDreamsConceptScreen extends StatelessWidget {
  const LavenderDreamsConceptScreen({super.key});

  // Renk paleti
  static const Color _lavenderLight = Color(0xFFFAF5FF);
  static const Color _lavenderBg = Color(0xFFF3E8FF);
  static const Color _lavenderAccent = Color(0xFFA78BFA);
  static const Color _lavenderDark = Color(0xFF7C3AED);
  static const Color _softPink = Color(0xFFF5D0FE);
  static const Color _cream = Color(0xFFFDFCFF);
  static const Color _purple = Color(0xFF8B5CF6);
  static const Color _violet = Color(0xFFC4B5FD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_lavenderBg, _lavenderLight, Color(0xFFFDF4FF)],
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
                      // Karşılama kartı - glassmorphism
                      _buildGreetingCard(),
                      const SizedBox(height: 24),

                      // Günlük istatistikler
                      _buildStatsRow(),
                      const SizedBox(height: 24),

                      // Alışkanlık bölümü
                      _buildSectionTitle('Alışkanlıklarım'),
                      const SizedBox(height: 16),
                      _buildHabitCard(
                        emoji: '🧘‍♀️',
                        title: 'Sabah Meditasyonu',
                        subtitle: 'Tamamlandı',
                        progress: 1.0,
                        color: _lavenderAccent,
                      ),
                      const SizedBox(height: 12),
                      _buildHabitCard(
                        emoji: '📖',
                        title: 'Günlük Okuma',
                        subtitle: '20/30 dakika',
                        progress: 0.67,
                        color: const Color(0xFFEC4899),
                      ),
                      const SizedBox(height: 12),
                      _buildHabitCard(
                        emoji: '💪',
                        title: 'Egzersiz',
                        subtitle: 'Bekliyor',
                        progress: 0.0,
                        color: const Color(0xFF6366F1),
                      ),
                      const SizedBox(height: 24),

                      // Motivasyon kartı
                      _buildMotivationCard(),
                      const SizedBox(height: 24),

                      // Focus Timer kartı
                      _buildTimerCard(),
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
        // Glassmorphism efekti
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _lavenderDark.withValues(alpha: 0.1),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_lavenderAccent, _lavenderDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                  child: Text('✨', style: TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'İyi Akşamlar 💫',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: _lavenderDark,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '30 Aralık 2024',
                      style: TextStyle(
                        fontSize: 14,
                        color: _lavenderDark.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _lavenderAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('🌙', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Bugün 4 alışkanlığı tamamladın!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _lavenderDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('🔥', '15', 'Seri')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('⚡', '87%', 'Başarı')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('🏆', '42', 'Puan')),
      ],
    );
  }

  Widget _buildStatCard(String emoji, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _violet.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _lavenderDark,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: _lavenderDark.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _lavenderDark,
            letterSpacing: -0.3,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Tümünü Gör',
            style: TextStyle(
              fontSize: 14,
              color: _lavenderAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.2),
                  color.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _lavenderDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: _lavenderDark.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: color.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: progress >= 1.0 ? color : Colors.transparent,
              border: progress < 1.0
                  ? Border.all(color: color.withValues(alpha: 0.4), width: 2)
                  : null,
              shape: BoxShape.circle,
            ),
            child: Icon(
              progress >= 1.0
                  ? Icons.check_rounded
                  : Icons.arrow_forward_ios_rounded,
              color: progress >= 1.0
                  ? Colors.white
                  : color.withValues(alpha: 0.6),
              size: progress >= 1.0 ? 22 : 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _softPink.withValues(alpha: 0.5),
            _violet.withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💜', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Text(
                'Günün Sözü',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _lavenderDark.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '"Küçük adımlar, büyük değişimlere yol açar."',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _lavenderDark,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_lavenderDark, _purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _lavenderDark.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Odaklanma Modu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pomodoro zamanlayıcısı',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 64,
            height: 64,
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
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: _violet.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: _lavenderDark.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.grid_view_rounded, true),
          _buildNavItem(Icons.insights_rounded, false),
          _buildCenterButton(),
          _buildNavItem(Icons.timer_outlined, false),
          _buildNavItem(Icons.person_outline_rounded, false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isActive
            ? _lavenderAccent.withValues(alpha: 0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        size: 26,
        color: isActive ? _lavenderDark : _lavenderDark.withValues(alpha: 0.35),
      ),
    );
  }

  Widget _buildCenterButton() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_lavenderAccent, _lavenderDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _lavenderDark.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
    );
  }
}
