import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../habit/domain/habit_model.dart';
import '../../habit/domain/habit_types.dart';
import '../../habit/domain/subtask_model.dart';
import '../../rhythm/domain/live_rhythm_model.dart';

/// A habit that belongs to a social room, shared by all members.
class RoomHabit {
  const RoomHabit({
    required this.id,
    required this.title,
    this.description = '',
    this.emoji,
    this.colorValue,
    required this.createdBy,
    required this.createdAt,
    this.isAdvanced = false,
    this.targetCount = 1,
    this.habitType = HabitType.simple,
    this.unit,
    this.startDate,
    this.endDate,
    this.frequency,
    this.frequencyType,
    this.selectedWeekdays,
    this.selectedMonthDays,
    this.selectedYearDays,
    this.periodicDays,
    this.scheduledDates,
    this.numericalTargetType = NumericalTargetType.minimum,
    this.timerTargetType = TimerTargetType.minimum,
    this.subtasks = const [],
    this.reminderEnabled = false,
    this.reminderTime,
    this.rhythmWindow,
  });

  final String id;
  final String title;
  final String description;
  final String? emoji;
  final int? colorValue;
  final String createdBy;
  final DateTime createdAt;
  final bool isAdvanced;
  final int targetCount;
  final HabitType habitType;
  final String? unit;
  final String? startDate;
  final String? endDate;
  final String? frequency;
  final String? frequencyType;
  final List<int>? selectedWeekdays;
  final List<int>? selectedMonthDays;
  final List<String>? selectedYearDays;
  final int? periodicDays;
  final List<String>? scheduledDates;
  final NumericalTargetType numericalTargetType;
  final TimerTargetType timerTargetType;
  final List<Subtask> subtasks;
  final bool reminderEnabled;
  final TimeOfDay? reminderTime;
  final RhythmWindow? rhythmWindow;

  Color get color =>
      colorValue != null ? Color(colorValue!) : const Color(0xFF6366F1);

  bool get isNumerical => habitType == HabitType.numerical || targetCount > 1;

  RoomHabit copyWith({
    String? id,
    String? title,
    String? description,
    String? emoji,
    int? colorValue,
    String? createdBy,
    DateTime? createdAt,
    bool? isAdvanced,
    int? targetCount,
    HabitType? habitType,
    String? unit,
    String? startDate,
    String? endDate,
    String? frequency,
    String? frequencyType,
    List<int>? selectedWeekdays,
    List<int>? selectedMonthDays,
    List<String>? selectedYearDays,
    int? periodicDays,
    List<String>? scheduledDates,
    NumericalTargetType? numericalTargetType,
    TimerTargetType? timerTargetType,
    List<Subtask>? subtasks,
    bool? reminderEnabled,
    TimeOfDay? reminderTime,
    RhythmWindow? rhythmWindow,
  }) {
    return RoomHabit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      colorValue: colorValue ?? this.colorValue,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      isAdvanced: isAdvanced ?? this.isAdvanced,
      targetCount: targetCount ?? this.targetCount,
      habitType: habitType ?? this.habitType,
      unit: unit ?? this.unit,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      frequency: frequency ?? this.frequency,
      frequencyType: frequencyType ?? this.frequencyType,
      selectedWeekdays: selectedWeekdays ?? this.selectedWeekdays,
      selectedMonthDays: selectedMonthDays ?? this.selectedMonthDays,
      selectedYearDays: selectedYearDays ?? this.selectedYearDays,
      periodicDays: periodicDays ?? this.periodicDays,
      scheduledDates: scheduledDates ?? this.scheduledDates,
      numericalTargetType: numericalTargetType ?? this.numericalTargetType,
      timerTargetType: timerTargetType ?? this.timerTargetType,
      subtasks: subtasks ?? this.subtasks,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      rhythmWindow: rhythmWindow ?? this.rhythmWindow,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        if (emoji != null) 'emoji': emoji,
        if (colorValue != null) 'colorValue': colorValue,
        'createdBy': createdBy,
        'createdAt': Timestamp.fromDate(createdAt),
        'isAdvanced': isAdvanced,
        'targetCount': targetCount,
        'habitType': habitType.name,
        if (unit != null) 'unit': unit,
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
        if (frequency != null) 'frequency': frequency,
        if (frequencyType != null) 'frequencyType': frequencyType,
        if (selectedWeekdays != null) 'selectedWeekdays': selectedWeekdays,
        if (selectedMonthDays != null) 'selectedMonthDays': selectedMonthDays,
        if (selectedYearDays != null) 'selectedYearDays': selectedYearDays,
        if (periodicDays != null) 'periodicDays': periodicDays,
        if (scheduledDates != null) 'scheduledDates': scheduledDates,
        'numericalTargetType': numericalTargetType.name,
        'timerTargetType': timerTargetType.name,
        'subtasks': subtasks.map((s) => s.toJson()).toList(),
        'reminderEnabled': reminderEnabled,
        if (reminderTime != null)
          'reminderTime': {
            'hour': reminderTime!.hour,
            'minute': reminderTime!.minute,
          },
        if (rhythmWindow != null) 'rhythmWindow': rhythmWindow!.name,
      };

