import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// A habit that belongs to a social room, shared by all members.
class RoomHabit {
  const RoomHabit({
    required this.id,
    required this.title,
    this.emoji,
    this.colorValue,
    required this.createdBy,
    required this.createdAt,
    this.isAdvanced = false,
  });

  final String id;
  final String title;
  final String? emoji;
  final int? colorValue;
  final String createdBy;
  final DateTime createdAt;
  final bool isAdvanced;

  Color get color => colorValue != null ? Color(colorValue!) : const Color(0xFF6366F1);

  Map<String, dynamic> toJson() => {
        'title': title,
        if (emoji != null) 'emoji': emoji,
        if (colorValue != null) 'colorValue': colorValue,
        'createdBy': createdBy,
        'createdAt': Timestamp.fromDate(createdAt),
        'isAdvanced': isAdvanced,
      };

  static RoomHabit fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return RoomHabit(
      id: doc.id,
      title: d['title'] as String? ?? '',
      emoji: d['emoji'] as String?,
      colorValue: (d['colorValue'] as num?)?.toInt(),
      createdBy: d['createdBy'] as String? ?? '',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isAdvanced: d['isAdvanced'] as bool? ?? false,
    );
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
  });

  final String uid;
  final String displayName;
  final String? avatarUrl;
  final int value;
  final int target;
  final bool isCompleted;
  final DateTime lastUpdated;

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
        'value': value,
        'target': target,
        'isCompleted': isCompleted,
        'lastUpdated': Timestamp.fromDate(lastUpdated),
      };

  static MemberProgress fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data()!;
    return MemberProgress(
      uid: doc.id,
      displayName: d['displayName'] as String? ?? '',
      avatarUrl: d['avatarUrl'] as String?,
      value: (d['value'] as num?)?.toInt() ?? 0,
      target: (d['target'] as num?)?.toInt() ?? 1,
      isCompleted: d['isCompleted'] as bool? ?? false,
      lastUpdated: (d['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

/// Represents a recorded session of work for a room habit, capturing start/stop times and calculated lost time.
class RoomHabitSession {
  const RoomHabitSession({
    required this.id,
    required this.habitId,
    required this.uid,
    required this.startTime,
    required this.endTime,
    required this.elapsedSeconds,
    required this.reportedValue,
  });

  final String id;
  final String habitId;
  final String uid;
  final DateTime startTime;
  final DateTime endTime;
  final int elapsedSeconds; // The actual world time passed between start and stop
  final int reportedValue; // What the user said they achieved (in minutes or units)

  Map<String, dynamic> toJson() => {
        'habitId': habitId,
        'uid': uid,
        'startTime': Timestamp.fromDate(startTime),
        'endTime': Timestamp.fromDate(endTime),
        'elapsedSeconds': elapsedSeconds,
        'reportedValue': reportedValue,
      };

  static RoomHabitSession fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data()!;
    return RoomHabitSession(
      id: doc.id,
      habitId: d['habitId'] as String? ?? '',
      uid: d['uid'] as String? ?? '',
      startTime: (d['startTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endTime: (d['endTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      elapsedSeconds: (d['elapsedSeconds'] as num?)?.toInt() ?? 0,
      reportedValue: (d['reportedValue'] as num?)?.toInt() ?? 0,
    );
  }
}
