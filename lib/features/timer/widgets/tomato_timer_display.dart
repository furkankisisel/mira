import 'dart:math' as math;
import 'package:flutter/material.dart';

class TomatoTimerDisplay extends StatefulWidget {
  const TomatoTimerDisplay({
    super.key,
    required this.remaining,
    required this.totalDuration,
  });

  final Duration remaining;
  final Duration totalDuration;

  @override
  State<TomatoTimerDisplay> createState() => _TomatoTimerDisplayState();
}

class _TomatoTimerDisplayState extends State<TomatoTimerDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // We can use this controller for subtle idle animations or smoothing if needed.
    // For now, we'll just drive the display directly from the props.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate rotation angle.
    // 60 minutes = 360 degrees.
    // 0 minutes = 0 degrees.
    // The dial usually goes from 0 to 55 or 60.
    // Let's assume a standard 60-minute kitchen timer.
    // If the total duration is > 60m, we might need to adjust, but standard Pomodoro is <= 60m.

    final totalSeconds = 60 * 60; // 60 minutes max for the dial visuals
    final remainingSeconds = widget.remaining.inSeconds;

    // The timer rotates clockwise to 0. Use 0-60 layout.
    // Angle 0 is at the top.
    // Let's say we want to show the specific value on the dial.
    // The rotation should align the "remaining minutes" mark to the pointer.
    // If the pointer is at the bottom-left (like in the image, or standard designs),
    // we need to rotate the top hemisphere so the number aligns.
    // But typically kitchen timers rotate the top part.
    // Let's assume the pointer is fixed on the body (e.g., usually a small arrow on the base).
    // And the top rotates.

    // In the image provided:
    // It looks like a standard tomato timer.
    // There is a small arrow (triangle) on the bottom body, pointing UP.
    // The numbers 0, 5, 10... are on the rotating top part.
    // 0 is the starting point. When you twist it to 25, the '25' aligns with the arrow.
    // Then it ticks back to 0.
    // So the rotation angle is proportional to the remaining time.

    // For side view:
    // We want the tick for 'remainingSeconds' to be at the center (theta=0).
    // The painter calculates theta = tickAngle - angle.
    // So we should pass angle = tickAngle.
    final angle = (remainingSeconds / 3600) * 2 * math.pi;
    final maxMinutes = (widget.totalDuration.inMinutes > 0)
        ? widget.totalDuration.inMinutes
        : 60;

    return SizedBox(
      width: 300,
      height: 300,
      child: CustomPaint(
        painter: TomatoTimerPainter(
          angle: angle,
          maxMinutes: maxMinutes,
          textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class TomatoTimerPainter extends CustomPainter {
  final double angle;
  final int maxMinutes;
  final TextStyle textStyle;

  TomatoTimerPainter({
    required this.angle,
    required this.maxMinutes,
    required this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Use slightly less than half width to leave room using padding/aspect ratio
    final radius = math.min(size.width, size.height) / 2.2;
    // Scale vertical radius to look like a flattened tomato sideways
    final radiusY = radius * 0.85;

    // 1. Draw Shadow
    final shadowPath = Path()
      ..addOval(
        Rect.fromCenter(
          center: center.translate(0, radiusY * 0.95),
          width: radius * 1.8,
          height: radius * 0.25,
        ),
      );
    canvas.drawPath(
      shadowPath,
      Paint()
        ..color = Colors.black.withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Helper to draw lobes
    void drawLobes(
      Canvas canvas,
      double yStart,
      double yEnd,
      double rotationOffset,
      bool isTop,
    ) {
      final lobePaint = Paint()
        ..color = Color(0xFFB71C1C)
            .withOpacity(0.3) // Dark shadow for creases
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2; // Soft crease
      // ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2); // Blur makes it look softer

      // Fixed number of lobes, e.g., 6 around the 360 degrees
      const lobeCount = 8;

      for (int i = 0; i < lobeCount; i++) {
        final lobeAngleBase = (i / lobeCount) * 2 * math.pi;

        // Apply rotation
        var theta = lobeAngleBase - rotationOffset;

        // Wrap
        while (theta > math.pi) theta -= 2 * math.pi;
        while (theta <= -math.pi) theta += 2 * math.pi;

        // Visible if front facing
        if (theta.abs() < math.pi / 2.2) {
          // Slightly cut off edge to avoid drawing on outline
          final x = center.dx + radius * math.sin(theta);

          // Draw arc from yStart to yEnd passing through x
          // Simple approximation: Quadratic bezier or just a line since it's vertical?
          // No, longitude lines curve towards the poles (center x).
          // At equator (yEnd for top), x is max width. At pole (yStart for top), x is center ??
          // Actually for a sphere, longitude lines converge at poles.
          // Top pole: center.dy - radiusY. Bottom pole: center.dy + radiusY.
          // Seam: center.dy.
          // At seam, width is full. At poles, width is 0.

          final path = Path();
          path.moveTo(center.dx, yStart); // Pole
          // Control point to curve it out to 'x' at 'midY'?
          // Quadratic bezier from Pole(0) to Equator(x).
          // Control point should be roughly at (x, midY)?
          // Let's assume Equator is at yEnd (for top).
          // Actually, yStart is pole, yEnd is equator.

          // path.quadraticBezierTo(x, (yStart + yEnd)/2, x, yEnd);
          // Wait. At Equator (yEnd), the x is 'x'. At Pole (yStart), x is center.
          // So curve from center to x.
          final controlY = (yStart + yEnd) / 2;
          // Pulling control point out:
          path.quadraticBezierTo(x + (x - center.dx) * 0.2, controlY, x, yEnd);

          canvas.drawPath(path, lobePaint);
        }
      }
    }

    // 2. Draw Bottom Body (Fixed)
    // Semi-ellipse for bottom half
    final bottomRect = Rect.fromCenter(
      center: center,
      width: radius * 2,
      height: radiusY * 2,
    );

    final bottomPath = Path();
    bottomPath.moveTo(center.dx - radius, center.dy);
    bottomPath.arcTo(bottomRect, math.pi, -math.pi, false); // Bottom arc
    bottomPath.lineTo(center.dx - radius, center.dy);
    bottomPath.close();

    final bodyGradient = RadialGradient(
      center: const Alignment(0.4, -0.4), // Light coming from top-left roughly
      radius: 0.8,
      colors: [
        const Color(0xFFFF5252),
        const Color(0xFFD32F2F),
        const Color(0xFFB71C1C),
      ],
      stops: const [0.0, 0.6, 1.0],
    );

    final bottomPaint = Paint()..shader = bodyGradient.createShader(bottomRect);
    canvas.drawPath(bottomPath, bottomPaint);

    // Draw Bottom Lobes (Fixed - Rotation 0)
    canvas.save();
    canvas.clipPath(bottomPath);
    drawLobes(canvas, center.dy + radiusY, center.dy, 0.0, false);
    canvas.restore();

    // 3. Draw Fixed Pointer on Bottom Body
    // Triangle pointing UP at center
    final pointerPaint = Paint()..color = Colors.white;
    final pointerPath = Path();
    final pointerSize = 8.0; // Size of triangle

    // Position: Center x, just below the seam (center.dy)
    // Seam is at center.dy
    final pointerTipY = center.dy + 4; // Slight gap

    pointerPath.moveTo(center.dx, pointerTipY - pointerSize); // Tip
    pointerPath.lineTo(
      center.dx - pointerSize / 1.5,
      pointerTipY + pointerSize / 2,
    );
    pointerPath.lineTo(
      center.dx + pointerSize / 1.5,
      pointerTipY + pointerSize / 2,
    );
    pointerPath.close();

    canvas.drawPath(pointerPath, pointerPaint);

    // 4. Draw Top Body (Rotating - visually simulated)
    final topPath = Path();
    topPath.moveTo(center.dx - radius, center.dy);
    topPath.arcTo(bottomRect, math.pi, math.pi, false); // Top arc
    topPath.lineTo(center.dx - radius, center.dy);
    topPath.close();

    // Rotating top background
    // To make lobes rotate correctly including the silhouette, strictly speaking the outline shouldn't change if it's a perfect solid of revolution.
    // Since tomatoes are lobed, the outline changes slightly as it rotates.
    // For simplicity, we keep the outline static circular, but simulate lobes via shading.

    final topPaint = Paint()..shader = bodyGradient.createShader(bottomRect);
    canvas.drawPath(topPath, topPaint);

    // Draw Top Lobes (Rotating - Uses 'angle')
    canvas.save();
    canvas.clipPath(topPath);
    // Top Pole: center.dy - radiusY. Equator: center.dy.
    drawLobes(canvas, center.dy - radiusY, center.dy, angle, true);
    canvas.restore();

    // Stem on top (Rotates with top?)
    // If it's the winder, it rotates.
    final stemPaint = Paint()..color = const Color(0xFF2E7D32);
    canvas.save();
    // Simple 2D rotation of stem image is ok if we assume looking from side.
    // Or we can simulate 3D rotation of leaves.
    // Let's just draw stem static at top center for now, or rotating in 2D?
    // A tomato stem is usually centered. 3D rotation would mean leaves come in/out of view.
    // Let's keep stem simple static or slight wobble?
    // Actually, "Ust yarim donsun" -> Top rotates.
    // If we simply rotate the leaves in 2D around the top center point?
    // Top center point is (center.dx, center.dy - radiusY).

    // Let's draw stem relative to rotation 'angle'.
    // We visualize it top-down projected to side?
    // Effectively x = sin(angle + leafAngle).
    // Let's stick to the previous simple logic but maybe vary the width of leaves based on angle?
    // Simpler: Draw static stem at top to maintain clean look, assuming the user holds the base and twists the tomato body?
    // Usually you hold base, twist top. So stem rotates.
    // Let's animate leaf rotation.

    final stemCenter = Offset(center.dx, center.dy - radiusY);
    canvas.translate(stemCenter.dx, stemCenter.dy);
    // Draw flattened leaves
    // We can just draw indices.

    for (int i = 0; i < 5; i++) {
      double leafRot = (i / 5) * 2 * math.pi - angle; // Rotate
      // Project to 2D side view.
      // y is compressed. x is full.
      // z determines visibility.
      double lx = 20.0 * math.sin(leafRot);
      double ly = 8.0 * math.cos(leafRot); // Elliptical orbit
      double lz = math.cos(leafRot);

      if (lz > -0.5) {
        // Draw if mostly front or side
        final path = Path();
        path.moveTo(0, 0);
        path.quadraticBezierTo(lx * 1.2, ly * 1.2 - 5, lx, ly + 5);
        // Draw leaf
        canvas.drawPath(
          path,
          stemPaint
            ..strokeWidth = 3
            ..style = PaintingStyle.stroke,
        );
      }
    }

    // Draw center stalk
    canvas.drawRect(
      Rect.fromLTWH(-4, -6, 8, 8),
      stemPaint..style = PaintingStyle.fill,
    );

    canvas.restore();

    // 5. Draw Ticks and Numbers along the seam on the Top Body
    canvas.save();
    canvas.clipRect(
      Rect.fromLTWH(0, 0, size.width, center.dy),
    ); // Clip to top half

    final tickPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Loop 0..60
    for (int i = 0; i <= 60; i++) {
      if (i > maxMinutes) continue;

      final tickRad = (i / 60) * 2 * math.pi;
      var theta = tickRad - angle; // Use angle directly as calculated in Widget

      // Wrap theta
      while (theta > math.pi) theta -= 2 * math.pi;
      while (theta <= -math.pi) theta += 2 * math.pi;

      if (theta.abs() < math.pi / 2.2) {
        final x = center.dx + radius * math.sin(theta);

        // Follow the curve of the body?
        // At equator, it's straight down (in side view, the rim is vertical-ish?)
        // Actually, the rim is the horizon. Ticks go UP from the rim?
        // Or checks go ON the face.
        // Let's draw them slightly above the seam line.

        final isMajor = i % 5 == 0;
        final tickH = isMajor ? 10.0 : 6.0;
        final tickYBase = center.dy - 2;

        canvas.drawLine(
          Offset(x, tickYBase),
          Offset(x, tickYBase - tickH),
          tickPaint,
        );

        if (isMajor) {
          textPainter.text = TextSpan(
            text: '$i',
            style: textStyle.copyWith(
              fontSize: 14,
              color: Colors.white.withOpacity(
                ((math.pi / 2.2 - theta.abs()) / (math.pi / 2.2)).clamp(
                  0.2,
                  1.0,
                ),
              ),
            ),
          );
          textPainter.layout();
          textPainter.paint(
            canvas,
            Offset(
              x - textPainter.width / 2,
              tickYBase - tickH - textPainter.height - 2,
            ),
          );
        }
      }
    }

    canvas.restore();

    // Gloss
    final glossPaint = Paint()..color = Colors.white.withOpacity(0.15);
    final glossPath = Path();
    glossPath.addOval(
      Rect.fromCenter(
        center: center.translate(-radius * 0.4, -radiusY * 0.4),
        width: radius * 0.3,
        height: radiusY * 0.3,
      ),
    );
    canvas.drawPath(glossPath, glossPaint);
  }

  @override
  bool shouldRepaint(covariant TomatoTimerPainter oldDelegate) {
    return oldDelegate.angle != angle;
  }
}
