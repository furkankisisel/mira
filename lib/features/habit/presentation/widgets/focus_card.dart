import 'package:flutter/material.dart';

import '../../domain/habit_model.dart';
import '../../domain/habit_types.dart';
import '../../domain/daily_task_model.dart';
import '../../domain/subtask_model.dart';
import '../../../../design_system/tokens/colors.dart';
import '../../../timer/timer_screen.dart';

/// Golden ratio constant for proportional design
const double phi = 1.618033988749895;

/// A hero card displaying the daily focus item with AI motivation.
///
/// Uses golden ratio proportions for aesthetically pleasing layout.
class FocusCard extends StatefulWidget {
  const FocusCard({
    super.key,
    this.habit,
    this.dailyTask,
    this.aiMessage,
    this.isLoadingAi = false,
    required this.onComplete,
    required this.onRemoveFocus,
    this.onRefreshAi,
    this.onValueUpdate,
    this.subtasks,
    this.onSubtaskToggle,
  });

  /// The habit if focus type is habit
  final Habit? habit;

  /// The daily task if focus type is dailyTask
  final DailyTask? dailyTask;

  /// AI-generated motivation message
  final String? aiMessage;

  /// Whether AI message is being loaded
  final bool isLoadingAi;

  /// Called when the focus item is completed
  final VoidCallback onComplete;

  /// Called when focus is removed
  final VoidCallback onRemoveFocus;

  /// Called to refresh AI message
  final VoidCallback? onRefreshAi;

  /// Called when numerical/timer value is updated
  final Function(int)? onValueUpdate;

  /// Subtasks for subtask-type habits
  final List<Subtask>? subtasks;

  /// Called when a subtask is toggled
  final Function(String, bool)? onSubtaskToggle;

  @override
  State<FocusCard> createState() => _FocusCardState();
}

