import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

enum TimerDialMode {
  stopwatch,
  countdown,
  pomodoro,
}

/// A bespoke, luxury dial & precision counter for the Mira timer.
/// Replaces cartoonish animations with a Swiss mechanical chronograph inspired
/// architectural dial, subtle organic breathing aura, and tabular monospace figures.
class EliteTimerDial extends StatefulWidget {
  const EliteTimerDial({
    super.key,
    required this.mode,
    required this.duration,
    this.totalDuration,
    required this.isRunning,
    required this.accentColor,
    this.isWorkPhase = true,
    this.pomodoroCycle = 0,
    this.pomodoroTotalCycles = 4,
    this.onTap,
    this.size,
  });

  final TimerDialMode mode;
  final Duration duration;
  final Duration? totalDuration;
  final bool isRunning;
  final Color accentColor;
  final bool isWorkPhase;
  final int pomodoroCycle;
  final int pomodoroTotalCycles;
  final VoidCallback? onTap;
  final double? size;

  @override
  State<EliteTimerDial> createState() => _EliteTimerDialState();
}

class _EliteTimerDialState extends State<EliteTimerDial>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    if (widget.isRunning) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant EliteTimerDial oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRunning != oldWidget.isRunning) {
      if (widget.isRunning) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.animateTo(0.0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut);
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  double _calculateProgress() {
    switch (widget.mode) {
      case TimerDialMode.stopwatch:
        // Elegant 60-second sweep loop
        final ms = widget.duration.inMilliseconds;
        return ((ms % 60000) / 60000.0).clamp(0.0, 1.0);

      case TimerDialMode.countdown:
      case TimerDialMode.pomodoro:
        final total = widget.totalDuration;
        if (total == null || total.inMilliseconds <= 0) return 0.0;
        final rem = widget.duration.inMilliseconds;
        return (rem / total.inMilliseconds).clamp(0.0, 1.0);
    }
  }

