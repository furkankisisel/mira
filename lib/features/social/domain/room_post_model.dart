import 'package:cloud_firestore/cloud_firestore.dart';

/// A note post shared in a social room feed.
class RoomPost {
  const RoomPost({
    required this.id,
    required this.roomId,
    required this.authorUid,
    required this.authorName,
    this.authorAvatarUrl,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String roomId;
  final String authorUid;
  final String authorName;
  final String? authorAvatarUrl;
  final String content;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'authorUid': authorUid,
        'authorName': authorName,
        if (authorAvatarUrl != null) 'authorAvatarUrl': authorAvatarUrl,
        'content': content,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  static RoomPost fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    String roomId,
  ) {
    final d = doc.data()!;
    return RoomPost(
      id: doc.id,
      roomId: roomId,
      authorUid: d['authorUid'] as String? ?? '',
      authorName: d['authorName'] as String? ?? '',
      authorAvatarUrl: d['authorAvatarUrl'] as String?,
      content: d['content'] as String? ?? '',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
