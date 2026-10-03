import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:mira/features/rhythm/domain/live_rhythm_model.dart';
import 'package:mira/features/rhythm/domain/live_rhythm_repository.dart';
import 'package:mira/features/rhythm/presentation/rhythm_onboarding_screen.dart';
import '../../../../l10n/app_localizations.dart';

/// Elite, aesthetically restored Biological Clock Card.
/// Combines living circadian micro-animations, celestial orbital arcs,
/// window-themed luxury lighting, and organic breathing pulses.
class BiologicalClockArcCard extends StatefulWidget {
  final VoidCallback? onTap;

  const BiologicalClockArcCard({
    super.key,
    this.onTap,
  });

  @override
  State<BiologicalClockArcCard> createState() => _BiologicalClockArcCardState();
}

class _BiologicalClockArcCardState extends State<BiologicalClockArcCard>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  late final AnimationController _shimmerController;
  late final Animation<double> _shimmerAnimation;


  @override
  void initState() {
    super.initState();
    // Smooth breathing aura animation (~3.6s cycle)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..repeat(reverse: true);

    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOutSine,
    );

    // Cosmic starlight shimmer sweep (~4.8s cycle)
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4800),
    )..repeat();

    _shimmerAnimation = CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.linear,
    );

  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  String _getWindowDisplayName(RhythmWindow window, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isTr = l10n.localeName.startsWith('tr');
    switch (window) {
      case RhythmWindow.focus:
        return isTr ? 'Odak Akışı' : l10n.rhythmWindowFocus;
      case RhythmWindow.energy:
        return isTr ? 'Enerji Zamanı' : l10n.rhythmWindowEnergy;
      case RhythmWindow.light:
        return isTr ? 'Hafif Tempo' : l10n.rhythmWindowLight;
      case RhythmWindow.reflection:
        return isTr ? 'İçsel Yansıma' : l10n.rhythmWindowReflection;
    }
  }

  String _formatNextTransition(DateTime? nextTransition) {
    if (nextTransition == null) {
      final now = DateTime.now();
      final defaultNext = now.add(const Duration(hours: 2, minutes: 20));
      return DateFormat('HH:mm').format(defaultNext);
    }
    return DateFormat('HH:mm').format(nextTransition);
  }

  double _calculateDayProgress() {
    final now = DateTime.now();
    // 06:00 (dawn) to 23:00 (night) = 17 hours
    const startHour = 6;
    const totalHours = 17;
    final totalMinutes = totalHours * 60;
    int currentMinutes = (now.hour - startHour) * 60 + now.minute;

    if (currentMinutes < 0) {
      currentMinutes = 0;
    } else if (currentMinutes > totalMinutes) {
      currentMinutes = totalMinutes;
    }

    final ratio = currentMinutes / totalMinutes;
    return (0.08 + ratio * 0.84).clamp(0.08, 0.92);
  }

  _RhythmPalette _getPalette(RhythmWindow window, bool isDark, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isTr = l10n.localeName.startsWith('tr');
    final colorScheme = Theme.of(context).colorScheme;
    switch (window) {
      case RhythmWindow.focus:
        return _RhythmPalette(
          primary: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
          secondary: isDark ? const Color(0xFF818CF8) : const Color(0xFF6366F1),
          glow: const Color(0xFF0EA5E9),
          bgStart: colorScheme.surfaceContainerHigh,
          bgEnd: colorScheme.surface,
          pillBg: isDark
              ? const Color(0xFF0284C7).withValues(alpha: 0.16)
              : const Color(0xFF0284C7).withValues(alpha: 0.10),
          tagLabel: isTr ? 'ODAK AKIŞI' : l10n.rhythmWindowFocus.toUpperCase(),
          iconSymbol: '🧠',
        );
      case RhythmWindow.energy:
        return _RhythmPalette(
          primary: isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
          secondary: isDark ? const Color(0xFFFB923C) : const Color(0xFFEA580C),
          glow: const Color(0xFFF59E0B),
          bgStart: colorScheme.surfaceContainerHigh,
          bgEnd: colorScheme.surface,
          pillBg: isDark
              ? const Color(0xFFD97706).withValues(alpha: 0.16)
              : const Color(0xFFD97706).withValues(alpha: 0.10),
          tagLabel: isTr ? 'ENERJİ ZAMANI' : l10n.rhythmWindowEnergy.toUpperCase(),
          iconSymbol: '⚡',
        );
      case RhythmWindow.light:
        return _RhythmPalette(
          primary: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA),
          secondary: isDark ? const Color(0xFFF472B6) : const Color(0xFFDB2777),
          glow: const Color(0xFFA855F7),
          bgStart: colorScheme.surfaceContainerHigh,
          bgEnd: colorScheme.surface,
          pillBg: isDark
              ? const Color(0xFF9333EA).withValues(alpha: 0.16)
              : const Color(0xFF9333EA).withValues(alpha: 0.10),
          tagLabel: isTr ? 'HAFİF TEMPO' : l10n.rhythmWindowLight.toUpperCase(),
          iconSymbol: '🌤️',
        );
      case RhythmWindow.reflection:
        return _RhythmPalette(
          primary: isDark ? const Color(0xFFA5B4FC) : const Color(0xFF4F46E5),
          secondary: isDark ? const Color(0xFF93C5FD) : const Color(0xFF2563EB),
          glow: const Color(0xFF6366F1),
          bgStart: colorScheme.surfaceContainerHigh,
          bgEnd: colorScheme.surface,
          pillBg: isDark
              ? const Color(0xFF4F46E5).withValues(alpha: 0.16)
              : const Color(0xFF4F46E5).withValues(alpha: 0.10),
          tagLabel: isTr ? 'İÇSEL YANSIMA' : l10n.rhythmWindowReflection.toUpperCase(),
          iconSymbol: '🌙',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isTr = l10n.localeName.startsWith('tr');

    return ListenableBuilder(
      listenable: LiveRhythmRepository.instance,
      builder: (context, _) {
        final profile = LiveRhythmRepository.instance.profile;
        final currentWindow =
            profile?.getCurrentWindow() ?? RhythmWindow.focus;
        final nextTransition = profile?.getNextTransition();
        final windowTitle = _getWindowDisplayName(currentWindow, context);
        final nextTransitionStr = _formatNextTransition(nextTransition);
        final dayProgress = _calculateDayProgress();
        final palette = _getPalette(currentWindow, isDark, context);

        final titleColor = theme.colorScheme.onSurface;

        final subtitleColor = theme.colorScheme.onSurfaceVariant;

        return AnimatedBuilder(
          animation: Listenable.merge([_pulseAnimation, _shimmerAnimation]),
          builder: (context, child) {
            final pulseVal = _pulseAnimation.value;
            final shimmerVal = _shimmerAnimation.value;

            return GestureDetector(
              onTap: widget.onTap ??
                  () {
                    HapticFeedback.lightImpact();
                    if (profile == null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RhythmOnboardingScreen(),
                        ),
                      );
                    }
                  },
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0.85, -0.4),
                    radius: 1.35,
                    colors: [
                      palette.primary.withValues(
                        alpha: isDark
                            ? 0.16 + (0.05 * pulseVal)
                            : 0.10 + (0.04 * pulseVal),
                      ),
                      palette.bgStart,
                      palette.bgEnd,
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isDark
                        ? palette.primary.withValues(alpha: 0.22 + (0.08 * pulseVal))
                        : palette.primary.withValues(alpha: 0.20),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: palette.glow.withValues(
                        alpha: isDark ? 0.14 + (0.06 * pulseVal) : 0.08,
                      ),
                      blurRadius: 18 + (6 * pulseVal),
                      offset: const Offset(0, 5),
                    ),
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.35)
                          : Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Stack(
                    children: [
                      // Ambient background particle glow
                      Positioned(
                        top: -30,
                        right: 20,
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: palette.primary.withValues(
                              alpha: isDark ? 0.09 : 0.06,
                            ),
                          ),
                        ),
                      ),

                      // Card Content
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Left Section: Badges & Window Title
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Live Circadian Status Chip
                                  Row(
                                    children: [
                                      Container(
                                        width: 7,
                                        height: 7,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: palette.primary,
                                          boxShadow: [
                                            BoxShadow(
                                              color: palette.primary.withValues(
                                                alpha: 0.5 + (0.4 * pulseVal),
                                              ),
                                              blurRadius: 4 + (3 * pulseVal),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        isTr
                                            ? 'SİRKADİYEN DÖNGÜ'
                                            : 'CIRCADIAN CYCLE',
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w800,
                                          color: palette.primary,
                                          letterSpacing: 0.9,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),

                                  // Hero Rhythm Window Title with Icon
                                  Row(
                                    children: [
                                      Text(
                                        palette.iconSymbol,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          windowTitle,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            color: titleColor,
                                            letterSpacing: -0.5,
                                            height: 1.15,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Right Section: Living Celestial Arc & Next Transition Badge
                            SizedBox(
                              width: 148,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Animated Celestial Arc
                                  RepaintBoundary(
                                    child: SizedBox(
                                      width: 148,
                                      height: 60,
                                      child: CustomPaint(
                                        painter: _EliteCelestialArcPainter(
                                          progress: dayProgress,
                                          pulse: pulseVal,
                                          shimmer: shimmerVal,
                                          palette: palette,
                                          isDark: isDark,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  // Sleek Next Phase Capsule
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 2.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: palette.pillBg,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: palette.primary.withValues(
                                          alpha: isDark ? 0.25 : 0.18,
                                        ),
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.access_time_rounded,
                                          size: 10.5,
                                          color: palette.primary,
                                        ),
                                        const SizedBox(width: 4),
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: subtitleColor.withValues(alpha: 0.9),
                                            ),
                                            children: [
                                              TextSpan(
                                                text: isTr ? 'Sonraki: ' : 'Next: ',
                                              ),
                                              TextSpan(
                                                text: nextTransitionStr,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: titleColor,
                                                  fontSize: 10.5,
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Helper model for rhythm window visual palettes.
class _RhythmPalette {
  final Color primary;
  final Color secondary;
  final Color glow;
  final Color bgStart;
  final Color bgEnd;
  final Color pillBg;
  final String tagLabel;
  final String iconSymbol;

  const _RhythmPalette({
    required this.primary,
    required this.secondary,
    required this.glow,
    required this.bgStart,
    required this.bgEnd,
    required this.pillBg,
    required this.tagLabel,
    required this.iconSymbol,
  });
}

/// State-of-the-art painter drawing the luminous orbital arc,
/// morning crescent, radiant sun, midnight moon, and animated star node.
class _EliteCelestialArcPainter extends CustomPainter {
  final double progress; // 0.08 to 0.92
  final double pulse; // 0.0 to 1.0 (smooth breath)
  final double shimmer; // 0.0 to 1.0 (continuous sweep)
  final _RhythmPalette palette;
  final bool isDark;

  const _EliteCelestialArcPainter({
    required this.progress,
    required this.pulse,
    required this.shimmer,
    required this.palette,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final startPt = Offset(14, size.height - 8);
    final endPt = Offset(size.width - 14, size.height - 8);
    final controlPt = Offset(size.width / 2, -8);

    // 1. Full Orbital Path (Atmospheric Baseline)
    final basePath = Path()
      ..moveTo(startPt.dx, startPt.dy)
      ..quadraticBezierTo(controlPt.dx, controlPt.dy, endPt.dx, endPt.dy);

    final basePaint = Paint()
      ..color = isDark
          ? const Color(0xFF64748B).withValues(alpha: 0.30)
          : const Color(0xFF94A3B8).withValues(alpha: 0.40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    _drawDashedPath(canvas, basePath, basePaint, dashWidth: 3.5, dashSpace: 3.5);

    // 2. Traversed Active Trail (Glowing Gradient Arc)
    final metrics = basePath.computeMetrics().toList();
    if (metrics.isNotEmpty) {
      final totalLen = metrics.first.length;
      final activeLen = totalLen * ((progress - 0.05) / 0.88).clamp(0.0, 1.0);

      if (activeLen > 0) {
        final activePath = metrics.first.extractPath(0, activeLen);

        // Soft glow bloom stroke
        final bloomPaint = Paint()
          ..shader = LinearGradient(
            colors: [
              palette.secondary.withValues(alpha: 0.35 + (0.15 * pulse)),
              palette.primary.withValues(alpha: 0.50 + (0.20 * pulse)),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.6
          ..strokeCap = StrokeCap.round;
        canvas.drawPath(activePath, bloomPaint);

        // Sharp core stroke
        final activePaint = Paint()
          ..shader = LinearGradient(
            colors: [
              palette.secondary,
              palette.primary,
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8
          ..strokeCap = StrokeCap.round;
        canvas.drawPath(activePath, activePaint);
      }
    }

    // 3. Starlight Shimmer Particle Traveling the Arc
    final shimmerPt = _getBezierPoint(shimmer, startPt, controlPt, endPt);
    final shimmerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45 + (0.40 * math.sin(shimmer * math.pi)))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(shimmerPt, 1.4, shimmerPaint);

    // 4. Dawn Moon (Bottom-Left)
    _drawMoon(canvas, startPt, isLeft: true);

    // 5. Dusk Moon (Bottom-Right)
    _drawMoon(canvas, endPt, isLeft: false);

    // 6. Midday Sun with Radiant Solar Corona (Zenith Peak)
    final sunCenter = _getBezierPoint(0.5, startPt, controlPt, endPt);
    _drawSun(canvas, Offset(sunCenter.dx, sunCenter.dy - 2));

    // 7. Living Current-Time Star Node
    final dotPt = _getBezierPoint(progress, startPt, controlPt, endPt);
    _drawTimeNode(canvas, dotPt);
  }

  Offset _getBezierPoint(double t, Offset p0, Offset p1, Offset p2) {
    final u = 1 - t;
    final tt = t * t;
    final uu = u * u;
    final x = uu * p0.dx + 2 * u * t * p1.dx + tt * p2.dx;
    final y = uu * p0.dy + 2 * u * t * p1.dy + tt * p2.dy;
    return Offset(x, y);
  }

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint, {
    required double dashWidth,
    required double dashSpace,
  }) {
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final length = math.min(dashWidth, metric.length - distance);
        final extractPath = metric.extractPath(distance, distance + length);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  void _drawMoon(Canvas canvas, Offset center, {required bool isLeft}) {
    final moonColor = isLeft
        ? const Color(0xFF60A5FA) // Morning celestial blue
        : const Color(0xFFA78BFA); // Evening starlight lavender

    final paint = Paint()
      ..color = moonColor.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    const r = 7.0;
    final moonPath = Path();

    if (isLeft) {
      moonPath.addArc(
        Rect.fromCircle(center: center, radius: r),
        -math.pi / 2,
        math.pi,
      );
      moonPath.arcToPoint(
        Offset(center.dx, center.dy - r),
        radius: const Radius.circular(r * 0.72),
        clockwise: false,
      );
    } else {
      moonPath.addArc(
        Rect.fromCircle(center: center, radius: r),
        math.pi / 2,
        math.pi,
      );
      moonPath.arcToPoint(
        Offset(center.dx, center.dy + r),
        radius: const Radius.circular(r * 0.72),
        clockwise: false,
      );
    }

    canvas.drawPath(moonPath, paint);

    // Tiny accent twinkle beside the moon
    final twinklePt = Offset(
      center.dx + (isLeft ? -4.5 : 4.5),
      center.dy - 4.0,
    );
    final twinklePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5 + (0.35 * pulse))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(twinklePt, 1.1, twinklePaint);
  }

  void _drawSun(Canvas canvas, Offset center) {
    // 1. Breathing Solar Aura Halo
    final auraPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFF59E0B).withValues(alpha: 0.40 + (0.25 * pulse)),
          const Color(0xFFF59E0B).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 14.0 + (3.0 * pulse)))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 14.0 + (3.0 * pulse), auraPaint);

    // 2. Solar Rays
    final rayPaint = Paint()
      ..color = const Color(0xFFF59E0B).withValues(alpha: 0.85 + (0.15 * pulse))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;

    const rayCount = 8;
    const innerR = 7.5;
    final outerR = 10.2 + (0.8 * pulse);

    for (int i = 0; i < rayCount; i++) {
      final angle = (i * 2 * math.pi) / rayCount;
      final start = Offset(
        center.dx + innerR * math.cos(angle),
        center.dy + innerR * math.sin(angle),
      );
      final end = Offset(
        center.dx + outerR * math.cos(angle),
        center.dy + outerR * math.sin(angle),
      );
      canvas.drawLine(start, end, rayPaint);
    }

    // 3. Vibrant Sun Core
    final corePaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0xFFFEF08A),
          Color(0xFFF59E0B),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 6.0))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 6.0, corePaint);

    // 4. White center sparkle
    final centerSpark = Paint()
      ..color = Colors.white.withValues(alpha: 0.75)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 1.8, centerSpark);
  }

  void _drawTimeNode(Canvas canvas, Offset center) {
    // 1. Vertical alignment plumb-line
    final linePaint = Paint()
      ..color = palette.primary.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;
    canvas.drawLine(center, Offset(center.dx, center.dy + 8), linePaint);

    // 2. Outer Breathing Halo
    final haloPaint = Paint()
      ..color = palette.primary.withValues(
        alpha: 0.28 + (0.18 * pulse),
      )
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 9.5 + (2.5 * pulse), haloPaint);

    // 3. Shadow + Solid White Rim
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.8);
    canvas.drawCircle(Offset(center.dx, center.dy + 1), 5.2, shadowPaint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 5.2, borderPaint);

    // 4. Vibrant Jewel Core (Window Hue)
    final corePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          palette.primary,
          palette.secondary,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 3.8))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 3.8, corePaint);

    // 5. Specular highlight
    final specularPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx - 1.2, center.dy - 1.2), 1.0, specularPaint);
  }

  @override
  bool shouldRepaint(covariant _EliteCelestialArcPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.pulse != pulse ||
        oldDelegate.shimmer != shimmer ||
        oldDelegate.isDark != isDark ||
        oldDelegate.palette != palette;
  }
}
