import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/room_model.dart';
import '../domain/room_member_model.dart';
import '../domain/room_post_model.dart';
import '../domain/room_habit_model.dart';

/// Firestore-backed repository for social rooms.
class RoomRepository {
  RoomRepository._();
  static final RoomRepository instance = RoomRepository._();

  FirebaseFirestore get _db => FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _roomsRef =>
      _db.collection('rooms');

  // ─── Room CRUD ──────────────────────────────────────────

  /// Create a new room and return its Firestore ID.
  Future<String> createRoom(Room room) async {
    final docRef = await _roomsRef.add(room.toJson());
    // Also add the owner as the first member
    await docRef.collection('members').doc(room.ownerId).set({
      'displayName': room.ownerName,
      'joinedAt': Timestamp.fromDate(room.createdAt),
    });
    return docRef.id;
  }

  /// Find a room by invite code. Returns null if not found.
  Future<Room?> findByInviteCode(String code) async {
    final snap = await _roomsRef
        .where('inviteCode', isEqualTo: code.toUpperCase())
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return Room.fromFirestore(snap.docs.first);
  }

  /// Add a user to an existing room.
  Future<void> joinRoom({
    required String roomId,
    required String uid,
    required String displayName,
    String? avatarUrl,
  }) async {
    final roomRef = _roomsRef.doc(roomId);
    await roomRef.update({
      'memberIds': FieldValue.arrayUnion([uid]),
    });
    await roomRef.collection('members').doc(uid).set({
      'displayName': displayName,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'joinedAt': Timestamp.now(),
    });
  }

  /// Remove a user from a room.
  Future<void> leaveRoom({
    required String roomId,
    required String uid,
  }) async {
    final roomRef = _roomsRef.doc(roomId);
    await roomRef.update({
      'memberIds': FieldValue.arrayRemove([uid]),
    });
    await roomRef.collection('members').doc(uid).delete();
  }

  /// Delete a room (owner only).
  Future<void> deleteRoom(String roomId) async {
    final roomRef = _roomsRef.doc(roomId);
    final members = await roomRef.collection('members').get();
    for (final doc in members.docs) {
      await doc.reference.delete();
    }
    final habits = await roomRef.collection('habits').get();
    for (final doc in habits.docs) {
      final progress = await doc.reference.collection('progress').get();
      for (final p in progress.docs) {
        await p.reference.delete();
      }
      await doc.reference.delete();
    }
    final posts = await roomRef.collection('posts').get();
    for (final doc in posts.docs) {
      await doc.reference.delete();
    }
    await roomRef.delete();
  }

  // ─── Room Streams ───────────────────────────────────────

  /// Stream of rooms where the user is a member.
  Stream<List<Room>> streamMyRooms(String uid) {
    return _roomsRef
        .where('memberIds', arrayContains: uid)
        .snapshots()
        .map((snap) {
      final rooms = snap.docs.map(Room.fromFirestore).toList();
      rooms.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return rooms;
    });
  }

  /// Stream of members in a room.
  Stream<List<RoomMember>> streamRoomMembers(String roomId) {
    return _roomsRef
        .doc(roomId)
        .collection('members')
        .snapshots()
        .map((snap) => snap.docs.map(RoomMember.fromFirestore).toList());
  }

  // ─── Room Habits ────────────────────────────────────────

  /// Add a habit to a room.
  Future<String> addRoomHabit(String roomId, RoomHabit habit) async {
    final docRef = await _roomsRef
        .doc(roomId)
        .collection('habits')
        .add(habit.toJson());
    return docRef.id;
  }

  /// Delete a habit from a room.
  Future<void> deleteRoomHabit(String roomId, String habitId) async {
    final habitRef =
        _roomsRef.doc(roomId).collection('habits').doc(habitId);
    // Delete all progress sub-docs
    final progress = await habitRef.collection('progress').get();
    for (final doc in progress.docs) {
      await doc.reference.delete();
    }
    await habitRef.delete();
  }

  /// Update the title of a room habit.
  Future<void> updateRoomHabitTitle(
      String roomId, String habitId, String newTitle) async {
    await _roomsRef
        .doc(roomId)
        .collection('habits')
        .doc(habitId)
        .update({'title': newTitle});
  }

