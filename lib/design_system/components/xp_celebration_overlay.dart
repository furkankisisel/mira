import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Ultra-modern, tactile, and aesthetic XP celebration banner with
/// spring physics, glowing claymorphic capsule, and subtle particle sparkles.
class XpCelebrationToast extends StatefulWidget {
  final int amount;
  final Color primaryColor;

  const XpCelebrationToast({
    super.key,
    required this.amount,
    required this.primaryColor,
  });

  @override
  State<XpCelebrationToast> createState() => _XpCelebrationToastState();
}

class _XpCelebrationToastState extends State<XpCelebrationToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _particleAnimation;

  final List<_SparkleParticle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    // Trigger crisp tactical haptic feedback
    HapticFeedback.mediumImpact();

    // Generate random particle trajectories
    for (int i = 0; i < 8; i++) {
      final angle = (i * (2 * math.pi / 8)) + (_random.nextDouble() * 0.4 - 0.2);
      final distance = 36.0 + _random.nextDouble() * 24.0;
      final size = 4.0 + _random.nextDouble() * 4.0;
      _particles.add(
        _SparkleParticle(
          dx: math.cos(angle) * distance,
          dy: math.sin(angle) * distance,
          size: size,
          icon: i % 2 == 0 ? '✦' : '★',
        ),
      );
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    // Spring entrance scale (0.0 -> 1.08 -> 1.0)
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.2, end: 1.06)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.06, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.85)
            .chain(CurveTween(curve: Curves.easeInBack)),
        weight: 15,
      ),
    ]).animate(_controller);

    // Slide down from top, hold, then exit upwards
    _slideAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: -40.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(0.0),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -40.0)
            .chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 15,
      ),
    ]).animate(_controller);

    // Fade in quickly, hold, fade out at the very end
    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 15,
      ),
    ]).animate(_controller);

    // Particle burst timing (bursts out early and fades)
    _particleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.05, 0.45, curve: Curves.easeOutQuad),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Sparkle particle burst
                  if (_particleAnimation.value < 1.0)
                    ..._particles.map((p) {
                      final pProgress = _particleAnimation.value;
                      final currentDx = p.dx * pProgress;
                      final currentDy = p.dy * pProgress;
                      final pOpacity = (1.0 - pProgress).clamp(0.0, 1.0);

                      return Positioned(
                        left: currentDx,
                        top: currentDy,
                        child: Opacity(
                          opacity: pOpacity,
                          child: Text(
                            p.icon,
                            style: TextStyle(
                              fontSize: p.size,
                              color: const Color(0xFFFFD700),
                              shadows: [
                                Shadow(
                                  color: const Color(0xFFF59E0B).withValues(alpha: 0.8),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                  // Glowing claymorphic capsule
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFF59E0B), // Vibrant Gold
                          Color(0xFFD97706), // Amber
                          Color(0xFFB45309), // Deep Amber
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.45),
                        width: 1.3,
                      ),
                      boxShadow: [
                        // Ambient Gold Glow
                        BoxShadow(
                          color: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.45 : 0.35),
                          blurRadius: 18,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                        // Soft Depth Shadow
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.20),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animated Star Badge
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.22),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.50),
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '⚡',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Points text
                        Text(
                          '+${widget.amount} XP',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.4,
                            decoration: TextDecoration.none,
                            shadows: [
                              Shadow(
                                color: Color(0x66000000),
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 6),

                        // Mini "Kazanıldı" pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'KAZANILDI',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                              decoration: TextDecoration.none,
                            ),
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
  }
}

class _SparkleParticle {
  final double dx;
  final double dy;
  final double size;
  final String icon;

  _SparkleParticle({
    required this.dx,
    required this.dy,
    required this.size,
    required this.icon,
  });
}
