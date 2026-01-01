import 'package:flutter/material.dart';

/// Konsept 5: Focused Zen
/// Ana eylem odaklı, dikkat dağıtıcı unsurları minimize eden minimalist tasarım
/// Kullanıcıyı "bugün yapılacak tek şey"e yönlendiren yapı
class FocusedZenConceptScreen extends StatelessWidget {
  const FocusedZenConceptScreen({super.key});

  // Renk paleti - Sakin, nötr tonlar
  static const Color _bgLight = Color(0xFFF8F9FA);
  static const Color _cardBg = Color(0xFFFFFFFF);
  static const Color _primary = Color(0xFF6366F1); // Indigo - action color
  static const Color _success = Color(0xFF22C55E);
  static const Color _textPrimary = Color(0xFF1F2937);
  static const Color _textSecondary = Color(0xFF6B7280);
  static const Color _textMuted = Color(0xFF9CA3AF);
  static const Color _border = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 100), // Konsept seçici için boşluk
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Minimal karşılama - tarih odaklı
                    _buildMinimalHeader(),
                    const SizedBox(height: 32),

                    // ANA ODAK: Bugünkü en önemli alışkanlık (BÜYÜK)
                    _buildMainFocusCard(),
                    const SizedBox(height: 32),

                    // Küçük ilerleme göstergesi
                    _buildProgressIndicator(),
                    const SizedBox(height: 32),

                    // Diğer alışkanlıklar - SESSİZ, kompakt liste
                    _buildSecondaryHabits(),
                    const SizedBox(height: 24),

                    // Gizli özellikler - sadece ikon şeklinde
                    _buildQuietFeatures(),
                  ],
                ),
              ),
            ),
            // Minimal alt navigasyon
            _buildMinimalBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pazartesi',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _textMuted,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '30 Aralık',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w300,
            color: _textPrimary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildMainFocusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Büyük emoji
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🧘', style: TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: 24),

          // Ana başlık
          Text(
            'Sabah Meditasyonu',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '10 dakika • Her gün',
            style: TextStyle(fontSize: 14, color: _textSecondary),
          ),
          const SizedBox(height: 32),

          // BÜYÜK aksiyon butonu
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow_rounded, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Başla',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildProgressDot(true),
        const SizedBox(width: 8),
        _buildProgressDot(true),
        const SizedBox(width: 8),
        _buildProgressDot(false), // Current
        const SizedBox(width: 8),
        _buildProgressDot(false),
        const SizedBox(width: 8),
        _buildProgressDot(false),
        const SizedBox(width: 16),
        Text(
          '2/5 tamamlandı',
          style: TextStyle(fontSize: 13, color: _textSecondary),
        ),
      ],
    );
  }

  Widget _buildProgressDot(bool completed) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: completed ? _success : _border,
        shape: BoxShape.circle,
      ),
      child: completed
          ? const Icon(Icons.check, size: 8, color: Colors.white)
          : null,
    );
  }

  Widget _buildSecondaryHabits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sıradaki',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _textMuted,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        // Kompakt liste - sessiz ama erişilebilir
        _buildCompactHabitRow('💧', 'Su İç', '6/8 bardak'),
        _buildCompactHabitRow('📚', 'Kitap Oku', '15 sayfa'),
        _buildCompactHabitRow('🏃', 'Yürüyüş', '30 dakika'),
      ],
    );
  }

  Widget _buildCompactHabitRow(String emoji, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border.withValues(alpha: 0.5)),
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
          Text(subtitle, style: TextStyle(fontSize: 13, color: _textMuted)),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, size: 20, color: _textMuted),
        ],
      ),
    );
  }

  Widget _buildQuietFeatures() {
    // Diğer özellikler - küçük ve sessiz
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuietFeatureIcon(Icons.mood_outlined, 'Ruh Hali'),
          _buildQuietFeatureIcon(Icons.timer_outlined, 'Zamanlayıcı'),
          _buildQuietFeatureIcon(Icons.insights_outlined, 'İstatistik'),
          _buildQuietFeatureIcon(Icons.calendar_today_outlined, 'Takvim'),
        ],
      ),
    );
  }

  Widget _buildQuietFeatureIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _bgLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: _textSecondary, size: 22),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: 11, color: _textMuted)),
      ],
    );
  }

  Widget _buildMinimalBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      decoration: BoxDecoration(
        color: _cardBg,
        border: Border(top: BorderSide(color: _border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.home_filled, color: _primary, size: 28),
          Icon(Icons.list_alt_outlined, color: _textMuted, size: 28),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: _primary, shape: BoxShape.circle),
            child: const Icon(Icons.add, color: Colors.white, size: 24),
          ),
          Icon(Icons.bar_chart_outlined, color: _textMuted, size: 28),
          Icon(Icons.person_outline, color: _textMuted, size: 28),
        ],
      ),
    );
  }
}