  /// Update full details of a room habit.
  Future<void> updateRoomHabit(String roomId, String habitId, Map<String, dynamic> data) async {
    await _roomsRef
        .doc(roomId)
        .collection('habits')
        .doc(habitId)
        .update(data);
  }

  // ─── Room Habit Sessions (Analytics) ───────────────────────

  /// Adds a new session record for analytics.
  Future<String> addRoomHabitSession(
      String roomId, RoomHabitSession session) async {
    final docRef = await _roomsRef
        .doc(roomId)
        .collection('sessions')
        .add(session.toJson());
    return docRef.id;
  }

  /// Fetches all sessions for a room within a time range.
  Future<List<RoomHabitSession>> getRoomHabitSessions(
      String roomId, DateTime start, DateTime end) async {
    final snap = await _roomsRef
        .doc(roomId)
        .collection('sessions')
        .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('startTime', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .get();

    return snap.docs.map((d) => RoomHabitSession.fromFirestore(d)).toList();
  }

  // ─── Room Habit Streams ───────────────────────────────────

  /// Stream all habits for a room.
  Stream<List<RoomHabit>> streamRoomHabits(String roomId) {
    return _roomsRef
        .doc(roomId)
        .collection('habits')
        .snapshots()
        .map((snap) {
      final habits = snap.docs.map(RoomHabit.fromFirestore).toList();
      habits.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return habits;
    });
  }

  /// Get a specific member's progress for a habit.
  Future<MemberProgress?> getMemberProgress(
    String roomId,
    String habitId,
    String uid,
  ) async {
    final doc = await _roomsRef
        .doc(roomId)
        .collection('habits')
        .doc(habitId)
        .collection('progress')
        .doc(uid)
        .get();
    if (doc.exists && doc.data() != null) {
      return MemberProgress.fromFirestore(doc);
    }
    return null;
  }

  /// Stream all member progress for a specific room habit.
  Stream<List<MemberProgress>> streamHabitProgress(
    String roomId,
    String habitId,
  ) {
    return _roomsRef
        .doc(roomId)
        .collection('habits')
        .doc(habitId)
        .collection('progress')
        .snapshots()
        .map((snap) =>
            snap.docs.map(MemberProgress.fromFirestore).toList());
  }

  /// Update a member's progress on a room habit.
  Future<void> updateMemberProgress({
    required String roomId,
    required String habitId,
    required String uid,
    required MemberProgress progress,
  }) async {
    await _roomsRef
        .doc(roomId)
        .collection('habits')
        .doc(habitId)
        .collection('progress')
        .doc(uid)
        .set(progress.toJson());
  }

  // ─── Notes (Posts) ──────────────────────────────────────

  /// Stream note posts in a room, newest first.
  Stream<List<RoomPost>> streamRoomPosts(String roomId) {
    return _roomsRef
        .doc(roomId)
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => RoomPost.fromFirestore(d, roomId)).toList());
  }

  /// Add a note post to a room.
  Future<void> addPost(String roomId, RoomPost post) async {
    await _roomsRef.doc(roomId).collection('posts').add(post.toJson());
  }

  /// Delete a note post.
  Future<void> deletePost(String roomId, String postId) async {
    await _roomsRef.doc(roomId).collection('posts').doc(postId).delete();
  }

  /// Get a single room by ID.
  Future<Room?> getRoom(String roomId) async {
    final doc = await _roomsRef.doc(roomId).get();
    if (!doc.exists) return null;
    return Room.fromFirestore(doc);
  }

  /// Fetch all room IDs the user is a member of (one-shot).
  Future<List<String>> getMyRoomIds(String uid) async {
    final snap = await _roomsRef
        .where('memberIds', arrayContains: uid)
        .get();
    return snap.docs.map((d) => d.id).toList();
  }

  /// Fetch all habits for a room (one-shot).
  Future<List<RoomHabit>> getRoomHabits(String roomId) async {
    final snap = await _roomsRef.doc(roomId).collection('habits').get();
    return snap.docs.map(RoomHabit.fromFirestore).toList();
  }
}
