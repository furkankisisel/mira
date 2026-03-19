import 'package:cloud_firestore/cloud_firestore.dart';

/// A social room where members track shared goals.
class Room {
  const Room({
    required this.id,
    required this.name,
    this.emoji,
    required this.inviteCode,
    required this.ownerId,
    required this.ownerName,
    required this.createdAt,
    required this.memberIds,
  });

  final String id;
  final String name;
  final String? emoji;
  final String inviteCode;
  final String ownerId;
  final String ownerName;
  final DateTime createdAt;
  final List<String> memberIds;

  int get memberCount => memberIds.length;

  Map<String, dynamic> toJson() => {
        'name': name,
        'emoji': emoji,
        'inviteCode': inviteCode,
        'ownerId': ownerId,
        'ownerName': ownerName,
        'createdAt': Timestamp.fromDate(createdAt),
        'memberIds': memberIds,
      };

  static Room fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Room(
      id: doc.id,
      name: d['name'] as String? ?? '',
      emoji: d['emoji'] as String?,
      inviteCode: d['inviteCode'] as String? ?? '',
      ownerId: d['ownerId'] as String? ?? '',
      ownerName: d['ownerName'] as String? ?? '',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      memberIds: List<String>.from(d['memberIds'] ?? []),
    );
  }
}
