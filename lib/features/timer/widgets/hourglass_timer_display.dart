import 'package:flutter/material.dart';

class HourglassTimerDisplay extends StatefulWidget {
  const HourglassTimerDisplay({
    super.key,
    required this.remaining,
    required this.totalDuration,
    required this.isRunning,
  });

  final Duration remaining;
  final Duration totalDuration;
  final bool isRunning;

  @override
  State<HourglassTimerDisplay> createState() => _HourglassTimerDisplayState();
}

class _HourglassTimerDisplayState extends State<HourglassTimerDisplay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _grainController;

  @override
  void initState() {
    super.initState();
    _grainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    if (widget.isRunning) {
      _grainController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant HourglassTimerDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRunning != oldWidget.isRunning) {
      if (widget.isRunning) {
        _grainController.repeat();
      } else {
        _grainController.stop();
      }
    }
  }

  @override
  void dispose() {
    _grainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Calculate progress (0.0 means full top/start, 1.0 means full bottom/finished)
    final totalSeconds = widget.totalDuration.inSeconds;
    final remainingSeconds = widget.remaining.inSeconds;

    // Avoid division by zero
    final progress = totalSeconds > 0
        ? 1.0 - (remainingSeconds / totalSeconds)
        : 1.0;

    // Digital time for display
    final hours = widget.remaining.inHours;
    final minutes = widget.remaining.inMinutes % 60;
    final seconds = widget.remaining.inSeconds % 60;
    final timeText = hours > 0
        ? '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'
        : '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Digital Timer Display (Top)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            timeText,
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w300,
              fontFeatures: const [FontFeature.tabularFigures()],
              letterSpacing: 2,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Hourglass Animation
        Expanded(
          child: AnimatedBuilder(
            animation: _grainController,
            builder: (context, child) {
              return CustomPaint(
                painter: _HourglassPainter(
                  progress: progress,
                  isRunning: widget.isRunning && remainingSeconds > 0,
                  grainOffset: _grainController.value,
                  glassColor: isDark ? Colors.grey[700]! : Colors.grey[400]!,
                  sandColor: Colors.amber,
                  woodColor: isDark
                      ? const Color(0xFF5D4037)
                      : const Color(0xFF8D6E63),
                ),
                child: const SizedBox(width: 300, height: 400),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HourglassPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final bool isRunning;
  final double grainOffset;
  final Color glassColor;
  final Color sandColor;
  final Color woodColor;

  _HourglassPainter({
    required this.progress,
    required this.isRunning,
    required this.grainOffset,
    required this.glassColor,
    required this.sandColor,
    required this.woodColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    // Adjusted dimensions for a narrower, more elegant look
    final w = size.width * 0.55; // Much narrower (was 0.8)
    final h = size.height * 0.9;
    final left = cx - w / 2;
    final top = cy - h / 2;
    final bulbHeight = h * 0.45;
    final neckWidth = w * 0.08; // Thinner neck for elegance

    // 1. Draw Wood Frame (Top and Bottom plates)
    final plateHeight = h * 0.05;
    final plateWidth = w * 1.1;
    final platePaint = Paint()
      ..color = woodColor
      ..style = PaintingStyle.fill;

    // Top Plate
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx, top + plateHeight / 2),
          width: plateWidth,
          height: plateHeight,
        ),
        const Radius.circular(4),
      ),
      platePaint,
    );
    // Bottom Plate
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx, top + h - plateHeight / 2),
          width: plateWidth,
          height: plateHeight,
        ),
        const Radius.circular(4),
      ),
      platePaint,
    );

    // Pillars (optional, simple lines)
    final pillarPaint = Paint()
      ..color = woodColor.withOpacity(0.8)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(left, top + plateHeight),
      Offset(left, top + h - plateHeight),
      pillarPaint,
    );
    canvas.drawLine(
      Offset(left + w, top + plateHeight),
      Offset(left + w, top + h - plateHeight),
      pillarPaint,
    );

    // 2. Define Glass Path
    final glassPath = Path();
    // Top Bulb
    glassPath.moveTo(left, top + plateHeight);
    glassPath.quadraticBezierTo(
      left,
      cy,
      cx - neckWidth / 2,
      cy,
    ); // Curve to neck
    glassPath.lineTo(cx + neckWidth / 2, cy); // Neck
    glassPath.quadraticBezierTo(
      left + w,
      cy,
      left + w,
      top + plateHeight,
    ); // Curve to top right
    glassPath
        .close(); // Top part closed (visually) - actually we want full shape

    final fullGlass = Path();
    // Top part
    fullGlass.moveTo(left + w * 0.1, top + plateHeight);
    fullGlass.cubicTo(
      left + w * 0.1,
      cy * 0.8, // cp1
      cx,
      cy * 0.9, // cp2
      cx,
      cy, // end (neck center)
    );
    // Wait, let's use a simpler symmetric shape
    // Reset
    fullGlass.reset();

    // Top bulb
    fullGlass.moveTo(cx - neckWidth / 2, cy);
    fullGlass.quadraticBezierTo(
      cx - w / 2,
      cy - h / 4,
      cx - w / 2,
      top + plateHeight,
    );
    fullGlass.lineTo(cx + w / 2, top + plateHeight);
    fullGlass.quadraticBezierTo(cx + w / 2, cy - h / 4, cx + neckWidth / 2, cy);

    // Bottom bulb
    fullGlass.quadraticBezierTo(
      cx + w / 2,
      cy + h / 4,
      cx + w / 2,
      top + h - plateHeight,
    );
    fullGlass.lineTo(cx - w / 2, top + h - plateHeight);
    fullGlass.quadraticBezierTo(cx - w / 2, cy + h / 4, cx - neckWidth / 2, cy);
    fullGlass.close();

    // Draw Glass Background
    final glassPaint = Paint()
      ..color = glassColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    canvas.drawPath(fullGlass, glassPaint);

    final glassBorderPaint = Paint()
      ..color = glassColor.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawPath(fullGlass, glassBorderPaint);

    // 3. Sand
    // We clip to the glass path
    canvas.save();
    canvas.clipPath(fullGlass);

    final sandPaint = Paint()
      ..color = sandColor
      ..style = PaintingStyle.fill;

    // Top Sand (Decreasing)
    // Height of sand in top bulb depends on (1 - progress)
    // Top bulb area is roughly from (top + plateHeight) to cy
    final topBulbBottom = cy;
    final topBulbTop = top + plateHeight;
    final topBulbHeight = topBulbBottom - topBulbTop;

    // Visual height calculation - assume roughly linear volume for MVP,
    // or maybe sqrt for cleaner "draining" look
    final currentTopSandHeight = topBulbHeight * (1.0 - progress);

    if (currentTopSandHeight > 0) {
      final topSandRect = Rect.fromLTRB(
        left,
        topBulbBottom - currentTopSandHeight,
        left + w,
        topBulbBottom,
      );
      // Rough approximation of surface
      canvas.drawRect(topSandRect, sandPaint);

      // Draw surface detail (flat for now)
      final surfacePaint = Paint()..color = sandColor.withOpacity(0.8);
      canvas.drawLine(
        Offset(left, topBulbBottom - currentTopSandHeight),
        Offset(left + w, topBulbBottom - currentTopSandHeight),
        surfacePaint,
      );
    }

    // Bottom Sand (Increasing)
    final botBulbTop = cy;
    final botBulbBottom = top + h - plateHeight;
    final botBulbHeight = botBulbBottom - botBulbTop;

    // Using simple linear height accumulation.
    // Real hourglass mounds in the middle, but flat is okay for MVP style.
    final currentBotSandHeight = botBulbHeight * progress;

    if (currentBotSandHeight > 0) {
      // Draw a mound shape if possible
      final moundPath = Path();
      moundPath.moveTo(left, botBulbBottom);
      moundPath.lineTo(
        left,
        botBulbBottom - currentBotSandHeight * 0.8,
      ); // edges lower
      // Peak in center
      moundPath.quadraticBezierTo(
        cx,
        botBulbBottom - currentBotSandHeight * 1.2,
        left + w,
        botBulbBottom - currentBotSandHeight * 0.8,
      );
      moundPath.lineTo(left + w, botBulbBottom);
      moundPath.close();

      // Simpler rectangle for clipping safety
      final botSandRect = Rect.fromLTRB(
        left,
        botBulbBottom - currentBotSandHeight,
        left + w,
        botBulbBottom,
      );
      canvas.drawRect(botSandRect, sandPaint);
    }

    // 4. Stream (Falling Sand)
    if (isRunning && progress < 1.0) {
      final streamPaint = Paint()
        ..color = sandColor
        ..strokeWidth = 3;

      // Basic stream from neck to bottom sand surface
      final stopY = botBulbBottom - currentBotSandHeight;
      canvas.drawLine(Offset(cx, cy), Offset(cx, stopY), streamPaint);

      // Add simple grain effect (dots)
      final grainPaint = Paint()..color = Colors.white.withOpacity(0.5);
      // Draw a few random dots falling
      for (int i = 0; i < 3; i++) {
        final r = (grainOffset + i * 0.3) % 1.0;
        final dy = cy + (stopY - cy) * r;
        canvas.drawCircle(Offset(cx, dy), 1.5, grainPaint);
      }
    }

    canvas.restore();

    // Highlights on Glass
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    // Highlight curve left top
    canvas.drawPath(
      Path()
        ..moveTo(cx - w / 2 + 10, top + plateHeight + 10)
        ..quadraticBezierTo(
          cx - w / 2 + 10,
          cy - h / 4,
          cx - neckWidth / 2 - 5,
          cy - 10,
        ),
      highlightPaint,
    );
    // Highlight curve right bottom
    canvas.drawPath(
      Path()
        ..moveTo(cx + neckWidth / 2 + 5, cy + 10)
        ..quadraticBezierTo(
          cx + w / 2 - 10,
          cy + h / 4,
          cx + w / 2 - 10,
          top + h - plateHeight - 10,
        ),
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _HourglassPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isRunning != isRunning ||
        oldDelegate.grainOffset != grainOffset ||
        oldDelegate.glassColor != glassColor;
  }
}
