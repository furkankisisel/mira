import '../domain/habit_types.dart';
import '../domain/habit_model.dart';
import '../domain/subtask_model.dart';
import '../domain/daily_task_model.dart';
import 'package:flutter/material.dart';

/// Represents the top-level response from the AI service.
class AiHabitResponse {
  final List<AiHabitDto> habits;

  AiHabitResponse({required this.habits});

  factory AiHabitResponse.fromJson(Map<String, dynamic> json) {
    var habitsList = json['habits'] as List?;
    if (habitsList == null) {
      return AiHabitResponse(habits: []);
    }

    // Strict validation: Max 5 habits
    if (habitsList.length > 5) {
      habitsList = habitsList.sublist(0, 5);
    }

    final parsedHabits = habitsList
        .map((e) => AiHabitDto.tryFromJson(e as Map<String, dynamic>))
        .whereType<AiHabitDto>() // Filter out nulls (invalid items)
        .toList();

    return AiHabitResponse(habits: parsedHabits);
  }
}

/// Data Transfer Object for a single AI-generated habit.
class AiHabitDto {
  final String title;
  final String description;
  final String frequency; // 'daily' | 'weekly'
  final List<String> days; // ["mon", "tue", ...]
  final int? targetValue;
  final String category;
  final String? emoji; // New
  final String? colorCode; // New hex code e.g. #FF0000
  final String? type; // 'simple', 'numerical', 'timer', 'subtasks'
  final List<String>? subtasks;
  final int? duration; // in minutes
  final String? rationale; // Scientific explanation
  final int? durationDays; // For limited time habits (e.g. 21 days)
  final bool isTask; // If true, this is a one-off DailyTask

  AiHabitDto({
    required this.title,
    required this.description,
    required this.frequency,
    required this.days,
    this.targetValue,
    required this.category,
    this.emoji,
    this.colorCode,
    this.type,
    this.subtasks,
    this.duration,
    this.rationale,
    this.durationDays,
    this.isTask = false,
  });

  /// Factory that validates strict rules. Returns null if invalid.
  static AiHabitDto? tryFromJson(Map<String, dynamic> json) {
    try {
      final title = json['title'] as String?;
      var description = json['description'] as String?;
      var frequency = json['frequency'] as String?;
      // Handle days: might be missing or capitalized
      var dayList = (json['days'] as List?)
          ?.map((e) => e.toString().toLowerCase())
          .toList();

      final target = json['target_value'] as num?;
      final category = json['category'] as String?;
      final emoji = json['emoji'] as String?;
      final colorCode = json['color_code'] as String?;
      final type = json['type'] as String?;
      final subtasks =
          (json['subtasks'] as List?)?.map((e) => e.toString()).toList();
      final duration = json['duration_minutes'] as int?;
      final rationale = json['rationale'] as String?;
      final durationDays = json['duration_days'] as int?;
      final isTask = json['is_task'] as bool? ?? false;

      // Validate required fields
      if (title == null || title.trim().isEmpty) return null;

      // Defaults and salvaging
      description ??= '';

      // Frequency fallback
      if (frequency == null ||
          (frequency != 'daily' &&
              frequency != 'weekly' &&
              frequency != 'monthly')) {
        frequency = 'daily';
      }

      // Days fallback
      const validDays = {'mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'};
      final allDays = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

      if (dayList == null || dayList.isEmpty) {
        // If days missing, default to All Days for daily, or just Mon for weekly?
        // Let's default to all days to be safe and visible.
        dayList = allDays;
      } else {
        // Filter invalid days
        dayList = dayList.where((d) => validDays.contains(d)).toList();
        if (dayList.isEmpty) {
          dayList = allDays;
        }
      }

      // Target value safety
      // Allow larger numbers for steps (e.g. 10000) or water (2000 ml)
      // New cap: 50000
      int? finalTarget;
      if (target != null) {
        final val = target.toInt();
        if (val > 0 && val <= 50000) {
          finalTarget = val;
        } else {
          finalTarget = 1; // Default to 1 if weird number
        }
      }

      return AiHabitDto(
        title: title.trim(),
        description: description.trim(),
        frequency: frequency,
        days: dayList,
        targetValue: finalTarget,
        category: category ?? 'Other',
        emoji: emoji,
        colorCode: colorCode,
        type: type,
        subtasks: subtasks,
        duration: duration,
        rationale: rationale,
        durationDays: durationDays,
        isTask: isTask,
      );
    } catch (e) {
      // Malformed JSON part
      return null;
    }
  }

