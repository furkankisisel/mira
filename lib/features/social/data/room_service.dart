import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/room_model.dart';
import '../domain/room_post_model.dart';
import '../domain/room_member_model.dart';
import '../domain/room_habit_model.dart';
import 'room_repository.dart';
import '../../profile/profile_repository.dart';
import '../../habit/domain/habit_repository.dart';
import '../../habit/domain/habit_model.dart';
import '../../habit/domain/habit_types.dart';

/// Business-logic service for social rooms.
class RoomService {
  RoomService._();
  static final RoomService instance = RoomService._();

  final _repo = RoomRepository.instance;

  // ─── Helpers ────────────────────────────────────────────

  String? get _currentUid => FirebaseAuth.instance.currentUser?.uid;

  String get _displayName {
    final profile = ProfileRepository.instance;
    if (profile.name.isNotEmpty) return profile.name;
    return FirebaseAuth.instance.currentUser?.displayName ?? 'Kullanıcı';
  }

  String? get _avatarUrl {
    final profile = ProfileRepository.instance;
    return profile.avatarUrl ??
        FirebaseAuth.instance.currentUser?.photoURL;
  }

  /// Generate a 6-char alphanumeric invite code.
  String _generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rng = Random.secure();
    return List.generate(6, (_) => chars[rng.nextInt(chars.length)]).join();
  }

  // ─── Room Actions ───────────────────────────────────────

  /// Create a new room. Returns the room ID.
  Future<String> createRoom({
    required String name,
    String? emoji,
  }) async {
    final uid = _currentUid;
    if (uid == null) throw StateError('Giriş yapılmamış');

    final code = _generateInviteCode();
    final room = Room(
      id: '',
      name: name.trim(),
      emoji: emoji,
      inviteCode: code,
      ownerId: uid,
      ownerName: _displayName,
      createdAt: DateTime.now(),
      memberIds: [uid],
    );

    return _repo.createRoom(room);
  }

  /// Join a room by invite code. Returns room name on success, null if not found.
  Future<String?> joinRoom(String inviteCode) async {
    final uid = _currentUid;
    if (uid == null) throw StateError('Giriş yapılmamış');

    final room = await _repo.findByInviteCode(inviteCode.toUpperCase().trim());
    if (room == null) return null;

    if (room.memberIds.contains(uid)) return room.name;

    await _repo.joinRoom(
      roomId: room.id,
      uid: uid,
      displayName: _displayName,
      avatarUrl: _avatarUrl,
    );
    return room.name;
  }

  /// Leave a room.
  Future<void> leaveRoom(String roomId) async {
    final uid = _currentUid;
    if (uid == null) return;
    await _repo.leaveRoom(roomId: roomId, uid: uid);
  }

  /// Delete a room (owner only).
  Future<void> deleteRoom(String roomId) async {
    await _repo.deleteRoom(roomId);
  }

  // ─── Room Habits ────────────────────────────────────────

  /// Add a habit to a room from a locally-created Habit object.
  /// The Habit's title, emoji, and color are used to create a RoomHabit.
  Future<String> addHabitToRoom(String roomId, Habit habit) async {
    final uid = _currentUid;
    if (uid == null) throw StateError('Giriş yapılmamış');

    final roomHabit = RoomHabit(
      id: '',
      title: habit.title,
      emoji: habit.emoji,
      colorValue: habit.color.value,
      createdBy: uid,
      createdAt: DateTime.now(),
    );
    return _repo.addRoomHabit(roomId, roomHabit);
  }

  /// Delete a room habit.
  Future<void> deleteRoomHabit(String roomId, String habitId) async {
    await _repo.deleteRoomHabit(roomId, habitId);
  }

  /// Sync the current user's progress for a specific room habit.
  /// Finds the matching local habit by title and syncs its progress.
  Future<void> syncMyProgress(String roomId, RoomHabit roomHabit) async {
    final uid = _currentUid;
    if (uid == null) return;

    // Find matching local habit by title
    final localHabits = HabitRepository.instance.habits;
    final match = localHabits.where((h) => h.title == roomHabit.title).toList();

    int value = 0;
    int target = 1;
    bool isCompleted = false;

    if (match.isNotEmpty) {
      final h = match.first;
      value = h.currentStreak;
      target = h.targetCount;
      isCompleted = h.isCompleted;
    }

    final progress = MemberProgress(
      uid: uid,
      displayName: _displayName,
      avatarUrl: _avatarUrl,
      value: value,
      target: target,
      isCompleted: isCompleted,
      lastUpdated: DateTime.now(),
    );

    await _repo.updateMemberProgress(
      roomId: roomId,
      habitId: roomHabit.id,
      uid: uid,
      progress: progress,
    );
  }

  /// Sync all of the current user's progress across all rooms.
  Future<void> syncAllMyProgress() async {
    final uid = _currentUid;
    if (uid == null) return;

    try {
      final roomIds = await _repo.getMyRoomIds(uid);
      for (final roomId in roomIds) {
        final habits = await _repo.getRoomHabits(roomId);
        for (final habit in habits) {
          await syncMyProgress(roomId, habit);
        }
      }
    } catch (_) {
      // Silently fail — sync is best-effort
    }
  }

  /// Pull all room habits from Firestore and add missing ones to local repo.
  /// This ensures every room member gets the room habits on their Bugün screen.
  Future<void> syncRoomHabitsToLocal() async {
    final uid = _currentUid;
    if (uid == null) return;

    try {
      final localHabits = HabitRepository.instance.habits;
      final localTitles = localHabits.map((h) => h.title).toSet();

      final roomIds = await _repo.getMyRoomIds(uid);
      for (final roomId in roomIds) {
        final roomHabits = await _repo.getRoomHabits(roomId);
        for (final rh in roomHabits) {
          // Skip if a local habit with the same title already exists
          if (localTitles.contains(rh.title)) continue;

          final now = DateTime.now();
          final dayKey =
              '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

          final habit = Habit(
            id: 'room_${rh.id}_${now.millisecondsSinceEpoch}',
            title: rh.title,
            description: '',
            icon: Icons.track_changes,
            emoji: rh.emoji,
            color: rh.color,
            habitType: HabitType.simple,
            targetCount: 1,
            unit: '',
            currentStreak: 0,
            isCompleted: false,
            progressDate: dayKey,
            startDate: dayKey,
            frequency: 'Günlük',
            frequencyType: 'daily',
          );

          await HabitRepository.instance.addHabit(habit);
          localTitles.add(rh.title); // prevent duplicate adds
        }
      }
    } catch (e) {
      debugPrint('syncRoomHabitsToLocal error: $e');
    }
  }

  // ─── Notes ──────────────────────────────────────────────

  /// Share a free-text note to a room.
  Future<void> shareNote(String roomId, String text) async {
    final uid = _currentUid;
    if (uid == null) return;

    final post = RoomPost(
      id: '',
      roomId: roomId,
      authorUid: uid,
      authorName: _displayName,
      authorAvatarUrl: _avatarUrl,
      content: text.trim(),
      createdAt: DateTime.now(),
    );
    await _repo.addPost(roomId, post);
  }

  /// Delete own note.
  Future<void> deletePost(String roomId, String postId) async {
    await _repo.deletePost(roomId, postId);
  }

  // ─── Streams (delegate) ─────────────────────────────────

  Stream<List<Room>> streamMyRooms() {
    final uid = _currentUid;
    if (uid == null) return const Stream.empty();
    return _repo.streamMyRooms(uid);
  }

  Stream<List<RoomMember>> streamMembers(String roomId) =>
      _repo.streamRoomMembers(roomId);

  Stream<List<RoomHabit>> streamRoomHabits(String roomId) =>
      _repo.streamRoomHabits(roomId);

  Stream<List<MemberProgress>> streamHabitProgress(
          String roomId, String habitId) =>
      _repo.streamHabitProgress(roomId, habitId);

  Stream<List<RoomPost>> streamPosts(String roomId) =>
      _repo.streamRoomPosts(roomId);
}
