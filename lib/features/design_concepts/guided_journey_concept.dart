import 'package:flutter/material.dart';

/// Konsept 6: Guided Journey
/// Kullanıcıyı adım adım yönlendiren, hedef odaklı tasarım
/// Günlük rutin akışını vurgulayan, bağlamsal ipuçları sunan yapı
class GuidedJourneyConceptScreen extends StatelessWidget {
  const GuidedJourneyConceptScreen({super.key});

  // Renk paleti - Sıcak ve teşvik edici
  static const Color _bgGradientStart = Color(0xFFFEF3E2);
  static const Color _bgGradientEnd = Color(0xFFFFF9F0);
  static const Color _cardBg = Color(0xFFFFFFFF);
  static const Color _accent = Color(0xFFFF8C42); // Warm orange
  static const Color _accentLight = Color(0xFFFFE8D6);
  static const Color _success = Color(0xFF4ADE80);
  static const Color _textPrimary = Color(0xFF2D2A26);
  static const Color _textSecondary = Color(0xFF7A746C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgGradientStart, _bgGradientEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 100),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Günün aşaması göstergesi
                      _buildDayPhaseIndicator(),
                      const SizedBox(height: 24),

                      // Yönlendirici mesaj
                      _buildGuidanceCard(),
                      const SizedBox(height: 24),

                      // Şu anki adım (ODAK)
                      _buildCurrentStepCard(),
                      const SizedBox(height: 20),

                      // Sonraki adımlar (timeline view)
                      _buildUpcomingTimeline(),
                      const SizedBox(height: 24),

                      // Tamamlananlar (collapse)
                      _buildCompletedSection(),
                    ],
                  ),
                ),
              ),
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayPhaseIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Gün aşamaları
          Expanded(
            child: Row(
              children: [
                _buildPhaseChip('🌅', 'Sabah', true),
                const SizedBox(width: 8),
                Container(width: 24, height: 2, color: _accent),
                const SizedBox(width: 8),
                _buildPhaseChip('☀️', 'Öğle', false),
                const SizedBox(width: 8),
                Container(width: 24, height: 2, color: _accentLight),
                const SizedBox(width: 8),
                _buildPhaseChip('🌙', 'Akşam', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseChip(String emoji, String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? _accent : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          if (isActive) ...[
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGuidanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_accent, _accent.withValues(alpha: 0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _accent.withValues(alpha: 0.3),
            blurRadius: 16,
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
                const Text(
                  '💡 Sabah rutininiz başlıyor',
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Güne meditasyonla başlamak \nenerjinizi artırır!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('✨', style: TextStyle(fontSize: 28)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStepCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _accent.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: _accent.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Step indicator
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _accentLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '📍 Şu anki adım',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _accent,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '⏱️ ~10 dk',
                style: TextStyle(fontSize: 13, color: _textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Habit info
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _accentLight,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                  child: Text('🧘', style: TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sabah Meditasyonu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '12 günlük seriniz devam ediyor! 🔥',
                      style: TextStyle(fontSize: 13, color: _textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _textSecondary,
                    side: BorderSide(
                      color: _textSecondary.withValues(alpha: 0.3),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Atla'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow_rounded),
                      SizedBox(width: 4),
                      Text(
                        'Başla',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sıradaki adımlar',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        // Timeline items
        _buildTimelineItem('💧', 'Su İç', '08:30', false, true),
        _buildTimelineItem('📚', 'Kitap Oku', '09:00', false, true),
        _buildTimelineItem('🏃', 'Sabah Koşusu', '09:30', false, false),
      ],
    );
  }

  Widget _buildTimelineItem(
    String emoji,
    String title,
    String time,
    bool completed,
    bool hasLine,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline line and dot
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: completed ? _success : _accentLight,
                shape: BoxShape.circle,
                border: completed ? null : Border.all(color: _accent, width: 2),
              ),
            ),
            if (hasLine) Container(width: 2, height: 40, color: _accentLight),
          ],
        ),
        const SizedBox(width: 16),
        // Content
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _cardBg.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 15, color: _textPrimary),
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(fontSize: 13, color: _textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: _success, size: 24),
          const SizedBox(width: 12),
          Text(
            '2 alışkanlık tamamlandı',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _textPrimary,
            ),
          ),
          const Spacer(),
          Icon(Icons.expand_more, color: _textSecondary),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        color: _cardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.route, 'Yolculuk', true),
          _buildNavItem(Icons.list_alt_outlined, 'Tümü', false),
          _buildNavItem(Icons.insights_outlined, 'Analiz', false),
          _buildNavItem(Icons.person_outline, 'Profil', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? _accent : _textSecondary, size: 26),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive ? _accent : _textSecondary,
          ),
        ),
      ],
    );
  }
}
