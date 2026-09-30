import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../design_system/components/pressable_scale.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/live_rhythm_model.dart';

/// Elite, aesthetically restored Circadian Rhythm Results Screen.
/// Displays chronotype persona, 24h orbital timeline, circadian power windows,
/// biological flexibility insights, and high-end glassmorphic interactive cards.
class RhythmResultsScreen extends StatefulWidget {
  final RhythmProfile profile;

  const RhythmResultsScreen({super.key, required this.profile});

  @override
  State<RhythmResultsScreen> createState() => _RhythmResultsScreenState();
}

class _RhythmResultsScreenState extends State<RhythmResultsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.05, 0.75, curve: Curves.easeOutBack),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.15, 0.95, curve: Curves.easeOutCubic),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onDone() {
    HapticFeedback.mediumImpact();
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  _ChronoVisuals _getChronoVisuals(
    BuildContext context,
    ChronoType type,
    bool isDark,
    bool isTr,
  ) {
    final l10n = AppLocalizations.of(context);
    switch (type) {
      case ChronoType.morning:
        return _ChronoVisuals(
          title: l10n.rhythmChronoMorning,
          badgeLabel: isTr ? 'ERKEN UYANIŞ' : 'EARLY LARK',
          persona: isTr ? 'Şafak Avcısı' : 'Morning Lark',
          emoji: '🌅',
          primary: isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
          secondary: isDark ? const Color(0xFFFB923C) : const Color(0xFFEA580C),
          glow: const Color(0xFFF59E0B),
          bgStart: isDark ? const Color(0xFF261D15) : const Color(0xFFFEF8EE),
          bgEnd: isDark ? const Color(0xFF1E1712) : const Color(0xFFFFFDF8),
          description: isTr
              ? 'Biyolojik saatin gün ışığıyla kusursuz bir senkron içinde. Sabahın ilk saatlerinde kortizol ve zihinsel berraklığın zirveye çıkar. En zorlu analitik ve yaratıcı işlerini öğleden önceye planlayarak doğal enerjini en üst seviyede kullanabilirsin.'
              : 'Your circadian rhythm peaks with natural dawn light. Cortisol and cognitive acuity are highest in the morning hours. Scheduling your most demanding focus tasks before noon harnesses your innate peak flow.',
        );
      case ChronoType.evening:
        return _ChronoVisuals(
          title: l10n.rhythmChronoEvening,
          badgeLabel: isTr ? 'GECE ODAĞI' : 'NIGHT OWL',
          persona: isTr ? 'Gece Mimarı' : 'Night Visionary',
          emoji: '🌙',
          primary: isDark ? const Color(0xFFA5B4FC) : const Color(0xFF4F46E5),
          secondary: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA),
          glow: const Color(0xFF6366F1),
          bgStart: isDark ? const Color(0xFF16162C) : const Color(0xFFF3F3FE),
          bgEnd: isDark ? const Color(0xFF101124) : const Color(0xFFF9F9FF),
          description: isTr
              ? 'Bilişsel zirven ve yaratıcı derinleşmen günün ikinci yarısında ve akşam başlar. Sabahları hafif tempoyla başlayıp enerjini korumak, akşam saatlerindeki derin çalışma bloklarını paha biçilmez kılar.'
              : 'Your peak clarity and deep focus awaken in the afternoon and evening hours. Easing into mornings and reserving your major deep work blocks for later unlocks your greatest creative output.',
        );
      case ChronoType.intermediate:
      case ChronoType.variable:
        return _ChronoVisuals(
          title: l10n.rhythmChronoIntermediate,
          badgeLabel: isTr ? 'DENGELİ DÖNGÜ' : 'BALANCED RHYTHM',
          persona: isTr ? 'Uyum Ustası' : 'Balanced Navigator',
          emoji: '⚖️',
          primary: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
          secondary: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
          glow: const Color(0xFF0EA5E9),
          bgStart: isDark ? const Color(0xFF141E28) : const Color(0xFFF2F8FD),
          bgEnd: isDark ? const Color(0xFF101720) : const Color(0xFFFAFDFE),
          description: isTr
              ? 'Günün doğal akışına mükemmel uyum sağlayan esnek ve dengeli bir biyolojik saate sahipsin. Sabahları sabit enerjiyle başlayıp, gün boyunca odak ve aktivite arasında ritmik ve istikrarlı bir geçiş sağlarsın.'
              : 'You possess a resilient, balanced biological clock that synchronizes comfortably with everyday routines, maintaining steady mental energy and smooth physical rhythm throughout the day.',
        );
    }
  }

  String _formatTimeRange(TimeRange r) {
    return '${r.startHour.toString().padLeft(2, '0')}:00 - ${r.endHour.toString().padLeft(2, '0')}:00';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isTr = l10n.localeName.startsWith('tr');

    final visuals = _getChronoVisuals(
      context,
      widget.profile.chronoType,
      isDark,
      isTr,
    );

    final titleColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final subtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    final flexPercent = (widget.profile.flexibilityScore * 100).round().clamp(60, 96);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F17) : const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Ambient Radial Light Glow Behind Hero
          Positioned(
            top: -60,
            left: -40,
            right: -40,
            height: 380,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.2),
                    radius: 1.1,
                    colors: [
                      visuals.glow.withValues(alpha: isDark ? 0.22 : 0.16),
                      visuals.glow.withValues(alpha: isDark ? 0.08 : 0.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Main Scrollable Body
          SafeArea(
            child: Column(
              children: [
                // Top Custom Header / Bar
                _buildTopBar(context, visuals, isDark, isTr),

                // Scroll Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Hero Chronotype Card
                            ScaleTransition(
                              scale: _scaleAnimation,
                              child: _buildHeroCard(
                                visuals,
                                isDark,
                                isTr,
                                titleColor,
                                subtitleColor,
                                flexPercent,
                              ),
                            ),
                            const SizedBox(height: 22),

                            // 24-Hour Circadian Timeline Visualizer
                            _buildCircadianTimeline(
                              context,
                              isDark,
                              isTr,
                              titleColor,
                              subtitleColor,
                            ),
                            const SizedBox(height: 24),

                            // Section Title: Optimal Windows
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: visuals.primary,
                                    boxShadow: [
                                      BoxShadow(
                                        color: visuals.primary.withValues(alpha: 0.6),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.rhythmHabitSuggestionTitle,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                    color: titleColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // 4 Circadian Power Window Cards
                            _buildWindowCard(
                              context,
                              isDark: isDark,
                              isTr: isTr,
                              badge: isTr ? 'ZİHİNSEL ODAK' : 'DEEP FOCUS',
                              title: isTr ? 'Odak Akışı' : l10n.rhythmWindowFocus,
                              time: _formatTimeRange(widget.profile.focusWindow),
                              hint: l10n.rhythmFocusHint,
                              iconSymbol: '🧠',
                              primary: isDark
                                  ? const Color(0xFF38BDF8)
                                  : const Color(0xFF0284C7),
                              secondary: isDark
                                  ? const Color(0xFF818CF8)
                                  : const Color(0xFF6366F1),
                              titleColor: titleColor,
                              subtitleColor: subtitleColor,
                            ),
                            const SizedBox(height: 12),

                            _buildWindowCard(
                              context,
                              isDark: isDark,
                              isTr: isTr,
                              badge: isTr ? 'ZİRVE GÜÇ' : 'PEAK POWER',
                              title: isTr ? 'Enerji Zamanı' : l10n.rhythmWindowEnergy,
                              time: _formatTimeRange(widget.profile.energyWindow),
                              hint: l10n.rhythmEnergyHint,
                              iconSymbol: '⚡',
                              primary: isDark
                                  ? const Color(0xFFFBBF24)
                                  : const Color(0xFFD97706),
                              secondary: isDark
                                  ? const Color(0xFFFB923C)
                                  : const Color(0xFFEA580C),
                              titleColor: titleColor,
                              subtitleColor: subtitleColor,
                            ),
                            const SizedBox(height: 12),

                            _buildWindowCard(
                              context,
                              isDark: isDark,
                              isTr: isTr,
                              badge: isTr ? 'HAFİF AKIŞ' : 'EASY FLOW',
                              title: isTr ? 'Hafif Tempo' : l10n.rhythmWindowLight,
                              time: _formatTimeRange(widget.profile.lightWindow),
                              hint: l10n.rhythmLightHint,
                              iconSymbol: '🌤️',
                              primary: isDark
                                  ? const Color(0xFFC084FC)
                                  : const Color(0xFF9333EA),
                              secondary: isDark
                                  ? const Color(0xFFF472B6)
                                  : const Color(0xFFDB2777),
                              titleColor: titleColor,
                              subtitleColor: subtitleColor,
                            ),
                            const SizedBox(height: 12),

                            _buildWindowCard(
                              context,
                              isDark: isDark,
                              isTr: isTr,
                              badge: isTr ? 'TEFEKKÜR & UYKU' : 'EVENING REST',
                              title: isTr ? 'İçsel Yansıma' : l10n.rhythmWindowReflection,
                              time: _formatTimeRange(widget.profile.reflectionWindow),
                              hint: l10n.rhythmReflectionHint,
                              iconSymbol: '🌙',
                              primary: isDark
                                  ? const Color(0xFFA5B4FC)
                                  : const Color(0xFF4F46E5),
                              secondary: isDark
                                  ? const Color(0xFF93C5FD)
                                  : const Color(0xFF2563EB),
                              titleColor: titleColor,
                              subtitleColor: subtitleColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Pinned Bottom Glassmorphic Action Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomActionBar(context, l10n, visuals, isDark),
          ),
        ],
      ),
    );
  }

  // ── Header Bar ──

  Widget _buildTopBar(
    BuildContext context,
    _ChronoVisuals visuals,
    bool isDark,
    bool isTr,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Close / Back button with glass circle
          PressableScale(
            onTap: _onDone,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.05),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : Colors.black.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 17,
                color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Live Circadian Status Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: visuals.primary.withValues(alpha: isDark ? 0.16 : 0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: visuals.primary.withValues(alpha: isDark ? 0.35 : 0.25),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.5,
                  height: 6.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: visuals.primary,
                    boxShadow: [
                      BoxShadow(
                        color: visuals.primary.withValues(alpha: 0.7),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isTr ? 'SİRKADİYEN PROFİL' : 'CIRCADIAN PROFILE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: visuals.primary,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // Share / Info Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: visuals.primary.withValues(alpha: isDark ? 0.12 : 0.08),
            ),
            child: Center(
              child: Text(
                visuals.emoji,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero Chronotype Card ──

  Widget _buildHeroCard(
    _ChronoVisuals visuals,
    bool isDark,
    bool isTr,
    Color titleColor,
    Color subtitleColor,
    int flexPercent,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: RadialGradient(
          center: const Alignment(0.7, -0.6),
          radius: 1.4,
          colors: [
            visuals.primary.withValues(alpha: isDark ? 0.18 : 0.12),
            visuals.bgStart,
            visuals.bgEnd,
          ],
        ),
        border: Border.all(
          color: visuals.primary.withValues(alpha: isDark ? 0.28 : 0.22),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: visuals.glow.withValues(alpha: isDark ? 0.18 : 0.10),
            blurRadius: 26,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Background ambient sun/moon watermark
            Positioned(
              right: -25,
              top: -25,
              child: IgnorePointer(
                child: Text(
                  visuals.emoji,
                  style: TextStyle(
                    fontSize: 130,
                    color: Colors.white.withValues(alpha: isDark ? 0.04 : 0.06),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar & Badge Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Layered Glow Emoji Avatar
                      Container(
                        width: 66,
                        height: 66,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              visuals.primary.withValues(alpha: isDark ? 0.28 : 0.20),
                              visuals.secondary.withValues(alpha: isDark ? 0.22 : 0.12),
                            ],
                          ),
                          border: Border.all(
                            color: visuals.primary.withValues(alpha: 0.45),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: visuals.glow.withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            visuals.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Chrono Persona & Badge
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 3.5,
                              ),
                              decoration: BoxDecoration(
                                color: visuals.primary.withValues(
                                  alpha: isDark ? 0.18 : 0.12,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                visuals.badgeLabel,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: visuals.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              visuals.title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.4,
                                color: titleColor,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Natural Description Paragraph
                  Text(
                    visuals.description,
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.55,
                      color: subtitleColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Biological Flexibility Chip & Persona Stat
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.06),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.speed_rounded,
                          size: 16,
                          color: visuals.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isTr ? 'Biyolojik Esneklik:' : 'Circadian Flexibility:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: subtitleColor,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: visuals.primary.withValues(
                              alpha: isDark ? 0.22 : 0.15,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '%$flexPercent',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: visuals.primary,
                            ),
                          ),
                        ),
                      ],
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

  // ── 24-Hour Circadian Timeline ──

  Widget _buildCircadianTimeline(
    BuildContext context,
    bool isDark,
    bool isTr,
    Color titleColor,
    Color subtitleColor,
  ) {
    final now = DateTime.now();
    final currentHourRatio = (now.hour + now.minute / 60.0) / 24.0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF131926).withValues(alpha: 0.85)
            : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.10)
              : Colors.black.withValues(alpha: 0.06),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
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
                isTr ? '24 Saatlik Ritim Çizelgesi' : '24-Hour Rhythm Timeline',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                  color: titleColor,
                ),
              ),
              Text(
                '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} (Şu an)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF38BDF8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Multi-colored 24h Bar with Current Position Pin
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Segmented bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  height: 14,
                  child: Row(
                    children: [
                      // Night to dawn (00:00 - focus start)
                      Expanded(
                        flex: widget.profile.focusWindow.startHour,
                        child: Container(color: const Color(0xFF4F46E5).withValues(alpha: 0.6)),
                      ),
                      // Focus window
                      Expanded(
                        flex: (widget.profile.focusWindow.endHour -
                                widget.profile.focusWindow.startHour)
                            .clamp(1, 24),
                        child: Container(color: const Color(0xFF0284C7)),
                      ),
                      // Energy window
                      Expanded(
                        flex: (widget.profile.energyWindow.endHour -
                                widget.profile.energyWindow.startHour)
                            .clamp(1, 24),
                        child: Container(color: const Color(0xFFD97706)),
                      ),
                      // Light window
                      Expanded(
                        flex: (widget.profile.lightWindow.endHour -
                                widget.profile.lightWindow.startHour)
                            .clamp(1, 24),
                        child: Container(color: const Color(0xFF9333EA)),
                      ),
                      // Remainder of day / night
                      Expanded(
                        flex: (24 - widget.profile.lightWindow.endHour).clamp(1, 24),
                        child: Container(color: const Color(0xFF4F46E5)),
                      ),
                    ],
                  ),
                ),
              ),

              // Current time marker pin
              Positioned(
                left: (MediaQuery.of(context).size.width - 76) * currentHourRatio - 5,
                top: -5,
                child: Container(
                  width: 12,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(color: const Color(0xFF0284C7), width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Hour Markings (00:00, 06:00, 12:00, 18:00, 24:00)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimelineHour('00:00', subtitleColor),
              _buildTimelineHour('06:00', subtitleColor),
              _buildTimelineHour('12:00', subtitleColor),
              _buildTimelineHour('18:00', subtitleColor),
              _buildTimelineHour('24:00', subtitleColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineHour(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 9.5,
        fontWeight: FontWeight.w600,
        color: color.withValues(alpha: 0.8),
      ),
    );
  }

  // ── Circadian Power Window Card ──

  Widget _buildWindowCard(
    BuildContext context, {
    required bool isDark,
    required bool isTr,
    required String badge,
    required String title,
    required String time,
    required String hint,
    required String iconSymbol,
    required Color primary,
    required Color secondary,
    required Color titleColor,
    required Color subtitleColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF131722).withValues(alpha: 0.85)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primary.withValues(alpha: isDark ? 0.22 : 0.16),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: isDark ? 0.08 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primary.withValues(alpha: isDark ? 0.25 : 0.15),
                      secondary.withValues(alpha: isDark ? 0.18 : 0.10),
                    ],
                  ),
                  border: Border.all(
                    color: primary.withValues(alpha: 0.35),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    iconSymbol,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Title, Time Pill & Hint
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Title + Time Pill
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                badge,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.7,
                                  color: primary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                  color: titleColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Time Pill Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: primary.withValues(
                              alpha: isDark ? 0.18 : 0.10,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: primary.withValues(
                                alpha: isDark ? 0.35 : 0.20,
                              ),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 11,
                                color: primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                time,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Hint Description
                    Text(
                      hint,
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.45,
                        color: subtitleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Bottom Pinned Action Bar ──

  Widget _buildBottomActionBar(
    BuildContext context,
    AppLocalizations l10n,
    _ChronoVisuals visuals,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        14 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0F172A).withValues(alpha: 0.88)
            : Colors.white.withValues(alpha: 0.90),
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.10)
                : Colors.black.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.40 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: PressableScale(
            onTap: _onDone,
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    visuals.primary,
                    visuals.secondary,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: visuals.glow.withValues(alpha: 0.40),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.rhythmResultGotIt,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper model for Chronotype visual and editorial assets.
class _ChronoVisuals {
  final String title;
  final String badgeLabel;
  final String persona;
  final String emoji;
  final Color primary;
  final Color secondary;
  final Color glow;
  final Color bgStart;
  final Color bgEnd;
  final String description;

  const _ChronoVisuals({
    required this.title,
    required this.badgeLabel,
    required this.persona,
    required this.emoji,
    required this.primary,
    required this.secondary,
    required this.glow,
    required this.bgStart,
    required this.bgEnd,
    required this.description,
  });
}
