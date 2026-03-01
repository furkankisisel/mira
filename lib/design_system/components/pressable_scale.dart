import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../design_system/tokens/durations.dart';

class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.scale = .94,
    this.duration = AppDurations.fast,
  });
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final Duration duration;
  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  void _set(bool v) => setState(() => _pressed = v);

  void _handleTap() {
    if (widget.onTap != null) {
      HapticFeedback.lightImpact();
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => _set(true) : null,
      onTapUp: widget.onTap != null ? (_) => _set(false) : null,
      onTapCancel: widget.onTap != null ? () => _set(false) : null,
      onTap: widget.onTap != null ? _handleTap : null,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _pressed ? widget.scale : 1,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
