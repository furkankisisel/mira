import 'package:cloud_firestore/cloud_firestore.dart';

/// A member of a social room.
class RoomMember {
  const RoomMember({
    required this.uid,
    required this.displayName,
    this.avatarUrl,
    required this.joinedAt,
  });

  final String uid;
  final String displayName;
  final String? avatarUrl;
  final DateTime joinedAt;

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'displayName': displayName,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
        'joinedAt': Timestamp.fromDate(joinedAt),
      };

  static RoomMember fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return RoomMember(
      uid: doc.id,
      displayName: d['displayName'] as String? ?? '',
      avatarUrl: d['avatarUrl'] as String?,
      joinedAt: (d['joinedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  static RoomMember fromJson(Map<String, dynamic> json, String uid) =>
      RoomMember(
        uid: uid,
        displayName: json['displayName'] as String? ?? '',
        avatarUrl: json['avatarUrl'] as String?,
        joinedAt: (json['joinedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
}
