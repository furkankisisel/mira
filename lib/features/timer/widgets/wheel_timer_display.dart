import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A single digit with iOS-style wheel flip animation.
/// The digit flips like a calendar page when changing values.
class WheelDigit extends StatefulWidget {
  const WheelDigit({
    super.key,
    required this.value,
    this.digitHeight = 80,
    this.digitWidth = 50,
    this.textStyle,
    this.backgroundColor,
    this.dividerColor,
  });

  final int value;
  final double digitHeight;
  final double digitWidth;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? dividerColor;

  @override
  State<WheelDigit> createState() => _WheelDigitState();
}

class _WheelDigitState extends State<WheelDigit>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  int _previousValue = 0;
  int _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _previousValue = widget.value;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void didUpdateWidget(WheelDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = _currentValue;
      _currentValue = widget.value;
      _controller.forward(from: 0);
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
    final colorScheme = theme.colorScheme;
    final bgColor =
        widget.backgroundColor ??
        colorScheme.surfaceContainerHighest.withValues(alpha: 0.6);
    final dividerColor =
        widget.dividerColor ?? colorScheme.outline.withValues(alpha: 0.3);
    final style =
        widget.textStyle ??
        TextStyle(
          fontSize: widget.digitHeight * 0.6,
          fontWeight: FontWeight.w600,
          fontFeatures: const [FontFeature.tabularFigures()],
          color: colorScheme.onSurface,
        );

    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, _) {
        final flipValue = _flipAnimation.value;
        return SizedBox(
          width: widget.digitWidth,
          height: widget.digitHeight,
          child: Stack(
            children: [
              // Bottom half (static, shows new value)
              Positioned(
                top: widget.digitHeight / 2,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: Container(
                    height: widget.digitHeight / 2,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(8),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Transform.translate(
                        offset: Offset(0, -widget.digitHeight / 4),
                        child: Text(_currentValue.toString(), style: style),
                      ),
                    ),
                  ),
                ),
              ),
              // Top half (static, shows previous or current)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: Container(
                    height: widget.digitHeight / 2,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Transform.translate(
                        offset: Offset(0, widget.digitHeight / 4),
                        child: Text(
                          flipValue < 0.5
                              ? _previousValue.toString()
                              : _currentValue.toString(),
                          style: style,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Flipping top half (old value flipping down)
              if (flipValue < 0.5)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.002)
                      ..rotateX(-flipValue * math.pi),
                    child: ClipRect(
                      child: Container(
                        height: widget.digitHeight / 2,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Transform.translate(
                            offset: Offset(0, widget.digitHeight / 4),
                            child: Text(
                              _previousValue.toString(),
                              style: style,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              // Flipping bottom half (new value flipping up)
              if (flipValue >= 0.5)
                Positioned(
                  top: widget.digitHeight / 2,
                  left: 0,
                  right: 0,
                  child: Transform(
                    alignment: Alignment.topCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.002)
                      ..rotateX((1 - flipValue) * math.pi),
                    child: ClipRect(
                      child: Container(
                        height: widget.digitHeight / 2,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(8),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Transform.translate(
                            offset: Offset(0, -widget.digitHeight / 4),
                            child: Text(_currentValue.toString(), style: style),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              // Center divider line
              Positioned(
                top: widget.digitHeight / 2 - 0.5,
                left: 0,
                right: 0,
                child: Container(height: 1, color: dividerColor),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A complete time display with wheel flip animation for HH:MM:SS format.
class WheelTimerDisplay extends StatelessWidget {
  const WheelTimerDisplay({
    super.key,
    required this.hours,
    required this.minutes,
    required this.seconds,
    this.digitHeight = 80,
    this.digitWidth = 50,
    this.showHours = true,
    this.textStyle,
    this.separatorStyle,
    this.backgroundColor,
  });

  final int hours;
  final int minutes;
  final int seconds;
  final double digitHeight;
  final double digitWidth;
  final bool showHours;
  final TextStyle? textStyle;
  final TextStyle? separatorStyle;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sepStyle =
        separatorStyle ??
        TextStyle(
          fontSize: digitHeight * 0.5,
          fontWeight: FontWeight.w300,
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showHours) ...[
          // Hours tens
          WheelDigit(
            value: hours ~/ 10,
            digitHeight: digitHeight,
            digitWidth: digitWidth,
            textStyle: textStyle,
            backgroundColor: backgroundColor,
          ),
          const SizedBox(width: 2),
          // Hours ones
          WheelDigit(
            value: hours % 10,
            digitHeight: digitHeight,
            digitWidth: digitWidth,
            textStyle: textStyle,
            backgroundColor: backgroundColor,
          ),
          const SizedBox(width: 8),
          Text(':', style: sepStyle),
          const SizedBox(width: 8),
        ],
        // Minutes tens
        WheelDigit(
          value: minutes ~/ 10,
          digitHeight: digitHeight,
          digitWidth: digitWidth,
          textStyle: textStyle,
          backgroundColor: backgroundColor,
        ),
        const SizedBox(width: 2),
        // Minutes ones
        WheelDigit(
          value: minutes % 10,
          digitHeight: digitHeight,
          digitWidth: digitWidth,
          textStyle: textStyle,
          backgroundColor: backgroundColor,
        ),
        const SizedBox(width: 8),
        Text(':', style: sepStyle),
        const SizedBox(width: 8),
        // Seconds tens
        WheelDigit(
          value: seconds ~/ 10,
          digitHeight: digitHeight,
          digitWidth: digitWidth,
          textStyle: textStyle,
          backgroundColor: backgroundColor,
        ),
        const SizedBox(width: 2),
        // Seconds ones
        WheelDigit(
          value: seconds % 10,
          digitHeight: digitHeight,
          digitWidth: digitWidth,
          textStyle: textStyle,
          backgroundColor: backgroundColor,
        ),
      ],
    );
  }
}