  static RoomHabit fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    final isAdv = d['isAdvanced'] as bool? ?? false;
    final target = (d['targetCount'] as num?)?.toInt() ?? 1;

    HabitType type = HabitType.simple;
    if (d['habitType'] != null) {
      type = HabitType.values.firstWhere(
        (e) => e.name == d['habitType'],
        orElse: () => isAdv ? HabitType.numerical : HabitType.simple,
      );
    } else if (target > 1 || isAdv) {
      type = HabitType.numerical;
    }

    final createdAt =
        (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
    final defaultStartDate =
        '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';

    final numTypeStr = d['numericalTargetType'] as String?;
    final numType = numTypeStr != null
        ? NumericalTargetType.values.firstWhere(
            (e) => e.name == numTypeStr,
            orElse: () => NumericalTargetType.minimum,
          )
        : NumericalTargetType.minimum;

    final timTypeStr = d['timerTargetType'] as String?;
    final timType = timTypeStr != null
        ? TimerTargetType.values.firstWhere(
            (e) => e.name == timTypeStr,
            orElse: () => TimerTargetType.minimum,
          )
        : TimerTargetType.minimum;

    List<Subtask> parsedSubtasks = [];
    if (d['subtasks'] is List) {
      parsedSubtasks = (d['subtasks'] as List)
          .whereType<Map<String, dynamic>>()
          .map(Subtask.fromJson)
          .toList();
    }

    TimeOfDay? reminderTime;
    if (d['reminderTime'] is Map) {
      final rt = d['reminderTime'] as Map;
      reminderTime = TimeOfDay(
        hour: (rt['hour'] as num?)?.toInt() ?? 9,
        minute: (rt['minute'] as num?)?.toInt() ?? 0,
      );
    }

    RhythmWindow? rhythmWindow;
    if (d['rhythmWindow'] is String) {
      rhythmWindow = RhythmWindow.values.firstWhere(
        (w) => w.name == d['rhythmWindow'],
        orElse: () => RhythmWindow.focus,
      );
    }

    return RoomHabit(
      id: doc.id,
      title: d['title'] as String? ?? '',
      description: d['description'] as String? ?? '',
      emoji: d['emoji'] as String?,
      colorValue: (d['colorValue'] as num?)?.toInt(),
      createdBy: d['createdBy'] as String? ?? '',
      createdAt: createdAt,
      isAdvanced: isAdv,
      targetCount: target,
      habitType: type,
      unit: d['unit'] as String?,
      startDate: d['startDate'] as String? ?? defaultStartDate,
      endDate: d['endDate'] as String?,
      frequency: d['frequency'] as String?,
      frequencyType: d['frequencyType'] as String?,
      selectedWeekdays: (d['selectedWeekdays'] as List?)
          ?.whereType<num>()
          .map((e) => e.toInt())
          .toList(),
      selectedMonthDays: (d['selectedMonthDays'] as List?)
          ?.whereType<num>()
          .map((e) => e.toInt())
          .toList(),
      selectedYearDays: (d['selectedYearDays'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      periodicDays: (d['periodicDays'] as num?)?.toInt(),
      scheduledDates:
          (d['scheduledDates'] as List?)?.map((e) => e.toString()).toList(),
      numericalTargetType: numType,
      timerTargetType: timType,
      subtasks: parsedSubtasks,
      reminderEnabled: d['reminderEnabled'] as bool? ?? false,
      reminderTime: reminderTime,
      rhythmWindow: rhythmWindow,
    );
  }

  factory RoomHabit.fromHabit(
    Habit habit, {
    required String createdBy,
    DateTime? createdAt,
    String? id,
  }) {
    return RoomHabit(
      id: id ?? habit.id,
      title: habit.title,
      description: habit.description,
      emoji: habit.emoji,
      colorValue: habit.color.value,
      createdBy: createdBy,
      createdAt: createdAt ?? DateTime.now(),
      isAdvanced: habit.isAdvanced,
      targetCount: habit.targetCount,
      habitType: habit.habitType,
      unit: habit.unit,
      startDate: habit.startDate,
      endDate: habit.endDate,
      frequency: habit.frequency,
      frequencyType: habit.frequencyType,
      selectedWeekdays: habit.selectedWeekdays,
      selectedMonthDays: habit.selectedMonthDays,
      selectedYearDays: habit.selectedYearDays,
      periodicDays: habit.periodicDays,
      scheduledDates: habit.scheduledDates,
      numericalTargetType: habit.numericalTargetType,
      timerTargetType: habit.timerTargetType,
      subtasks: habit.subtasks,
      reminderEnabled: habit.reminderEnabled,
      reminderTime: habit.reminderTime,
      rhythmWindow: habit.rhythmWindow,
    );
  }

  Habit toHabit({
    MemberProgress? myProgress,
    String? roomId,
    String? roomName,
  }) {
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final progress = myProgress?.todayValue ?? 0;
    final completed = myProgress?.isCompletedToday ?? false;

    final displaySubtasks = subtasks.map((s) {
      final isSubDone =
          myProgress?.completedSubtaskIds.contains(s.id) ?? false;
      return Subtask(id: s.id, title: s.title, isCompleted: isSubDone);
    }).toList();

    final h = Habit(
      id: id,
      title: title,
      description: description,
      icon: Icons.groups_rounded,
      emoji: emoji,
      color: color,
      targetCount: targetCount,
      habitType: habitType,
      unit: unit,
      frequency: frequency,
      frequencyType: frequencyType,
      selectedWeekdays: selectedWeekdays,
      selectedMonthDays: selectedMonthDays,
      selectedYearDays: selectedYearDays,
      periodicDays: periodicDays,
      currentStreak: progress,
      isCompleted: completed,
      progressDate: dateStr,
      startDate: startDate ?? dateStr,
      endDate: endDate,
      scheduledDates: scheduledDates,
      categoryName: roomName != null ? '👥 $roomName' : '👥 Oda Alışkanlığı',
      numericalTargetType: numericalTargetType,
      timerTargetType: timerTargetType,
      subtasks: displaySubtasks,
      reminderEnabled: reminderEnabled,
      reminderTime: reminderTime,
      rhythmWindow: rhythmWindow,
      dailyLog: {dateStr: progress},
    )..isAdvanced = isAdvanced;

    h.roomId = roomId;
    h.roomName = roomName;
    h.roomHabitCreatedBy = createdBy;
    h.roomStreak = myProgress?.streak ?? 0;
    return h;
  }
}

/// Progress of a single member on a room habit.
class MemberProgress {
  const MemberProgress({
    required this.uid,
    required this.displayName,
    this.avatarUrl,
    required this.value,
    required this.target,
    required this.isCompleted,
    required this.lastUpdated,
    this.streak = 0,
    this.completedSubtaskIds = const [],
  });

  final String uid;
  final String displayName;
  final String? avatarUrl;
  final int value;
  final int target;
  final bool isCompleted;
  final DateTime lastUpdated;
  final int streak;
  final List<String> completedSubtaskIds;

  /// Whether this progress entry was updated TODAY.
  bool get isToday {
    final now = DateTime.now();
    return lastUpdated.year == now.year &&
        lastUpdated.month == now.month &&
        lastUpdated.day == now.day;
  }

  /// Today's completion status. If last updated before today, returns false.
  bool get isCompletedToday => isCompleted && isToday;

  /// Today's value. If last updated before today, returns 0.
  int get todayValue => isToday ? value : 0;

  /// Completion percentage (0.0 – 1.0) for today.
  double get completionRatio =>
      target > 0 ? (todayValue / target).clamp(0.0, 1.0) : 0.0;

  /// Completion percentage as int (0 – 100).
  int get completionPercent => (completionRatio * 100).round();

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
        'value': value,
        'target': target,
        'isCompleted': isCompleted,
        'lastUpdated': Timestamp.fromDate(lastUpdated),
        'streak': streak,
        'completedSubtaskIds': completedSubtaskIds,
      };

  static MemberProgress fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data()!;
    final subtaskIds = (d['completedSubtaskIds'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        const <String>[];

    DateTime parsedLastUpdated = DateTime.now();
    if (d['lastUpdated'] is Timestamp) {
      parsedLastUpdated = (d['lastUpdated'] as Timestamp).toDate().toLocal();
    } else if (d['lastUpdated'] is String) {
      parsedLastUpdated =
          DateTime.tryParse(d['lastUpdated'] as String)?.toLocal() ??
              DateTime.now();
    }

    return MemberProgress(
      uid: doc.id,
      displayName: d['displayName'] as String? ?? '',
      avatarUrl: d['avatarUrl'] as String?,
      value: (d['value'] as num?)?.toInt() ?? 0,
      target: (d['target'] as num?)?.toInt() ?? 1,
      isCompleted: d['isCompleted'] as bool? ?? false,
      lastUpdated: parsedLastUpdated,
      streak: (d['streak'] as num?)?.toInt() ?? 0,
      completedSubtaskIds: subtaskIds,
    );
  }
}
