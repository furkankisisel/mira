import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/habit_model.dart';
import '../../domain/habit_types.dart';
import '../../domain/subtask_model.dart';

/// Renders a single habit row in the timeline view matching the user's reference design:
/// - Left: Time label (09:00, 12:30, 15:00) + vertical dashed timeline track + colored node dot.
/// - Right: Soft pastel pill card with avatar icon, title, subtitle (e.g. "20 dk"), and circular checkbox.
/// Tapping triggers previous completion animation for simple habits, or opens the data entry dialog for advanced habits.
class TimelineHabitRow extends StatefulWidget {
  final Habit habit;
  final String timeLabel;
  final bool isFirst;
  final bool isLast;
  final int currentProgress;
  final bool? isCompleted;
  final List<Subtask>? subtasks;
  final VoidCallback onTap;
  final VoidCallback? onToggle;
  final VoidCallback? onAdvancedTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onGoToRoom;

  const TimelineHabitRow({
    super.key,
    required this.habit,
    required this.timeLabel,
    required this.isFirst,
    required this.isLast,
    this.currentProgress = 0,
    this.isCompleted,
    this.subtasks,
    required this.onTap,
    this.onToggle,
    this.onAdvancedTap,
    this.onLongPress,
    this.onGoToRoom,
  });

  @override
  State<TimelineHabitRow> createState() => _TimelineHabitRowState();
}

