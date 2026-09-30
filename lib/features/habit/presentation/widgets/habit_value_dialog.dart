import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/habit_model.dart';
import '../../domain/habit_types.dart';
import '../../domain/subtask_model.dart';
import '../../../timer/timer_screen.dart';

/// Shows the data entry dialog for advanced habits (numerical, timer, subtasks).
Future<void> showAdvancedHabitDialog({
  required BuildContext context,
  required Habit habit,
  required int currentProgress,
  required ValueChanged<int> onValueUpdate,
  List<Subtask>? subtasks,
  Function(String, bool)? onSubtaskToggle,
}) async {
  if (habit.habitType == HabitType.subtasks) {
    await _showSubtasksBottomSheet(
      context: context,
      habit: habit,
      subtasks: subtasks ?? habit.subtasks,
      onSubtaskToggle: onSubtaskToggle,
    );
    return;
  }

  int currentValue = currentProgress;
  bool isManualEntry = false;
  final controller = TextEditingController(text: currentValue.toString());
  final theme = Theme.of(context);
  final cs = theme.colorScheme;
  final l10n = AppLocalizations.of(context);
  final bool isTimer = habit.habitType == HabitType.timer;

  await showDialog<void>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (context, setDialogState) {
        final double progress = habit.targetCount > 0
            ? (currentValue / habit.targetCount).clamp(0.0, 1.0)
            : 0.0;

        String? ruleHint() {
          String unitLabel = '';
          if (habit.unit != null && habit.unit!.isNotEmpty) {
            unitLabel = ' ${habit.unit}';
          } else if (isTimer) {
            unitLabel = ' ${l10n.minutes.toLowerCase()}';
          }
          final targetText = '${habit.targetCount}$unitLabel';
          if (habit.habitType == HabitType.numerical) {
            switch (habit.numericalTargetType) {
              case NumericalTargetType.minimum:
                return l10n.ruleEnteredValueAtLeast(targetText);
              case NumericalTargetType.exact:
                return l10n.ruleEnteredValueExactly(targetText);
              case NumericalTargetType.maximum:
                return l10n.ruleEnteredValueAtMost(targetText);
            }
          }
          if (isTimer) {
            switch (habit.timerTargetType) {
              case TimerTargetType.minimum:
                return l10n.ruleEnteredDurationAtLeast(targetText);
              case TimerTargetType.exact:
                return l10n.ruleEnteredDurationExactly(targetText);
              case TimerTargetType.maximum:
                return l10n.ruleEnteredDurationAtMost(targetText);
            }
          }
          return null;
        }

        return Dialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title with icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: habit.color.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          habit.icon,
                          color: habit.color,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          habit.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  if (isTimer) ...[
                    SizedBox(
                      height: 46,
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const TimerScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow_rounded, size: 22),
                        label: Text(
                          l10n.localeName.startsWith('tr')
                              ? 'Süre Tut'
                              : 'Track Timer',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            height: 1.0,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: habit.color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(
                      color: cs.outlineVariant.withOpacity(0.2),
                      height: 1,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Main Value Entry Area
                  if (!isManualEntry)
                    Column(
                      children: [
                        if (isTimer)
                          SizedBox(
                            height: 150,
                            child: CupertinoTimerPicker(
                              mode: CupertinoTimerPickerMode.hm,
                              initialTimerDuration:
                                  Duration(minutes: currentValue),
                              onTimerDurationChanged: (Duration newDuration) {
                                setDialogState(() {
                                  currentValue = newDuration.inMinutes;
                                  controller.text = currentValue.toString();
                                });
                              },
                            ),
                          )
                        else
                          Container(
                            height: 64,
                            decoration: BoxDecoration(
                              color: habit.color.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: habit.color.withOpacity(0.18),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_rounded),
                                  color: habit.color,
                                  onPressed: () {
                                    if (currentValue > 0) {
                                      setDialogState(() {
                                        currentValue--;
                                        controller.text =
                                            currentValue.toString();
                                      });
                                      HapticFeedback.lightImpact();
                                    }
                                  },
                                ),
                                VerticalDivider(
                                  color: habit.color.withOpacity(0.2),
                                  width: 1,
                                  indent: 12,
                                  endIndent: 12,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setDialogState(() => isManualEntry = true);
                                    HapticFeedback.selectionClick();
                                  },
                                  child: Container(
                                    constraints:
                                        const BoxConstraints(minWidth: 80),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    color: Colors.transparent,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          currentValue.toString(),
                                          style: theme.textTheme.headlineLarge
                                              ?.copyWith(
                                            color: habit.color,
                                            fontWeight: FontWeight.w900,
                                            height: 1.0,
                                          ),
                                        ),
                                        const SizedBox(height: 1),
                                        Text(
                                          habit.unit ?? l10n.valueLabel,
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                            color: cs.onSurfaceVariant,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 9,
                                            height: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                VerticalDivider(
                                  color: habit.color.withOpacity(0.2),
                                  width: 1,
                                  indent: 12,
                                  endIndent: 12,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_rounded),
                                  color: habit.color,
                                  onPressed: () {
                                    setDialogState(() {
                                      currentValue++;
                                      controller.text =
                                          currentValue.toString();
                                    });
                                    HapticFeedback.lightImpact();
                                  },
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            setDialogState(() => isManualEntry = true);
                            HapticFeedback.selectionClick();
                          },
                          child: Text(
                            isTimer
                                ? (l10n.localeName.startsWith('tr')
                                    ? 'Klavyeyle girmek için dokun'
                                    : 'Tap to type duration')
                                : (l10n.localeName.startsWith('tr')
                                    ? 'Klavyeyle girmek için rakama dokun'
                                    : 'Tap number to type'),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: cs.onSurfaceVariant.withOpacity(0.7),
                              fontSize: 11,
                              decoration:
                                  isTimer ? TextDecoration.underline : null,
                              fontStyle: isTimer ? null : FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: habit.color,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Hedef: ${habit.targetCount}',
                        suffixText: habit.unit,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onChanged: (val) {
                        final parsed = int.tryParse(val);
                        if (parsed != null && parsed >= 0) {
                          setDialogState(() {
                            currentValue = parsed;
                          });
                        }
                      },
                    ),

                  const SizedBox(height: 20),

                  // Progress Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.localeName.startsWith('tr')
                                ? 'Bugünkü İlerleme'
                                : 'Today\'s Progress',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            '${(progress * 100).round()}%',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: habit.color,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          minHeight: 8,
                          value: progress <= 0 ? 0 : progress,
                          backgroundColor: habit.color.withOpacity(0.12),
                          valueColor: AlwaysStoppedAnimation(habit.color),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '$currentValue / ${habit.targetCount}${habit.unit != null ? ' ${habit.unit}' : ''}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant.withOpacity(0.6),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Rule Hint
                  if (ruleHint() != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: habit.color.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 15,
                            color: habit.color,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              ruleHint()!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Action Buttons: Cancel and Save
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(l10n.cancel),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: habit.color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          final finalVal =
                              int.tryParse(controller.text) ?? currentValue;
                          Navigator.pop(ctx);
                          HapticFeedback.mediumImpact();
                          onValueUpdate(finalVal);
                        },
                        child: Text(
                          l10n.localeName.startsWith('tr')
                              ? 'Kaydet'
                              : 'Save',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

/// Shows subtasks checklist in a clean bottom sheet
Future<void> _showSubtasksBottomSheet({
  required BuildContext context,
  required Habit habit,
  required List<Subtask> subtasks,
  Function(String, bool)? onSubtaskToggle,
}) async {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => StatefulBuilder(
      builder: (context, setSheetState) {
        final completedCount = subtasks.where((s) => s.isCompleted).length;
        final totalCount = subtasks.length;
        final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: habit.color.withOpacity(0.18),
                      ),
                      child: Icon(habit.icon, color: habit.color, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habit.title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '$completedCount / $totalCount tamamlandı',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    minHeight: 6,
                    value: progress,
                    backgroundColor: habit.color.withOpacity(0.12),
                    valueColor: AlwaysStoppedAnimation(habit.color),
                  ),
                ),
                const SizedBox(height: 16),

                // Subtask Items
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: subtasks.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final subtask = subtasks[index];
                      return CheckboxListTile(
                        value: subtask.isCompleted,
                        activeColor: habit.color,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          subtask.title,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            decoration: subtask.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: subtask.isCompleted
                                ? (isDark
                                    ? const Color(0xFF64748B)
                                    : const Color(0xFF94A3B8))
                                : null,
                          ),
                        ),
                        onChanged: (val) {
                          final newVal = val ?? false;
                          setSheetState(() {
                            subtask.isCompleted = newVal;
                          });
                          HapticFeedback.selectionClick();
                          onSubtaskToggle?.call(subtask.id, newVal);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
