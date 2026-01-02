import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';

/// Pomodoro timer için domates şeklinde görüntü widget'ı
class TomatoTimerDisplay extends StatefulWidget {
  const TomatoTimerDisplay({
    super.key,
    required this.remaining,
    required this.totalDuration,
    required this.isRunning,
  });

  final Duration remaining;
  final Duration totalDuration;
  final bool isRunning;

  @override
  State<TomatoTimerDisplay> createState() => _TomatoTimerDisplayState();
}

class _TomatoTimerDisplayState extends State<TomatoTimerDisplay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(covariant TomatoTimerDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRunning != oldWidget.isRunning) {
      if (widget.isRunning) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Format time
    final minutes = widget.remaining.inMinutes;
    final seconds = widget.remaining.inSeconds % 60;
    final timeText =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: 280,
        height: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Lottie Animation
            Lottie.asset(
              'assets/animations/tomato.json',
              controller: _controller,
              onLoaded: (composition) {
                _controller.duration = composition.duration;
                if (widget.isRunning) {
                  _controller.repeat();
                } else {
                  _controller.stop(); // Ensure it starts stopped if not running
                }
              },
              fit: BoxFit.contain,
            ),

            // Time display overlay
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  timeText,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
