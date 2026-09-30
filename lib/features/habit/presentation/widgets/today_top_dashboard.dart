import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../vision/data/vision_model.dart';
import '../../../vision/data/vision_repository.dart';
import '../../../vision/presentation/vision_wizard_screen.dart';
import '../../domain/daily_task_model.dart';
import '../../domain/daily_task_repository.dart';
import '../../domain/habit_model.dart';
import '../../domain/habit_repository.dart';
import '../../domain/habit_types.dart';
import 'daily_task_dialog.dart';

/// Top dashboard for the Today screen.
/// Places the Swipeable Vision Deck Card and the Scrollable Daily Tasks Card
/// side-by-side in a single row at the top of the Today screen.
class TodayTopDashboard extends StatelessWidget {
  final DateTime date;
  final VoidCallback? onOpenGoals;
  final VoidCallback? onAddTask;

  const TodayTopDashboard({
    super.key,
    required this.date,
    this.onOpenGoals,
    this.onAddTask,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
      child: SizedBox(
        height: 158,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left: Vision Deck Card (swipes vertically to switch visions)
            Expanded(
              child: _VisionDeckSwipeCard(
                date: date,
                onOpenGoals: onOpenGoals,
              ),
            ),
            const SizedBox(width: 12),
            // Right: Daily Tasks Card (scrollable vertically)
            Expanded(
              child: _DailyTasksScrollCard(
                date: date,
                onAddTask: onAddTask,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. VISION DECK SWIPE CARD (Yukarı / Aşağı Kart Atma Animasyonu)
// ─────────────────────────────────────────────────────────────────────────────

class _VisionDeckSwipeCard extends StatefulWidget {
  final DateTime date;
  final VoidCallback? onOpenGoals;

  const _VisionDeckSwipeCard({
    required this.date,
    this.onOpenGoals,
  });

  @override
  State<_VisionDeckSwipeCard> createState() => _VisionDeckSwipeCardState();
}

class _VisionDeckSwipeCardState extends State<_VisionDeckSwipeCard>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  double _dragDy = 0.0;

  late AnimationController _animController;
  Animation<double>? _throwAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  static bool _isHabitScheduledForDate(Habit habit, DateTime date) {
    final checkDate = DateTime(date.year, date.month, date.day);

    // 1. Start date check
    final startDateStr = habit.startDate;
    if (startDateStr.length >= 10) {
      final startOnly = DateTime(
        int.parse(startDateStr.substring(0, 4)),
        int.parse(startDateStr.substring(5, 7)),
        int.parse(startDateStr.substring(8, 10)),
      );
      if (checkDate.isBefore(startOnly)) return false;
    }

    // End date check
    if (habit.endDate != null && habit.endDate!.length >= 10) {
      final endDateStr = habit.endDate!;
      final endOnly = DateTime(
        int.parse(endDateStr.substring(0, 4)),
        int.parse(endDateStr.substring(5, 7)),
        int.parse(endDateStr.substring(8, 10)),
      );
      if (checkDate.isAfter(endOnly)) return false;
    }

    // 2. Explicit scheduled dates
    final dayKey =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    if (habit.scheduledDates != null && habit.scheduledDates!.isNotEmpty) {
      return habit.scheduledDates!.contains(dayKey);
    }

    // 3. Frequency type
    if (habit.frequencyType == null || habit.frequencyType == 'daily') {
      return true;
    }

    switch (habit.frequencyType) {
      case 'weekly':
      case 'specificWeekdays':
        if (habit.selectedWeekdays == null || habit.selectedWeekdays!.isEmpty) {
          return true;
        }
        final int weekdayIndex = date.weekday - 1; // 0=Mon, 6=Sun
        return habit.selectedWeekdays!.contains(weekdayIndex);
      case 'monthly':
      case 'specificMonthDays':
        if (habit.selectedMonthDays == null ||
            habit.selectedMonthDays!.isEmpty) {
          return true;
        }
        return habit.selectedMonthDays!.contains(date.day);
      case 'periodic':
        if (habit.periodicDays == null || habit.periodicDays! <= 1) return true;
        if (startDateStr.length >= 10) {
          final startOnly = DateTime(
            int.parse(startDateStr.substring(0, 4)),
            int.parse(startDateStr.substring(5, 7)),
            int.parse(startDateStr.substring(8, 10)),
          );
          final diff = checkDate.difference(startOnly).inDays;
          return (diff % habit.periodicDays!) == 0;
        }
        return true;
      default:
        return true;
    }
  }

  void _onVerticalDragStart(DragStartDetails details) {
    if (_animController.isAnimating) {
      _animController.stop();
    }
  }

  void _onVerticalDragUpdate(DragUpdateDetails details, int totalVisions) {
    if (totalVisions <= 1) {
      // Subtle rubber-band resistance when only 1 vision
      setState(() {
        _dragDy += details.primaryDelta! * 0.35;
      });
      return;
    }
    setState(() {
      _dragDy += details.primaryDelta!;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details, int totalVisions) {
    if (totalVisions <= 1) {
      _snapBack();
      return;
    }

    final vy = details.velocity.pixelsPerSecond.dy;
    final isFlingUp = vy < -300 || _dragDy < -55;
    final isFlingDown = vy > 300 || _dragDy > 55;

    if (isFlingUp) {
      _throwCard(targetDy: -320, isNext: true, totalVisions: totalVisions);
    } else if (isFlingDown) {
      _throwCard(targetDy: 320, isNext: false, totalVisions: totalVisions);
    } else {
      _snapBack();
    }
  }

  void _throwCard({
    required double targetDy,
    required bool isNext,
    required int totalVisions,
  }) {
    HapticFeedback.mediumImpact();
    final startDy = _dragDy;
    _animController.duration = const Duration(milliseconds: 200);
    _throwAnimation = Tween<double>(begin: startDy, end: targetDy).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInQuad),
    )..addListener(() {
        setState(() {
          _dragDy = _throwAnimation!.value;
        });
      });

    _animController.forward(from: 0.0).then((_) {
      if (!mounted) return;
      setState(() {
        if (isNext) {
          _currentIndex = (_currentIndex + 1) % totalVisions;
        } else {
          _currentIndex = (_currentIndex - 1 + totalVisions) % totalVisions;
        }
        _dragDy = 0.0;
      });
    });
  }

  void _snapBack() {
    final startDy = _dragDy;
    _animController.duration = const Duration(milliseconds: 260);
    _throwAnimation = Tween<double>(begin: startDy, end: 0.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    )..addListener(() {
        setState(() {
          _dragDy = _throwAnimation!.value;
        });
      });
    _animController.forward(from: 0.0);
  }

  double _calculateProgress(Vision v, List<Habit> habits) {
    final linkedHabits = habits
        .where((h) =>
            v.linkedHabitIds.contains(h.id) || h.linkedVisionId == v.id)
        .toList();
    final totalItems = linkedHabits.length + v.tasks.length;
    if (totalItems == 0) return 0.0;
    int done = 0;
    for (final h in linkedHabits) {
      if (h.isCompleted) done++;
    }
    for (final t in v.tasks) {
      if (t.isCompleted) done++;
    }
    return done / totalItems;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final today = DateTime(widget.date.year, widget.date.month, widget.date.day);

    return StreamBuilder<List<Vision>>(
      stream: VisionRepository.instance.stream,
      initialData: VisionRepository.instance.visions,
      builder: (context, visionSnap) {
        final allVisions = visionSnap.data ?? VisionRepository.instance.visions;

        return ListenableBuilder(
          listenable: HabitRepository.instance,
          builder: (context, _) {
            final allHabits = HabitRepository.instance.habits;

            // Filter active visions: not expired and not 100% completed
            final activeVisions = allVisions.where((v) {
              if (v.endDate != null) {
                final end = DateTime(
                  v.endDate!.year,
                  v.endDate!.month,
                  v.endDate!.day,
                );
                if (end.isBefore(today)) return false;
              }
              return true;
            }).toList();

            // Empty state if no active visions
            if (activeVisions.isEmpty) {
              return _buildEmptyVisionCard(theme, l10n);
            }

            // Ensure current index is within bounds
            if (_currentIndex >= activeVisions.length) {
              _currentIndex = 0;
            }

            final currentVision = activeVisions[_currentIndex];
            final nextVision = activeVisions.length > 1
                ? activeVisions[(_currentIndex + 1) % activeVisions.length]
                : null;

            final progress = _calculateProgress(currentVision, allHabits);
            final todayActionText = _findTodayAction(
              currentVision,
              allHabits,
              l10n,
              today,
            );

            // Compute physics tilt and scale for the foreground card
            final angle = (_dragDy / 400.0).clamp(-0.20, 0.20);
            final scale = (1.0 - (_dragDy.abs() / 1500.0)).clamp(0.90, 1.0);
            final opacity = (1.0 - (_dragDy.abs() / 500.0)).clamp(0.35, 1.0);

            // Progress factor of current drag (0.0 to 1.0) for background card peek
            final dragFactor = (_dragDy.abs() / 200.0).clamp(0.0, 1.0);

            return Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
                // 1. Background Card (peeks when dragging if there are multiple visions)
                if (nextVision != null)
                  Positioned.fill(
                    child: Transform.scale(
                      scale: 0.94 + (dragFactor * 0.05),
                      child: Opacity(
                        opacity: 0.60 + (dragFactor * 0.35),
                        child: _VisionCardSurface(
                          vision: nextVision,
                          progress: _calculateProgress(nextVision, allHabits),
                          todayAction: _findTodayAction(
                            nextVision,
                            allHabits,
                            l10n,
                            today,
                          ),
                          pageInfo:
                              '${((_currentIndex + 1) % activeVisions.length) + 1}/${activeVisions.length}',
                          isInteractive: false,
                        ),
                      ),
                    ),
                  ),

                // 2. Foreground Swipeable Card
                Positioned.fill(
                  child: GestureDetector(
                    onVerticalDragStart: _onVerticalDragStart,
                    onVerticalDragUpdate: (d) =>
                        _onVerticalDragUpdate(d, activeVisions.length),
                    onVerticalDragEnd: (d) =>
                        _onVerticalDragEnd(d, activeVisions.length),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      if (widget.onOpenGoals != null) {
                        widget.onOpenGoals!();
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                VisionWizardScreen(repo: VisionRepository.instance),
                          ),
                        );
                      }
                    },
                    child: Transform(
                      transform: Matrix4.identity()
                        ..translate(0.0, _dragDy)
                        ..rotateZ(angle)
                        ..scale(scale),
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: opacity,
                        child: _VisionCardSurface(
                          vision: currentVision,
                          progress: progress,
                          todayAction: todayActionText,
                          pageInfo: activeVisions.length > 1
                              ? '${_currentIndex + 1}/${activeVisions.length}'
                              : null,
                          isInteractive: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _findTodayAction(
    Vision v,
    List<Habit> allHabits,
    AppLocalizations l10n,
    DateTime today,
  ) {
    // Check habits scheduled for today
    final linkedHabits = allHabits
        .where((h) =>
            v.linkedHabitIds.contains(h.id) || h.linkedVisionId == v.id)
        .toList();

    final todayHabits = linkedHabits
        .where((h) => _isHabitScheduledForDate(h, today))
        .toList();

    final pendingHabit =
        todayHabits.where((h) => !h.isCompleted).firstOrNull;
    if (pendingHabit != null) {
      final target = pendingHabit.targetCount > 0 &&
              pendingHabit.habitType != HabitType.simple
          ? ' (${pendingHabit.targetCount} ${pendingHabit.unit ?? ''})'.trim()
          : '';
      return '${pendingHabit.title}$target';
    }

    // Check uncompleted one-time tasks
    final uncompletedTasks = v.tasks.where((t) => !t.isCompleted).toList();
    if (uncompletedTasks.isNotEmpty) {
      return uncompletedTasks.first.title;
    }

    if (todayHabits.isNotEmpty) {
      return l10n.todayStepsDone;
    }

    return l10n.goToGoal;
  }

  Widget _buildEmptyVisionCard(ThemeData theme, AppLocalizations l10n) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (widget.onOpenGoals != null) {
          widget.onOpenGoals!();
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  VisionWizardScreen(repo: VisionRepository.instance),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withOpacity(0.5),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_mosaic_rounded,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.visionBoard,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              l10n.visionCreateTitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// The visual presentation of a single Vision Card inside the deck.
class _VisionCardSurface extends StatelessWidget {
  final Vision vision;
  final double progress;
  final String todayAction;
  final String? pageInfo;
  final bool isInteractive;

  const _VisionCardSurface({
    required this.vision,
    required this.progress,
    required this.todayAction,
    this.pageInfo,
    this.isInteractive = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visionColor = Color(vision.colorValue);
    final percent = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: visionColor.withOpacity(0.25),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: visionColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Emoji / Icon + Localized Vision Board Label + Page Count Badge
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: visionColor.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  vision.emoji?.isNotEmpty == true ? vision.emoji! : '🎯',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  AppLocalizations.of(context).visionBoard,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (pageInfo != null) ...[
                const SizedBox(width: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withOpacity(0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        pageInfo!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.unfold_more_rounded,
                        size: 11,
                        color: theme.colorScheme.onSurfaceVariant
                            .withOpacity(0.8),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 7),

          // Title
          Text(
            vision.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              height: 1.2,
            ),
          ),

          const Spacer(),

          // Progress Bar & Percentage
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 4.5,
                    backgroundColor: visionColor.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(visionColor),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '%$percent',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: visionColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          // Today's Action Snippet
          Row(
            children: [
              Icon(
                Icons.arrow_forward_rounded,
                size: 11,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  todayAction,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. DAILY TASKS SCROLL CARD (Aşağı / Yukarı Kaydırılabilir Scroll Görevler)
// ─────────────────────────────────────────────────────────────────────────────

class _DailyTasksScrollCard extends StatefulWidget {
  final DateTime date;
  final VoidCallback? onAddTask;

  const _DailyTasksScrollCard({
    required this.date,
    this.onAddTask,
  });

  @override
  State<_DailyTasksScrollCard> createState() => _DailyTasksScrollCardState();
}

class _DailyTasksScrollCardState extends State<_DailyTasksScrollCard> {
  final DailyTaskRepository _taskRepo = DailyTaskRepository.instance;

  @override
  void initState() {
    super.initState();
    _taskRepo.addListener(_onTasksChanged);
  }

  @override
  void dispose() {
    _taskRepo.removeListener(_onTasksChanged);
    super.dispose();
  }

  void _onTasksChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _toggleTask(DailyTask task) async {
    HapticFeedback.selectionClick();
    final dayKey =
        '${widget.date.year}-${widget.date.month.toString().padLeft(2, '0')}-${widget.date.day.toString().padLeft(2, '0')}';

    setState(() {
      task.isDone = !task.isDone;
      if (task.isDone) {
        task.completionDateKey = dayKey;
      } else {
        task.completionDateKey = null;
      }
    });

    await _taskRepo.updateTask(task);
  }

  void _showQuickAddDialog() async {
    HapticFeedback.lightImpact();
    if (widget.onAddTask != null) {
      widget.onAddTask!();
      return;
    }

    final res = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => const DailyTaskDialog(),
    );

    if (res != null) {
      final String title = (res['title'] as String?)?.trim() ?? '';
      final String description =
          (res['description'] as String?)?.trim() ?? '';
      if (title.isEmpty) return;
      final dayKey =
          '${widget.date.year}-${widget.date.month.toString().padLeft(2, '0')}-${widget.date.day.toString().padLeft(2, '0')}';
      final task = DailyTask(
        id: UniqueKey().toString(),
        title: title,
        description: description,
        dateKey: dayKey,
      );
      await _taskRepo.addTask(task);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final dayKey =
        '${widget.date.year}-${widget.date.month.toString().padLeft(2, '0')}-${widget.date.day.toString().padLeft(2, '0')}';
    final tasks = _taskRepo.tasksForDateWithCarryover(dayKey);
    final completedCount = tasks.where((t) => t.isDone).length;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.45),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.fromLTRB(11, 10, 8, 4),
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.checklist_rounded,
                    color: theme.colorScheme.primary,
                    size: 15,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.dailyTaskTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (tasks.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: completedCount == tasks.length
                          ? Colors.green.withOpacity(0.15)
                          : theme.colorScheme.surfaceContainerHighest
                              .withOpacity(0.6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$completedCount/${tasks.length}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: completedCount == tasks.length
                            ? Colors.green[700]
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                // Quick Add Button
                InkWell(
                  onTap: _showQuickAddDialog,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Icon(
                      Icons.add_circle_outline_rounded,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 0.7),

          // Scrollable Task List
          Expanded(
            child: tasks.isEmpty
                ? _buildEmptyState(theme, l10n)
                : RawScrollbar(
                    thumbVisibility: false,
                    thickness: 2.5,
                    radius: const Radius.circular(3),
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(9, 6, 9, 8),
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      itemCount: tasks.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 5),
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return _DailyTaskMiniRow(
                          task: task,
                          onToggle: () => _toggleTask(task),
                          onLongPress: () => _showTaskOptions(task),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _showTaskOptions(DailyTask task) async {
    HapticFeedback.mediumImpact();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isTr = l10n.localeName.startsWith('tr');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2235) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.12)
                : Colors.black.withValues(alpha: 0.08),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Drag Pill
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Task Title Display
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.checklist_rounded,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Edit Option
              ListTile(
                leading: Icon(
                  Icons.edit_outlined,
                  color: theme.colorScheme.primary,
                ),
                title: Text(
                  isTr ? 'Görevi Düzenle' : 'Edit Task',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  final res = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (ctx) => DailyTaskDialog(
                      initialTitle: task.title,
                      initialDescription: task.description,
                      isEditing: true,
                    ),
                  );
                  if (res != null) {
                    final newTitle =
                        (res['title'] as String?)?.trim() ?? task.title;
                    final newDescription =
                        (res['description'] as String?)?.trim() ??
                            task.description;
                    if (newTitle.isNotEmpty) {
                      task.title = newTitle;
                      task.description = newDescription;
                      await _taskRepo.updateTask(task);
                      setState(() {});
                    }
                  }
                },
              ),
              // Delete Option
              ListTile(
                leading: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                ),
                title: Text(
                  isTr ? 'Görevi Sil' : 'Delete Task',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  HapticFeedback.lightImpact();
                  await _taskRepo.removeTask(task.id);
                  setState(() {});
                },
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt_rounded,
              size: 24,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.noTasksYet,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 11,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: _showQuickAddDialog,
              child: Text(
                '+ ${l10n.addTask}',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyTaskMiniRow extends StatelessWidget {
  final DailyTask task;
  final VoidCallback onToggle;
  final VoidCallback? onLongPress;

  const _DailyTaskMiniRow({
    required this.task,
    required this.onToggle,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDone = task.isDone;

    return InkWell(
      onTap: onToggle,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.5, horizontal: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Checkbox
            Container(
              width: 17,
              height: 17,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                border: Border.all(
                  color: isDone
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outlineVariant.withOpacity(0.8),
                  width: 1.4,
                ),
              ),
              child: isDone
                  ? const Icon(
                      Icons.check,
                      size: 11,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 7),
            // Title
            Expanded(
              child: Text(
                task.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isDone ? FontWeight.w400 : FontWeight.w500,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                  color: isDone
                      ? theme.colorScheme.onSurfaceVariant.withOpacity(0.55)
                      : theme.colorScheme.onSurface,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
