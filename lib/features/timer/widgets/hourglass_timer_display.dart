import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'dart:ui';

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
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(covariant HourglassTimerDisplay oldWidget) {
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

        // Squirrel Animation
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
            child: DotLottieLoader.fromAsset(
              "assets/animations/Squirrel running.lottie",
              frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
                if (dotlottie != null) {
                  return Lottie.memory(
                    dotlottie.animations.values.single,
                    controller: _controller,
                    fit: BoxFit.contain,
                    onLoaded: (composition) {
                      _controller.duration = composition.duration;
                      if (widget.isRunning) {
                        _controller.repeat();
                      }
                    },
                  );
                } else {
                  return const SizedBox(
                    width: 100,
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
              errorBuilder: (ctx, e, s) {
                return Center(child: Text("Animation Error: $e"));
              },
            ),
          ),
        ),
      ],
    );
  }
}
