import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' as io;

import '../../../../l10n/app_localizations.dart';
import '../../../vision/data/vision_model.dart';
import '../../../vision/data/vision_repository.dart';
import '../../../vision/data/vision_task_model.dart';
import '../../../vision/presentation/widgets/goal_summary_sheet.dart';
import '../../domain/habit_model.dart';
import '../../domain/habit_repository.dart';
import '../../domain/habit_types.dart';

/// Helper candidate representation for active goal selection.
class _GoalCandidate {
  final Vision vision;
  final List<Habit> todayHabits;
  final List<VisionTask> uncompletedTasks;
  final double progress;

  const _GoalCandidate({
    required this.vision,
    required this.todayHabits,
    required this.uncompletedTasks,
    required this.progress,
  });
}

/// A compact "Active Goal" summary card displayed on the Today screen.
class ActiveGoalCard extends StatefulWidget {
  const ActiveGoalCard({
    super.key,
    required this.date,
    this.onOpenGoals,
  });

  final DateTime date;
  final VoidCallback? onOpenGoals;

  /// Helper to check if a habit is scheduled for a given date.
  static bool isHabitScheduledForDate(Habit habit, DateTime date) {
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
        return habit.selectedWeekdays!.contains(weekdayIndex) ||
            habit.selectedWeekdays!.contains(date.weekday);
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

  @override
  State<ActiveGoalCard> createState() => _ActiveGoalCardState();
}

class _ActiveGoalCardState extends State<ActiveGoalCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final today = DateTime(widget.date.year, widget.date.month, widget.date.day);

    return StreamBuilder<List<Vision>>(
      stream: VisionRepository.instance.stream,
      initialData: VisionRepository.instance.visions,
      builder: (context, visionSnap) {
        final visions = visionSnap.data ?? VisionRepository.instance.visions;

        if (visions.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListenableBuilder(
          listenable: HabitRepository.instance,
          builder: (context, _) {
            final habits = HabitRepository.instance.habits;

            // 1. Evaluate candidate visions
            final candidates = <_GoalCandidate>[];

            for (final v in visions) {
              // Condition 2: Not expired
              if (v.endDate != null) {
                final end = DateTime(
                  v.endDate!.year,
                  v.endDate!.month,
                  v.endDate!.day,
                );
                if (end.isBefore(today)) continue;
              }

              // Linked habits
              final linkedHabits = habits
                  .where((h) =>
                      v.linkedHabitIds.contains(h.id) ||
                      h.linkedVisionId == v.id)
                  .toList();

              // Today habits
              final todayHabits = linkedHabits
                  .where((h) => ActiveGoalCard.isHabitScheduledForDate(h, today))
                  .toList();

              // Uncompleted one-time tasks
              final uncompletedTasks =
                  v.tasks.where((t) => !t.isCompleted).toList();

              // Condition 3: Has today habit OR uncompleted task
              if (todayHabits.isEmpty && uncompletedTasks.isEmpty) {
                continue;
              }

              // Calculate approximate progress
              int totalItems = linkedHabits.length + v.tasks.length;
              int completedItems = 0;
              for (final h in linkedHabits) {
                if (h.isCompleted) completedItems++;
              }
              for (final t in v.tasks) {
                if (t.isCompleted) completedItems++;
              }
              final progress =
                  totalItems > 0 ? (completedItems / totalItems) : 0.0;

              // Condition 2: Not 100% completed
              if (progress >= 1.0) continue;

              candidates.add(_GoalCandidate(
                vision: v,
                todayHabits: todayHabits,
                uncompletedTasks: uncompletedTasks,
                progress: progress,
              ));
            }

            if (candidates.isEmpty) {
              return const SizedBox.shrink();
            }

            // 2. Sort by Priority Rules:
            // 1) Has habit scheduled for today
            // 2) Nearest end date
            // 3) Most recently created
            candidates.sort((a, b) {
              final aHasToday = a.todayHabits.isNotEmpty ? 1 : 0;
              final bHasToday = b.todayHabits.isNotEmpty ? 1 : 0;
              if (aHasToday != bHasToday) {
                return bHasToday.compareTo(aHasToday);
              }

              // Nearest end date
              if (a.vision.endDate != null && b.vision.endDate != null) {
                final c = a.vision.endDate!.compareTo(b.vision.endDate!);
                if (c != 0) return c;
              } else if (a.vision.endDate != null) {
                return -1;
              } else if (b.vision.endDate != null) {
                return 1;
              }

              // Most recently created
              return b.vision.createdAt.compareTo(a.vision.createdAt);
            });

            final selected = candidates.first;
            final v = selected.vision;
            final color = Color(v.colorValue);
            final percent = (selected.progress * 100).toInt();

            // Next actionable text summary
            String actionSummary = '';
            final pendingHabit = selected.todayHabits
                .where((h) => !h.isCompleted)
                .firstOrNull;

            if (pendingHabit != null) {
              final target = pendingHabit.targetCount > 0 &&
                      pendingHabit.habitType != HabitType.simple
                  ? ' (${pendingHabit.targetCount} ${pendingHabit.unit ?? ''})'.trim()
                  : '';
              actionSummary = '${pendingHabit.title}$target';
            } else if (selected.uncompletedTasks.isNotEmpty) {
              actionSummary = selected.uncompletedTasks.first.title;
            } else if (selected.todayHabits.isNotEmpty) {
              actionSummary = l10n.todayStepsDone;
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
              child: GestureDetector(
                onTapDown: (_) => _pressCtrl.forward(),
                onTapUp: (_) => _pressCtrl.reverse(),
                onTapCancel: () => _pressCtrl.reverse(),
                onTap: () {
                  HapticFeedback.lightImpact();
                  GoalSummarySheet.show(
                    context,
                    visionId: v.id,
                    onOpenGoals: widget.onOpenGoals,
                  );
                },
                child: ScaleTransition(
                  scale: _scale,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: color.withValues(alpha: isDark ? 0.30 : 0.20),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: isDark ? 0.20 : 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                        if (!isDark)
                          const BoxShadow(
                            color: Colors.white,
                            blurRadius: 2,
                            offset: Offset(0, -1),
                          ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top row: Avatar, Title, Chevron
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: isDark ? 0.25 : 0.12),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: color.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: v.coverImage != null && v.coverImage!.isNotEmpty
                                  ? (v.coverImage!.startsWith('assets/')
                                      ? Image.asset(v.coverImage!, fit: BoxFit.cover)
                                      : Image.file(io.File(v.coverImage!), fit: BoxFit.cover))
                                  : Center(
                                      child: Text(
                                        v.emoji ?? '🎯',
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: color.withValues(alpha: 0.14),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          l10n.activeGoal.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w800,
                                            color: color,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    v.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Progress row: %42 tamamlandı • Bugün 1 adımın var
                        Row(
                          children: [
                            Text(
                              l10n.percentCompleted(percent),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: color,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '•',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                selected.todayHabits.isNotEmpty
                                    ? l10n.todayStepsCount(
                                        selected.todayHabits.length)
                                    : l10n.todayTasksCount(
                                        selected.uncompletedTasks.length),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Progress indicator bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: selected.progress,
                            minHeight: 5,
                            backgroundColor: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : color.withValues(alpha: 0.12),
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                          ),
                        ),

                        // Action summary text (nearest/uncompleted task or habit)
                        if (actionSummary.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_right_alt_rounded,
                                size: 14,
                                color: color,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  actionSummary,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
