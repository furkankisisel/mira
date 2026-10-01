import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../mood/data/mood_models.dart';
import '../../mood/mood_screen.dart';
import '../../schedule/presentation/weekly_schedule_screen.dart';
import '../../schedule/presentation/widgets/week_picker_sheet.dart';
import '../../../design_system/theme/theme_variations.dart';
import '../../../design_system/tokens/colors.dart';
import 'widgets/daily_task_dialog.dart';
import 'widgets/list_creation_dialog.dart';
import 'widgets/habit_card.dart';
import 'widgets/today_top_dashboard.dart';
import 'widgets/biological_clock_arc_card.dart';
import 'widgets/timeline_habit_row.dart';
import 'widgets/habit_value_dialog.dart';
import 'simple_habit_screen.dart';
import 'simple_habit_wizard_screen.dart';
import 'advanced_habit_wizard_screen.dart';

import 'advanced_habit_screen.dart';
import 'habit_analysis_screen.dart';
import 'package:mira/l10n/app_localizations.dart';
import '../domain/habit_types.dart';
import '../domain/habit_repository.dart';
import '../domain/habit_model.dart';
import '../domain/subtask_model.dart';
import '../domain/list_repository.dart';
import '../domain/list_model.dart';
import '../domain/daily_task_repository.dart';
import '../domain/daily_task_model.dart';

import '../../vision/data/vision_repository.dart';
import '../../vision/data/vision_model.dart';
import '../../../ui/premium_gate.dart';
import '../../rhythm/domain/live_rhythm_repository.dart';
import '../../rhythm/domain/live_rhythm_model.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../../social/data/room_service.dart';

// removed unused imports

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

/// Represents a grouped item for the habit/task list view
sealed class _GroupedItem {}

class _ListHeader extends _GroupedItem {
  final String? listId;
  final String title;
  _ListHeader({required this.listId, required this.title});
}

class _TaskItem extends _GroupedItem {
  final DailyTask task;
  _TaskItem(this.task);
}

class _HabitItem extends _GroupedItem {
  final Habit habit;
  _HabitItem(this.habit);
}

IconData _iconFor(MoodLevel m) => switch (m) {
      MoodLevel.terrible => Icons.sentiment_very_dissatisfied,
      MoodLevel.bad => Icons.sentiment_dissatisfied,
      MoodLevel.neutral => Icons.sentiment_neutral,
      MoodLevel.good => Icons.sentiment_satisfied,
      MoodLevel.excellent => Icons.sentiment_very_satisfied,
    };

Color _colorFor(MoodLevel m) => switch (m) {
      MoodLevel.terrible => Colors.redAccent,
      MoodLevel.bad => Colors.deepOrange,
      MoodLevel.neutral => AppColors.accentSand,
      MoodLevel.good => AppColors.accentBlue,
      MoodLevel.excellent => AppColors.accentGold,
    };

enum HabitScreenViewMode { today, weekly }

class HabitScreen extends StatefulWidget {
  const HabitScreen({
    super.key,
    this.variant = ThemeVariant.cotton,
    this.onViewModeChanged,
    this.onDateChanged,
    this.onOpenGoals,
  });
  final ThemeVariant variant;
  final ValueChanged<HabitScreenViewMode>? onViewModeChanged;
  final ValueChanged<DateTime>? onDateChanged;
  final VoidCallback? onOpenGoals;

  @override
  State<HabitScreen> createState() => HabitScreenState();
}

