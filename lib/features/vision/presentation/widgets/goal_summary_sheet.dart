import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../habit/domain/habit_model.dart';
import '../../../habit/domain/habit_repository.dart';
import '../../../habit/domain/habit_types.dart';
import '../../data/vision_model.dart';
import '../../data/vision_repository.dart';
import '../../data/vision_task_model.dart';
import '../../data/vision_template_repository.dart';

/// Shows an aesthetic, comprehensive Goal Summary bottom sheet.
class GoalSummarySheet extends StatefulWidget {
  const GoalSummarySheet({
    super.key,
    required this.visionId,
    this.onOpenGoals,
    this.onEdit,
    this.onDelete,
    this.onLinkHabits,
  });

  final String visionId;
  final VoidCallback? onOpenGoals;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onLinkHabits;

  static Future<void> show(
    BuildContext context, {
    required String visionId,
    VoidCallback? onOpenGoals,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    VoidCallback? onLinkHabits,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GoalSummarySheet(
        visionId: visionId,
        onOpenGoals: onOpenGoals,
        onEdit: onEdit,
        onDelete: onDelete,
        onLinkHabits: onLinkHabits,
      ),
    );
  }

  @override
  State<GoalSummarySheet> createState() => _GoalSummarySheetState();
}

class _GoalSummarySheetState extends State<GoalSummarySheet> {
  final _taskCtrl = TextEditingController();
  bool _isAddingTask = false;

  @override
  void dispose() {
    _taskCtrl.dispose();
    super.dispose();
  }

  bool _isHabitScheduledForToday(Habit habit) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 1. Start Date Check
    final String startDateStr = habit.startDate;
    if (startDateStr.length >= 10) {
      final startDate = DateTime(
        int.parse(startDateStr.substring(0, 4)),
        int.parse(startDateStr.substring(5, 7)),
        int.parse(startDateStr.substring(8, 10)),
      );
      if (today.isBefore(startDate)) return false;
    }

    // End Date Check
    if (habit.endDate != null && habit.endDate!.length >= 10) {
      final endDateStr = habit.endDate!;
      final endDate = DateTime(
        int.parse(endDateStr.substring(0, 4)),
        int.parse(endDateStr.substring(5, 7)),
        int.parse(endDateStr.substring(8, 10)),
      );
      if (today.isAfter(endDate)) return false;
    }

    // 2. Explicit Scheduled Dates
    final dayKey =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    if (habit.scheduledDates != null && habit.scheduledDates!.isNotEmpty) {
      return habit.scheduledDates!.contains(dayKey);
    }

    // 3. Frequency Type
    if (habit.frequencyType == null || habit.frequencyType == 'daily') {
      return true;
    }

