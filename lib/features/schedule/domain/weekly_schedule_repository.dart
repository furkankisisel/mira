import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'schedule_event.dart';
import '../../habit/domain/habit_model.dart';
import '../../habit/domain/habit_repository.dart';
import '../../habit/domain/habit_types.dart';
import '../../rhythm/domain/live_rhythm_model.dart';

/// Repository for persisting custom schedule events and merging habit-based
/// events into a unified weekly grid.
class WeeklyScheduleRepository extends ChangeNotifier {
  WeeklyScheduleRepository._();
  static final WeeklyScheduleRepository instance = WeeklyScheduleRepository._();

  static const _storageKey = 'weekly_schedule_events_v1';

  final List<ScheduleEvent> _events = [];
  bool _initialized = false;
  bool _habitListenerAttached = false;

  List<ScheduleEvent> get events => List.unmodifiable(_events);

  // ── Initialization ──────────────────────────────────────────────────────

  Future<void> initialize() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List;
        _events.clear();
        for (final item in list) {
          _events.add(ScheduleEvent.fromJson(item as Map<String, dynamic>));
        }
      } catch (_) {
        // corrupted data – start fresh
        _events.clear();
      }
    }

    // Ensure HabitRepository is initialized and listened to
    await HabitRepository.instance.initialize();
    if (!_habitListenerAttached) {
      HabitRepository.instance.addListener(_onHabitsChanged);
      _habitListenerAttached = true;
    }

    _initialized = true;
    notifyListeners();
  }

  void _onHabitsChanged() {
    notifyListeners();
  }

  /// Reloads data from storage (e.g., after restoring a backup)
  Future<void> reload() async {
    _initialized = false;
    await initialize();
  }

  // ── CRUD ────────────────────────────────────────────────────────────────

  Future<void> addEvent(ScheduleEvent event) async {
    _events.add(event);
    await _persist();
    notifyListeners();
  }

  Future<void> addEvents(List<ScheduleEvent> events) async {
    _events.addAll(events);
    await _persist();
    notifyListeners();
  }

  Future<void> updateEvent(ScheduleEvent event) async {
    final idx = _events.indexWhere((e) => e.id == event.id);
    if (idx != -1) {
      _events[idx] = event;
      await _persist();
      notifyListeners();
    }
  }

  Future<void> removeEvent(String id) async {
    _events.removeWhere((e) => e.id == id);
    await _persist();
    notifyListeners();
  }

  // ── Queries ─────────────────────────────────────────────────────────────

  /// All events for a specific week (custom schedule events + scheduled habit events).
  List<ScheduleEvent> getEventsForWeek(DateTime startOfWeek) {
    final String weekKey = _weekStartString(startOfWeek);

    // 1. Custom stored events for this week
    final customEvents = _events.where((e) {
      if (e.startDate == null) {
        return true; // legacy events show on all weeks until edited
      }
      return e.startDate == weekKey;
    }).toList();

    // 2. Synthesize habit events for the 7 days of this week
    final habitEvents = <ScheduleEvent>[];
    final habits = HabitRepository.instance.habits;

    final monday = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day)
        .subtract(Duration(days: startOfWeek.weekday - 1));

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (int dayIdx = 0; dayIdx < 7; dayIdx++) {
      final dayDate = monday.add(Duration(days: dayIdx));
      final dayOfWeek = dayIdx + 1; // 1=Mon ... 7=Sun
      final dayKey =
          '${dayDate.year}-${dayDate.month.toString().padLeft(2, '0')}-${dayDate.day.toString().padLeft(2, '0')}';
      final isToday = dayDate.isAtSameMomentAs(today);
      final isPast = dayDate.isBefore(today);

      int fallbackIndex = 0;
      final usedStartMinutes = <int>{};

      for (int hIdx = 0; hIdx < habits.length; hIdx++) {
        final habit = habits[hIdx];
        if (!isHabitScheduledForDate(habit, dayDate)) continue;

        TimeOfDay startTime;
        if (habit.reminderTime != null) {
          final hour = habit.reminderTime!.hour.clamp(6, 23);
          startTime = TimeOfDay(hour: hour, minute: habit.reminderTime!.minute);
        } else if (habit.rhythmWindow != null) {
          TimeOfDay baseTime;
          switch (habit.rhythmWindow!) {
            case RhythmWindow.energy:
              baseTime = const TimeOfDay(hour: 9, minute: 0);
              break;
            case RhythmWindow.focus:
              baseTime = const TimeOfDay(hour: 12, minute: 30);
              break;
            case RhythmWindow.light:
              baseTime = const TimeOfDay(hour: 15, minute: 0);
              break;
            case RhythmWindow.reflection:
              baseTime = const TimeOfDay(hour: 20, minute: 0);
              break;
          }
          int baseMins = baseTime.hour * 60 + baseTime.minute;
          while (usedStartMinutes.contains(baseMins) && baseMins < 23 * 60) {
            baseMins += 50;
          }
          startTime = TimeOfDay(hour: (baseMins ~/ 60).clamp(6, 23), minute: baseMins % 60);
        } else {
          const fallbackSlots = [
            TimeOfDay(hour: 8, minute: 0),
            TimeOfDay(hour: 9, minute: 45),
            TimeOfDay(hour: 11, minute: 30),
            TimeOfDay(hour: 13, minute: 30),
            TimeOfDay(hour: 15, minute: 15),
            TimeOfDay(hour: 17, minute: 0),
            TimeOfDay(hour: 18, minute: 45),
            TimeOfDay(hour: 20, minute: 30),
            TimeOfDay(hour: 22, minute: 0),
          ];
          int slotIdx = fallbackIndex % fallbackSlots.length;
          TimeOfDay slotTime = fallbackSlots[slotIdx];
          int slotMins = slotTime.hour * 60 + slotTime.minute;
          while (usedStartMinutes.contains(slotMins) && slotMins < 23 * 60) {
            fallbackIndex++;
            slotIdx = fallbackIndex % fallbackSlots.length;
            slotTime = fallbackSlots[slotIdx];
            slotMins = slotTime.hour * 60 + slotTime.minute;
          }
          fallbackIndex++;
          startTime = slotTime;
        }

        final duration = getHabitDurationMinutes(habit);
        final startTotal = startTime.hour * 60 + startTime.minute;
        usedStartMinutes.add(startTotal);

        final endTotal = (startTotal + duration).clamp(0, 24 * 60);
        final endHour = endTotal ~/ 60;
        final endMinute = endTotal % 60;

        final bool isCompleted;
        if (isToday) {
          isCompleted = habit.isCompleted ||
              HabitRepository.evaluateCompletionFromLog(habit, dayKey);
        } else if (isPast) {
          isCompleted = HabitRepository.evaluateCompletionFromLog(habit, dayKey);
        } else {
          isCompleted = false;
        }

        habitEvents.add(
          ScheduleEvent(
            id: 'habit_${habit.id}_$dayKey',
            title: habit.title,
            description: habit.description,
            dayOfWeek: dayOfWeek,
            startHour: startTime.hour,
            startMinute: startTime.minute,
            endHour: endHour,
            endMinute: endMinute,
            color: habit.color,
            isHabit: true,
            habitId: habit.id,
            emoji: habit.emoji,
            location: habit.targetCount > 0
                ? '${habit.targetCount} ${habit.unit ?? ''}'.trim()
                : null,
            startDate: weekKey,
            isCompleted: isCompleted,
            targetCount: habit.targetCount,
            unit: habit.unit,
          ),
        );
      }
    }

    return [...customEvents, ...habitEvents];
  }

  /// Determines whether a habit is active on [date] based on start/end dates,
  /// explicit scheduled dates, and frequency configuration.
  static bool isHabitScheduledForDate(Habit habit, DateTime date) {
    // 1. Date boundaries check
    final dateOnly = DateTime(date.year, date.month, date.day);
    if (habit.startDate.length >= 10) {
      final start = DateTime.tryParse(habit.startDate.substring(0, 10));
      if (start != null) {
        final startOnly = DateTime(start.year, start.month, start.day);
        if (dateOnly.isBefore(startOnly)) return false;
      }
    }

    if (habit.endDate != null && habit.endDate!.length >= 10) {
      final end = DateTime.tryParse(habit.endDate!.substring(0, 10));
      if (end != null) {
        final endOnly = DateTime(end.year, end.month, end.day);
        if (dateOnly.isAfter(endOnly)) return false;
      }
    }

    // 2. Explicit scheduledDates check
    final dayKey =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    if (habit.scheduledDates != null && habit.scheduledDates!.isNotEmpty) {
      return habit.scheduledDates!.contains(dayKey);
    }

    // 3. Frequency type check
    final freq = habit.frequencyType;
    if (freq == null || freq.isEmpty) {
      if (habit.selectedWeekdays != null && habit.selectedWeekdays!.isNotEmpty) {
        return habit.selectedWeekdays!.contains(date.weekday - 1) ||
            habit.selectedWeekdays!.contains(date.weekday);
      }
      return true;
    }

    switch (freq) {
      case 'daily':
        return true;
      case 'weekly':
      case 'specificWeekdays':
        if (habit.selectedWeekdays == null || habit.selectedWeekdays!.isEmpty) {
          return true;
        }
        return habit.selectedWeekdays!.contains(date.weekday - 1) ||
            habit.selectedWeekdays!.contains(date.weekday);
      case 'monthly':
      case 'specificMonthDays':
        if (habit.selectedMonthDays == null || habit.selectedMonthDays!.isEmpty) {
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
        DateTime startOnly = dateOnly;
        if (habit.startDate.length >= 10) {
          final s = DateTime.tryParse(habit.startDate.substring(0, 10));
          if (s != null) startOnly = DateTime(s.year, s.month, s.day);
        }
        final diff = dateOnly.difference(startOnly).inDays;
        return (diff % habit.periodicDays!) == 0;
      default:
        if (habit.selectedWeekdays != null && habit.selectedWeekdays!.isNotEmpty) {
          return habit.selectedWeekdays!.contains(date.weekday - 1) ||
              habit.selectedWeekdays!.contains(date.weekday);
        }
        return true;
    }
  }

  /// Determines optimal start time for a habit (reminder time > rhythm window > index slot fallback).
  static TimeOfDay getHabitTime(Habit h, int habitIndex) {
    if (h.reminderTime != null) {
      final hour = h.reminderTime!.hour.clamp(6, 23);
      return TimeOfDay(hour: hour, minute: h.reminderTime!.minute);
    }
    if (h.rhythmWindow != null) {
      switch (h.rhythmWindow!) {
        case RhythmWindow.energy:
          return const TimeOfDay(hour: 9, minute: 0);
        case RhythmWindow.focus:
          return const TimeOfDay(hour: 12, minute: 30);
        case RhythmWindow.light:
          return const TimeOfDay(hour: 15, minute: 0);
        case RhythmWindow.reflection:
          return const TimeOfDay(hour: 20, minute: 0);
      }
    }
    const fallbackSlots = [
      TimeOfDay(hour: 8, minute: 0),
      TimeOfDay(hour: 9, minute: 30),
      TimeOfDay(hour: 11, minute: 0),
      TimeOfDay(hour: 13, minute: 0),
      TimeOfDay(hour: 14, minute: 30),
      TimeOfDay(hour: 16, minute: 0),
      TimeOfDay(hour: 17, minute: 30),
      TimeOfDay(hour: 19, minute: 0),
      TimeOfDay(hour: 20, minute: 30),
      TimeOfDay(hour: 22, minute: 0),
    ];
    return fallbackSlots[(habitIndex >= 0 ? habitIndex : 0) % fallbackSlots.length];
  }

  /// Calculates planned duration in minutes for a habit block.
  static int getHabitDurationMinutes(Habit h) {
    if (h.habitType == HabitType.timer && h.targetCount > 0) {
      return h.targetCount.clamp(30, 90);
    }
    return 45; // 45-minute block provides optimal readability and proportions
  }

  /// Helper to get the canonical string for a week (always Monday)
  static String _weekStartString(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  // ── Persistence ─────────────────────────────────────────────────────────

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(_events.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, json);
  }

  /// Clear all custom events.
  Future<void> wipeAllStoredData() async {
    _events.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    notifyListeners();
  }
}
