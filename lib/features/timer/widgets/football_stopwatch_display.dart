import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';

class FootballStopwatchDisplay extends StatefulWidget {
  const FootballStopwatchDisplay({
    super.key,
    required this.elapsed,
    required this.isRunning,
  });

  final Duration elapsed;
  final bool isRunning;

  @override
  State<FootballStopwatchDisplay> createState() =>
      _FootballStopwatchDisplayState();
}

class _FootballStopwatchDisplayState extends State<FootballStopwatchDisplay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(covariant FootballStopwatchDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRunning && !oldWidget.isRunning) {
      _controller.repeat();
    } else if (!widget.isRunning && oldWidget.isRunning) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Format elapsed time
    final hours = widget.elapsed.inHours;
    final minutes = widget.elapsed.inMinutes % 60;
    final seconds = widget.elapsed.inSeconds % 60;
    final centiseconds = (widget.elapsed.inMilliseconds % 1000) ~/ 10;

    final timeText =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    final centiText = '.${centiseconds.toString().padLeft(2, '0')}';

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Digital Clock Display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              timeText,
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.w300,
                fontFeatures: const [FontFeature.tabularFigures()],
                letterSpacing: 2,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Lottie Animation
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
            child: DotLottieLoader.fromAsset(
              "assets/animations/ping-pong.lottie",
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