    switch (habit.frequencyType) {
      case 'weekly':
      case 'specificWeekdays':
        if (habit.selectedWeekdays == null || habit.selectedWeekdays!.isEmpty) {
          return true;
        }
        final int weekdayIndex = now.weekday - 1; // 0=Mon, 6=Sun
        return habit.selectedWeekdays!.contains(weekdayIndex) ||
            habit.selectedWeekdays!.contains(now.weekday);
      case 'monthly':
      case 'specificMonthDays':
        if (habit.selectedMonthDays == null ||
            habit.selectedMonthDays!.isEmpty) {
          return true;
        }
        return habit.selectedMonthDays!.contains(now.day);
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<List<Vision>>(
      stream: VisionRepository.instance.stream,
      initialData: VisionRepository.instance.visions,
      builder: (context, snapshot) {
        final visions = snapshot.data ?? VisionRepository.instance.visions;
        final vision =
            visions.where((v) => v.id == widget.visionId).firstOrNull;

        if (vision == null) {
          return const SizedBox.shrink();
        }

        final color = Color(vision.colorValue);

        return ListenableBuilder(
          listenable: HabitRepository.instance,
          builder: (context, _) {
            final allHabits = HabitRepository.instance.habits;
            final linkedHabits = allHabits
                .where((h) =>
                    vision.linkedHabitIds.contains(h.id) ||
                    h.linkedVisionId == vision.id)
                .toList();

            final todayHabits = linkedHabits
                .where((h) => _isHabitScheduledForToday(h))
                .toList();

            final uncompletedTasks =
                vision.tasks.where((t) => !t.isCompleted).toList();

            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.88,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag Handle
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        width: 38,
                        height: 4.5,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.2)
                              : Colors.black.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Scrollable Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // ── Goal Header ──
                            _buildHeader(context, vision, color, isDark, l10n),
                            const SizedBox(height: 16),

                            // ── Overall Progress Card ──
                            _buildProgressCard(
                                context, vision, color, isDark, l10n),
                            const SizedBox(height: 18),

                            // ── Today's Steps Section (Prominent) ──
                            if (todayHabits.isNotEmpty ||
                                uncompletedTasks.isNotEmpty) ...[
                              _buildTodaySection(
                                context,
                                vision,
                                color,
                                todayHabits,
                                uncompletedTasks,
                                isDark,
                                l10n,
                              ),
                              const SizedBox(height: 18),
                            ],

                            // ── Linked Habits Section ──
                            _buildLinkedHabitsSection(
                              context,
                              vision,
                              color,
                              linkedHabits,
                              isDark,
                              l10n,
                            ),
                            const SizedBox(height: 18),

                            // ── One-Time Tasks Section ──
                            _buildTasksSection(
                              context,
                              vision,
                              color,
                              vision.tasks,
                              isDark,
                              l10n,
                            ),
                            const SizedBox(height: 20),

                            // ── Footer / Navigation Actions ──
                            if (widget.onOpenGoals != null) ...[
                              OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  widget.onOpenGoals?.call();
                                },
                                icon: const Icon(Icons.explore_outlined,
                                    size: 18),
                                label: Text(l10n.viewAllGoals),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  side: BorderSide(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.15)
                                        : Colors.black.withValues(alpha: 0.12),
                                    width: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    Vision vision,
    Color color,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Emoji / Cover avatar
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.22 : 0.12),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1.2,
            ),
          ),
          child: vision.coverImage != null && vision.coverImage!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: io.File(vision.coverImage!).existsSync()
                      ? Image.file(
                          io.File(vision.coverImage!),
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Text(
                            vision.emoji ?? '🎯',
                            style: const TextStyle(fontSize: 26),
                          ),
                        ),
                )
              : Center(
                  child: Text(
                    vision.emoji ?? '🎯',
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
        ),
        const SizedBox(width: 14),

        // Title and description
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      l10n.activeGoal.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: color,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // More menu
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_horiz_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onSelected: (value) async {
                      if (value == 'edit') {
                        Navigator.pop(context);
                        widget.onEdit?.call();
                      } else if (value == 'link') {
                        Navigator.pop(context);
                        widget.onLinkHabits?.call();
                      } else if (value == 'share') {
                        try {
                          final tpl = VisionRepository.instance
                              .exportAsTemplate(vision);
                          final link = VisionTemplateRepository.instance
                              .toShareLink(tpl);
                          await SharePlus.instance.share(
                            ShareParams(text: link, subject: vision.title),
                          );
                        } catch (_) {}
                      } else if (value == 'delete') {
                        Navigator.pop(context);
                        widget.onDelete?.call();
                      }
                    },
                    itemBuilder: (ctx) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(Icons.edit_outlined, size: 18),
                            const SizedBox(width: 10),
                            Text(l10n.edit),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'link',
                        child: Row(
                          children: [
                            const Icon(Icons.link_rounded, size: 18),
                            const SizedBox(width: 10),
                            Text(l10n.linkHabits),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            const Icon(Icons.ios_share_rounded, size: 18),
                            const SizedBox(width: 10),
                            Text(l10n.shareVision),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete_outline_rounded,
                                size: 18, color: Colors.red),
                            const SizedBox(width: 10),
                            Text(l10n.delete,
                                style: const TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                vision.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  letterSpacing: -0.3,
                ),
              ),
              if (vision.description != null &&
                  vision.description!.trim().isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  vision.description!.trim(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    Vision vision,
    Color color,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return FutureBuilder<double>(
      future: VisionRepository.instance.calculateVisionProgress(vision.id),
      builder: (context, snap) {
        final progress = (snap.data ?? 0.0).clamp(0.0, 1.0);
        final percent = (progress * 100).toInt();

        String dateInfo = '';
        if (vision.endDate != null) {
          final end = vision.endDate!;
          dateInfo = 'Bitiş: ${end.day}.${end.month}.${end.year}';
        } else {
          dateInfo = l10n.durationIndefinite;
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withValues(alpha: isDark ? 0.25 : 0.15),
              width: 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.percentCompleted(percent),
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: color,
                      letterSpacing: -0.2,
                    ),
                  ),
                  Text(
                    dateInfo,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? Colors.white60
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: isDark
                      ? Colors.white.withValues(alpha: 0.10)
                      : color.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTodaySection(
    BuildContext context,
    Vision vision,
    Color color,
    List<Habit> todayHabits,
    List<VisionTask> uncompletedTasks,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? color.withValues(alpha: 0.12)
            : color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.4,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bolt_rounded, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                l10n.todaySteps,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: -0.2,
                ),
              ),
              const Spacer(),
              if (todayHabits.isNotEmpty)
                Text(
                  l10n.todayStepsCount(todayHabits.length),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color.withValues(alpha: 0.85),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Today Habits list
          ...todayHabits.map((habit) {
            final isDone = habit.isCompleted;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1B202D) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.05),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    habit.emoji ?? '⚡',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.title,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            decoration:
                                isDone ? TextDecoration.lineThrough : null,
                            color: isDone
                                ? theme.colorScheme.onSurfaceVariant
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                        if (habit.habitType != HabitType.simple)
                          Text(
                            'Hedef: ${habit.targetCount} ${habit.unit ?? ''}'
                                .trim(),
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isDone
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: isDone ? const Color(0xFF10B981) : color,
                      size: 22,
                    ),
                    onPressed: () async {
                      HapticFeedback.lightImpact();
                      habit.isCompleted = !habit.isCompleted;
                      await HabitRepository.instance.updateHabit(habit);
                    },
                  ),
                ],
              ),
            );
          }),

          // Today uncompleted tasks
          ...uncompletedTasks.take(2).map((task) {
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1B202D) : Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_box_outline_blank_rounded,
                      size: 18, color: color),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.check_rounded, size: 16),
                    onPressed: () async {
                      HapticFeedback.lightImpact();
                      await VisionRepository.instance
                          .toggleTask(vision.id, task.id);
                    },
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLinkedHabitsSection(
    BuildContext context,
    Vision vision,
    Color color,
    List<Habit> linkedHabits,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${l10n.linkedHabits} (${linkedHabits.length})',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            if (widget.onLinkHabits != null)
              TextButton.icon(
                onPressed: widget.onLinkHabits,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: Text(l10n.addHabitStep),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: color,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        if (linkedHabits.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: Center(
              child: Text(
                l10n.noLinkedHabits,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          Column(
            children: linkedHabits.map((habit) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.04)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.black.withValues(alpha: 0.05),
                  ),
                ),
                child: Row(
                  children: [
                    Text(habit.emoji ?? '🎯',
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habit.title,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            habit.frequency ?? 'Günlük',
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (habit.currentStreak > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFFF9500).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            Text(
                              '${habit.currentStreak}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFF9500),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildTasksSection(
    BuildContext context,
    Vision vision,
    Color color,
    List<VisionTask> tasks,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${l10n.oneTimeTasks} (${tasks.length})',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            IconButton(
              icon: Icon(
                _isAddingTask
                    ? Icons.close_rounded
                    : Icons.add_circle_outline_rounded,
                size: 20,
                color: color,
              ),
              onPressed: () {
                setState(() => _isAddingTask = !_isAddingTask);
              },
            ),
          ],
        ),
        if (_isAddingTask) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _taskCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Görev adı...',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : const Color(0xFFF1F5F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _submitNewTask(vision.id),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                icon: const Icon(Icons.arrow_upward_rounded, size: 18),
                style: IconButton.styleFrom(backgroundColor: color),
                onPressed: () => _submitNewTask(vision.id),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 4),
        if (tasks.isEmpty && !_isAddingTask)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'Eklenmiş tek seferlik görev yok',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          Column(
            children: tasks.map((task) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.04)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: task.isCompleted,
                      activeColor: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onChanged: (_) async {
                        HapticFeedback.lightImpact();
                        await VisionRepository.instance
                            .toggleTask(vision.id, task.id);
                      },
                    ),
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 13.5,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted
                              ? theme.colorScheme.onSurfaceVariant
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.5),
                      ),
                      onPressed: () async {
                        await VisionRepository.instance
                            .removeTask(vision.id, task.id);
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Future<void> _submitNewTask(String visionId) async {
    final text = _taskCtrl.text.trim();
    if (text.isEmpty) return;
    _taskCtrl.clear();
    setState(() => _isAddingTask = false);
    await VisionRepository.instance.addTask(visionId, text);
  }
}