class HabitScreenState extends State<HabitScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  HabitScreenViewMode _viewMode = HabitScreenViewMode.today;
  bool get isWeeklyView => _viewMode == HabitScreenViewMode.weekly;
  HabitScreenViewMode get viewMode => _viewMode;
  DateTime get selectedDate => _selected;
  bool get isToday => _isSameDay(_selected, DateTime.now());
  late DateTime _weeklyStartDate = () {
    final now = DateTime.now();
    final mon = now.subtract(Duration(days: now.weekday - 1));
    return DateTime(mon.year, mon.month, mon.day);
  }();

  String title(BuildContext context, AppLocalizations l10n) {
    if (isWeeklyView) {
      final locale = Localizations.localeOf(context).toString();
      return formatWeekTitle(_weeklyStartDate, locale: locale);
    }
    if (isToday) return l10n.today;
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.MMMMd(locale).format(_selected);
  }

  void switchToToday([DateTime? date]) {
    if (!mounted) return;
    final target = date ?? DateTime.now();
    setState(() {
      _viewMode = HabitScreenViewMode.today;
      _selected = DateTime(target.year, target.month, target.day);
    });
    widget.onViewModeChanged?.call(_viewMode);
    widget.onDateChanged?.call(_selected);
  }

  void switchToWeekly([DateTime? date]) {
    if (!mounted) return;
    final target = date ?? _selected;
    final mon = target.subtract(Duration(days: target.weekday - 1));
    setState(() {
      _viewMode = HabitScreenViewMode.weekly;
      _weeklyStartDate = DateTime(mon.year, mon.month, mon.day);
    });
    widget.onViewModeChanged?.call(_viewMode);
    widget.onDateChanged?.call(_weeklyStartDate);
  }

  int get _activeTasksAndHabitsCount {
    try {
      final tasks =
          _filteredTasksForSelectedDay().where((t) => !t.isDone).length;
      final habits = _filteredHabits()
          .where((h) => !_isHabitCompletedOnDate(h, _selected))
          .length;
      return tasks + habits;
    } catch (_) {
      return 0;
    }
  }


  DateTime _selected = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  Key _listAnimationKey = UniqueKey();

  void reanimate() {
    if (mounted) {
      setState(() {
        _listAnimationKey = UniqueKey();
      });
    }
  }

  final HabitRepository _repo = HabitRepository.instance;
  final ListRepository _listRepo = ListRepository.instance;
  final DailyTaskRepository _taskRepo = DailyTaskRepository.instance;



  // Filter state
  Set<HabitType> _selectedTypes = {
    HabitType.simple,
    HabitType.numerical,
    HabitType.timer,
    HabitType.checkbox,
    HabitType.subtasks,
  };
  CompletionFilter _completionFilter = CompletionFilter.all;
  String? _selectedListId; // null = all lists
  bool _isOtherItemsExpanded =
      false; // Collapse non-focus items when focus is active

  @override
  void initState() {
    super.initState();
    _repo.addListener(_onRepoChange);
    _listRepo.addListener(_onRepoChange);
    _taskRepo.addListener(_onRepoChange);

    Future.wait([
      _repo.initialize(),
      _listRepo.initialize(),
      _taskRepo.initialize(),
    ]).then((_) {
      if (mounted) setState(() {});
      // Sync room habits from Firestore → local repo for all members
      RoomService.instance.syncRoomHabitsToLocal().then((_) {
        if (mounted) setState(() {});
      });
    });



    // Start rhythm timer to auto-update focus based on live rhythm
    _startRhythmTimer();

  }

  Timer? _rhythmTimer;
  RhythmWindow? _lastRhythmWindow;

  void _startRhythmTimer() {
    _rhythmTimer?.cancel();
    _rhythmTimer =
        Timer.periodic(const Duration(minutes: 1), (_) => _checkRhythmUpdate());
    // Initial check
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkRhythmUpdate());
  }

  void _checkRhythmUpdate() {
    if (!mounted) return;
    final rhythmRepo = LiveRhythmRepository.instance;
    // Only premium users typically use live rhythm features, but we can check existence
    if (!rhythmRepo.hasProfile) return;

    final currentWindow = rhythmRepo.currentWindow;
    if (currentWindow != _lastRhythmWindow) {
      _lastRhythmWindow = currentWindow;
      _updateFocusForRhythm(currentWindow);
    }
  }

  Future<void> _updateFocusForRhythm(RhythmWindow? window) async {
    if (window == null) return;

    // Find habits assigned to this window
    final candidates =
        _repo.habits.where((h) => h.rhythmWindow == window).toList();

    // If no habits match the current rhythm window, clear the focus
    if (candidates.isEmpty) {
      final (currentFocus, _) = _findFocusedItem();
      if (currentFocus != null) {
        print('clearing focus: no habits assigned to ${window.name}');
        await _clearFocus();
      }
      return;
    }

    // Prefer incomplete habits
    final best = candidates.firstWhere((h) => !h.isCompleted,
        orElse: () => candidates.first);

    // Check if we need to change focus
    final (currentFocus, _) = _findFocusedItem();
    if (currentFocus?.id != best.id) {
      print(
          'refocusing to ${best.title} due to rhythm change to ${window.name}');
      await _setAsFocus(best.id);
    }
  }

  Timer? _syncDebounce;

  void _onRepoChange() {
    if (!mounted) return;
    setState(() {});
    // Debounced sync of room progress to Firestore
    _syncDebounce?.cancel();
    _syncDebounce = Timer(const Duration(seconds: 2), () {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.isAnonymous) {
        RoomService.instance.syncAllMyProgress();
      }
    });
  }

  (Habit?, DailyTask?) _findFocusedItem() {
    try {
      final habit = _repo.habits.firstWhere((h) => h.isFocus);
      return (habit, null);
    } catch (_) {}
    try {
      final task = _taskRepo.allTasks.firstWhere((t) => t.isFocus);
      return (null, task);
    } catch (_) {}
    return (null, null);
  }

  Future<void> _setAsFocus(String id, {bool isHabit = true}) async {
    if (isHabit) {
      await _repo.setAsFocus(id);
      await _taskRepo.clearFocus();
    } else {
      await _taskRepo.setAsFocus(id);
      await _repo.clearFocus();
    }
  }

  Future<void> _clearFocus() async {
    await _repo.clearFocus();
    await _taskRepo.clearFocus();
  }

  // _ensureAutoFocus removed. Logic is simplified: if no focus, no card.

  bool _isHabitScheduledForDate(Habit habit, DateTime date) {
    // 1. Start/End Date Check
    final String startDateStr = habit.startDate;
    final DateTime startDate = DateTime(
      int.parse(startDateStr.substring(0, 4)),
      int.parse(startDateStr.substring(5, 7)),
      int.parse(startDateStr.substring(8, 10)),
    );
    // Normalize date to YYYY-MM-DD for comparison
    final DateTime checkDate = DateTime(date.year, date.month, date.day);
    final DateTime startOnly = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );

    if (checkDate.isBefore(startOnly)) return false;

    if (habit.endDate != null && habit.endDate!.isNotEmpty) {
      final String endDateStr = habit.endDate!;
      final DateTime endDate = DateTime(
        int.parse(endDateStr.substring(0, 4)),
        int.parse(endDateStr.substring(5, 7)),
        int.parse(endDateStr.substring(8, 10)),
      );
      final DateTime endOnly = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
      );
      if (checkDate.isAfter(endOnly)) return false;
    }

    // 2. Explicit Schedule Check provided by scheduledDates (e.g. from calendar picker)
    final dayKey = _dayKeyFromDate(date);
    if (habit.scheduledDates != null && habit.scheduledDates!.isNotEmpty) {
      return habit.scheduledDates!.contains(dayKey);
    }

    // 3. Frequency Logic
    if (habit.frequencyType == null) {
      // Default fallback: if no specific frequency type, assume daily (unless otherwise implied)
      return true;
    }

    switch (habit.frequencyType) {
      case 'daily':
        return true;
      case 'weekly': // Legacy/Wizard compatibility
      case 'specificWeekdays':
        if (habit.selectedWeekdays == null || habit.selectedWeekdays!.isEmpty) {
          return true;
        }
        // DateTime.weekday is 1..7 (Mon..Sun)
        // Ensure habit.selectedWeekdays matches this (1-indexed)
        // SimpleHabitWizard uses 0..6 (Mon..Sun) ? Let's check.
        // Wizard uses: weekdays = [l10n.mondayShort...]; index 0 = Mon.
        // So wizard saves 0 for Mon. DateTime.weekday gives 1 for Mon.
        // We need to adjust: stored 0 => check 1.
        // Actually let's assume wizard saves 0-indexed where 0=Monday.
        // DateTime.weekday: 1=Mon, 7=Sun.
        // So we check if selectedWeekdays contains (date.weekday - 1).

        // Let's verify what index wizard uses.
        // SimpleHabitWizard: _weeklyDays.add(index); index 0 is Monday.
        // Habit model might expect 1-7 or 0-6.
        // Let's handle 0-indexed (Mon=0) to match wizard.
        final int weekdayIndex = date.weekday - 1; // 0=Mon, 6=Sun
        return habit.selectedWeekdays!.contains(weekdayIndex) ||
            habit.selectedWeekdays!.contains(date.weekday);

      case 'monthly': // Legacy/Wizard compatibility
      case 'specificMonthDays':
        if (habit.selectedMonthDays == null ||
            habit.selectedMonthDays!.isEmpty) {
          return true;
        }
        return habit.selectedMonthDays!.contains(date.day);
      case 'specificYearDays':
        final md =
            '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        if (habit.selectedYearDays == null || habit.selectedYearDays!.isEmpty) {
          return true;
        }
        return habit.selectedYearDays!.contains(md);
      case 'periodic':
        if (habit.periodicDays == null || habit.periodicDays! <= 1) return true;
        final diff = checkDate.difference(startOnly).inDays;
        return (diff % habit.periodicDays!) == 0;
      default:
        return true;
    }
  }



  @override
  void dispose() {
    _repo.removeListener(_onRepoChange);
    _listRepo.removeListener(_onRepoChange);
    _taskRepo.removeListener(_onRepoChange);
    _rhythmTimer?.cancel();
    _syncDebounce?.cancel();
    super.dispose();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> showCalendar() async {
    if (isWeeklyView) {
      await showWeekPicker();
      return;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();

    DateTime selectedDay = _selected;
    DateTime displayMonth = DateTime(selectedDay.year, selectedDay.month, 1);

    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setPickerState) {
            final firstDayOfMonth = DateTime(displayMonth.year, displayMonth.month, 1);
            final daysInMonth = DateTime(displayMonth.year, displayMonth.month + 1, 0).day;
            final startWeekday = firstDayOfMonth.weekday; // 1 to 7
            final prevMonthDays = DateTime(displayMonth.year, displayMonth.month, 0).day;
            final totalCells = ((startWeekday - 1 + daysInMonth) / 7).ceil() * 7;
            final monthYearStr = DateFormat.yMMMM(locale).format(displayMonth);
            final now = DateTime.now();

            final weekdayLabels = [
              l10n.dayMonShort,
              l10n.dayTueShort,
              l10n.dayWedShort,
              l10n.dayThuShort,
              l10n.dayFriShort,
              l10n.daySatShort,
              l10n.daySunShort,
            ];

            return ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  decoration: BoxDecoration(
                    // The daily calendar must inherit the active palette;
                    // a fixed navy sheet conflicted with warm themes.
                    color: colorScheme.surfaceContainerHigh.withValues(
                      alpha: 0.94,
                    ),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.95),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.10),
                        blurRadius: 28,
                        offset: const Offset(0, -6),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          width: 38,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.calendar_month_rounded,
                              size: 20,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              monthYearStr,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                                fontFamily: 'Outfit',
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              setPickerState(() {
                                displayMonth = DateTime(displayMonth.year, displayMonth.month - 1, 1);
                              });
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorScheme.surfaceContainerHigh,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.95),
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.chevron_left_rounded,
                                size: 20,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              setPickerState(() {
                                displayMonth = DateTime(displayMonth.year, displayMonth.month + 1, 1);
                              });
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorScheme.surfaceContainerHigh,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.95),
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.chevron_right_rounded,
                                size: 20,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _buildQuickDateChip(
                            label: l10n.localeName.startsWith('tr') ? 'Dün' : 'Yesterday',
                            targetDate: now.subtract(const Duration(days: 1)),
                            selectedDate: selectedDay,
                            isDark: isDark,
                            primaryColor: colorScheme.primary,
                            onTap: (d) {
                              HapticFeedback.selectionClick();
                              setPickerState(() {
                                selectedDay = d;
                                displayMonth = DateTime(d.year, d.month, 1);
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildQuickDateChip(
                            label: l10n.localeName.startsWith('tr') ? 'Bugün' : 'Today',
                            targetDate: now,
                            selectedDate: selectedDay,
                            isDark: isDark,
                            primaryColor: colorScheme.primary,
                            onTap: (d) {
                              HapticFeedback.selectionClick();
                              setPickerState(() {
                                selectedDay = d;
                                displayMonth = DateTime(d.year, d.month, 1);
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildQuickDateChip(
                            label: l10n.localeName.startsWith('tr') ? 'Yarın' : 'Tomorrow',
                            targetDate: now.add(const Duration(days: 1)),
                            selectedDate: selectedDay,
                            isDark: isDark,
                            primaryColor: colorScheme.primary,
                            onTap: (d) {
                              HapticFeedback.selectionClick();
                              setPickerState(() {
                                selectedDay = d;
                                displayMonth = DateTime(d.year, d.month, 1);
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: weekdayLabels.map((lbl) {
                          return SizedBox(
                            width: 38,
                            child: Center(
                              child: Text(
                                lbl,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                          childAspectRatio: 1,
                        ),
                        itemCount: totalCells,
                        itemBuilder: (context, index) {
                          final dayOffset = index - (startWeekday - 1);
                          DateTime cellDate;
                          bool isCurrentMonth = true;

                          if (dayOffset < 0) {
                            final prevDay = prevMonthDays + dayOffset + 1;
                            cellDate = DateTime(displayMonth.year, displayMonth.month - 1, prevDay);
                            isCurrentMonth = false;
                          } else if (dayOffset >= daysInMonth) {
                            final nextDay = dayOffset - daysInMonth + 1;
                            cellDate = DateTime(displayMonth.year, displayMonth.month + 1, nextDay);
                            isCurrentMonth = false;
                          } else {
                            cellDate = DateTime(displayMonth.year, displayMonth.month, dayOffset + 1);
                          }

                          final isSelected = _isSameDay(cellDate, selectedDay);
                          final isToday = _isSameDay(cellDate, now);

                          return GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setPickerState(() {
                                selectedDay = cellDate;
                                if (!isCurrentMonth) {
                                  displayMonth = DateTime(cellDate.year, cellDate.month, 1);
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          colorScheme.primary,
                                          colorScheme.primary.withValues(alpha: 0.85),
                                        ],
                                      )
                                    : null,
                                color: isSelected
                                    ? null
                                    : (isToday
                                        ? colorScheme.primary.withValues(alpha: 0.12)
                                        : Colors.transparent),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.4)
                                      : (isToday
                                          ? colorScheme.primary.withValues(alpha: 0.5)
                                          : Colors.transparent),
                                  width: isSelected || isToday ? 1.5 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: colorScheme.primary.withValues(alpha: 0.35),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                        const BoxShadow(
                                          color: Colors.white24,
                                          blurRadius: 1.5,
                                          offset: Offset(0, -1),
                                        ),
                                      ]
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${cellDate.day}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : (!isCurrentMonth
                                          ? colorScheme.onSurface.withValues(alpha: 0.25)
                                          : (isToday
                                              ? colorScheme.primary
                                              : colorScheme.onSurface)),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          Navigator.of(context).pop(selectedDay);
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.primary,
                                colorScheme.primary.withValues(alpha: 0.85),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withValues(alpha: 0.4),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                              const BoxShadow(
                                color: Colors.white24,
                                blurRadius: 2,
                                offset: Offset(0, -1),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            l10n.localeName.startsWith('tr') ? 'Tarihe Git' : 'Go to Date',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (picked != null) {
      switchToToday(picked);
    }
  }

  Widget _buildQuickDateChip({
    required String label,
    required DateTime targetDate,
    required DateTime selectedDate,
    required bool isDark,
    required Color primaryColor,
    required ValueChanged<DateTime> onTap,
  }) {
    final isSelected = _isSameDay(targetDate, selectedDate);
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(targetDate),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor.withValues(alpha: 0.15)
                : colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? primaryColor.withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: isDark ? 0.08 : 0.9),
              width: 1.2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? primaryColor : null,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showWeekPicker() async {
    final pickedWeek = await showWeekPickerSheet(
      context: context,
      initialWeekStart: _weeklyStartDate,
      variant: widget.variant,
    );
    if (pickedWeek != null) {
      setState(() {
        _weeklyStartDate = pickedWeek;
      });
      widget.onDateChanged?.call(pickedWeek);
    }
  }

  String _dayKeyFromDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  bool _isHabitCompletedOnDate(Habit habit, DateTime date) {
    final String dayKey = _dayKeyFromDate(date);
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final bool isToday = _isSameDay(date, todayDate);
    // Before start date: not counted (and not considered missed)
    final String startDateStr = habit.startDate;
    final DateTime startDate = DateTime(
      int.parse(startDateStr.substring(0, 4)),
      int.parse(startDateStr.substring(5, 7)),
      int.parse(startDateStr.substring(8, 10)),
    );
    if (date.isBefore(
      DateTime(startDate.year, startDate.month, startDate.day),
    )) {
      return false;
    }
    // If habit has an explicit schedule, only consider days on that schedule
    if (habit.scheduledDates != null && habit.scheduledDates!.isNotEmpty) {
      if (!habit.scheduledDates!.contains(dayKey)) return false;
    }
    if (isToday) {
      // Live state for today: consider in-memory flag or explicit log entry
      if (habit.isCompleted) return true;
      // If there is an explicit entry today, evaluate it; otherwise not completed yet
      if (habit.dailyLog.containsKey(dayKey)) {
        return HabitRepository.evaluateCompletionFromLog(habit, dayKey);
      }
      return false;
    }
    // For non-today days: only completed if there is an explicit log entry that satisfies policy
    return HabitRepository.evaluateCompletionFromLog(habit, dayKey);
  }

  int _consecutiveMissedDaysBefore(Habit habit, DateTime date, {int cap = 7}) {
    int streak = 0;
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final String startDateStr = habit.startDate;
    final DateTime startDate = DateTime(
      int.parse(startDateStr.substring(0, 4)),
      int.parse(startDateStr.substring(5, 7)),
      int.parse(startDateStr.substring(8, 10)),
    );
    // Count from the day before the given date, back to startDate or until a completed is found
    DateTime cursor = DateTime(
      date.year,
      date.month,
      date.day,
    ).subtract(const Duration(days: 1));
    while (streak < cap) {
      // Stop if before start
      final dOnly = DateTime(cursor.year, cursor.month, cursor.day);
      if (dOnly.isBefore(
        DateTime(startDate.year, startDate.month, startDate.day),
      )) {
        break;
      }
      // For future days relative to 'today', don't count as missed
      if (dOnly.isAfter(todayDate)) break;
      // If scheduledDates present and the day is not scheduled, skip counting it as missed
      final String k = _dayKeyFromDate(dOnly);
      if (habit.scheduledDates != null && habit.scheduledDates!.isNotEmpty) {
        if (!habit.scheduledDates!.contains(k)) {
          cursor = cursor.subtract(const Duration(days: 1));
          continue;
        }
      }
      final completed = _isHabitCompletedOnDate(habit, dOnly);
      if (completed) break;
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  // Exposed for AppBar action in main.dart
  Future<void> showFilterSheet() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        Set<HabitType> localTypes = {..._selectedTypes};
        CompletionFilter localCompletion = _completionFilter;
        String? localListId = _selectedListId;
        return StatefulBuilder(
          builder: (context, setModalState) {
            final theme = Theme.of(context);
            final colorScheme = theme.colorScheme;
            final isDark = theme.brightness == Brightness.dark;
            final l10n = AppLocalizations.of(context);

            void toggleType(HabitType t) {
              setModalState(() {
                if (localTypes.contains(t)) {
                  localTypes.remove(t);
                } else {
                  localTypes.add(t);
                }
              });
            }

            Widget buildTypeChip(HabitType t, String label, IconData icon) {
              final isSelected = localTypes.contains(t);
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  toggleType(t);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              colorScheme.primary,
                              colorScheme.primary.withValues(alpha: 0.85),
                            ],
                          )
                        : null,
                    color: isSelected
                        ? null
                        : (isDark ? const Color(0xFF1E2430) : const Color(0xFFF4F6F9)),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.35)
                          : Colors.white.withValues(alpha: isDark ? 0.08 : 0.95),
                      width: 1.2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                            const BoxShadow(
                              color: Colors.white24,
                              blurRadius: 1.5,
                              offset: Offset(0, -1),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 1.5),
                            ),
                          ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 16,
                        color: isSelected
                            ? Colors.white
                            : colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : colorScheme.onSurface.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            Widget buildStatusOption(
              CompletionFilter value,
              String label,
              IconData icon,
            ) {
              final isSelected = localCompletion == value;
              return InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setModalState(() => localCompletion = value);
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        size: 20,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle_rounded,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                    ],
                  ),
                ),
              );
            }

            final content = Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Header
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.filterTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                        await openManageListsSheet();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E2430)
                              : const Color(0xFFF2F4F7),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: isDark ? 0.08 : 0.9,
                            ),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.folder_open_rounded,
                              size: 15,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              l10n.manageLists,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? const Color(0xFF1E2430) : Colors.white,
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: isDark ? 0.12 : 0.95,
                            ),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? 0.25 : 0.05,
                              ),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Type section
                Text(
                  l10n.typeLabel.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    buildTypeChip(
                      HabitType.simple,
                      l10n.simpleTypeShort,
                      Icons.check_circle_outline,
                    ),
                    buildTypeChip(
                      HabitType.numerical,
                      l10n.numericalType,
                      Icons.tag,
                    ),
                    buildTypeChip(
                      HabitType.timer,
                      l10n.timerType,
                      Icons.timer_outlined,
                    ),
                    buildTypeChip(
                      HabitType.checkbox,
                      l10n.checkboxType,
                      Icons.check_box_outlined,
                    ),
                    buildTypeChip(
                      HabitType.subtasks,
                      l10n.subtasksType,
                      Icons.checklist_rounded,
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // List section
                Text(
                  l10n.listLabel.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E2430)
                        : const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(
                        alpha: isDark ? 0.08 : 0.95,
                      ),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.15 : 0.03,
                        ),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: localListId,
                      isExpanded: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(
                            l10n.allLabel,
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        ..._listRepo.lists.map(
                          (l) => DropdownMenuItem<String?>(
                            value: l.id,
                            child: Text(
                              l.title,
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (v) => setModalState(() => localListId = v),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Status section
                Text(
                  l10n.statusLabel.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E2430)
                        : const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withValues(
                        alpha: isDark ? 0.08 : 0.95,
                      ),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.15 : 0.03,
                        ),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      buildStatusOption(
                        CompletionFilter.all,
                        l10n.allLabel,
                        Icons.list_alt_rounded,
                      ),
                      Divider(
                        height: 1,
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.15,
                        ),
                      ),
                      buildStatusOption(
                        CompletionFilter.completed,
                        l10n.completedSelectedDay,
                        Icons.check_circle_outline,
                      ),
                      Divider(
                        height: 1,
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.15,
                        ),
                      ),
                      buildStatusOption(
                        CompletionFilter.incomplete,
                        l10n.incompleteSelectedDay,
                        Icons.radio_button_unchecked,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.of(context).pop({'reset': true}),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF222938)
                                : const Color(0xFFF2F4F7),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.white.withValues(
                                alpha: isDark ? 0.08 : 0.9,
                              ),
                              width: 1.2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            l10n.clear,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: localTypes.isEmpty
                            ? null
                            : () {
                                HapticFeedback.mediumImpact();
                                Navigator.of(context).pop({
                                  'types': localTypes,
                                  'completion': localCompletion,
                                  'listId': localListId,
                                });
                              },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: localTypes.isNotEmpty
                                ? LinearGradient(
                                    colors: [
                                      colorScheme.primary,
                                      colorScheme.primary.withValues(
                                        alpha: 0.85,
                                      ),
                                    ],
                                  )
                                : null,
                            color: localTypes.isEmpty
                                ? (isDark ? Colors.white10 : Colors.black12)
                                : null,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: localTypes.isNotEmpty
                                  ? Colors.white.withValues(alpha: 0.35)
                                  : Colors.transparent,
                              width: 1.2,
                            ),
                            boxShadow: localTypes.isNotEmpty
                                ? [
                                    BoxShadow(
                                      color: colorScheme.primary.withValues(
                                        alpha: 0.4,
                                      ),
                                      blurRadius: 14,
                                      offset: const Offset(0, 5),
                                    ),
                                    const BoxShadow(
                                      color: Colors.white24,
                                      blurRadius: 2,
                                      offset: Offset(0, -1),
                                    ),
                                  ]
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            l10n.apply,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: localTypes.isEmpty
                                  ? colorScheme.onSurface.withValues(
                                      alpha: 0.4,
                                    )
                                  : Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );

            return ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF141923).withValues(alpha: 0.94)
                        : Colors.white.withValues(alpha: 0.94),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    border: Border.all(
                      color: Colors.white.withValues(
                        alpha: isDark ? 0.12 : 0.95,
                      ),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.45 : 0.10,
                        ),
                        blurRadius: 28,
                        offset: const Offset(0, -6),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    24 + MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SingleChildScrollView(child: content),
                ),
              ),
            );
          },
        );
      },
    );

    if (!mounted) return;
    if (result == null) return;
    if (result['reset'] == true) {
      setState(() {
        _selectedTypes = {
          HabitType.simple,
          HabitType.numerical,
          HabitType.timer,
        };
        _completionFilter = CompletionFilter.all;
        _selectedListId = null;
      });
      return;
    }
    final Set<HabitType>? types = (result['types'] as Set<HabitType>?);
    final CompletionFilter? completion =
        result['completion'] as CompletionFilter?;
    final String? listId = result['listId'] as String?;
    if (types != null && completion != null) {
      setState(() {
        _selectedTypes = types;
        _completionFilter = completion;
        _selectedListId = listId;
      });
    }
  }

  // Exposed for AppBar 3-dots menu action in main.dart
  Future<void> openManageListsSheet() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            final lists = _listRepo.lists;
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF141923).withValues(alpha: 0.94)
                        : Colors.white.withValues(alpha: 0.94),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    border: Border.all(
                      color: Colors.white.withValues(
                        alpha: isDark ? 0.12 : 0.95,
                      ),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.45 : 0.10,
                        ),
                        blurRadius: 28,
                        offset: const Offset(0, -6),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + bottomInset),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 38,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.folder_special_rounded,
                              size: 20,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.manageLists,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                    fontFamily: 'Outfit',
                                  ),
                                ),
                                Text(
                                  l10n.manageListsSubtitle,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? const Color(0xFF1E2430)
                                    : Colors.white,
                                border: Border.all(
                                  color: Colors.white.withValues(
                                    alpha: isDark ? 0.12 : 0.95,
                                  ),
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                      alpha: isDark ? 0.25 : 0.05,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (lists.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E2430)
                                : const Color(0xFFF7F8FA),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.white.withValues(
                                alpha: isDark ? 0.08 : 0.95,
                              ),
                              width: 1.2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.folder_open_rounded,
                                size: 36,
                                color: colorScheme.primary.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.localeName.startsWith('tr')
                                    ? 'Henüz liste oluşturulmadı'
                                    : 'No lists created yet',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.4,
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: lists.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, i) {
                              final l = lists[i];
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF1E2430)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: Colors.white.withValues(
                                      alpha: isDark ? 0.08 : 0.95,
                                    ),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: isDark ? 0.22 : 0.03,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withValues(
                                        alpha: isDark ? 0.04 : 0.8,
                                      ),
                                      blurRadius: 1,
                                      offset: const Offset(0, -1),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 34,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary.withValues(
                                          alpha: 0.12,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.label_rounded,
                                        size: 18,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        l.title,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final ctrl = TextEditingController(
                                          text: l.title,
                                        );
                                        final newTitle =
                                            await showDialog<String?>(
                                          context: context,
                                          builder: (dCtx) {
                                            return AlertDialog(
                                              title: Text(
                                                AppLocalizations.of(
                                                  context,
                                                ).editListTitle,
                                              ),
                                              content: TextField(
                                                controller: ctrl,
                                                decoration: InputDecoration(
                                                  labelText: AppLocalizations.of(
                                                    context,
                                                  ).listNameLabel,
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(dCtx, null),
                                                  child: Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    ).cancel,
                                                  ),
                                                ),
                                                FilledButton(
                                                  onPressed: () {
                                                    final t = ctrl.text.trim();
                                                    Navigator.pop(
                                                      dCtx,
                                                      t.isEmpty ? null : t,
                                                    );
                                                  },
                                                  child: Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    ).save,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        if (newTitle != null &&
                                            newTitle != l.title) {
                                          await _listRepo.updateList(
                                            AppList(id: l.id, title: newTitle),
                                          );
                                          setStateSheet(() {});
                                        }
                                      },
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? const Color(0xFF2A3242)
                                              : const Color(0xFFF2F4F7),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.edit_outlined,
                                          size: 16,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () async {
                                        bool cascadeHabits = true;
                                        bool cascadeTasks = true;
                                        final confirmed =
                                            await showDialog<bool>(
                                          context: context,
                                          builder: (dCtx) {
                                            return StatefulBuilder(
                                              builder: (context, setStateDialog) {
                                                return AlertDialog(
                                                  title: Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    ).deleteListTitle,
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                          context,
                                                        ).deleteListMessage,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      CheckboxListTile(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        value: cascadeHabits,
                                                        onChanged: (v) =>
                                                            setStateDialog(
                                                          () => cascadeHabits =
                                                              v ?? true,
                                                        ),
                                                        title: Text(
                                                          AppLocalizations.of(
                                                            context,
                                                          ).unassignLinkedHabits,
                                                        ),
                                                      ),
                                                      CheckboxListTile(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        value: cascadeTasks,
                                                        onChanged: (v) =>
                                                            setStateDialog(
                                                          () => cascadeTasks =
                                                              v ?? true,
                                                        ),
                                                        title: Text(
                                                          AppLocalizations.of(
                                                            context,
                                                          ).unassignLinkedDailyTasks,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                        dCtx,
                                                        false,
                                                      ),
                                                      child: Text(
                                                        AppLocalizations.of(
                                                          context,
                                                        ).cancel,
                                                      ),
                                                    ),
                                                    FilledButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                        dCtx,
                                                        true,
                                                      ),
                                                      child: Text(
                                                        AppLocalizations.of(
                                                          context,
                                                        ).delete,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        );
                                        if (confirmed != true) return;
                                        if (cascadeHabits) {
                                          for (final h in _repo.habits.where(
                                            (h) => h.listId == l.id,
                                          )) {
                                            await _repo.assignHabitToList(
                                              h.id,
                                              null,
                                            );
                                          }
                                        }
                                        if (cascadeTasks) {
                                          for (final t in _taskRepo.allTasks
                                              .where(
                                            (t) => t.listId == l.id,
                                          )) {
                                            await _taskRepo.assignTaskToList(
                                              t.id,
                                              null,
                                            );
                                          }
                                        }
                                        await _listRepo.removeList(l.id);
                                        if (mounted) setStateSheet(() {});
                                      },
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent.withValues(
                                            alpha: 0.12,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                          Icons.delete_outline,
                                          size: 16,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 18),
                      // Create New List Capsule Button
                      GestureDetector(
                        onTap: () async {
                          final res = await showDialog<Map<String, dynamic>>(
                            context: context,
                            builder: (context) => const ListCreationDialog(),
                          );
                          if (res != null &&
                              (res['title'] as String).trim().isNotEmpty) {
                            final list = AppList(
                              id: UniqueKey().toString(),
                              title: (res['title'] as String).trim(),
                            );
                            await _listRepo.addList(list);
                            if (mounted) setStateSheet(() {});
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(
                                    context,
                                  ).listCreatedMessage(list.title),
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 52,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.primary,
                                colorScheme.primary.withValues(alpha: 0.85),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                              const BoxShadow(
                                color: Colors.white24,
                                blurRadius: 2,
                                offset: Offset(0, -1),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.newList,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedTypes = {
        HabitType.simple,
        HabitType.numerical,
        HabitType.timer,
        HabitType.checkbox,
        HabitType.subtasks,
      };
      _completionFilter = CompletionFilter.all;
      _selectedListId = null;
    });
  }

  bool _isHabitCompletedOnSelected(Habit habit) {
    final String dayKey =
        '${_selected.year}-${_selected.month.toString().padLeft(2, '0')}-${_selected.day.toString().padLeft(2, '0')}';
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(
      _selected.year,
      _selected.month,
      _selected.day,
    );
    final bool isToday = _isSameDay(selectedDate, todayDate);
    // Başlangıç tarihinden önce ise tamamlanmış sayılmaz
    final String startDateStr = habit.startDate;
    final DateTime startDate = DateTime(
      int.parse(startDateStr.substring(0, 4)),
      int.parse(startDateStr.substring(5, 7)),
      int.parse(startDateStr.substring(8, 10)),
    );
    final bool isBeforeStart = selectedDate.isBefore(
      DateTime(startDate.year, startDate.month, startDate.day),
    );
    if (isBeforeStart) return false;

    // Today: in-memory completion or explicit log; Other days: explicit log only
    final bool dayCompleted = isToday
        ? (habit.isCompleted ||
            HabitRepository.evaluateCompletionFromLog(habit, dayKey))
        : HabitRepository.evaluateCompletionFromLog(habit, dayKey);
    return dayCompleted;
  }

  bool _matchesCompletionFilter(Habit h) => switch (_completionFilter) {
        CompletionFilter.all => true,
        CompletionFilter.completed => _isHabitCompletedOnSelected(h),
        CompletionFilter.incomplete => !_isHabitCompletedOnSelected(h),
      };

  List<Habit> _filteredHabits() {
    final list = _repo.habits
        .where((h) => _selectedTypes.contains(h.habitType))
        .where(_matchesCompletionFilter)
        .where(
          (h) => _selectedListId == null ? true : h.listId == _selectedListId,
        )
        .where((h) => _isHabitScheduledForDate(h, _selected))
        .toList();

    list.sort((a, b) {
      final timeA = _getHabitTimeInMinutes(a);
      final timeB = _getHabitTimeInMinutes(b);
      final diff = timeA.compareTo(timeB);
      if (diff != 0) return diff;
      return _repo.habits.indexOf(a).compareTo(_repo.habits.indexOf(b));
    });
    return list;
  }

  List<DailyTask> _filteredTasksForSelectedDay() {
    final String dayKey =
        '${_selected.year}-${_selected.month.toString().padLeft(2, '0')}-${_selected.day.toString().padLeft(2, '0')}';
    // Use carry-over aware retrieval so incomplete tasks from previous days
    // continue to appear until completed.
    final tasks = _taskRepo.tasksForDateWithCarryover(dayKey);
    // Apply list filter only (type filter is for habits). Completion filter affects tasks, too.
    List<DailyTask> listFiltered = _selectedListId == null
        ? tasks
        : tasks.where((t) => t.listId == _selectedListId).toList();
    switch (_completionFilter) {
      case CompletionFilter.all:
        return listFiltered;
      case CompletionFilter.completed:
        return listFiltered.where((t) => t.isDone).toList();
      case CompletionFilter.incomplete:
        return listFiltered.where((t) => !t.isDone).toList();
    }
  }

  /// Groups habits and tasks by their listId for grouped display
  List<_GroupedItem> _buildGroupedItems(
    List<Habit> habits,
    List<DailyTask> tasks,
  ) {
    final items = <_GroupedItem>[];
    final l10n = AppLocalizations.of(context);

    final filteredHabits = habits;
    final filteredTasks = tasks;

    // Get all lists and create a map for quick lookup
    final listsMap = <String, AppList>{};
    for (final l in _listRepo.lists) {
      listsMap[l.id] = l;
    }

    // Collect all unique listIds from habits and tasks
    final listIds = <String?>{};
    for (final h in filteredHabits) {
      listIds.add(h.listId);
    }
    for (final t in filteredTasks) {
      listIds.add(t.listId);
    }

    // Sort listIds: named lists first (alphabetically), then null (unlisted) at the end
    final sortedListIds = listIds.toList()
      ..sort((a, b) {
        if (a == null && b == null) return 0;
        if (a == null) return 1; // null goes last
        if (b == null) return -1;
        final aTitle = listsMap[a]?.title ?? '';
        final bTitle = listsMap[b]?.title ?? '';
        return aTitle.compareTo(bTitle);
      });

    // Build grouped items
    for (final listId in sortedListIds) {
      var listHabits = filteredHabits.where((h) => h.listId == listId).toList();
      final listTasks = filteredTasks.where((t) => t.listId == listId).toList();

      if (listHabits.isEmpty && listTasks.isEmpty) continue;

      // Sort habits by rhythm match: current window matching habits first
      final currentWindow = LiveRhythmRepository.instance.currentWindow;
      if (currentWindow != null) {
        listHabits.sort((a, b) {
          final aMatches = a.rhythmWindow == currentWindow;
          final bMatches = b.rhythmWindow == currentWindow;
          if (aMatches && !bMatches) return -1;
          if (!aMatches && bMatches) return 1;
          return 0;
        });
      }

      // Add list header
      final listTitle = listId == null
          ? l10n.unlistedItems
          : (listsMap[listId]?.title ?? l10n.unknownList);
      items.add(_ListHeader(listId: listId, title: listTitle));

      // Add tasks first, then habits
      for (final task in listTasks) {
        items.add(_TaskItem(task));
      }
      for (final habit in listHabits) {
        items.add(_HabitItem(habit));
      }
    }

    return items;
  }

  Widget _buildListHeaderWidget(_ListHeader header) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isUnlisted = header.listId == null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
            decoration: BoxDecoration(
              color: isUnlisted
                  ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
                  : colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isUnlisted
                    ? colorScheme.outlineVariant.withValues(alpha: 0.25)
                    : colorScheme.primary.withValues(alpha: 0.20),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isUnlisted ? Icons.inbox_outlined : Icons.folder_outlined,
                  size: 11,
                  color: isUnlisted
                      ? colorScheme.outline
                      : colorScheme.primary,
                ),
                const SizedBox(width: 5),
                Text(
                  header.title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.5,
                    letterSpacing: 0.7,
                    fontWeight: FontWeight.w800,
                    color: isUnlisted
                        ? colorScheme.outline
                        : colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCardWidget(DailyTask task) {
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(
      _selected.year,
      _selected.month,
      _selected.day,
    );
    final String dayKey =
        '${_selected.year}-${_selected.month.toString().padLeft(2, '0')}-${_selected.day.toString().padLeft(2, '0')}';
    final isToday = _isSameDay(selectedDate, todayDate);

    // Determine if this card should be muted (focus is active and this is not the focused item)
    final (focusHabit, focusTask) = _findFocusedItem();
    return _TaskCard(
      title: task.title,
      description: task.description,
      isDone: task.isDone,
      isMuted: false,
      listName:
          null, // Don't show list name in grouped view since it's under the header
      onToggleDone: (value) {
        setState(() {
          task.isDone = value;
          // Set completion date to currently selected day when marked as done
          if (value) {
            task.completionDateKey = dayKey;
          } else {
            task.completionDateKey = null;
          }
        });
        _taskRepo.updateTask(task);
      },
      onAssignToList: () => _assignTaskToListDialog(task),
      onSetAsFocus: isToday
          ? () {
              _setAsFocus(task.id, isHabit: false);
            }
          : null,
      onEdit: () async {
        final res = await showDialog<Map<String, dynamic>>(
          context: context,
          builder: (ctx) => DailyTaskDialog(),
        );
        if (res != null) {
          final newTitle = (res['title'] as String?)?.trim() ?? task.title;
          final newDescription =
              (res['description'] as String?)?.trim() ?? task.description;
          task.title = newTitle;
          task.description = newDescription;
          await _taskRepo.updateTask(task);
        }
      },
      onDelete: () async {
        final confirmed = await _confirmDelete(
          title: AppLocalizations.of(context).delete,
          message:
              '${AppLocalizations.of(context).deleteTaskConfirmTitle}\n\n${AppLocalizations.of(context).deleteTaskConfirmMessage}',
          confirmText: AppLocalizations.of(context).delete,
          cancelText: AppLocalizations.of(context).cancel,
        );
        if (confirmed) {
          await _taskRepo.removeTask(task.id);
        }
      },
    );
  }

  Widget _buildHabitCardWidget(Habit habit) {
    final String dayKey =
        '${_selected.year}-${_selected.month.toString().padLeft(2, '0')}-${_selected.day.toString().padLeft(2, '0')}';
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(
      _selected.year,
      _selected.month,
      _selected.day,
    );
    final bool isToday = _isSameDay(selectedDate, todayDate);
    final bool isFuture = selectedDate.isAfter(todayDate);

    final String startDateStr = habit.startDate;
    final DateTime startDate = DateTime(
      int.parse(startDateStr.substring(0, 4)),
      int.parse(startDateStr.substring(5, 7)),
      int.parse(startDateStr.substring(8, 10)),
    );
    final bool isBeforeStart = selectedDate.isBefore(
      DateTime(startDate.year, startDate.month, startDate.day),
    );

    final int dayProgress =
        isToday ? habit.currentStreak : (habit.dailyLog[dayKey] ?? 0);
    final bool dayCompleted = isToday
        ? (habit.isCompleted ||
            HabitRepository.evaluateCompletionFromLog(habit, dayKey))
        : HabitRepository.evaluateCompletionFromLog(habit, dayKey);
    final int missedBefore = _consecutiveMissedDaysBefore(
      habit,
      selectedDate,
      cap: 7,
    );

    // Subtasks için: geçmiş tarih ise subtasksLog'dan yükle, değilse mevcut subtasks kullan
    List<Subtask>? displaySubtasks;
    if (habit.habitType == HabitType.subtasks) {
      if (isToday) {
        displaySubtasks = habit.subtasks;
      } else if (habit.subtasksLog.containsKey(dayKey)) {
        // Geçmiş tarih için subtasksLog'dan yükle
        displaySubtasks = habit.subtasksLog[dayKey]!
            .map(
              (s) => Subtask(
                id: s['id'] as String,
                title: s['title'] as String,
                isCompleted: s['isCompleted'] as bool? ?? false,
              ),
            )
            .toList();
      } else {
        // Henüz log yok, tüm subtasks'leri tamamlanmamış olarak göster
        displaySubtasks = habit.subtasks
            .map((s) => Subtask(id: s.id, title: s.title, isCompleted: false))
            .toList();
      }
    }

    // Non-focus items are now fully opaque
    const isMuted = false;

    return HabitCard(
      title: habit.title,
      description: _buildHabitSubtitle(habit),
      isMuted: isMuted,
      icon: habit.icon,
      emoji: habit.emoji,
      categoryName: habit.categoryName,
      color: habit.color,
      currentStreak: dayProgress,
      streakCount: HabitRepository.instance.consecutiveStreak(
        habit.id,
        upTo: selectedDate,
      ),
      targetCount: habit.targetCount,
      isCompleted: dayCompleted,
      habitType: habit.habitType,
      numericalTargetType: habit.habitType == HabitType.numerical
          ? habit.numericalTargetType
          : null,
      timerTargetType:
          habit.habitType == HabitType.timer ? habit.timerTargetType : null,
      unit: habit.unit,
      readOnly: isFuture || isBeforeStart,
      iceEnabled: !isFuture &&
          !isBeforeStart &&
          (habit.habitType == HabitType.simple ||
              habit.habitType == HabitType.checkbox),
      requiredBreakTaps: missedBefore,
      onTap: () {
        if (isFuture || isBeforeStart) return;
        if (habit.habitType == HabitType.simple ||
            habit.habitType == HabitType.checkbox) {
          if (isToday) {
            _repo.toggleSimple(habit.id);
          } else {
            _repo.toggleSimpleForDate(habit.id, _selected);
          }
        }
      },
      onAssignToList: () => _assignHabitToListDialog(habit),
      showStreakIndicator: _repo.getShowStreakIndicatorFor(habit.id),
      onToggleStreakIndicator: (v) async {
        await _repo.setShowStreakIndicatorFor(habit.id, v);
      },
      onValueUpdate: (newValue) {
        if (isFuture || isBeforeStart) return;
        if (habit.habitType == HabitType.numerical ||
            habit.habitType == HabitType.timer) {
          if (isToday) {
            _repo.setManualProgress(habit.id, newValue);
          } else {
            _repo.setManualProgressForDate(habit.id, _selected, newValue);
          }
        }
      },
      onSetAsFocus: isToday
          ? () async {
              if (await requirePremium(context)) {
                _setAsFocus(habit.id);
              }
            }
          : null,
      onAnalyze: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HabitAnalysisScreen(
              habitTitle: habit.title,
              habitDescription: habit.description,
              habitIcon: habit.icon,
              habitColor: habit.color,
              currentStreak: habit.currentStreak,
              targetCount: habit.targetCount,
              unit: habit.unit,
              habitId: habit.id,
            ),
          ),
        );
      },
      onEdit: () => _editHabit(habit),
      onDelete: () => _deleteHabit(habit),
      subtasks: displaySubtasks,
      onSubtaskToggle: (subtaskId, completed) {
        if (isFuture || isBeforeStart) return;
        if (isToday) {
          _repo.toggleSubtask(habit.id, subtaskId, completed);
        } else {
          _repo.toggleSubtaskForDate(habit.id, subtaskId, completed, _selected);
        }
      },
    );
  }

  Future<void> _editHabit(Habit habit) async {
    // Vision habits: edit with AdvancedHabitScreen (vision context)
    if (habit.linkedVisionId != null) {
      final visionRepo = VisionRepository.instance;
      await visionRepo.initialize();
      final visions = await visionRepo.stream.first;
      final vision = visions.cast<Vision?>().firstWhere(
            (v) => v?.id == habit.linkedVisionId,
            orElse: () => null,
          );

      if (!mounted) return;

      if (vision != null) {
        final result = await Navigator.of(context).push<Map<String, dynamic>>(
          MaterialPageRoute(
            builder: (context) => AdvancedHabitScreen(
              editingHabitMap: {
                'id': habit.id,
                'title': habit.title,
                'description': habit.description,
                'icon': habit.icon,
                'color': habit.color,
                'targetCount': habit.targetCount,
                'habitType': habit.habitType,
                'unit': habit.unit,
                if (habit.emoji != null) 'emoji': habit.emoji,
                'numericalTargetType': habit.numericalTargetType,
                'timerTargetType': habit.timerTargetType,
                'startDate': habit.startDate,
                'endDate': habit.endDate,
                if (habit.scheduledDates != null)
                  'scheduledDates': habit.scheduledDates,
                'reminderEnabled': habit.reminderEnabled,
                if (habit.reminderTime != null)
                  'reminderTime': {
                    'hour': habit.reminderTime!.hour,
                    'minute': habit.reminderTime!.minute,
                  },
                'visionId': vision.id,
                'visionStartDate': vision.startDate,
                'visionEndDate': vision.endDate,
              },
              useVisionDayOffsets: true,
              returnAsMap: true,
            ),
          ),
        );
        if (result != null) {
          _applyHabitEditResult(habit, result);
        }
      }
      return;
    }

    // Simple habit type
    if (habit.habitType == HabitType.simple && !habit.isAdvanced) {
      final editedHabit = await Navigator.of(context).push<Habit>(
        MaterialPageRoute(
          builder: (context) => SimpleHabitScreen(existingHabit: habit),
        ),
      );
      if (editedHabit != null) {
        habit.title = editedHabit.title;
        habit.description = editedHabit.description;
        habit.emoji = editedHabit.emoji;
        habit.color = editedHabit.color;
        habit.frequency = editedHabit.frequency;
        habit.frequencyType = editedHabit.frequencyType;
        habit.selectedWeekdays = editedHabit.selectedWeekdays;
        habit.selectedMonthDays = editedHabit.selectedMonthDays;
        habit.selectedYearDays = editedHabit.selectedYearDays;
        habit.periodicDays = editedHabit.periodicDays;
        habit.scheduledDates = editedHabit.scheduledDates;
        habit.startDate = editedHabit.startDate;
        habit.progressDate = editedHabit.progressDate;
        habit.reminderEnabled = editedHabit.reminderEnabled;
        habit.reminderTime = editedHabit.reminderTime;
        habit.rhythmWindow = editedHabit.rhythmWindow;
        await _repo.updateHabit(habit);
      }
      return;
    }

    // Advanced habit - Habit objesi döndür
    final editedHabit = await Navigator.of(context).push<Habit>(
      MaterialPageRoute(
        builder: (context) => AdvancedHabitScreen(existingHabit: habit),
      ),
    );
    if (editedHabit != null) {
      habit.title = editedHabit.title;
      habit.description = editedHabit.description;
      habit.color = editedHabit.color;
      habit.emoji = editedHabit.emoji;
      habit.habitType = editedHabit.habitType;
      habit.targetCount = editedHabit.targetCount;
      habit.unit = editedHabit.unit;
      habit.numericalTargetType = editedHabit.numericalTargetType;
      habit.timerTargetType = editedHabit.timerTargetType;
      habit.frequency = editedHabit.frequency;
      habit.frequencyType = editedHabit.frequencyType;
      habit.selectedWeekdays = editedHabit.selectedWeekdays;
      habit.selectedMonthDays = editedHabit.selectedMonthDays;
      habit.selectedYearDays = editedHabit.selectedYearDays;
      habit.periodicDays = editedHabit.periodicDays;
      habit.scheduledDates = editedHabit.scheduledDates;
      habit.startDate = editedHabit.startDate;
      habit.progressDate = editedHabit.progressDate;
      habit.endDate = editedHabit.endDate;
      habit.reminderEnabled = editedHabit.reminderEnabled;
      habit.reminderTime = editedHabit.reminderTime;
      habit.rhythmWindow = editedHabit.rhythmWindow;
      habit.subtasks = editedHabit.subtasks;
      habit.subtasksLog = editedHabit.subtasksLog;
      await _repo.updateHabit(habit);
    }
  }

  void _applyHabitEditResult(Habit habit, Map<String, dynamic> result) {
    habit.title = (result['title'] ?? habit.title) as String;
    habit.description = (result['description'] ?? habit.description) as String;
    if (result['color'] is int) {
      habit.color = Color(result['color'] as int);
    } else if (result['color'] is Color) {
      habit.color = result['color'] as Color;
    }
    if (result['emoji'] is String &&
        (result['emoji'] as String).trim().isNotEmpty) {
      habit.emoji = (result['emoji'] as String).trim();
    }
    if (result['frequency'] is String) {
      final f = (result['frequency'] as String).trim();
      habit.frequency = f.isEmpty ? null : f;
    }
    if (result['frequencyType'] != null) {
      habit.frequencyType = result['frequencyType']?.toString();
    }

    if (result['targetCount'] is int) {
      habit.targetCount = result['targetCount'] as int;
    }
    if (result['unit'] is String) {
      habit.unit = result['unit'] as String;
    }
    if (result['habitType'] is HabitType) {
      habit.habitType = result['habitType'] as HabitType;
    }
    if (result['numericalTargetType'] is NumericalTargetType) {
      habit.numericalTargetType =
          result['numericalTargetType'] as NumericalTargetType;
    }
    if (result['timerTargetType'] is TimerTargetType) {
      habit.timerTargetType = result['timerTargetType'] as TimerTargetType;
    }
    if (result['scheduledDates'] is List) {
      habit.scheduledDates = List<String>.from(result['scheduledDates']);
    }
    if (result['startDate'] is String) {
      habit.startDate = result['startDate'] as String;
    }
    if (result['endDate'] is String?) {
      habit.endDate = result['endDate'] as String?;
    }
    if (result['subtasks'] is List) {
      habit.subtasks = (result['subtasks'] as List)
          .map((e) => Subtask.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (result['rhythmWindow'] is RhythmWindow?) {
      habit.rhythmWindow = result['rhythmWindow'] as RhythmWindow?;
    }

    _repo.updateHabit(habit);
  }

  Future<void> _deleteHabit(Habit habit) async {
    print('DEBUG: _deleteHabit called for ${habit.title}');
    final confirmed = await _confirmDelete(
      title: AppLocalizations.of(context).delete,
      message: AppLocalizations.of(context).deleteHabitConfirm(habit.title),
      confirmText: AppLocalizations.of(context).delete,
      cancelText: AppLocalizations.of(context).cancel,
    );
    print('DEBUG: _confirmDelete returned $confirmed');
    if (confirmed) {
      try {
        print('DEBUG: Calling _repo.removeHabit...');
        await _repo.removeHabit(habit.id);
        print('DEBUG: _repo.removeHabit completed');
        if (mounted) setState(() {});
      } catch (e) {
        print('DEBUG: Error deleting habit: $e');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  String _buildHabitSubtitle(Habit habit) {
    // Only show the habit's own description; do not append the list title.
    return habit.description;
  }

  Future<void> _assignHabitToListDialog(Habit habit) async {
    // show dialog with list options + create new
    final selected = await showModalBottomSheet<String?>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.clear_all_outlined),
                title: Text(AppLocalizations.of(context).removeFromList),
                onTap: () => Navigator.pop(context, ''),
              ),
              const Divider(height: 1),
              ..._listRepo.lists.map(
                (l) => ListTile(
                  leading: const Icon(Icons.label_outline),
                  title: Text(l.title),
                  trailing: habit.listId == l.id
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () => Navigator.pop(context, l.id),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.add_outlined),
                title: Text(AppLocalizations.of(context).createNewList),
                onTap: () async {
                  final res = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (context) => const ListCreationDialog(),
                  );
                  if (res != null &&
                      (res['title'] as String).trim().isNotEmpty) {
                    final list = AppList(
                      id: UniqueKey().toString(),
                      title: (res['title'] as String).trim(),
                    );
                    await _listRepo.addList(list);
                    if (!mounted) return;
                    Navigator.pop(context, list.id);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
    if (selected == null) return;
    final listId = selected.isEmpty ? null : selected;
    await _repo.assignHabitToList(habit.id, listId);
  }

  Future<void> _assignTaskToListDialog(DailyTask task) async {
    final selected = await showModalBottomSheet<String?>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.clear_all_outlined),
                title: Text(AppLocalizations.of(context).removeFromList),
                onTap: () => Navigator.pop(context, ''),
              ),
              const Divider(height: 1),
              ..._listRepo.lists.map(
                (l) => ListTile(
                  leading: const Icon(Icons.label_outline),
                  title: Text(l.title),
                  trailing: task.listId == l.id
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () => Navigator.pop(context, l.id),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.add_outlined),
                title: Text(AppLocalizations.of(context).createNewList),
                onTap: () async {
                  final res = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (context) => const ListCreationDialog(),
                  );
                  if (res != null &&
                      (res['title'] as String).trim().isNotEmpty) {
                    final list = AppList(
                      id: UniqueKey().toString(),
                      title: (res['title'] as String).trim(),
                    );
                    await _listRepo.addList(list);
                    if (!mounted) return;
                    Navigator.pop(context, list.id);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
    if (selected == null) return;
    final listId = selected.isEmpty ? null : selected;
    await _taskRepo.assignTaskToList(task.id, listId);
  }

  Future<bool> _confirmDelete({
    required String title,
    required String message,
    String confirmText = 'Sil',
    String cancelText = 'İptal',
  }) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(cancelText),
          ),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return res ?? false;
  }

  Future<void> _pickDate() => showCalendar();

  void _showDailyTaskDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const DailyTaskDialog(),
    );

    if (result != null) {
      final String title = (result['title'] as String?)?.trim() ?? '';
      final String description =
          (result['description'] as String?)?.trim() ?? '';
      if (title.isEmpty) return;
      final String dayKey =
          '${_selected.year}-${_selected.month.toString().padLeft(2, '0')}-${_selected.day.toString().padLeft(2, '0')}';
      final task = DailyTask(
        id: UniqueKey().toString(),
        title: title,
        description: description,
        dateKey: dayKey,
      );
      await _taskRepo.addTask(task);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).dailyTaskCreatedMessage(task.title),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }

  void _navigateToCreateHabit() {
    _showHabitTypeSelectionModal();
  }

  void _showHabitTypeSelectionModal() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              l10n.habitTypePickerTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.habitTypePickerSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Simple Habit Option
            _HabitTypeOption(
              icon: Icons.check_circle_outline,
              title: l10n.simpleHabitTitle,
              description: l10n.simpleHabitTypeDescription,
              color: colorScheme.primary,
              onTap: () {
                Navigator.pop(context);
                _createSimpleHabit();
              },
            ),
            const SizedBox(height: 12),

            // Advanced Habit Option
            _HabitTypeOption(
              icon: Icons.auto_graph,
              title: l10n.advancedHabitTitle,
              description: l10n.advancedHabitTypeDescription,
              color: colorScheme.secondary,
              onTap: () {
                Navigator.pop(context);
                _createAdvancedHabit();
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _ensureRhythmListAndAssign(Habit habit) async {
    // Only assign if it has a rhythm window and is NOT currently in a list (Unlisted)
    if (habit.rhythmWindow == null || habit.listId != null) return;

    final l10n = AppLocalizations.of(context);
    String listTitle;
    switch (habit.rhythmWindow!) {
      case RhythmWindow.focus:
        listTitle = l10n.rhythmWindowFocus;
        break;
      case RhythmWindow.energy:
        listTitle = l10n.rhythmWindowEnergy;
        break;
      case RhythmWindow.light:
        listTitle = l10n.rhythmWindowLight;
        break;
      case RhythmWindow.reflection:
        listTitle = l10n.rhythmWindowReflection;
        break;
    }

    try {
      final existingList =
          _listRepo.lists.firstWhere((l) => l.title == listTitle);
      habit.listId = existingList.id;
    } catch (_) {
      // Create new list
      final newList = AppList(id: UniqueKey().toString(), title: listTitle);
      await _listRepo.addList(newList);
      habit.listId = newList.id;
    }
  }

  void _createSimpleHabit() async {
    final habit = await Navigator.of(context).push<Habit>(
      MaterialPageRoute(builder: (context) => const SimpleHabitWizardScreen()),
    );

    if (habit != null && mounted) {
      await _ensureRhythmListAndAssign(habit);
      await _repo.addHabit(habit);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).habitCreatedMessage(habit.title),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    }
  }

  void _createAdvancedHabit() async {
    final ok = await requirePremium(context);
    if (!ok) return;

    final habit = await Navigator.of(context).push<Habit>(
      MaterialPageRoute(
        builder: (context) => const AdvancedHabitWizardScreen(),
      ),
    );

    if (habit != null && mounted) {
      habit.isAdvanced = true;
      await _ensureRhythmListAndAssign(habit);
      await _repo.addHabit(habit);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).habitCreatedMessage(habit.title),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    }
  }

  void _showListCreationDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const ListCreationDialog(),
    );

    if (result != null) {
      final title = (result['title'] as String?)?.trim();
      if (title != null && title.isNotEmpty) {
        final list = AppList(id: UniqueKey().toString(), title: title);
        await _listRepo.addList(list);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).listCreated(list.title)),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    }
  }

  /// Builds the toggle button to expand/collapse non-focus items
  Widget _buildOtherItemsToggle(int itemCount) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _isOtherItemsExpanded = !_isOtherItemsExpanded;
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.4,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                _isOtherItemsExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _getHabitTimeInMinutes(Habit h) {
    if (h.reminderTime != null) {
      return h.reminderTime!.hour * 60 + h.reminderTime!.minute;
    }
    if (h.rhythmWindow != null) {
      switch (h.rhythmWindow!) {
        case RhythmWindow.energy:
          return 9 * 60; // 09:00
        case RhythmWindow.focus:
          return 12 * 60 + 30; // 12:30
        case RhythmWindow.light:
          return 15 * 60; // 15:00
        case RhythmWindow.reflection:
          return 20 * 60; // 20:00
      }
    }
    final idx = _repo.habits.indexOf(h);
    const fallbackSlots = [
      8 * 60, // 08:00
      9 * 60 + 30, // 09:30
      11 * 60, // 11:00
      13 * 60, // 13:00
      14 * 60 + 30, // 14:30
      16 * 60, // 16:00
      17 * 60 + 30, // 17:30
      19 * 60, // 19:00
      20 * 60 + 30, // 20:30
      22 * 60, // 22:00
    ];
    return fallbackSlots[(idx >= 0 ? idx : 0) % fallbackSlots.length];
  }

  String _formatHabitTime(Habit h) {
    final totalMins = _getHabitTimeInMinutes(h);
    final hour = (totalMins ~/ 60).toString().padLeft(2, '0');
    final min = (totalMins % 60).toString().padLeft(2, '0');
    return '$hour:$min';
  }

  void _openAdvancedHabitDialog(
    Habit habit,
    int currentProgress,
    List<Subtask>? subtasks,
  ) {
    showAdvancedHabitDialog(
      context: context,
      habit: habit,
      currentProgress: currentProgress,
      subtasks: subtasks,
      onValueUpdate: (newValue) {
        if (isToday) {
          _repo.setManualProgress(habit.id, newValue);
        } else {
          _repo.setManualProgressForDate(habit.id, _selected, newValue);
        }
      },
      onSubtaskToggle: (subtaskId, completed) {
        if (isToday) {
          _repo.toggleSubtask(habit.id, subtaskId, completed);
        } else {
          _repo.toggleSubtaskForDate(habit.id, subtaskId, completed, _selected);
        }
      },
    );
  }

  void _toggleTimelineHabit(Habit habit) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isFuture = _selected.isAfter(today);
    final isBeforeStart = habit.startDate.length >= 10 &&
        _selected.isBefore(DateTime(
          int.parse(habit.startDate.substring(0, 4)),
          int.parse(habit.startDate.substring(5, 7)),
          int.parse(habit.startDate.substring(8, 10)),
        ));
    if (isFuture || isBeforeStart) return;

    if (habit.habitType == HabitType.simple ||
        habit.habitType == HabitType.checkbox) {
      if (isToday) {
        _repo.toggleSimple(habit.id);
      } else {
        _repo.toggleSimpleForDate(habit.id, _selected);
      }
    } else if (habit.habitType == HabitType.numerical ||
        habit.habitType == HabitType.timer) {
      final nextVal = habit.isCompleted ? 0 : habit.targetCount;
      if (isToday) {
        _repo.setManualProgress(habit.id, nextVal);
      } else {
        _repo.setManualProgressForDate(habit.id, _selected, nextVal);
      }
    } else {
      if (isToday) {
        _repo.toggleSimple(habit.id);
      } else {
        _repo.toggleSimpleForDate(habit.id, _selected);
      }
    }
  }

  void _showTimelineHabitOptions(Habit habit) {
    HapticFeedback.mediumImpact();
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(habit.icon, color: habit.color),
              title: Text(
                habit.title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                habit.description.isNotEmpty
                    ? habit.description
                    : (l10n.localeName.startsWith('tr')
                        ? 'Alışkanlık'
                        : 'Habit'),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.localeName.startsWith('tr') ? 'Düzenle' : 'Edit'),
              onTap: () {
                Navigator.pop(ctx);
                _editHabit(habit);
              },
            ),
            ListTile(
              leading: const Icon(Icons.insights_outlined),
              title: Text(
                l10n.localeName.startsWith('tr')
                    ? 'Analiz ve İstatistik'
                    : 'Analysis',
              ),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HabitAnalysisScreen(
                      habitTitle: habit.title,
                      habitDescription: habit.description,
                      habitIcon: habit.icon,
                      habitColor: habit.color,
                      currentStreak: habit.currentStreak,
                      targetCount: habit.targetCount,
                      unit: habit.unit,
                      habitId: habit.id,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.label_outline),
              title: Text(
                l10n.localeName.startsWith('tr')
                    ? 'Listeye Ata'
                    : 'Assign to List',
              ),
              onTap: () {
                Navigator.pop(ctx);
                _assignHabitToListDialog(habit);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: Text(
                l10n.localeName.startsWith('tr') ? 'Sil' : 'Delete',
                style: const TextStyle(color: Colors.redAccent),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _deleteHabit(habit);
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.emptyHabitTitle,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.emptyHabitSubtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _createSimpleHabit,
              icon: const Icon(Icons.add),
              label: Text(l10n.createFirstHabit),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewSwitcher(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    final isDark = theme.brightness == Brightness.dark;

    // Translucent frosted glass background matching CottonBottomBar
    final capsuleBgColor = isDark
        ? Color.alphaBlend(
            colorScheme.primary.withValues(alpha: 0.08),
            colorScheme.surfaceContainerHighest.withValues(alpha: 0.65),
          )
        : Color.alphaBlend(
            colorScheme.primary.withValues(alpha: 0.07),
            Color.alphaBlend(
              Colors.black.withValues(alpha: 0.04),
              theme.scaffoldBackgroundColor,
            ),
          );

    final capsuleBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.75);

    final activePillColor = isDark
        ? colorScheme.surfaceContainerHigh
        : Colors.white;

    final activeTextColor = colorScheme.onSurface;

    final inactiveTextColor = isDark
        ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
        : colorScheme.onSurfaceVariant;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          if (!isDark)
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.6),
              blurRadius: 4,
              offset: const Offset(0, -1),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: capsuleBgColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: capsuleBorderColor,
                width: 1.5,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final pillWidth = (constraints.maxWidth - 4) / 2;

                return Stack(
                  children: [
                    // Animated elevated white sliding indicator matching active tab pill
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      alignment: !isWeeklyView
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        width: pillWidth,
                        height: 42,
                        decoration: BoxDecoration(
                          color: activePillColor,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.12)
                                : Colors.white.withValues(alpha: 0.95),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? 0.28 : 0.08,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () {
                                if (isWeeklyView ||
                                    !_isSameDay(_selected, DateTime.now())) {
                                  HapticFeedback.selectionClick();
                                  switchToToday(DateTime.now());
                                }
                              },
                              child: Container(
                                height: 42,
                                alignment: Alignment.center,
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontFamily:
                                        theme.textTheme.bodyMedium?.fontFamily,
                                    fontWeight: !isWeeklyView
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: !isWeeklyView
                                        ? activeTextColor
                                        : inactiveTextColor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        !isWeeklyView
                                            ? Icons.wb_sunny_rounded
                                            : Icons.wb_sunny_outlined,
                                        size: 18,
                                        color: !isWeeklyView
                                            ? colorScheme.primary
                                            : inactiveTextColor,
                                      ),
                                      const SizedBox(width: 7),
                                      Text(
                                        l10n.localeName.startsWith('tr')
                                            ? 'Günlük'
                                            : 'Daily',
                                      ),
                                      if (_activeTasksAndHabitsCount > 0) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: !isWeeklyView
                                                ? colorScheme.primary
                                                    .withValues(alpha: 0.12)
                                                : colorScheme
                                                    .surfaceContainerHigh,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            '$_activeTasksAndHabitsCount',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: !isWeeklyView
                                                  ? colorScheme.primary
                                                  : inactiveTextColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () {
                                if (!isWeeklyView) {
                                  HapticFeedback.selectionClick();
                                  switchToWeekly();
                                }
                              },
                              child: Container(
                                height: 42,
                                alignment: Alignment.center,
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontFamily:
                                        theme.textTheme.bodyMedium?.fontFamily,
                                    fontWeight: isWeeklyView
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isWeeklyView
                                        ? activeTextColor
                                        : inactiveTextColor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        isWeeklyView
                                            ? Icons.calendar_view_week_rounded
                                            : Icons.calendar_view_week_outlined,
                                        size: 18,
                                        color: isWeeklyView
                                            ? colorScheme.primary
                                            : inactiveTextColor,
                                      ),
                                      const SizedBox(width: 7),
                                      Text(l10n.weeklySchedule),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // ── Aesthetic Segmented View Switcher: [ ☀️ Bugün | 📅 Haftalık ] ──
              _buildViewSwitcher(theme, colorScheme, l10n),

              // Animated view content between Today and Weekly
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: _viewMode == HabitScreenViewMode.today
                      ? KeyedSubtree(
                          key: const ValueKey('today_content_view'),
                          child: Builder(
                  builder: (context) {
                    final tasks = _filteredTasksForSelectedDay();
                    final habits = _filteredHabits();
                    final bool canShowTopDashboard = isToday && !isWeeklyView;
                    final listTasks = canShowTopDashboard ? const <DailyTask>[] : tasks;

                    final isDark = theme.brightness == Brightness.dark;

                    if (habits.isEmpty && listTasks.isEmpty) {
                      return ListView(
                        padding: const EdgeInsets.only(top: 4, bottom: 40),
                        children: [
                          const BiologicalClockArcCard(),
                          _buildEmptyState(
                            context,
                            AppLocalizations.of(context),
                          ),
                          if (canShowTopDashboard) ...[
                            const SizedBox(height: 12),
                            TodayTopDashboard(
                              date: _selected,
                              onOpenGoals: widget.onOpenGoals,
                              onAddTask: _showDailyTaskDialog,
                            ),
                          ],
                        ],
                      );
                    }

                    // If no list is selected, show restored rhythm timeline view
                    if (_selectedListId == null) {
                      // Items in the scrollable timeline:
                      // 0: BiologicalClockArcCard
                      // Followed by each habit in habits rendered with TimelineHabitRow
                      // Last item (if canShowTopDashboard): TodayTopDashboard (scrolls with habits)
                      const int headerCount = 1;
                      final int dashboardCount = canShowTopDashboard ? 1 : 0;
                      final int totalCount =
                          headerCount + habits.length + dashboardCount;

                      return AnimationLimiter(
                        key: _listAnimationKey,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 4, bottom: 32),
                          itemCount: totalCount,
                          itemBuilder: (context, index) {
                            Widget childWidget;
                            if (index == 0) {
                              childWidget = const BiologicalClockArcCard();
                            } else if (canShowTopDashboard &&
                                index == totalCount - 1) {
                              // Vision & Daily Tasks card scrolling naturally with habits
                              childWidget = Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 16.0),
                                child: TodayTopDashboard(
                                  date: _selected,
                                  onOpenGoals: widget.onOpenGoals,
                                  onAddTask: _showDailyTaskDialog,
                                ),
                              );
                            } else {
                              final habitIndex = index - headerCount;
                              final habit = habits[habitIndex];
                              final String dayKey =
                                  '${_selected.year}-${_selected.month.toString().padLeft(2, '0')}-${_selected.day.toString().padLeft(2, '0')}';
                              final int dayProgress = isToday
                                  ? habit.currentStreak
                                  : (habit.dailyLog[dayKey] ?? 0);

                              List<Subtask>? displaySubtasks;
                              if (habit.habitType == HabitType.subtasks) {
                                if (isToday) {
                                  displaySubtasks = habit.subtasks;
                                } else if (habit.subtasksLog.containsKey(dayKey)) {
                                  displaySubtasks = habit.subtasksLog[dayKey]!
                                      .map((s) => Subtask(
                                            id: s['id'] as String,
                                            title: s['title'] as String,
                                            isCompleted:
                                                s['isCompleted'] as bool? ?? false,
                                          ))
                                      .toList();
                                } else {
                                  displaySubtasks = habit.subtasks
                                      .map((s) => Subtask(
                                          id: s.id,
                                          title: s.title,
                                          isCompleted: false))
                                      .toList();
                                }
                              }

                              final bool dayCompleted = isToday
                                  ? (habit.isCompleted ||
                                      HabitRepository
                                          .evaluateCompletionFromLog(
                                        habit,
                                        dayKey,
                                      ))
                                  : HabitRepository.evaluateCompletionFromLog(
                                      habit,
                                      dayKey,
                                    );

                              childWidget = TimelineHabitRow(
                                habit: habit,
                                timeLabel: _formatHabitTime(habit),
                                isFirst: habitIndex == 0,
                                isLast: habitIndex == habits.length - 1,
                                currentProgress: dayProgress,
                                isCompleted: dayCompleted,
                                subtasks: displaySubtasks,
                                onTap: () {
                                  if (habit.habitType == HabitType.simple ||
                                      habit.habitType == HabitType.checkbox) {
                                    _toggleTimelineHabit(habit);
                                  } else {
                                    _openAdvancedHabitDialog(
                                        habit, dayProgress, displaySubtasks);
                                  }
                                },
                                onToggle: () => _toggleTimelineHabit(habit),
                                onAdvancedTap: () => _openAdvancedHabitDialog(
                                    habit, dayProgress, displaySubtasks),
                                onLongPress: () =>
                                    _showTimelineHabitOptions(habit),
                              );
                            }

                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 250),
                              child: SlideAnimation(
                                verticalOffset: 25.0,
                                child: childWidget,
                              ),
                            );
                          },
                        ),
                      );
                    }

                    // Otherwise show flat list (existing behavior when a list is selected)
                    final flatTasks = canShowTopDashboard ? const <DailyTask>[] : tasks;
                    final int dashboardCount = canShowTopDashboard ? 1 : 0;
                    final int totalFlatCount =
                        (flatTasks.isNotEmpty ? (1 + flatTasks.length) : 0) +
                        (habits.isNotEmpty ? (1 + habits.length) : 0) +
                        dashboardCount;

                    return AnimationLimiter(
                      key: _listAnimationKey,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 4, bottom: 32),
                        itemCount: totalFlatCount,
                        itemBuilder: (context, index) {
                          Widget childWidget = const SizedBox.shrink();
                          if (canShowTopDashboard && index == totalFlatCount - 1) {
                            childWidget = Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 16.0),
                              child: TodayTopDashboard(
                                date: _selected,
                                onOpenGoals: widget.onOpenGoals,
                                onAddTask: _showDailyTaskDialog,
                              ),
                            );
                          } else {
                            int cursor = 0;
                            // Tasks section
                            if (flatTasks.isNotEmpty) {
                            if (index == cursor) {
                              childWidget = Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 8, 12, 4),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .dailyTasksSection,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              );
                            } else {
                              cursor += 1;
                              if (index < cursor + tasks.length) {
                                final task = tasks[index - cursor];
                                final isMuted = false;
                                // Swipe-to-dismiss removed: present task card directly.
                                childWidget = _TaskCard(
                                  title: task.title,
                                  description: task.description,
                                  isDone: task.isDone,
                                  isMuted: isMuted,
                                  listName: task.listId == null
                                      ? null
                                      : _listRepo.lists
                                          .firstWhere(
                                            (l) => l.id == task.listId,
                                            orElse: () =>
                                                AppList(id: '', title: ''),
                                          )
                                          .title,
                                  onToggleDone: (value) {
                                    setState(() {
                                      task.isDone = value;
                                    });
                                    // Persist in background to avoid UI lag
                                    _taskRepo.updateTask(task);
                                  },
                                  onAssignToList: () =>
                                      _assignTaskToListDialog(task),
                                  onSetAsFocus: () {
                                    _setAsFocus(task.id, isHabit: false);
                                  },
                                  onEdit: () async {
                                    // Prefill edit dialog using same DailyTaskDialog
                                    final res =
                                        await showDialog<Map<String, dynamic>>(
                                      context: context,
                                      builder: (ctx) => DailyTaskDialog(),
                                    );
                                    if (res != null) {
                                      final newTitle =
                                          (res['title'] as String?)?.trim() ??
                                              task.title;
                                      final newDescription =
                                          (res['description'] as String?)
                                                  ?.trim() ??
                                              task.description;
                                      task.title = newTitle;
                                      task.description = newDescription;
                                      await _taskRepo.updateTask(task);
                                    }
                                  },
                                  onDelete: () async {
                                    final confirmed = await _confirmDelete(
                                      title:
                                          AppLocalizations.of(context).delete,
                                      // use the message variant from generated localizations;
                                      // interpolate the task title into the message where helpful
                                      message:
                                          '${AppLocalizations.of(context).deleteTaskConfirmTitle}\n\n${AppLocalizations.of(context).deleteTaskConfirmMessage}',
                                      confirmText: AppLocalizations.of(
                                        context,
                                      ).delete,
                                      cancelText: AppLocalizations.of(
                                        context,
                                      ).cancel,
                                    );
                                    if (confirmed) {
                                      await _taskRepo.removeTask(task.id);
                                    }
                                  },
                                );
                              }
                              cursor += tasks.length;
                            }
                          }

                          // Habits section header
                          if (habits.isNotEmpty && childWidget is SizedBox) {
                            if (index == cursor) {
                              childWidget = Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 8, 12, 4),
                                child: Text(
                                  AppLocalizations.of(context).habitsSection,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              );
                            } else {
                              cursor += 1;
                              if (index < cursor + habits.length) {
                                final habit = habits[index - cursor];
                                final String dayKey =
                                    '${_selected.year}-${_selected.month.toString().padLeft(2, '0')}-${_selected.day.toString().padLeft(2, '0')}';
                                final now = DateTime.now();
                                final todayDate = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                );
                                final selectedDate = DateTime(
                                  _selected.year,
                                  _selected.month,
                                  _selected.day,
                                );
                                final bool isToday = _isSameDay(
                                  selectedDate,
                                  todayDate,
                                );
                                final bool isFuture = selectedDate.isAfter(
                                  todayDate,
                                );
                                // Başlangıç tarihinden önce düzenlemeyi engelle
                                final String startDateStr = habit.startDate;
                                final DateTime startDate = DateTime(
                                  int.parse(startDateStr.substring(0, 4)),
                                  int.parse(startDateStr.substring(5, 7)),
                                  int.parse(startDateStr.substring(8, 10)),
                                );
                                final bool isBeforeStart =
                                    selectedDate.isBefore(
                                  DateTime(
                                    startDate.year,
                                    startDate.month,
                                    startDate.day,
                                  ),
                                );
                                // Progress value to display on the card
                                final int dayProgress = isToday
                                    ? habit.currentStreak
                                    : (habit.dailyLog[dayKey] ?? 0);
                                final bool dayCompleted = isToday
                                    ? (habit.isCompleted ||
                                        HabitRepository
                                            .evaluateCompletionFromLog(
                                          habit,
                                          dayKey,
                                        ))
                                    : HabitRepository.evaluateCompletionFromLog(
                                        habit,
                                        dayKey,
                                      );
                                // Ice mechanic: number of missed days prior to selected
                                final int missedBefore =
                                    _consecutiveMissedDaysBefore(
                                  habit,
                                  selectedDate,
                                  cap: 7,
                                );
                                final isMuted = false;
                                // Swipe-to-dismiss removed: present HabitCard directly.
                                childWidget = HabitCard(
                                  title: habit.title,
                                  description: _buildHabitSubtitle(habit),
                                  isMuted: isMuted,
                                  icon: habit.icon,
                                  emoji: habit.emoji,
                                  categoryName: habit.categoryName,
                                  color: habit.color,
                                  currentStreak: dayProgress,
                                  streakCount: HabitRepository.instance
                                      .consecutiveStreak(
                                    habit.id,
                                    upTo: selectedDate,
                                  ),
                                  targetCount: habit.targetCount,
                                  isCompleted: dayCompleted,
                                  habitType: habit.habitType,
                                  numericalTargetType:
                                      habit.habitType == HabitType.numerical
                                          ? habit.numericalTargetType
                                          : null,
                                  timerTargetType:
                                      habit.habitType == HabitType.timer
                                          ? habit.timerTargetType
                                          : null,
                                  unit: habit.unit,
                                  readOnly: isFuture ||
                                      isBeforeStart, // gelecek veya başlangıçtan önce günler kilitli
                                  iceEnabled: !isFuture &&
                                      !isBeforeStart &&
                                      habit.habitType == HabitType.simple,
                                  requiredBreakTaps: missedBefore,
                                  onTap: () {
                                    if (isFuture || isBeforeStart) return;
                                    if (habit.habitType == HabitType.simple) {
                                      if (isToday) {
                                        _repo.toggleSimple(habit.id);
                                      } else {
                                        _repo.toggleSimpleForDate(
                                          habit.id,
                                          _selected,
                                        );
                                      }
                                    }
                                  },
                                  onAssignToList: () =>
                                      _assignHabitToListDialog(habit),
                                  showStreakIndicator:
                                      _repo.getShowStreakIndicatorFor(habit.id),
                                  onToggleStreakIndicator: (v) async {
                                    await _repo.setShowStreakIndicatorFor(
                                      habit.id,
                                      v,
                                    );
                                  },
                                  onSetAsFocus: isToday
                                      ? () {
                                          _setAsFocus(habit.id);
                                        }
                                      : null,
                                  onValueUpdate: (newValue) {
                                    if (isFuture || isBeforeStart) return;
                                    if (habit.habitType ==
                                            HabitType.numerical ||
                                        habit.habitType == HabitType.timer) {
                                      if (isToday) {
                                        _repo.setManualProgress(
                                            habit.id, newValue);
                                      } else {
                                        _repo.setManualProgressForDate(
                                          habit.id,
                                          _selected,
                                          newValue,
                                        );
                                      }
                                    }
                                  },
                                  onAnalyze: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            HabitAnalysisScreen(
                                          habitTitle: habit.title,
                                          habitDescription: habit.description,
                                          habitIcon: habit.icon,
                                          habitColor: habit.color,
                                          currentStreak: habit.currentStreak,
                                          targetCount: habit.targetCount,
                                          unit: habit.unit,
                                          habitId: habit.id,
                                        ),
                                      ),
                                    );
                                  },
                                  onEdit: () async {
                                    print(
                                      '🎯 [HabitScreen] onEdit called for: ${habit.title}',
                                    );
                                    print('   habitType: ${habit.habitType}');
                                    print('   isAdvanced: ${habit.isAdvanced}');
                                    print(
                                      '   linkedVisionId: ${habit.linkedVisionId}',
                                    );

                                    // Vision habits: edit with AdvancedHabitScreen (vision context)
                                    if (habit.linkedVisionId != null) {
                                      print(
                                        '🔍 [HabitScreen] Editing vision habit: ${habit.title}',
                                      );
                                      print(
                                        '   linkedVisionId: ${habit.linkedVisionId}',
                                      );

                                      final visionRepo =
                                          VisionRepository.instance;
                                      // Ensure repository is initialized
                                      await visionRepo.initialize();

                                      // Find vision from stream
                                      final visions =
                                          await visionRepo.stream.first;
                                      print(
                                        '   Available visions: ${visions.length}',
                                      );
                                      for (final v in visions) {
                                        print('     - ${v.title} (${v.id})');
                                      }

                                      final vision = visions
                                          .cast<Vision?>()
                                          .firstWhere(
                                            (v) =>
                                                v?.id == habit.linkedVisionId,
                                            orElse: () => null,
                                          );

                                      if (vision != null) {
                                        print(
                                            '   ✅ Vision found: ${vision.title}');
                                        // Prepare editing map for AdvancedHabitScreen
                                        final result =
                                            await Navigator.of(context)
                                                .push<Map<String, dynamic>>(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AdvancedHabitScreen(
                                              useVisionDayOffsets: true,
                                              returnAsMap: true,
                                              editingHabitMap: {
                                                'id': habit.id,
                                                'title': habit.title,
                                                'description':
                                                    habit.description,
                                                'icon': habit.icon,
                                                'color': habit.color,
                                                'targetCount':
                                                    habit.targetCount,
                                                'habitType': habit.habitType,
                                                'unit': habit.unit,
                                                'currentStreak':
                                                    habit.currentStreak,
                                                'isCompleted':
                                                    habit.isCompleted,
                                                'startDate': habit.startDate,
                                                'endDate': habit.endDate,
                                                if (habit.scheduledDates !=
                                                    null)
                                                  'scheduledDates':
                                                      habit.scheduledDates,
                                                'numericalTargetType':
                                                    habit.numericalTargetType,
                                                'timerTargetType':
                                                    habit.timerTargetType,
                                                if (habit.emoji != null)
                                                  'emoji': habit.emoji,
                                                if (habit.frequency != null)
                                                  'frequency': habit.frequency,
                                                if (habit.frequencyType != null)
                                                  'frequencyType':
                                                      habit.frequencyType,
                                                if (habit.selectedWeekdays !=
                                                    null)
                                                  'selectedWeekdays':
                                                      habit.selectedWeekdays,
                                                if (habit.selectedMonthDays !=
                                                    null)
                                                  'selectedMonthDays':
                                                      habit.selectedMonthDays,
                                                if (habit.selectedYearDays !=
                                                    null)
                                                  'selectedYearDays':
                                                      habit.selectedYearDays,
                                                if (habit.periodicDays != null)
                                                  'periodicDays':
                                                      habit.periodicDays,
                                                'reminderEnabled':
                                                    habit.reminderEnabled,
                                                if (habit.reminderTime != null)
                                                  'reminderTime': {
                                                    'hour': habit
                                                        .reminderTime!.hour,
                                                    'minute': habit
                                                        .reminderTime!.minute,
                                                  },
                                                // Vision-specific context
                                                'visionId': vision.id,
                                                'visionStartDate':
                                                    vision.startDate,
                                                'visionEndDate': vision.endDate,
                                              },
                                            ),
                                          ),
                                        );

                                        if (result != null) {
                                          // Apply updates to habit
                                          habit.title = (result['title'] ??
                                              habit.title) as String;
                                          habit.description =
                                              (result['description'] ??
                                                  habit.description) as String;
                                          if (result['color'] is int) {
                                            habit.color = Color(
                                              result['color'] as int,
                                            );
                                          } else if (result['color'] is Color) {
                                            habit.color =
                                                result['color'] as Color;
                                          }
                                          if (result['emoji'] is String &&
                                              (result['emoji'] as String)
                                                  .trim()
                                                  .isNotEmpty) {
                                            habit.emoji =
                                                (result['emoji'] as String)
                                                    .trim();
                                          }
                                          if (result['frequency'] is String) {
                                            final f =
                                                (result['frequency'] as String)
                                                    .trim();
                                            habit.frequency =
                                                f.isEmpty ? null : f;
                                          }
                                          if (result['frequencyType'] != null) {
                                            habit.frequencyType =
                                                result['frequencyType']
                                                    ?.toString();
                                          }
                                          if (result['selectedWeekdays']
                                              is List) {
                                            habit.selectedWeekdays =
                                                (result['selectedWeekdays']
                                                        as List)
                                                    .whereType<num>()
                                                    .map((e) => e.toInt())
                                                    .toList();
                                          }
                                          if (result['selectedMonthDays']
                                              is List) {
                                            habit.selectedMonthDays =
                                                (result['selectedMonthDays']
                                                        as List)
                                                    .whereType<num>()
                                                    .map((e) => e.toInt())
                                                    .toList();
                                          }
                                          if (result['selectedYearDays']
                                              is List) {
                                            habit.selectedYearDays =
                                                (result['selectedYearDays']
                                                        as List)
                                                    .map(
                                                      (e) => e
                                                          .toString()
                                                          .split('T')
                                                          .first,
                                                    )
                                                    .toList();
                                          }
                                          if (result['periodicDays'] != null) {
                                            habit.periodicDays =
                                                (result['periodicDays'] as num?)
                                                    ?.toInt();
                                          }
                                          if (result['scheduledDates']
                                              is List) {
                                            habit.scheduledDates =
                                                (result['scheduledDates']
                                                        as List)
                                                    .map(
                                                      (e) => e
                                                          .toString()
                                                          .split('T')
                                                          .first,
                                                    )
                                                    .toList();
                                          }
                                          // Update reminder settings
                                          if (result.containsKey(
                                            'reminderEnabled',
                                          )) {
                                            habit.reminderEnabled =
                                                (result['reminderEnabled']
                                                        as bool?) ??
                                                    false;
                                          }
                                          if (result['reminderTime'] is Map) {
                                            final rt =
                                                result['reminderTime'] as Map;
                                            final hour = rt['hour'] as int?;
                                            final minute = rt['minute'] as int?;
                                            if (hour != null &&
                                                minute != null) {
                                              habit.reminderTime = TimeOfDay(
                                                hour: hour,
                                                minute: minute,
                                              );
                                            }
                                          } else if (result['reminderTime'] ==
                                              null) {
                                            habit.reminderTime = null;
                                          }
                                          await _ensureRhythmListAndAssign(
                                              habit);
                                          await _repo.updateHabit(habit);
                                        }
                                        return;
                                      } else {
                                        print(
                                          '   ❌ Vision not found for ID: ${habit.linkedVisionId}',
                                        );
                                        // Vision bulunamadı, normal düzenlemeye geç
                                      }
                                    }

                                    // If it's a simple non-advanced habit, edit in basic screen
                                    if (habit.habitType == HabitType.simple &&
                                        !habit.isAdvanced) {
                                      final editedHabit =
                                          await Navigator.of(context)
                                              .push<Habit>(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SimpleHabitScreen(
                                            existingHabit: habit,
                                          ),
                                        ),
                                      );
                                      if (editedHabit != null) {
                                        // SimpleHabitScreen döndürdüğü Habit'ten değerleri kopyala
                                        habit.title = editedHabit.title;
                                        habit.description =
                                            editedHabit.description;
                                        habit.emoji = editedHabit.emoji;
                                        habit.color = editedHabit.color;
                                        habit.frequency = editedHabit.frequency;
                                        habit.frequencyType =
                                            editedHabit.frequencyType;
                                        habit.selectedWeekdays =
                                            editedHabit.selectedWeekdays;
                                        habit.selectedMonthDays =
                                            editedHabit.selectedMonthDays;
                                        habit.selectedYearDays =
                                            editedHabit.selectedYearDays;
                                        habit.periodicDays =
                                            editedHabit.periodicDays;
                                        habit.scheduledDates =
                                            editedHabit.scheduledDates;
                                        habit.reminderEnabled =
                                            editedHabit.reminderEnabled;
                                        habit.reminderTime =
                                            editedHabit.reminderTime;
                                        await _ensureRhythmListAndAssign(habit);
                                        await _repo.updateHabit(habit);
                                      }
                                      return;
                                    }
                                    // Otherwise use advanced habit screen
                                    final editedHabit =
                                        await Navigator.of(context).push<Habit>(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AdvancedHabitScreen(
                                          existingHabit: habit,
                                        ),
                                      ),
                                    );
                                    if (editedHabit != null) {
                                      habit.title = editedHabit.title;
                                      habit.description =
                                          editedHabit.description;
                                      habit.color = editedHabit.color;
                                      habit.emoji = editedHabit.emoji;
                                      habit.habitType = editedHabit.habitType;
                                      habit.targetCount =
                                          editedHabit.targetCount;
                                      habit.unit = editedHabit.unit;
                                      habit.numericalTargetType =
                                          editedHabit.numericalTargetType;
                                      habit.timerTargetType =
                                          editedHabit.timerTargetType;
                                      habit.frequency = editedHabit.frequency;
                                      habit.frequencyType =
                                          editedHabit.frequencyType;
                                      habit.selectedWeekdays =
                                          editedHabit.selectedWeekdays;
                                      habit.selectedMonthDays =
                                          editedHabit.selectedMonthDays;
                                      habit.selectedYearDays =
                                          editedHabit.selectedYearDays;
                                      habit.periodicDays =
                                          editedHabit.periodicDays;
                                      habit.scheduledDates =
                                          editedHabit.scheduledDates;
                                      habit.reminderEnabled =
                                          editedHabit.reminderEnabled;
                                      habit.reminderTime =
                                          editedHabit.reminderTime;
                                      await _ensureRhythmListAndAssign(habit);
                                      await _repo.updateHabit(habit);
                                    }
                                  },
                                  onDelete: () {
                                    final removed = habit;
                                    _repo.removeHabit(habit.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          AppLocalizations.of(
                                            context,
                                          ).habitDeletedMessage(habit.title),
                                        ),
                                        action: SnackBarAction(
                                          label:
                                              AppLocalizations.of(context).undo,
                                          onPressed: () {
                                            _repo.insertHabit(index, removed);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            }
                          }
                        }

                        return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 250),
                            child: SlideAnimation(
                              verticalOffset: 30.0,
                              child: childWidget,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              )
            : KeyedSubtree(
                key: const ValueKey('weekly_content_view'),
                child: WeeklyScheduleScreen(
                  variant: widget.variant,
                  isEmbedded: true,
                  weekStart: _weeklyStartDate,
                  onWeekChanged: (w) {
                    setState(() {
                      _weeklyStartDate = w;
                    });
                    widget.onDateChanged?.call(w);
                  },
                  onDaySelected: (date) {
                    switchToToday(date);
                  },
                ),
              ),
          ),
        ),
      ],
    ),
    // Repository dinleyicisi setState ile çalıştığı için ek gizli AnimatedBuilder'a gerek yok
        ],
      ),
    );
  }

  // Exposed for AppBar action in main.dart
  void openMoodScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MoodScreen(variant: widget.variant),
      ),
    );
  }
}

