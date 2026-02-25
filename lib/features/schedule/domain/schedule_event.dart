import 'package:flutter/material.dart';

/// A single event block on the weekly schedule grid.
class ScheduleEvent {
  ScheduleEvent({
    required this.id,
    required this.title,
    this.description = '',
    required this.dayOfWeek, // 1=Mon ... 7=Sun
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.color,
    this.isHabit = false,
    this.habitId,
    this.location,
    this.startDate,
    this.emoji,
  });

  final String id;
  String title;
  String description;
  int dayOfWeek;
  int startHour;
  int startMinute;
  int endHour;
  int endMinute;
  Color color;
  bool isHabit;
  String? habitId;
  String? location;
  String? startDate; // YYYY-MM-DD representing the week this event belongs to
  String? emoji;

  /// Duration in minutes
  int get durationMinutes {
    final start = startHour * 60 + startMinute;
    final end = endHour * 60 + endMinute;
    return end - start;
  }

  /// Formatted time range string, e.g. "09:30 - 12:00"
  String get timeRangeText =>
      '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}'
      ' - '
      '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'dayOfWeek': dayOfWeek,
        'startHour': startHour,
        'startMinute': startMinute,
        'endHour': endHour,
        'endMinute': endMinute,
        'colorValue': color.value,
        'isHabit': isHabit,
        'habitId': habitId,
        'location': location,
        'startDate': startDate,
        'emoji': emoji,
      };

  factory ScheduleEvent.fromJson(Map<String, dynamic> json) => ScheduleEvent(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        dayOfWeek: json['dayOfWeek'] as int,
        startHour: json['startHour'] as int,
        startMinute: json['startMinute'] as int? ?? 0,
        endHour: json['endHour'] as int,
        endMinute: json['endMinute'] as int? ?? 0,
        color: Color(json['colorValue'] as int),
        isHabit: json['isHabit'] as bool? ?? false,
        habitId: json['habitId'] as String?,
        location: json['location'] as String?,
        startDate: json['startDate'] as String?,
        emoji: json['emoji'] as String?,
      );
}