  /// Mapper to convert DTO to internal Habit model.
  Habit toHabit() {
    // Map frequency/days to Habit model structure
    HabitType finalType = HabitType.simple;
    int finalTargetCount = 1;
    String? finalUnit;
    List<Subtask>? finalSubtasks;

    if (type != null) {
      switch (type!.toLowerCase()) {
        case 'numerical':
          finalType = HabitType.numerical;
          finalTargetCount = targetValue ?? 1;
          finalUnit = 'adet';
          break;
        case 'timer':
          finalType = HabitType.timer;
          finalTargetCount = duration ?? 30; // Default 30 min
          finalUnit = 'dk'; // Minutes
          break;
        case 'subtasks':
          finalType = HabitType.subtasks;
          if (subtasks != null && subtasks!.isNotEmpty) {
            finalSubtasks = subtasks!
                .map((t) => Subtask(id: UniqueKey().toString(), title: t))
                .toList();
            finalTargetCount = finalSubtasks.length;
          }
          break;
        case 'checkbox':
          finalType = HabitType.checkbox;
          break;
        default:
          finalType = HabitType.simple;
      }
    } else {
      // Fallback heuristics
      if (targetValue != null && targetValue! > 0) {
        finalType = HabitType.numerical;
        finalTargetCount = targetValue!;
        finalUnit = 'adet';
      }
    }

    // Default icon/color based on category
    IconData icon;
    Color color;
    switch (category.toLowerCase()) {
      case 'study':
      case 'eğitim':
        icon = Icons.book;
        color = Colors.blue;
        break;
      case 'health':
      case 'sağlık':
        icon = Icons.favorite;
        color = Colors.redAccent;
        break;
      case 'personal':
      case 'kişisel':
        icon = Icons.person;
        color = Colors.purple;
        break;
      default:
        icon = Icons.star;
        color = Colors.amber;
    }

    // Override if AI provided custom color
    if (colorCode != null) {
      try {
        final hex = colorCode!.replaceAll('#', '');
        if (hex.length == 6) {
          color = Color(int.parse('0xFF$hex'));
        }
      } catch (_) {}
    }

    // Create new Habit
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    // Frequency Logic
    String? finalFrequencyType;
    List<int>? finalSelectedWeekdays; // 0=Mon, 6=Sun
    List<int>? finalSelectedMonthDays;

    if (frequency == 'weekly') {
      finalFrequencyType = 'specificWeekdays';
      // If specific days provided in JSON, use them.
      // Otherwise, default to TODAY (user's join / add day).
      // Note: mapping keys 'mon'...'sun' to 0..6 (Mon=0)
      final dayMap = {
        'mon': 0,
        'tue': 1,
        'wed': 2,
        'thu': 3,
        'fri': 4,
        'sat': 5,
        'sun': 6,
      };

      // Check if original JSON 'days' list had specific inputs distinct from the default "all days" fallback
      // In tryFromJson we defaulted to allDays. We can inspect 'days' directly.
      // If days contains ALL days, and frequency is weekly, it's ambiguous.
      // But typically 'weekly' implies once or few times a week.
      // Better strategy:
      // If days are strictly subset of all days (e.g. just ["mon"]), use them.
      // If days are ALL days (default fallback), ignore them and use TODAY.
      bool useProvidedDays = days.length < 7 && days.isNotEmpty;

      if (useProvidedDays) {
        finalSelectedWeekdays =
            days.map((d) => dayMap[d]).whereType<int>().toList();
      } else {
        // Default to current weekday (0-6)
        finalSelectedWeekdays = [now.weekday - 1];
      }
    } else if (frequency == 'monthly') {
      finalFrequencyType = 'specificMonthDays';
      // Default to current day of month
      finalSelectedMonthDays = [now.day];
    } else {
      // Daily
      finalFrequencyType = 'daily';
      // Explicitly set all weekdays 0..6 just in case
      finalSelectedWeekdays = [0, 1, 2, 3, 4, 5, 6];
    }

    // Calculate End Date if duration_days provided
    String? finalEndDate;
    if (durationDays != null && durationDays! > 0) {
      final end = now.add(Duration(days: durationDays! - 1));
      finalEndDate =
          '${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}';
    }

    String finalDescription = description.trim();
    if (rationale != null && rationale!.trim().isNotEmpty) {
      finalDescription += '\n\n🔬 Science-informed note:\n$rationale';
    }

    return Habit(
      id: UniqueKey().toString(), // temporary ID
      title: title,
      description: finalDescription,
      icon: icon,
      emoji: emoji, // Pass emoji
      color: color,
      targetCount: finalTargetCount,
      habitType: finalType,
      unit: finalUnit, // Default unit
      subtasks: finalSubtasks,
      frequency: frequency,
      frequencyType: finalFrequencyType,
      selectedWeekdays: finalSelectedWeekdays,
      selectedMonthDays: finalSelectedMonthDays,
      currentStreak: 0,
      isCompleted: false,
      progressDate: dateStr,
      startDate: dateStr,
      endDate: finalEndDate,
      dailyLog: {},
      reminderEnabled: false,
    )..isAdvanced = false;
  }

  /// Converter for one-off tasks

  DailyTask toDailyTask() {
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    return DailyTask(
      id: UniqueKey().toString(),
      title: title,
      description:
          description + (rationale != null ? '\n\nNote: $rationale' : ''),
      dateKey: dateStr,
      isDone: false,
    );
  }
}