  Color _resolvePhaseColor(BuildContext context) {
    if (widget.mode == TimerDialMode.pomodoro) {
      return widget.isWorkPhase
          ? widget.accentColor
          : const Color(0xFF10B981); // Emerald green for break
    }
    return widget.accentColor;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final activeColor = _resolvePhaseColor(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableMax = math.min(constraints.maxWidth, constraints.maxHeight);
        final dialSize = widget.size ??
            (availableMax.isFinite && availableMax > 120
                ? availableMax.clamp(230.0, 280.0)
                : 260.0);

        final progress = _calculateProgress();

        return AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Center(
              child: GestureDetector(
                onTap: widget.onTap,
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: dialSize,
                  height: dialSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Dial Canvas (Aura, Bezel Disc, Radial Ticks, Progress Arc, Glowing Bead)
                      CustomPaint(
                        size: Size(dialSize, dialSize),
                        painter: _EliteDialPainter(
                          progress: progress,
                          pulseValue: _pulseController.value,
                          isRunning: widget.isRunning,
                          accentColor: activeColor,
                          isDark: isDark,
                          mode: widget.mode,
                        ),
                      ),

                      // Center Display Information
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 26),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 1. Top Context Pill
                            _buildTopContextPill(context, activeColor, isDark, l10n),

                            const SizedBox(height: 10),

                            // 2. Tabular Digits
                            _buildHeroDigits(context, activeColor, isDark),

                            const SizedBox(height: 10),

                            // 3. Integrated Bottom Indicators
                            _buildBottomIndicator(context, activeColor, isDark, l10n),
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

  Widget _buildTopContextPill(
    BuildContext context,
    Color activeColor,
    bool isDark,
    AppLocalizations l10n,
  ) {
    String label;
    IconData icon;
    bool showLiveDot = false;

    switch (widget.mode) {
      case TimerDialMode.stopwatch:
        label = l10n.timerTabStopwatch.toUpperCase();
        icon = Icons.timer_outlined;
        showLiveDot = widget.isRunning;
        break;

      case TimerDialMode.countdown:
        final hasDuration =
            widget.totalDuration != null && widget.totalDuration!.inSeconds > 0;
        if (!hasDuration) {
          label = l10n.timerSetDurationFirst;
          icon = Icons.touch_app_rounded;
        } else {
          final totalMins = widget.totalDuration!.inMinutes;
          label = totalMins > 0 ? 'HEDEF: $totalMins DK' : l10n.timerTabCountdown.toUpperCase();
          icon = Icons.hourglass_empty_rounded;
        }
        break;

      case TimerDialMode.pomodoro:
        if (widget.isWorkPhase) {
          label = l10n.timerPomodoroWorkPhase.toUpperCase();
          icon = Icons.local_fire_department_rounded;
        } else {
          label = l10n.timerPomodoroBreakPhase.toUpperCase();
          icon = Icons.coffee_rounded;
        }
        break;
    }

    final pillBg = activeColor.withValues(alpha: isDark ? 0.16 : 0.10);
    final pillBorder = activeColor.withValues(alpha: isDark ? 0.32 : 0.22);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
      decoration: BoxDecoration(
        color: pillBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: pillBorder, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLiveDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: activeColor,
                boxShadow: [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.6),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
          ] else ...[
            Icon(icon, size: 12, color: activeColor),
            const SizedBox(width: 4.5),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: activeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroDigits(BuildContext context, Color activeColor, bool isDark) {
    final textTheme = Theme.of(context).textTheme;
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final mutedTextColor =
        isDark ? Colors.white.withValues(alpha: 0.50) : const Color(0xFF64748B);

    if (widget.mode == TimerDialMode.stopwatch) {
      final hours = widget.duration.inHours;
      final minutes = widget.duration.inMinutes % 60;
      final seconds = widget.duration.inSeconds % 60;
      final centiseconds = (widget.duration.inMilliseconds % 1000) ~/ 10;

      final mainPart = hours > 0
          ? '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'
          : '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      final csPart = '.${centiseconds.toString().padLeft(2, '0')}';

      final mainFontSize = hours > 0 ? 34.0 : 44.0;
      final csFontSize = hours > 0 ? 18.0 : 22.0;

      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            mainPart,
            style: textTheme.headlineLarge?.copyWith(
              fontSize: mainFontSize,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.0,
              color: primaryTextColor,
              fontFeatures: const [ui.FontFeature.tabularFigures()],
            ),
          ),
          Text(
            csPart,
            style: textTheme.titleMedium?.copyWith(
              fontSize: csFontSize,
              fontWeight: FontWeight.w600,
              color: mutedTextColor,
              fontFeatures: const [ui.FontFeature.tabularFigures()],
            ),
          ),
        ],
      );
    } else {
      // Countdown & Pomodoro
      final hasDuration =
          widget.totalDuration != null && widget.totalDuration!.inSeconds > 0;

      if (widget.mode == TimerDialMode.countdown && !hasDuration) {
        return Text(
          '00:00',
          style: textTheme.headlineLarge?.copyWith(
            fontSize: 44.0,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.0,
            color: mutedTextColor.withValues(alpha: 0.5),
            fontFeatures: const [ui.FontFeature.tabularFigures()],
          ),
        );
      }

      final hours = widget.duration.inHours;
      final minutes = widget.duration.inMinutes % 60;
      final seconds = widget.duration.inSeconds % 60;

      final timeText = hours > 0
          ? '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'
          : '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

      final fontSize = hours > 0 ? 36.0 : 46.0;

      return Text(
        timeText,
        style: textTheme.headlineLarge?.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.0,
          color: primaryTextColor,
          fontFeatures: const [ui.FontFeature.tabularFigures()],
        ),
      );
    }
  }

  Widget _buildBottomIndicator(
    BuildContext context,
    Color activeColor,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final mutedTextColor =
        isDark ? Colors.white.withValues(alpha: 0.45) : const Color(0xFF64748B);

    switch (widget.mode) {
      case TimerDialMode.stopwatch:
        final statusText = widget.isRunning
            ? 'ÇALIŞIYOR'
            : (widget.duration.inSeconds > 0 ? 'DURAKLATILDI' : 'HAZIR');
        return Text(
          statusText,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: widget.isRunning
                ? activeColor
                : mutedTextColor,
          ),
        );

      case TimerDialMode.countdown:
        final hasDuration =
            widget.totalDuration != null && widget.totalDuration!.inSeconds > 0;
        if (!hasDuration) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Süre belirlemek için dokunun',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: activeColor.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios_rounded, size: 10, color: activeColor),
            ],
          );
        }

        final remMs = widget.duration.inMilliseconds;
        final totMs = widget.totalDuration!.inMilliseconds;
        final pct = totMs > 0 ? ((totMs - remMs) / totMs).clamp(0.0, 1.0) : 0.0;
        final pctInt = (pct * 100).toInt();

        return Text(
          widget.isRunning ? '%$pctInt Tamamlandı' : 'Kalan: ${_formatSimple(widget.duration)}',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: mutedTextColor,
          ),
        );

      case TimerDialMode.pomodoro:
        // Integrated Pomodoro Cycle Capsules
        final totalCycles = widget.pomodoroTotalCycles;
        final completedInCycle = widget.pomodoroCycle % totalCycles;
        final currentCycleIndex = completedInCycle;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(totalCycles, (index) {
                final isCompleted = index < currentCycleIndex;
                final isCurrent = index == currentCycleIndex;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  width: isCurrent ? 20 : 12,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: isCompleted || (isCurrent && widget.isWorkPhase)
                        ? activeColor
                        : (isDark
                            ? Colors.white.withValues(alpha: 0.15)
                            : Colors.black.withValues(alpha: 0.12)),
                    boxShadow: isCurrent && widget.isRunning
                        ? [
                            BoxShadow(
                              color: activeColor.withValues(alpha: 0.45),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                );
              }),
            ),
            const SizedBox(height: 5),
            Text(
              'Tur ${currentCycleIndex + 1} / $totalCycles',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: mutedTextColor,
              ),
            ),
          ],
        );
    }
  }

  String _formatSimple(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

/// Custom painter rendering the luxury mechanical dial, micro-ticks,
/// smooth progress sweep arc, ambient breathing aura, and glowing head.
class _EliteDialPainter extends CustomPainter {
  const _EliteDialPainter({
    required this.progress,
    required this.pulseValue,
    required this.isRunning,
    required this.accentColor,
    required this.isDark,
    required this.mode,
  });

  final double progress;
  final double pulseValue;
  final bool isRunning;
  final Color accentColor;
  final bool isDark;
  final TimerDialMode mode;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 10;
    final trackRadius = radius - 18;

    // 1. Organic Ambient Aura Glow (Behind Dial)
    if (isRunning) {
      final auraPaint = Paint()
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 16 + 10 * pulseValue)
        ..color = accentColor.withValues(alpha: 0.08 + 0.12 * pulseValue);
      canvas.drawCircle(center, radius + 2, auraPaint);
    }

    // 2. Bezel Disc (Soft matte background with subtle depth)
    final discRect = Rect.fromCircle(center: center, radius: radius);
    final discPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(center.dx, center.dy - radius),
        Offset(center.dx, center.dy + radius),
        isDark
            ? [const Color(0xFF191F2D), const Color(0xFF111520)]
            : [Colors.white, const Color(0xFFF3F6FA)],
      );
    canvas.drawCircle(center, radius, discPaint);

    // Bezel border
    final discBorder = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.05);
    canvas.drawCircle(center, radius, discBorder);

    // 3. Precision Radial Micro-Ticks (60 ticks around circumference)
    final tickStartRadius = radius - 4;
    final majorTickColor = accentColor.withValues(alpha: isDark ? 0.65 : 0.50);
    final minorTickColor = isDark
        ? Colors.white.withValues(alpha: 0.16)
        : Colors.black.withValues(alpha: 0.12);

    final tickPaint = Paint()..strokeCap = StrokeCap.round;

    for (int i = 0; i < 60; i++) {
      final angle = (i * 2 * math.pi / 60) - (math.pi / 2);
      final isMajor = i % 5 == 0;
      final tickLength = isMajor ? 7.0 : 3.5;

      tickPaint.strokeWidth = isMajor ? 1.8 : 1.0;
      tickPaint.color = isMajor ? majorTickColor : minorTickColor;

      final p1 = Offset(
        center.dx + tickStartRadius * math.cos(angle),
        center.dy + tickStartRadius * math.sin(angle),
      );
      final p2 = Offset(
        center.dx + (tickStartRadius - tickLength) * math.cos(angle),
        center.dy + (tickStartRadius - tickLength) * math.sin(angle),
      );

      canvas.drawLine(p1, p2, tickPaint);
    }

    // 4. Background Track Ring
    final trackBgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.5
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.06)
          : Colors.black.withValues(alpha: 0.05);
    canvas.drawCircle(center, trackRadius, trackBgPaint);

    // 5. Active Progress Arc
    if (progress > 0.002) {
      final sweepAngle = (2 * math.pi * progress).clamp(0.01, 2 * math.pi);
      final startAngle = -math.pi / 2;

      final arcRect = Rect.fromCircle(center: center, radius: trackRadius);
      final arcPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7.0
        ..strokeCap = StrokeCap.round
        ..shader = ui.Gradient.sweep(
          center,
          [
            accentColor.withValues(alpha: 0.70),
            accentColor,
          ],
          [0.0, 1.0],
          TileMode.clamp,
          startAngle,
          startAngle + sweepAngle,
        );

      canvas.drawArc(arcRect, startAngle, sweepAngle, false, arcPaint);

      // 6. Luminous Head Indicator Bead
      final tipAngle = startAngle + sweepAngle;
      final tipX = center.dx + trackRadius * math.cos(tipAngle);
      final tipY = center.dy + trackRadius * math.sin(tipAngle);
      final tipOffset = Offset(tipX, tipY);

      // Soft glow aura around bead
      final haloPaint = Paint()
        ..color = accentColor.withValues(alpha: 0.40)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
      canvas.drawCircle(tipOffset, 6.0, haloPaint);

      // Solid bright white center
      final beadPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(tipOffset, 3.5, beadPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _EliteDialPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.pulseValue != pulseValue ||
        oldDelegate.isRunning != isRunning ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.isDark != isDark ||
        oldDelegate.mode != mode;
  }
}