enum CompletionFilter { all, completed, incomplete }

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.title,
    required this.description,
    required this.isDone,
    this.listName,
    required this.onToggleDone,
    this.onEdit,
    this.onAssignToList,
    this.onSetAsFocus,
    this.onDelete,
    this.isMuted = false,
  });

  final String title;
  final String description;
  final bool isDone;
  final String? listName;
  final ValueChanged<bool> onToggleDone;
  final VoidCallback? onEdit;
  final VoidCallback? onAssignToList;
  final VoidCallback? onSetAsFocus;
  final VoidCallback? onDelete;
  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Muted styling when another item is focused
    final double mutedOpacity = isMuted ? 0.45 : 1.0;
    final double mutedScale = isMuted ? 0.92 : 1.0;

    // Elevated pill card styling matching CottonBottomBar active pill
    final pillBg = isMuted
        ? Colors.transparent
        : (isDark
            ? (isDone
                ? scheme.surfaceContainerHighest.withValues(alpha: 0.45)
                : scheme.surfaceContainerHigh)
            : (isDone
                ? const Color(0xFFF8FAFC)
                : Colors.white));

    final pillBorder = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : (isDone
            ? scheme.outlineVariant.withValues(alpha: 0.25)
            : Colors.white.withValues(alpha: 0.95));

    return Opacity(
      opacity: mutedOpacity,
      child: Transform.scale(
        scale: mutedScale,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4.5),
          decoration: BoxDecoration(
            color: pillBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: pillBorder,
              width: 1.2,
            ),
            boxShadow: isMuted
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.25 : 0.05,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                    if (!isDark && !isDone)
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.7),
                        blurRadius: 2,
                        offset: const Offset(0, -1),
                      ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                HapticFeedback.lightImpact();
                onToggleDone(!isDone);
              },
              onLongPress: () async {
                // show modal menu with Edit / Assign / Delete
                if (onEdit == null &&
                    onAssignToList == null &&
                    onDelete == null) {
                  return;
                }
                final l10n = AppLocalizations.of(context);
                final selected = await showModalBottomSheet<String?>(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) {
                    return SafeArea(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        decoration: BoxDecoration(
                          color: Theme.of(ctx).colorScheme.surface,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 8),
                            Center(
                              child: Container(
                                width: 36,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Theme.of(ctx)
                                      .colorScheme
                                      .onSurfaceVariant
                                      .withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (onEdit != null)
                              ListTile(
                                leading: const Icon(Icons.edit_outlined),
                                title: Text(l10n.edit),
                                onTap: () => Navigator.pop(ctx, 'edit'),
                              ),
                            if (onAssignToList != null)
                              ListTile(
                                leading: const Icon(
                                  Icons.playlist_add_outlined,
                                ),
                                title: Text(l10n.addToList),
                                onTap: () => Navigator.pop(ctx, 'assign'),
                              ),
                            if (onSetAsFocus != null)
                              ListTile(
                                leading: Icon(
                                  Icons.center_focus_strong_rounded,
                                  color: Theme.of(ctx).colorScheme.primary,
                                ),
                                title: Text(l10n.setAsTodayFocus),
                                subtitle: Text(l10n.prioritizeTaskSubtitle),
                                onTap: () => Navigator.pop(ctx, 'focus'),
                              ),
                            if (onDelete != null)
                              ListTile(
                                leading: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red[600],
                                ),
                                title: Text(
                                  l10n.delete,
                                  style: TextStyle(color: Colors.red[600]),
                                ),
                                onTap: () => Navigator.pop(ctx, 'delete'),
                              ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                  },
                );
                if (selected == 'edit') onEdit?.call();
                if (selected == 'assign') onAssignToList?.call();
                if (selected == 'focus') onSetAsFocus?.call();
                if (selected == 'delete') onDelete?.call();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Tactile squircle checkbox
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onToggleDone(!isDone);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isDone
                              ? const Color(0xFF10B981)
                              : (isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : const Color(0xFFF1F5F9)),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDone
                                ? const Color(0xFF10B981)
                                : (isDark
                                    ? Colors.white.withValues(alpha: 0.18)
                                    : const Color(0xFFCBD5E1)),
                            width: 1.5,
                          ),
                        ),
                        child: isDone
                            ? const Icon(
                                Icons.check_rounded,
                                size: 20,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 13),
                    // Title + description centered vertically
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: isDone ? FontWeight.w500 : FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: -0.2,
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: isDone
                                  ? scheme.onSurfaceVariant.withValues(alpha: 0.6)
                                  : scheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                description,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant.withValues(
                                    alpha: isDone ? 0.45 : 0.75,
                                  ),
                                  fontSize: 11.5,
                                  decoration: isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Optional list pill
                    if (listName != null && listName!.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.secondaryContainer.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          listName!,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: scheme.onSecondaryContainer,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Alışkanlık türü seçim modalında kullanılan seçenek widget'ı
class _HabitTypeOption extends StatelessWidget {
  const _HabitTypeOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outlineVariant, width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

/// Action item widget for inline FAB menu
class _InlineActionItem extends StatelessWidget {
  const _InlineActionItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
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
  }
}
