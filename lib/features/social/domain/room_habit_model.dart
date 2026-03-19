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
  });

  final String id;
  final String title;
  final String? emoji;
  final int? colorValue;
  final String createdBy;
  final DateTime createdAt;

  Color get color => colorValue != null ? Color(colorValue!) : const Color(0xFF6366F1);

  Map<String, dynamic> toJson() => {
        'title': title,
        if (emoji != null) 'emoji': emoji,
        if (colorValue != null) 'colorValue': colorValue,
        'createdBy': createdBy,
        'createdAt': Timestamp.fromDate(createdAt),
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
