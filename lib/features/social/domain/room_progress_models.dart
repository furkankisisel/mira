import 'package:cloud_firestore/cloud_firestore.dart';

/// Daily progress snapshot for a member on a room habit.
/// Stored in: rooms/{roomId}/habits/{habitId}/progressHistory/{date}_{uid}
class ProgressHistoryEntry {
  const ProgressHistoryEntry({
    required this.uid,
    required this.date,
    required this.value,
    required this.target,
    required this.isCompleted,
  });

  final String uid;
  final String date; // 'YYYY-MM-DD'
  final int value;
  final int target;
  final bool isCompleted;

  /// Completion ratio (0.0 – 1.0).
  double get completionRatio =>
      target > 0 ? (value / target).clamp(0.0, 1.0) : 0.0;

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'date': date,
        'value': value,
        'target': target,
        'isCompleted': isCompleted,
      };

  static ProgressHistoryEntry fromMap(Map<String, dynamic> d) {
    return ProgressHistoryEntry(
      uid: d['uid'] as String? ?? '',
      date: d['date'] as String? ?? '',
      value: (d['value'] as num?)?.toInt() ?? 0,
      target: (d['target'] as num?)?.toInt() ?? 1,
      isCompleted: d['isCompleted'] as bool? ?? false,
    );
  }
}

/// A nudge (dürtme) sent between room members.
/// Stored in: rooms/{roomId}/nudges/{docId}
class RoomNudge {
  const RoomNudge({
    required this.id,
    required this.fromUid,
    required this.fromName,
    this.fromAvatarUrl,
    required this.toUid,
    required this.toName,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  final String id;
  final String fromUid;
  final String fromName;
  final String? fromAvatarUrl;
  final String toUid;
  final String toName;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  Map<String, dynamic> toJson() => {
        'fromUid': fromUid,
        'fromName': fromName,
        if (fromAvatarUrl != null) 'fromAvatarUrl': fromAvatarUrl,
        'toUid': toUid,
        'toName': toName,
        'message': message,
        'createdAt': Timestamp.fromDate(createdAt),
        'isRead': isRead,
      };

  static RoomNudge fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data()!;
    return RoomNudge(
      id: doc.id,
      fromUid: d['fromUid'] as String? ?? '',
      fromName: d['fromName'] as String? ?? '',
      fromAvatarUrl: d['fromAvatarUrl'] as String?,
      toUid: d['toUid'] as String? ?? '',
      toName: d['toName'] as String? ?? '',
      message: d['message'] as String? ?? '',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: d['isRead'] as bool? ?? false,
    );
  }
}
