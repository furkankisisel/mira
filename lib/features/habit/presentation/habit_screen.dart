import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../mood/data/detailed_mood_repository.dart';
import '../../mood/data/mood_models.dart';
import '../../mood/mood_screen.dart';
import '../../../design_system/theme/theme_variations.dart';
import '../../../design_system/tokens/colors.dart';
import 'widgets/daily_task_dialog.dart';
import 'widgets/list_creation_dialog.dart';
import 'widgets/habit_card.dart';
import 'widgets/focus_card.dart';
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

import '../data/focus_motivation_service.dart';
import '../../vision/data/vision_repository.dart';
import '../../vision/data/vision_model.dart';
import '../../../core/config/api_config.dart';
import '../../../ui/premium_gate.dart';
import 'live_rhythm_header.dart';
import '../../rhythm/domain/live_rhythm_repository.dart';
import '../../rhythm/domain/live_rhythm_model.dart';
import 'dart:async';

import '../../../providers/premium_provider.dart';
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

class HabitScreen extends StatefulWidget {
  const HabitScreen({super.key, this.variant = ThemeVariant.cotton});
  final ThemeVariant variant;
  @override
  State<HabitScreen> createState() => HabitScreenState();
}

class HabitScreenState extends State<HabitScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _moodRepo = DetailedMoodRepository();
  MoodLevel? _currentMood;

  DateTime _selected = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  bool _isHeaderExpanded = false;
  final ScrollController _dateScrollController = ScrollController();
  Key _listAnimationKey = UniqueKey();

  void reanimate() {
    if (mounted) {
      setState(() {
        _listAnimationKey = UniqueKey();
      });
    }
  }

  // Bugünden 20 gün önce ve 20 gün sonrasını göster (toplam 41 gün)
  static const int _dateRangeDays = 20;

  Future<void> _initMood() async {
    try {
      final latest = await _moodRepo.getLatestMoodEntry();
      if (latest != null) {
        if (mounted) setState(() => _currentMood = latest.mood);
      }
    } catch (_) {}
  }

  DateTime get _today =>
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  List<DateTime> get _dateRange => List.generate(
        _dateRangeDays * 2 + 1, // 20 gün önce + bugün + 20 gün sonra = 41 gün
        (i) => _today.add(Duration(days: i - _dateRangeDays)),
      );

  final HabitRepository _repo = HabitRepository.instance;
  final ListRepository _listRepo = ListRepository.instance;
  final DailyTaskRepository _taskRepo = DailyTaskRepository.instance;

  // Focus state
  String? _focusAiMessage;
  bool _isLoadingFocusAi = false;
  FocusMotivationService? _focusMotivationService;

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
    _initMood();
    _repo.addListener(_onRepoChange);
    _listRepo.addListener(_onRepoChange);
    _taskRepo.addListener(_onRepoChange);

    Future.wait([
      _repo.initialize(),
      _listRepo.initialize(),
      _taskRepo.initialize(),
    ]).then((_) {
      if (mounted) setState(() {});
    });

    // Initialize AI service
    final apiKey = ApiConfig.groqApiKey;
    if (apiKey.isNotEmpty) {
      _focusMotivationService = FocusMotivationService(apiKey: apiKey);
    }

    // Scroll date row to make today's item visible on first show
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollDateRowToSelected(),
    );

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

  void _onRepoChange() {
    if (!mounted) return;
    setState(() {});
    _loadFocusAiMessage();
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

  Future<void> _loadFocusAiMessage({bool forceRefresh = false}) async {
    final (habit, task) = _findFocusedItem();
    if (habit == null && task == null) {
      if (mounted) {
        setState(() {
          _focusAiMessage = null;
          _isLoadingFocusAi = false;
        });
      }
      return;
    }

    // Use cached message if available (unless forceRefresh is true)
    final existingMessage = habit?.focusMessage ?? task?.focusMessage;
    if (existingMessage != null && !forceRefresh) {
      if (mounted) {
        setState(() {
          _focusAiMessage = existingMessage;
          _isLoadingFocusAi = false;
        });
      }
      return;
    }

    // Generate new AI message
    if (_focusMotivationService == null) {
      setState(() {
        _focusAiMessage = _getLocalMotivationMessage(
          habit?.title ?? task?.title ?? '',
        );
        _isLoadingFocusAi = false;
      });
      return;
    }

    setState(() => _isLoadingFocusAi = true);

    try {
      String title = '';
      String? description;
      int currentProgress = 0;
      int targetCount = 1;
      String? unit;
      bool isCompleted = false;
      int streak = 0;
      String? category;
      String? startDate;
      String? frequency;
      int missedDays = 0;
      String? habitTypeStr;

      if (habit != null) {
        title = habit.title;
        description = habit.description;
        // Context logic
        if (habit.habitType == HabitType.simple ||
            habit.habitType == HabitType.checkbox) {
          streak = habit.currentStreak;
          currentProgress = habit.isCompleted ? 1 : 0;
        } else {
          currentProgress = habit.currentStreak;
          streak = 0;
        }
        targetCount = habit.targetCount;
        unit = habit.unit;
        isCompleted = habit.isCompleted;
        category = habit.categoryName;
        startDate = habit.startDate;
        frequency = habit.frequency;

        // Calculate missed days
        missedDays = _consecutiveMissedDaysBefore(habit, DateTime.now());

        // Get habit type string
        habitTypeStr = switch (habit.habitType) {
          HabitType.timer => 'timer (zamanlayıcı)',
          HabitType.numerical => 'numerical (sayısal)',
          HabitType.subtasks => 'subtasks (alt görevler)',
          HabitType.simple || HabitType.checkbox => 'simple (basit)',
        };
      } else if (task != null) {
        title = task.title;
        description = task.description;
        isCompleted = task.isDone;
        startDate = task.dateKey;
        habitTypeStr = 'daily_task (günlük görev)';
      }

      if (title.isEmpty) {
        setState(() => _isLoadingFocusAi = false);
        return;
      }

      final message = await _focusMotivationService!.generateMotivation(
        focusTitle: title,
        focusDescription: description,
        type: habit != null ? 'habit' : 'task',
        currentProgress: currentProgress,
        targetCount: targetCount,
        unit: unit,
        isCompleted: isCompleted,
        streak: streak,
        category: category,
        startDate: startDate,
        frequency: frequency,
        missedDays: missedDays,
        habitType: habitTypeStr,
      );

      if (habit != null) {
        await _repo.updateFocusMessage(habit.id, message);
      } else if (task != null) {
        await _taskRepo.updateFocusMessage(task.id, message);
      }

      if (mounted) {
        setState(() {
          _focusAiMessage = message;
          _isLoadingFocusAi = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _focusAiMessage = _getLocalMotivationMessage(
            habit?.title ?? task?.title ?? '',
          );
          _isLoadingFocusAi = false;
        });
      }
    }
  }

  String _getLocalMotivationMessage(String title) {
    final l10n = AppLocalizations.of(context);
    final messages = [
      l10n.motivationDayStart(title),
      l10n.motivationSmallSteps,
      l10n.motivationJourneyStart,
      l10n.motivationWaiting(title),
    ];
    return messages[DateTime.now().second % messages.length];
  }

  Future<void> _setAsFocus(String id, {bool isHabit = true}) async {
    if (isHabit) {
      await _repo.setAsFocus(id);
      await _taskRepo.clearFocus();
    } else {
      await _taskRepo.setAsFocus(id);
      await _repo.clearFocus();
    }
    _loadFocusAiMessage();
  }

  Future<void> _clearFocus() async {
    await _repo.clearFocus();
    await _taskRepo.clearFocus();
    setState(() {
      _focusAiMessage = null;
    });
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
        return habit.selectedWeekdays!.contains(weekdayIndex);

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

  /// Builds the FocusCard widget if a focus is set for today
  Widget? _buildFocusCardIfNeeded() {
    final (focusHabit, focusTask) = _findFocusedItem();
    if (focusHabit == null && focusTask == null) return null;

    // Only show focus for today
    if (!_isSameDay(_selected, DateTime.now())) return null;

    // Temporary FocusItem wrapper for UI compatibility if FocusCard still expects it
    // But we should update FocusCard to accept habit/task directly?
    // The previous code passed `focusItem: focus` which was FocusItem.
    // It also passed habit/dailyTask.
    // We should simplify FocusCard to not need FocusItem logic if possible.
    // Or mock it?
    // I will check FocusCard signature.
    // Assuming for now I can pass null for focusItem if I update FocusCard,
    // or I'll create a fake one if I can't touch FocusCard yet.
    // But I plan to refactor FocusCard too.
    // For now, let's assume FocusCard will be updated to optional focusItem or handled.

    // Premium users see the AI message in the LiveRhythmHeader, so we hide it here to avoid duplication.
    final isPremium = context.watch<PremiumProvider>().isPremium;
    if (!isPremium) return null;

    return FocusCard(
      // focusItem: focus, // Deprecated/Removed
      habit: focusHabit,
      dailyTask: focusTask,
      aiMessage: isPremium ? null : _focusAiMessage,
      isLoadingAi: _isLoadingFocusAi,
      subtasks: focusHabit?.habitType == HabitType.subtasks
          ? focusHabit?.subtasks
          : null,
      onSubtaskToggle: focusHabit?.habitType == HabitType.subtasks
          ? (subtaskId, completed) {
              _repo.toggleSubtask(focusHabit!.id, subtaskId, completed);
            }
          : null,
      onComplete: () {
        if (focusHabit != null) {
          // Toggle habit completion
          if (focusHabit.habitType == HabitType.simple ||
              focusHabit.habitType == HabitType.checkbox) {
            _repo.toggleSimple(focusHabit.id);
          }
        } else if (focusTask != null) {
          // Toggle task completion
          setState(() {
            focusTask.isDone = !focusTask.isDone;
            // Set completion date to currently selected day (which is today)
            if (focusTask.isDone) {
              final now = DateTime.now();
              focusTask.completionDateKey =
                  '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
            } else {
              focusTask.completionDateKey = null;
            }
          });
          _taskRepo.updateTask(focusTask);
        }
      },
      onRemoveFocus: _clearFocus,
      onRefreshAi: () => _loadFocusAiMessage(forceRefresh: true),
      onValueUpdate: focusHabit != null
          ? (value) {
              _repo.setManualProgress(focusHabit.id, value);
            }
          : null,
    );
  }

  @override
  void dispose() {
    _repo.removeListener(_onRepoChange);
    _listRepo.removeListener(_onRepoChange);
    _taskRepo.removeListener(_onRepoChange);
    _dateScrollController.dispose();
    _rhythmTimer?.cancel();
    super.dispose();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _weekdayLabel(BuildContext context, int w) {
    final l10n = AppLocalizations.of(context);
    switch (w) {
      case DateTime.monday:
        return l10n.weekdaysShortMon;
      case DateTime.tuesday:
        return l10n.weekdaysShortTue;
      case DateTime.wednesday:
        return l10n.weekdaysShortWed;
      case DateTime.thursday:
        return l10n.weekdaysShortThu;
      case DateTime.friday:
        return l10n.weekdaysShortFri;
      case DateTime.saturday:
        return l10n.weekdaysShortSat;
      case DateTime.sunday:
        return l10n.weekdaysShortSun;
      default:
        return '';
    }
  }

  void showCalendar() {
    setState(() {
      _isHeaderExpanded = !_isHeaderExpanded;
    });
    // When expanding, scroll to center today
    if (_isHeaderExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToToday();
      });
    }
  }

  void _scrollToToday() {
    if (!_dateScrollController.hasClients) return;
    // Find today's index in _dateRange
    final todayIndex = _dateRange.indexWhere((d) => _isSameDay(d, _today));
    if (todayIndex < 0) return;
    // Each item width 42 + horizontal padding (right: 6) = 48
    const double itemWidth = 48.0;
    final double base =
        16.0 + todayIndex * itemWidth; // 16 is list start padding
    // Center the item
    final double viewportWidth =
        _dateScrollController.position.viewportDimension;
    final double offset = base - (viewportWidth / 2) + (itemWidth / 2);
    _dateScrollController.animateTo(
      offset.clamp(0.0, _dateScrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _scrollDateRowToSelected({bool animate = false}) {
    if (!_dateScrollController.hasClients) return;
    // Find the index of selected date in _dateRange
    final int index = _dateRange.indexWhere((d) => _isSameDay(d, _selected));
    if (index < 0) return; // Selected date is not in range
    // Each item width 42 + horizontal padding (right: 6) = 48
    final double itemWidth = 48.0;
    final double base = 16.0 + index * itemWidth; // 16 is list start padding

    // Try to place selected in the center of the viewport
    final viewport = _dateScrollController.position.viewportDimension;
    final target = (base - (viewport / 2) + (42 / 2)).clamp(
      0.0,
      _dateScrollController.position.maxScrollExtent,
    );
    if (animate) {
      _dateScrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      _dateScrollController.jumpTo(target);
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
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        Set<HabitType> localTypes = {..._selectedTypes};
        CompletionFilter localCompletion = _completionFilter;
        String? localListId = _selectedListId;
        return StatefulBuilder(
          builder: (context, setModalState) {
            final theme = Theme.of(context);
            final colorScheme = theme.colorScheme;
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
                onTap: () => toggleType(t),
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
                              colorScheme.primary.withValues(alpha: 0.8),
                            ],
                          )
                        : null,
                    color:
                        isSelected ? null : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 16,
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurfaceVariant,
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
              return GestureDetector(
                onTap: () => setModalState(() => localCompletion = value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary.withValues(alpha: 0.5)
                          : colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        size: 20,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                    ],
                  ),
                ),
              );
            }

            final content = Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                8,
                20,
                20 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.filter_list_rounded,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.filterTitle,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await _openManageListsSheet();
                        },
                        child: Text(l10n.manageLists),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Type section
                  Text(
                    l10n.typeLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
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

                  const SizedBox(height: 20),

                  // List section
                  Text(
                    l10n.listLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    ),
                    child: DropdownButtonFormField<String?>(
                      value: localListId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(l10n.allLabel),
                        ),
                        ..._listRepo.lists.map(
                          (l) => DropdownMenuItem<String?>(
                            value: l.id,
                            child: Text(l.title),
                          ),
                        ),
                      ],
                      onChanged: (v) => setModalState(() => localListId = v),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Status section
                  Text(
                    l10n.statusLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(16),
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
                            alpha: 0.2,
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
                            alpha: 0.2,
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

                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              Navigator.of(context).pop({'reset': true}),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(l10n.clear),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: FilledButton(
                          onPressed: localTypes.isEmpty
                              ? null
                              : () => Navigator.of(context).pop({
                                    'types': localTypes,
                                    'completion': localCompletion,
                                    'listId': localListId,
                                  }),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(l10n.apply),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
            return FractionallySizedBox(
              heightFactor: 0.85,
              child: SingleChildScrollView(child: content),
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

  Future<void> _openManageListsSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            final lists = _listRepo.lists;
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomInset),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context).manageLists,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        tooltip: AppLocalizations.of(context).close,
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context).manageListsSubtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: lists.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final l = lists[i];
                      return ListTile(
                        leading: const Icon(Icons.label_outline),
                        title: Text(l.title),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: AppLocalizations.of(context).edit,
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () async {
                                final ctrl = TextEditingController(
                                  text: l.title,
                                );
                                final newTitle = await showDialog<String?>(
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
                                            AppLocalizations.of(context).cancel,
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
                                            AppLocalizations.of(context).save,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (newTitle != null && newTitle != l.title) {
                                  await _listRepo.updateList(
                                    AppList(id: l.id, title: newTitle),
                                  );
                                  setStateSheet(() {});
                                }
                              },
                            ),
                            IconButton(
                              tooltip: AppLocalizations.of(context).delete,
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () async {
                                // Ask cascade option
                                bool cascadeHabits = true;
                                bool cascadeTasks = true;
                                final confirmed = await showDialog<bool>(
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
                                            mainAxisSize: MainAxisSize.min,
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
                                                contentPadding: EdgeInsets.zero,
                                                value: cascadeHabits,
                                                onChanged: (v) =>
                                                    setStateDialog(
                                                  () =>
                                                      cascadeHabits = v ?? true,
                                                ),
                                                title: Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  ).unassignLinkedHabits,
                                                ),
                                              ),
                                              CheckboxListTile(
                                                contentPadding: EdgeInsets.zero,
                                                value: cascadeTasks,
                                                onChanged: (v) =>
                                                    setStateDialog(
                                                  () =>
                                                      cascadeTasks = v ?? true,
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
                                                  Navigator.pop(dCtx, false),
                                              child: Text(
                                                AppLocalizations.of(
                                                  context,
                                                ).cancel,
                                              ),
                                            ),
                                            FilledButton(
                                              onPressed: () =>
                                                  Navigator.pop(dCtx, true),
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
                                // Unassign linked habits/tasks if requested
                                if (cascadeHabits) {
                                  for (final h in _repo.habits.where(
                                    (h) => h.listId == l.id,
                                  )) {
                                    await _repo.assignHabitToList(h.id, null);
                                  }
                                }
                                if (cascadeTasks) {
                                  for (final t in _taskRepo.allTasks.where(
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
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                          label: Text(AppLocalizations.of(context).close),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () async {
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
                          icon: const Icon(Icons.add),
                          label: Text(AppLocalizations.of(context).newList),
                        ),
                      ),
                    ],
                  ),
                ],
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
    return _repo.habits
        .where((h) => _selectedTypes.contains(h.habitType))
        .where(_matchesCompletionFilter)
        .where(
          (h) => _selectedListId == null ? true : h.listId == _selectedListId,
        )
        .where((h) => _isHabitScheduledForDate(h, _selected))
        .toList();
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

    // Filter out the focused item from the list ONLY if we are viewing Today
    // (Because FocusCard is only shown for Today)
    // AND only if the user is premium (because FocusCard is only shown for premium)
    final isToday = _isSameDay(_selected, DateTime.now());
    final isPremium = context.read<PremiumProvider>().isPremium;
    final (focusHabit, focusTask) = _findFocusedItem();

    final filteredHabits = (isToday && isPremium && focusHabit != null)
        ? habits.where((h) => h.id != focusHabit.id).toList()
        : habits;
    final filteredTasks = (isToday && isPremium && focusTask != null)
        ? tasks.where((t) => t.id != focusTask.id).toList()
        : tasks;

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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          Icon(
            isUnlisted ? Icons.inbox_outlined : Icons.folder_outlined,
            size: 14,
            color:
                isUnlisted ? colorScheme.outline : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              header.title.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: isUnlisted
                    ? colorScheme.outline
                    : colorScheme.onSurfaceVariant,
              ),
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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selected,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      setState(
        () => _selected = DateTime(picked.year, picked.month, picked.day),
      );
    }
  }

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
              'Alışkanlık Türü Seç',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Nasıl bir alışkanlık oluşturmak istiyorsun?',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Simple Habit Option
            _HabitTypeOption(
              icon: Icons.check_circle_outline,
              title: 'Basit Alışkanlık',
              description: 'Günlük yapılacaklar için. Tamamla veya tamamlama.',
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
              title: 'Gelişmiş Alışkanlık',
              description: 'Sayısal hedefler, zamanlayıcı ve detaylı takip.',
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

  /// Builds a centered add button that opens the add dialog
  Widget _buildInlineActionCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _showAddDialog,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.4,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.add_rounded,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Shows the add dialog with options for habit, task, and list
  void _showAddDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Habit option
              _buildDialogOption(
                icon: Icons.repeat,
                label: l10n.habit,
                color: colorScheme.primary,
                onTap: () {
                  Navigator.pop(ctx);
                  _showHabitTypeDialog();
                },
              ),
              const SizedBox(height: 12),
              // Task option
              _buildDialogOption(
                icon: Icons.task_alt,
                label: l10n.dailyTask,
                color: colorScheme.secondary,
                onTap: () {
                  Navigator.pop(ctx);
                  _showDailyTaskDialog();
                },
              ),
              const SizedBox(height: 12),
              // List option
              _buildDialogOption(
                icon: Icons.list_alt,
                label: l10n.createList,
                color: colorScheme.tertiary,
                onTap: () {
                  Navigator.pop(ctx);
                  _showListCreationDialog();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows the habit type selection dialog (simple vs advanced)
  void _showHabitTypeDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Simple habit option
              _buildDialogOption(
                icon: Icons.check_circle_outline,
                label: 'Basit Alışkanlık',
                color: colorScheme.primary,
                onTap: () {
                  Navigator.pop(ctx);
                  _createSimpleHabit();
                },
              ),
              const SizedBox(height: 12),
              // Advanced habit option
              _buildDialogOption(
                icon: Icons.auto_graph,
                label: 'Gelişmiş Alışkanlık',
                color: colorScheme.secondary,
                onTap: () {
                  Navigator.pop(ctx);
                  _createAdvancedHabit();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a dialog option row
  Widget _buildDialogOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        children: [
          // Filter action text button instead of bulky container
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: showFilterSheet,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 4,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.filter_list_rounded,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppLocalizations.of(context).filterTitle,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Show indicator if filters are active
                    if (_selectedTypes.length < 5 ||
                        _completionFilter != CompletionFilter.all ||
                        _selectedListId != null) ...[
                      const SizedBox(width: 4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          // Show current list name if selected
          if (_selectedListId != null)
            Text(
              _listRepo.lists
                  .firstWhere(
                    (l) => l.id == _selectedListId,
                    orElse: () => AppList(id: '', title: ''),
                  )
                  .title,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Expandable Date Row (shown directly under AppBar)
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                child: SizedBox(
                  height: _isHeaderExpanded ? null : 0,
                  child: _isHeaderExpanded
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 12),
                          child: _buildDateRow(context),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final tasks = _filteredTasksForSelectedDay();
                    final habits = _filteredHabits();
                    if (tasks.isEmpty && habits.isEmpty) {
                      // Show a unified empty state when nothing matches
                      return ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          _buildFilterRow(context, theme, colorScheme),
                          _buildEmptyState(
                            context,
                            AppLocalizations.of(context),
                          ),
                        ],
                      );
                    }
                    // Reserve space at the bottom so the last card is not obscured by the FAB.
                    // Compute a dynamic bottom inset using MediaQuery to include any system
                    // bottom padding (safe area) plus the typical FAB height and extra margin.
                    final mq = MediaQuery.of(context);
                    final double fabHeight = 56.0; // default FAB size
                    final double extraGap = 24.0; // comfortable breathing room
                    final double bottomReserve =
                        mq.viewPadding.bottom + fabHeight + extraGap;

                    // If no list is selected, show grouped view by list
                    if (_selectedListId == null) {
                      final groupedItems = _buildGroupedItems(habits, tasks);

                      // Build focus card if focus is active for today
                      final focusWidget = _buildFocusCardIfNeeded();
                      final isFocusActive = focusWidget != null;

                      // When focus is active, show toggle button + conditionally show items
                      // When no focus, show all items normally
                      final shouldShowOtherItems =
                          !isFocusActive || _isOtherItemsExpanded;
                      final itemsToShow = shouldShowOtherItems
                          ? groupedItems
                          : <_GroupedItem>[];

                      // Calculate item count: rhythm header (premium only) + focus + toggle button (if focus active) + items + action card (when expanded)
                      final isPremium =
                          context.watch<PremiumProvider>().isPremium;
                      final int rhythmHeaderCount = isPremium ? 1 : 0;
                      final int filterRowCount = 1;
                      final int focusItemCount = isFocusActive ? 1 : 0;
                      final int toggleButtonCount = isFocusActive ? 1 : 0;
                      final int actionCardCount = shouldShowOtherItems ? 1 : 0;
                      final int totalCount = rhythmHeaderCount +
                          filterRowCount +
                          focusItemCount +
                          toggleButtonCount +
                          itemsToShow.length +
                          actionCardCount;

                      return AnimationLimiter(
                        key: _listAnimationKey,
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: bottomReserve),
                          itemCount: totalCount,
                          itemBuilder: (context, index) {
                            Widget childWidget;
                            // 0. Show rhythm header first (premium only)
                            if (isPremium && index == 0) {
                              childWidget = LiveRhythmHeader(
                                aiMessage: _focusAiMessage,
                                isLoadingAiMessage: _isLoadingFocusAi,
                                onAiMessageTap: () =>
                                    _loadFocusAiMessage(forceRefresh: true),
                              );
                            } else if (index == rhythmHeaderCount) {
                              // Show filter row after header
                              childWidget =
                                  _buildFilterRow(context, theme, colorScheme);
                            } else if (isFocusActive &&
                                index == rhythmHeaderCount + filterRowCount) {
                              // Show focus card
                              childWidget = focusWidget;
                            } else if (isFocusActive &&
                                index ==
                                    rhythmHeaderCount + filterRowCount + 1) {
                              // Show toggle button after focus card
                              childWidget =
                                  _buildOtherItemsToggle(groupedItems.length);
                            } else {
                              // Show items if expanded or if no focus
                              final adjustedIndex = index -
                                  rhythmHeaderCount -
                                  filterRowCount -
                                  focusItemCount -
                                  toggleButtonCount;

                              // 4. Show inline action card at the end (when items are shown)
                              if (shouldShowOtherItems &&
                                  adjustedIndex == itemsToShow.length) {
                                childWidget = _buildInlineActionCard();
                              } else if (adjustedIndex < 0 ||
                                  adjustedIndex >= itemsToShow.length) {
                                childWidget = const SizedBox.shrink();
                              } else {
                                final item = itemsToShow[adjustedIndex];
                                childWidget = switch (item) {
                                  _ListHeader() => _buildListHeaderWidget(item),
                                  _TaskItem() =>
                                    _buildTaskCardWidget(item.task),
                                  _HabitItem() =>
                                    _buildHabitCardWidget(item.habit),
                                };
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
                    }

                    // Otherwise show flat list (existing behavior when a list is selected)

                    return AnimationLimiter(
                      key: _listAnimationKey,
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: bottomReserve),
                        itemCount: 1 +
                            (tasks.isNotEmpty ? (1 + tasks.length) : 0) +
                            (habits.isNotEmpty ? (1 + habits.length) : 0),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 250),
                              child: SlideAnimation(
                                verticalOffset: 30.0,
                                child: _buildFilterRow(
                                    context, theme, colorScheme),
                              ),
                            );
                          }
                          index -= 1; // Adjust index for the rest of the items
                          Widget childWidget = const SizedBox.shrink();
                          int cursor = 0;
                          // Tasks section
                          if (tasks.isNotEmpty) {
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
    // Refresh mood after return
    _initMood();
  }

  Widget _buildCustomHeader(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isToday = _isSameDay(_selected, DateTime.now());

    // Format date: "15 Oct"
    final locale = Localizations.localeOf(context).toString();
    final dateDisplay =
        isToday ? l10n.today : DateFormat.MMMd(locale).format(_selected);

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 12, // slightly more padding
        left: 20,
        right: 12,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Dynamic Title
          InkWell(
            onTap: () {
              setState(() {
                _isHeaderExpanded = !_isHeaderExpanded;
              });
              if (_isHeaderExpanded) {
                // scroll to ensure selected is visible when opening
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollDateRowToSelected(animate: true);
                });
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dateDisplay,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: _isHeaderExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          // Action Buttons

          // Mood Selector
          IconButton(
            onPressed: openMoodScreen,
            icon: _currentMood != null
                ? Icon(
                    _iconFor(_currentMood!),
                    color: _colorFor(_currentMood!),
                    size: 28,
                  )
                : Icon(
                    Icons.sentiment_neutral,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
            tooltip: "Mood",
          ),

          IconButton(
            tooltip: l10n.filterTooltip,
            icon: const Icon(Icons.filter_list),
            onPressed: () => showFilterSheet(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.builder(
        controller: _dateScrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _dateRange.length + 1, // +1 for Calendar button
        itemBuilder: (context, i) {
          // Last item is Calendar button
          if (i == _dateRange.length) {
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Center(
                child: IconButton.filledTonal(
                  icon: const Icon(Icons.calendar_month_outlined),
                  onPressed: _pickDate,
                ),
              ),
            );
          }

          final day = _dateRange[i];
          final bool selected = _isSameDay(day, _selected);
          final bool today = _isSameDay(day, DateTime.now());
          final scheme = Theme.of(context).colorScheme;

          final Color baseBg = scheme.surfaceContainerHighest;
          final Color unselectedBg = (!selected && today)
              ? Color.alphaBlend(scheme.primary.withValues(alpha: 0.08), baseBg)
              : baseBg;
          final Color selectedBg = scheme.primaryContainer;

          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                setState(() => _selected = day);
                _scrollDateRowToSelected(animate: true);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 42,
                decoration: BoxDecoration(
                  color: selected ? selectedBg : unselectedBg,
                  borderRadius: BorderRadius.circular(12),
                  border: selected
                      ? Border.all(
                          color: scheme.primary.withValues(alpha: 0.2),
                          width: 1.5,
                        )
                      : null,
                ),
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _weekdayLabel(context, day.weekday),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            color: selected
                                ? scheme.onPrimaryContainer
                                : today
                                    ? scheme.primary
                                    : scheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${day.day}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                            color: selected
                                ? scheme.onPrimaryContainer
                                : scheme.onSurface,
                          ),
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
    final scheme = Theme.of(context).colorScheme;

    // Muted styling when another item is focused
    final double mutedOpacity = isMuted ? 0.45 : 1.0;
    final double mutedScale = isMuted ? 0.92 : 1.0;

    return Opacity(
      opacity: mutedOpacity,
      child: Transform.scale(
        scale: mutedScale,
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
          child: Material(
            color: isMuted ? Colors.transparent : scheme.surface,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onToggleDone(!isDone),
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
                        decoration: BoxDecoration(
                          color: Theme.of(ctx).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                                title: const Text('Bugünün Odağı Yap'),
                                subtitle: const Text('Bu görevi önceliklendir'),
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
                            const SizedBox(height: 6),
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
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Symmetric checkbox area
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: Center(
                        child: Checkbox(
                          value: isDone,
                          onChanged: (v) => onToggleDone(v ?? false),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Title + description centered vertically
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    decoration: isDone
                                        ? TextDecoration.lineThrough
                                        : null,
                                    // When there is no description, use a slightly
                                    // tighter height so the title sits vertically
                                    // centered next to the checkbox.
                                    height: description.isEmpty ? 1.02 : null,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (description.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: scheme.onSurfaceVariant,
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
                    ),
                    const SizedBox(width: 12),
                    // Optional list pill
                    if (listName != null && listName!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          listName!,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: scheme.onSecondaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
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