class _FocusCardState extends State<FocusCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String get _title {
    if (widget.habit != null) return widget.habit!.title;
    if (widget.dailyTask != null) return widget.dailyTask!.title;
    return '';
  }

  String get _description {
    if (widget.habit != null) return widget.habit!.description;
    if (widget.dailyTask != null) return widget.dailyTask!.description;
    return '';
  }

  String? get _emoji {
    if (widget.habit != null) return widget.habit!.emoji;
    return null;
  }

  Color get _color {
    if (widget.habit != null) return widget.habit!.color;
    return AppColors.accentBlue;
  }

  bool get _isCompleted {
    if (widget.habit != null) return widget.habit!.isCompleted;
    if (widget.dailyTask != null) return widget.dailyTask!.isDone;
    return false;
  }

  /// Returns the appropriate icon based on habit type
  IconData _getHabitTypeIcon() {
    if (_isCompleted) return Icons.check_rounded;
    if (widget.habit == null) return Icons.check_circle_outline; // Daily task

    switch (widget.habit!.habitType) {
      case HabitType.timer:
        return Icons.timer_outlined;
      case HabitType.numerical:
        return Icons.tag;
      case HabitType.subtasks:
        return Icons.checklist_rounded;
      case HabitType.simple:
      case HabitType.checkbox:
        return Icons.check_circle_outline;
    }
  }

  double get _progress {
    if (widget.habit == null) return _isCompleted ? 1.0 : 0.0;
    final habit = widget.habit!;
    if (habit.habitType == HabitType.simple ||
        habit.habitType == HabitType.checkbox) {
      return habit.isCompleted ? 1.0 : 0.0;
    }
    if (habit.targetCount <= 0) return 0.0;
    return (habit.currentStreak / habit.targetCount).clamp(0.0, 1.0);
  }

  String get _progressText {
    if (widget.habit == null) return '';
    final habit = widget.habit!;
    if (habit.habitType == HabitType.simple ||
        habit.habitType == HabitType.checkbox) {
      return '';
    }
    final unit = habit.unit ?? '';
    return '${habit.currentStreak} / ${habit.targetCount} $unit';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Golden ratio based dimensions
    const cardPadding = 16.0;
    final innerPadding = cardPadding / phi; // ~9.9
    const iconSize = 48.0;

    // Calculate background color based on completion
    final backgroundColor = _isCompleted
        ? _color
        : Color.alphaBlend(
            _color.withValues(alpha: 0.08),
            colorScheme.surfaceContainerHighest,
          );
    final onColor = _isCompleted
        ? (_color.computeLuminance() < 0.5 ? Colors.white : Colors.black)
        : colorScheme.onSurface;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isCompleted ? 1.0 : _pulseAnimation.value,
          child: child,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // AI Message moved to top
          if (widget.aiMessage != null)
            _buildAiMessage(theme, colorScheme, onColor),

          // The main card
          Container(
            margin: EdgeInsets.symmetric(horizontal: cardPadding, vertical: 8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: _color.withValues(alpha: _isCompleted ? 0.3 : 0.15),
                  blurRadius: _isCompleted ? 24 : 16,
                  offset: const Offset(0, 8),
                  spreadRadius: _isCompleted ? 2 : 0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _handleTap,
                onLongPress: _showOptionsMenu,
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card Content (Title, Description, Icon)
                      Row(
                        children: [
                          // Icon container
                          Container(
                            width: iconSize,
                            height: iconSize,
                            decoration: BoxDecoration(
                              color: _isCompleted
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : _color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: _emoji != null && _emoji!.isNotEmpty
                                  ? Text(
                                      _emoji!,
                                      style: const TextStyle(fontSize: 28),
                                    )
                                  : Icon(
                                      _isCompleted
                                          ? Icons.check_circle
                                          : Icons.flag_rounded,
                                      color: _isCompleted
                                          ? Colors.white
                                          : _color,
                                      size: 28,
                                    ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Title and description
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _title,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: onColor,
                                    decoration: _isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (_description.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    _description,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: onColor.withValues(alpha: 0.7),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // Status indicator with habit-specific icon
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _color.withValues(alpha: 0.15),
                              border: Border.all(
                                color: _color.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                _getHabitTypeIcon(),
                                color: _color,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _progress,
                          minHeight: 6,
                          backgroundColor: onColor.withValues(alpha: 0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _isCompleted ? Colors.white : _color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiMessage(
    ThemeData theme,
    ColorScheme colorScheme,
    Color onColor,
  ) {
    if (widget.aiMessage == null && !widget.isLoadingAi)
      return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: _buildAiMessageSection(theme, colorScheme, onColor),
    );
  }

  Widget _buildAiMessageSection(
    ThemeData theme,
    ColorScheme colorScheme,
    Color onColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: _color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_awesome, size: 14, color: _color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: widget.isLoadingAi
                ? _buildLoadingAnimation(theme)
                : Text(
                    widget.aiMessage ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
          ),
          if (widget.onRefreshAi != null && !widget.isLoadingAi)
            IconButton(
              onPressed: widget.onRefreshAi,
              icon: Icon(
                Icons.refresh_rounded,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
              visualDensity: VisualDensity.compact,
              tooltip: 'Yenile',
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingAnimation(ThemeData theme) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(_color),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Motivasyon hazırlanıyor...',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  void _handleTap() {
    // Check if we can toggle completion
    // For simple habits and daily tasks, toggle completion (both complete and undo)
    if (widget.dailyTask != null ||
        (widget.habit != null &&
            (widget.habit!.habitType == HabitType.simple ||
                widget.habit!.habitType == HabitType.checkbox))) {
      widget.onComplete();
    } else if (widget.habit != null) {
      // For numerical/timer habits, show input dialog
      _showValueInputDialog();
    }
  }

  void _showValueInputDialog() {
    if (widget.habit == null || widget.onValueUpdate == null) return;

    final habit = widget.habit!;
    final isTimer = habit.habitType == HabitType.timer;
    final controller = TextEditingController(
      text: habit.currentStreak.toString(),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
          top: 12,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.outlineVariant.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Değer Gir', // TODO: Localize
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              if (isTimer) ...[
                SizedBox(
                  height: 64,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const TimerScreen()),
                      );
                    },
                    icon: const Icon(Icons.play_arrow_rounded, size: 32),
                    label: const Text(
                      "Süre Tut", // TODO: Localize
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.seed.withValues(alpha: 0.9),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Theme.of(
                          context,
                        ).colorScheme.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "veya manuel gir", // TODO: Localize
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Theme.of(
                          context,
                        ).colorScheme.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: !isTimer,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  labelText: habit.unit ?? 'Değer',
                  hintText: 'Hedef: ${habit.targetCount}',
                  prefixIcon: const Icon(
                    Icons.edit_note_rounded,
                    color: AppColors.seed,
                  ),
                  filled: true,
                  fillColor: AppColors.seed.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(20),
                ),
                onSubmitted: (_) {
                  final value = int.tryParse(controller.text.trim());
                  if (value != null && value >= 0) {
                    widget.onValueUpdate!(value);
                    Navigator.pop(ctx);
                  }
                },
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'İptal',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        final value = int.tryParse(controller.text.trim());
                        if (value != null && value >= 0) {
                          widget.onValueUpdate!(value);
                          Navigator.pop(ctx);
                        }
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Kaydet',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final colorScheme = Theme.of(ctx).colorScheme;
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.close_rounded, color: colorScheme.error),
                  title: const Text('Odağı Kaldır'),
                  onTap: () {
                    Navigator.pop(ctx);
                    widget.onRemoveFocus();
                  },
                ),
                if (widget.onRefreshAi != null)
                  ListTile(
                    leading: const Icon(Icons.refresh_rounded),
                    title: const Text('Motivasyonu Yenile'),
                    onTap: () {
                      Navigator.pop(ctx);
                      widget.onRefreshAi!();
                    },
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