class _TimelineHabitRowState extends State<TimelineHabitRow>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final AnimationController _completionController;
  late final Animation<double> _bounceAnimation;
  late final Animation<double> _badgeScaleAnimation;
  late final Animation<double> _sparkleAnimation;
  late final Animation<double> _rippleAnimation;
  late final Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
      reverseDuration: const Duration(milliseconds: 140),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _completionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.025)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.025, end: 0.995)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.995, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_completionController);

    _badgeScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.75, end: 1.25)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.25, end: 1.0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 55,
      ),
    ]).animate(CurvedAnimation(
      parent: _completionController,
      curve: const Interval(0.0, 0.75),
    ));

    _sparkleAnimation = CurvedAnimation(
      parent: _completionController,
      curve: const Interval(0.1, 0.85, curve: Curves.easeOutCubic),
    );

    _rippleAnimation = CurvedAnimation(
      parent: _completionController,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOutQuad),
    );

    _shimmerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _completionController,
        curve: const Interval(0.05, 0.95, curve: Curves.easeInOutCubic),
      ),
    );

    final bool initialDone = widget.isCompleted ?? widget.habit.isCompleted;
    if (initialDone) {
      _completionController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _completionController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TimelineHabitRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldDone = oldWidget.isCompleted ?? oldWidget.habit.isCompleted;
    final newDone = widget.isCompleted ?? widget.habit.isCompleted;

    if (!oldDone && newDone) {
      _completionController.forward(from: 0.0);
      HapticFeedback.mediumImpact();
    } else if (oldDone && !newDone) {
      _completionController.reset();
    }
  }

  void _handleTapDown(TapDownDetails _) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails _) async {
    final isAdvanced = widget.habit.habitType == HabitType.numerical ||
        widget.habit.habitType == HabitType.timer ||
        widget.habit.habitType == HabitType.subtasks;

    final isDone = widget.isCompleted ?? widget.habit.isCompleted;

    if (!isAdvanced) {
      if (!isDone) {
        _completionController.forward(from: 0.0);
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    } else {
      HapticFeedback.lightImpact();
    }

    if (isAdvanced) {
      if (widget.onAdvancedTap != null) {
        widget.onAdvancedTap!();
      } else {
        widget.onTap();
      }
    } else {
      if (widget.onToggle != null) {
        widget.onToggle!();
      } else {
        widget.onTap();
      }
    }

    await Future.delayed(const Duration(milliseconds: 70));
    if (mounted) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  void _handleCheckboxTap() {
    final isAdvanced = widget.habit.habitType == HabitType.numerical ||
        widget.habit.habitType == HabitType.timer ||
        widget.habit.habitType == HabitType.subtasks;

    final isDone = widget.isCompleted ?? widget.habit.isCompleted;

    if (!isAdvanced) {
      if (!isDone) {
        _completionController.forward(from: 0.0);
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    } else {
      HapticFeedback.selectionClick();
    }

    if (isAdvanced && widget.onAdvancedTap != null) {
      widget.onAdvancedTap!();
    } else if (widget.onToggle != null) {
      widget.onToggle!();
    } else {
      widget.onTap();
    }
  }

  double _calculateProgress() {
    final isDone = widget.isCompleted ?? widget.habit.isCompleted;
    if (isDone) return 1.0;

    if (widget.habit.habitType == HabitType.subtasks) {
      final subtasks = widget.subtasks ?? widget.habit.subtasks;
      if (subtasks.isNotEmpty) {
        final doneCount = subtasks.where((s) => s.isCompleted).length;
        return (doneCount / subtasks.length).clamp(0.0, 1.0);
      }
      return 0.0;
    }

    if (widget.habit.targetCount > 0) {
      return (widget.currentProgress / widget.habit.targetCount)
          .clamp(0.0, 1.0);
    }

    return 0.0;
  }

  String? _resolveMetricProgress() {
    final habit = widget.habit;
    final isDone = widget.isCompleted ?? habit.isCompleted;

    if (habit.habitType == HabitType.numerical ||
        habit.habitType == HabitType.timer) {
      final unitStr = habit.unit?.isNotEmpty == true
          ? ' ${habit.unit}'
          : (habit.habitType == HabitType.timer ? ' dk' : '');
      if (isDone) {
        return 'Tamamlandı (${habit.targetCount}$unitStr)';
      }
      return '${widget.currentProgress} / ${habit.targetCount}$unitStr';
    }
    if (habit.habitType == HabitType.subtasks) {
      final subtasks = widget.subtasks ?? habit.subtasks;
      if (subtasks.isNotEmpty) {
        final done = subtasks.where((s) => s.isCompleted).length;
        if (isDone) {
          return 'Tüm alt görevler yapıldı (${subtasks.length}/${subtasks.length})';
        }
        return '$done / ${subtasks.length} alt görev tamamlandı';
      }
    }
    if (habit.targetCount > 0 && habit.unit != null && habit.unit!.isNotEmpty) {
      return 'Hedef: ${habit.targetCount} ${habit.unit}';
    }
    return null;
  }

  Widget _buildCheckboxBadge({
    required bool isDone,
    required Color habitColor,
    required bool isDark,
    required double progress,
  }) {
    final bool hasPartialProgress = !isDone && progress > 0.0;

    return AnimatedBuilder(
      animation: _completionController,
      builder: (context, _) {
        final rippleProgress = _rippleAnimation.value;
        final sparkleProgress = _sparkleAnimation.value;
        final isCompletedAnimating =
            _completionController.isAnimating && isDone;

        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Celebratory Sparkles burst
            if (sparkleProgress > 0.0 && sparkleProgress < 1.0)
              Positioned(
                left: -20,
                top: -20,
                right: -20,
                bottom: -20,
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _SparklePainter(
                      progress: sparkleProgress,
                      primaryColor: habitColor,
                    ),
                  ),
                ),
              ),

            // Expanding ripple halo ring
            if (rippleProgress > 0.0 && rippleProgress < 1.0)
              IgnorePointer(
                child: Container(
                  width: 28 + (rippleProgress * 28),
                  height: 28 + (rippleProgress * 28),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: habitColor.withValues(
                        alpha: (1.0 - rippleProgress) * 0.75,
                      ),
                      width: 2.0 * (1.0 - rippleProgress * 0.5),
                    ),
                  ),
                ),
              ),

            // Main Checkbox Circle
            ScaleTransition(
              scale: isCompletedAnimating
                  ? _badgeScaleAnimation
                  : const AlwaysStoppedAnimation(1.0),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _handleCheckboxTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? Colors.white
                        : (hasPartialProgress
                            ? habitColor.withValues(alpha: 0.12)
                            : Colors.transparent),
                    border: Border.all(
                      color: isDone
                          ? Colors.white
                          : (hasPartialProgress
                              ? habitColor.withValues(alpha: 0.3)
                              : (isDark
                                  ? const Color(0xFF64748B)
                                  : const Color(0xFF94A3B8))),
                      width: 1.8,
                    ),
                    boxShadow: isDone
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Circular progress arc for partial progress
                      if (hasPartialProgress)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _StatusRingPainter(
                              progress: progress,
                              color: habitColor,
                              trackColor: habitColor.withValues(alpha: 0.15),
                              strokeWidth: 2.5,
                            ),
                          ),
                        ),

                      if (isDone)
                        Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: habitColor,
                        )
                      else if (hasPartialProgress &&
                          widget.habit.habitType == HabitType.timer)
                        Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: habitColor,
                        )
                      else if (hasPartialProgress &&
                          widget.habit.habitType == HabitType.numerical)
                        Icon(
                          Icons.tag,
                          size: 14,
                          color: habitColor,
                        )
                      else if (hasPartialProgress &&
                          widget.habit.habitType == HabitType.subtasks)
                        Icon(
                          Icons.checklist_rounded,
                          size: 14,
                          color: habitColor,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final habit = widget.habit;
    final habitColor = habit.color;
    final isDone = widget.isCompleted ?? habit.isCompleted;
    final progress = _calculateProgress();
    final habitDesc = habit.description.trim();
    final hasDescription = habitDesc.isNotEmpty;
    final metricProgress = _resolveMetricProgress();
    final hasRoomName = habit.isRoomHabit &&
        habit.roomName != null &&
        habit.roomName!.trim().isNotEmpty;
    final String? subtitleText = hasRoomName
        ? (hasDescription
            ? '${habit.roomName!.trim()} • $habitDesc'
            : (metricProgress != null
                ? '${habit.roomName!.trim()} • $metricProgress'
                : habit.roomName!.trim()))
        : (hasDescription ? habitDesc : metricProgress);
    final onCompleted =
        habitColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;

    // Subtle pastel background tint tailored to habit color
    final cardBg = Color.alphaBlend(
      habitColor.withOpacity(isDark ? 0.14 : 0.08),
      theme.colorScheme.surfaceContainerHigh,
    );

    final cardBorder =
        isDark ? habitColor.withOpacity(0.22) : habitColor.withOpacity(0.12);

    final titleColor =
        isDone ? onCompleted : theme.colorScheme.onSurface;

    final subtitleColor = isDone
        ? onCompleted.withValues(alpha: 0.85)
        : theme.colorScheme.onSurfaceVariant;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Left: Time Label + Timeline Track & Dot ──
          SizedBox(
            width: 68,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Time string (e.g., "09:00", "12:30", "15:00")
                Padding(
                  padding: const EdgeInsets.only(bottom: 9.0),
                  child: SizedBox(
                    width: 38,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        widget.timeLabel,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                // Timeline vertical track with colored node dot
                Expanded(
                  child: CustomPaint(
                    painter: _TimelineNodePainter(
                      color: habitColor,
                      isFirst: widget.isFirst,
                      isLast: widget.isLast,
                      isDark: isDark,
                      isDone: isDone,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ── Right: Soft Pastel Habit Card with Squish & Bounce Animation ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, bottom: 9.0),
              child: ScaleTransition(
                scale: _bounceAnimation,
                child: ScaleTransition(
                  scale: _scale,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTapDown: _handleTapDown,
                      onTapUp: _handleTapUp,
                      onTapCancel: _handleTapCancel,
                      onLongPress: widget.onLongPress,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDone
                                ? habitColor.withValues(alpha: 0.40)
                                : cardBorder,
                            width: 1.1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDone
                                  ? habitColor.withValues(
                                      alpha: isDark ? 0.30 : 0.22,
                                    )
                                  : habitColor.withOpacity(0.04),
                              blurRadius: isDone ? 16 : 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              // ── Progress Fill Layer (Dolma Animasyonu) ──
                              Positioned.fill(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return TweenAnimationBuilder<double>(
                                      duration:
                                          const Duration(milliseconds: 520),
                                      curve: Curves.easeOutCubic,
                                      tween: Tween<double>(
                                        begin: 0.0,
                                        end: progress,
                                      ),
                                      builder: (context, animProgress, _) {
                                        final fillWidth = (constraints
                                                    .maxWidth *
                                                animProgress)
                                            .clamp(0.0, constraints.maxWidth);

                                        return Stack(
                                          children: [
                                            // 1. The liquid gradient fill
                                            if (animProgress > 0)
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  width: fillWidth,
                                                  height: constraints.maxHeight,
                                                  decoration: BoxDecoration(
                                                    gradient: isDone
                                                        ? LinearGradient(
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                            colors: [
                                                              habitColor
                                                                  .withValues(
                                                                alpha: isDark
                                                                    ? 0.88
                                                                    : 0.92,
                                                              ),
                                                              habitColor,
                                                            ],
                                                          )
                                                        : LinearGradient(
                                                            begin: Alignment
                                                                .centerLeft,
                                                            end: Alignment
                                                                .centerRight,
                                                            colors: [
                                                              habitColor
                                                                  .withValues(
                                                                alpha: isDark
                                                                    ? 0.12
                                                                    : 0.08,
                                                              ),
                                                              habitColor
                                                                  .withValues(
                                                                alpha: isDark
                                                                    ? 0.32
                                                                    : 0.24,
                                                              ),
                                                            ],
                                                          ),
                                                  ),
                                                ),
                                              ),

                                            // 2. Leading edge indicator (tactile neon line)
                                            if (!isDone &&
                                                animProgress > 0.02 &&
                                                animProgress < 0.99)
                                              Positioned(
                                                left: (fillWidth - 3.5).clamp(
                                                  0.0,
                                                  constraints.maxWidth - 3.5,
                                                ),
                                                top: 3,
                                                bottom: 3,
                                                child: Container(
                                                  width: 3.5,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        habitColor.withValues(
                                                      alpha: 0.90,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: habitColor
                                                            .withValues(
                                                          alpha: 0.55,
                                                        ),
                                                        blurRadius: 7,
                                                        spreadRadius: 0.5,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                            // 3. Shimmer beam on completion
                                            if (isDone)
                                              AnimatedBuilder(
                                                animation:
                                                    _completionController,
                                                builder: (context, _) {
                                                  if (_shimmerAnimation.value <=
                                                          0.0 ||
                                                      _shimmerAnimation.value >=
                                                          1.0) {
                                                    return const SizedBox
                                                        .shrink();
                                                  }
                                                  return CustomPaint(
                                                    size: Size(
                                                      constraints.maxWidth,
                                                      constraints.maxHeight,
                                                    ),
                                                    painter: _ShimmerPainter(
                                                      progress:
                                                          _shimmerAnimation
                                                              .value,
                                                      color: Colors.white
                                                          .withValues(
                                                        alpha: 0.35,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              // ── Foreground Card Content ──
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 13,
                                  vertical: 8.5,
                                ),
                                child: Row(
                                  children: [
                                    // Circular Avatar Icon with matching pastel tint
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isDone
                                                ? Colors.white
                                                    .withValues(alpha: 0.22)
                                                : habitColor.withOpacity(0.18),
                                          ),
                                          child: habit.emoji != null &&
                                                  habit.emoji!.isNotEmpty
                                              ? Text(
                                                  habit.emoji!,
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                  ),
                                                )
                                              : Icon(
                                                  habit.icon,
                                                  color: isDone
                                                      ? onCompleted
                                                      : habitColor,
                                                  size: 18,
                                                ),
                                        ),
                                        if (habit.isRoomHabit)
                                          Positioned(
                                            right: -2.5,
                                            bottom: -2.5,
                                            child: Container(
                                              padding: const EdgeInsets.all(2.5),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isDark
                                                    ? const Color(0xFF1E293B)
                                                    : Colors.white,
                                                border: Border.all(
                                                  color: isDone
                                                      ? onCompleted
                                                          .withValues(alpha: 0.4)
                                                      : habitColor
                                                          .withValues(alpha: 0.35),
                                                  width: 1,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withValues(alpha: 0.18),
                                                    blurRadius: 3,
                                                    offset: const Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Icon(
                                                Icons.groups_rounded,
                                                size: 9.5,
                                                color: isDone
                                                    ? onCompleted
                                                    : habitColor,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),

                                    const SizedBox(width: 12),

                                    // Title & Subtitle
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            habit.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14.5,
                                              fontWeight: FontWeight.w700,
                                              color: titleColor,
                                              letterSpacing: -0.2,
                                              decoration: isDone
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                          if (subtitleText != null &&
                                              subtitleText.isNotEmpty) ...[
                                            const SizedBox(height: 1.5),
                                            Text(
                                              subtitleText,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w400,
                                                color: subtitleColor,
                                                height: 1.15,
                                                decoration: isDone
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    // Checkbox Badge with Sparkle / Ripple / Ring
                                    _buildCheckboxBadge(
                                      isDone: isDone,
                                      habitColor: habitColor,
                                      isDark: isDark,
                                      progress: progress,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for drawing vertical dashed track and centered node dot.
class _TimelineNodePainter extends CustomPainter {
  final Color color;
  final bool isFirst;
  final bool isLast;
  final bool isDark;
  final bool isDone;

  const _TimelineNodePainter({
    required this.color,
    required this.isFirst,
    required this.isLast,
    required this.isDark,
    this.isDone = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    // Align with vertical center of habit card (offset by bottom margin)
    final centerY = (size.height - 12) / 2;

    final linePaint = Paint()
      ..color = isDark
          ? const Color(0xFF334155).withOpacity(0.7)
          : const Color(0xFFCBD5E1).withOpacity(0.9)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 1. Draw top dashed line
    if (!isFirst) {
      _drawDashedVerticalLine(canvas, centerX, 0, centerY - 8, linePaint);
    }

    // 2. Draw bottom dashed line
    if (!isLast) {
      _drawDashedVerticalLine(
          canvas, centerX, centerY + 8, size.height, linePaint);
    }

    // 3. Draw Colored Node Circle Dot
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (isDone) {
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
      canvas.drawCircle(Offset(centerX, centerY), 8.0, glowPaint);
    }

    canvas.drawCircle(Offset(centerX, centerY), 6.0, dotPaint);

    // Subtle white inner ring for depth
    final innerPaint = Paint()
      ..color = Colors.white.withOpacity(0.40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(Offset(centerX, centerY), 4.5, innerPaint);
  }

  void _drawDashedVerticalLine(
    Canvas canvas,
    double x,
    double startY,
    double endY,
    Paint paint,
  ) {
    if (startY >= endY) return;
    const dashLength = 3.5;
    const dashSpace = 3.0;
    double y = startY;
    while (y < endY) {
      final len = (y + dashLength > endY) ? (endY - y) : dashLength;
      canvas.drawLine(Offset(x, y), Offset(x, y + len), paint);
      y += dashLength + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _TimelineNodePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.isFirst != isFirst ||
        oldDelegate.isLast != isLast ||
        oldDelegate.isDark != isDark ||
        oldDelegate.isDone != isDone;
  }
}

class _ShimmerPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color color;

  _ShimmerPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0 || progress >= 1.0) return;
    final width = size.width;
    final height = size.height;
    final currentX = -width * 0.4 + (width * 1.8) * progress;

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withValues(alpha: 0.0),
          color.withValues(alpha: 0.40),
          color.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(currentX - 60, 0, 120, height));

    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);
  }

  @override
  bool shouldRepaint(covariant _ShimmerPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class _SparklePainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color primaryColor;

  _SparklePainter({required this.progress, required this.primaryColor});

  static const _offsets = [
    Offset(1.0, 0.0),
    Offset(0.707, 0.707),
    Offset(0.0, 1.0),
    Offset(-0.707, 0.707),
    Offset(-1.0, 0.0),
    Offset(-0.707, -0.707),
    Offset(0.0, -1.0),
    Offset(0.707, -0.707),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0 || progress >= 1.0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final double distance = 14.0 + progress * 24.0;
    final double opacity = (1.0 - progress).clamp(0.0, 1.0);
    final double radius = (1.0 - progress * 0.5) * 2.8;

    final colors = [
      primaryColor,
      const Color(0xFFFFD54F), // Amber/gold
      Colors.white,
      primaryColor.withValues(alpha: 0.85),
    ];

    for (int i = 0; i < _offsets.length; i++) {
      final offset = _offsets[i];
      final pos = center + offset * distance;
      final paint = Paint()
        ..color = colors[i % colors.length].withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pos, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparklePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.primaryColor != primaryColor;
}

class _StatusRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  _StatusRingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    this.strokeWidth = 2.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    // Active progress arc
    if (progress > 0.0) {
      final arcPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      const startAngle = -math.pi / 2;
      final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        arcPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StatusRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.trackColor != trackColor;
}
