import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../domain/room_model.dart';
import '../domain/room_post_model.dart';
import '../domain/room_member_model.dart';
import '../domain/room_habit_model.dart';
import '../domain/room_progress_models.dart';
import 'room_repository.dart';
import '../../profile/profile_repository.dart';
import '../../habit/domain/habit_model.dart';
import '../../habit/domain/habit_types.dart';

/// Business-logic service for social rooms with real-time reactive sync.
class RoomService extends ChangeNotifier {
  RoomService._() {
    _initAuthListener();
  }
  static final RoomService instance = RoomService._();

  final _repo = RoomRepository.instance;

  StreamSubscription<User?>? _authSub;
  StreamSubscription<List<Room>>? _roomsSub;
  final Map<String, StreamSubscription<List<RoomHabit>>> _habitsSubs = {};
  final Map<String, StreamSubscription<MemberProgress?>> _progressSubs = {};

  List<Room> _myRooms = [];
  final Map<String, List<RoomHabit>> _roomHabitsMap = {}; // roomId -> habits
  final Map<String, MemberProgress> _memberProgressMap =
      {}; // '$roomId:$habitId' -> progress

  List<Habit> _cachedHabits = [];

  List<Habit> get roomHabits => List.unmodifiable(_cachedHabits);

  Habit? findHabitById(String habitId) {
    return _cachedHabits.where((h) => h.id == habitId).firstOrNull;
  }

  RoomHabit? findRoomHabit(String roomId, String habitId) {
    return _roomHabitsMap[roomId]?.where((h) => h.id == habitId).firstOrNull;
  }

  Room? findRoomById(String roomId) {
    return _myRooms.where((r) => r.id == roomId).firstOrNull;
  }

  /// Returns room habits formatted as Habit objects that are valid for [date].
  List<Habit> getRoomHabitsForDate(DateTime date) {
    return _cachedHabits.where((h) {
      try {
        final start = DateTime.parse(h.startDate);
        final dayOnly = DateTime(date.year, date.month, date.day);
        final startOnly = DateTime(start.year, start.month, start.day);
        if (dayOnly.isBefore(startOnly)) return false;

        if (h.endDate != null) {
          final end = DateTime.parse(h.endDate!);
          final endOnly = DateTime(end.year, end.month, end.day);
          if (dayOnly.isAfter(endOnly)) return false;
        }
      } catch (_) {}
      return true;
    }).toList();
  }

  // ─── Helpers ────────────────────────────────────────────

  String? get _currentUid => FirebaseAuth.instance.currentUser?.uid;

  String get _displayName {
    final profile = ProfileRepository.instance;
    if (profile.name.isNotEmpty) return profile.name;
    return FirebaseAuth.instance.currentUser?.displayName ?? 'Kullanıcı';
  }

  String? get _avatarUrl {
    final profile = ProfileRepository.instance;
    return profile.avatarUrl ?? FirebaseAuth.instance.currentUser?.photoURL;
  }

  String _generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rng = Random.secure();
    return List.generate(6, (_) => chars[rng.nextInt(chars.length)]).join();
  }

  void _initAuthListener() {
    _authSub?.cancel();
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _startRoomsSync();
      } else {
        _stopRoomsSync();
      }
    });
  }

  void _stopRoomsSync() {
    _roomsSub?.cancel();
    _roomsSub = null;
    for (final sub in _habitsSubs.values) {
      sub.cancel();
    }
    _habitsSubs.clear();
    for (final sub in _progressSubs.values) {
      sub.cancel();
    }
    _progressSubs.clear();
    _myRooms.clear();
    _roomHabitsMap.clear();
    _memberProgressMap.clear();
    _cachedHabits.clear();
    notifyListeners();
  }

  void _startRoomsSync() {
    final uid = _currentUid;
    if (uid == null) return;

    _roomsSub?.cancel();
    _roomsSub = _repo.streamMyRooms(uid).listen((rooms) {
      _myRooms = rooms;
      final activeRoomIds = rooms.map((r) => r.id).toSet();

      // Cancel and remove rooms user is no longer a member of
      _habitsSubs.keys
          .where((rId) => !activeRoomIds.contains(rId))
          .toList()
          .forEach((rId) {
        _habitsSubs[rId]?.cancel();
        _habitsSubs.remove(rId);
        _roomHabitsMap.remove(rId);
        final prefix = '$rId:';
        _progressSubs.keys
            .where((k) => k.startsWith(prefix))
            .toList()
            .forEach((k) {
          _progressSubs[k]?.cancel();
          _progressSubs.remove(k);
          _memberProgressMap.remove(k);
        });
      });

      // Subscribe to all active rooms
      for (final room in rooms) {
        if (!_habitsSubs.containsKey(room.id)) {
          _habitsSubs[room.id] =
              _repo.streamRoomHabits(room.id).listen((habits) {
            _roomHabitsMap[room.id] = habits;
            final activeHabitIds = habits.map((h) => h.id).toSet();

            // Clean up removed habits' progress subs
            final prefix = '${room.id}:';
            _progressSubs.keys
                .where((k) =>
                    k.startsWith(prefix) &&
                    !activeHabitIds.contains(k.substring(prefix.length)))
                .toList()
                .forEach((k) {
              _progressSubs[k]?.cancel();
              _progressSubs.remove(k);
              _memberProgressMap.remove(k);
            });

            // Listen to current user's progress for each habit
            for (final habit in habits) {
              final progressKey = '${room.id}:${habit.id}';
              if (!_progressSubs.containsKey(progressKey)) {
                _progressSubs[progressKey] = _repo
                    .streamMemberProgress(room.id, habit.id, uid)
                    .listen((prog) {
                  if (prog != null) {
                    _memberProgressMap[progressKey] = prog;
                  } else {
                    _memberProgressMap.remove(progressKey);
                  }
                  _recomputeCachedHabits();
                  notifyListeners();
                });
              }
            }

            _recomputeCachedHabits();
            notifyListeners();
          });
        }
      }

      _recomputeCachedHabits();
      notifyListeners();
    });
  }

  void _recomputeCachedHabits() {
    final list = <Habit>[];
    for (final room in _myRooms) {
      final habits = _roomHabitsMap[room.id] ?? [];
      for (final habit in habits) {
        final progress = _memberProgressMap['${room.id}:${habit.id}'];
        final h = habit.toHabit(
          myProgress: progress,
          roomId: room.id,
          roomName: room.name,
        );
        list.add(h);
      }
    }
    _cachedHabits = list;
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

    final room =
        await _repo.findByInviteCode(inviteCode.toUpperCase().trim());
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

  /// Add a habit to a room from a Habit object with all configurations.
  Future<String> addHabitToRoom(String roomId, Habit habit) async {
    final uid = _currentUid;
    if (uid == null) throw StateError('Giriş yapılmamış');

    final roomHabit = RoomHabit.fromHabit(
      habit,
      createdBy: uid,
      createdAt: DateTime.now(),
    );
    return _repo.addRoomHabit(roomId, roomHabit);
  }

  /// Update full details of a room habit in Firestore.
  Future<void> updateRoomHabitFull(
    String roomId,
    RoomHabit updatedHabit,
  ) async {
    await _repo.updateRoomHabit(
      roomId,
      updatedHabit.id,
      updatedHabit.toJson(),
    );
  }

  /// Delete a room habit (creator only).
  Future<void> deleteRoomHabit(String roomId, String habitId) async {
    await _repo.deleteRoomHabit(roomId, habitId);
  }

  /// Update the title of a room habit (creator only).
  Future<void> updateRoomHabitTitle({
    required String roomId,
    required String habitId,
    required String newTitle,
  }) async {
    await _repo.updateRoomHabitTitle(roomId, habitId, newTitle);
  }

  /// Get all habits for a room.
  Future<List<RoomHabit>> getRoomHabits(String roomId) async {
    return _repo.getRoomHabits(roomId);
  }

  // ─── Room Habit Progress Sync ───────────────────────

  /// Directly toggle or update the current user's progress on a room habit.
  /// Works in real-time inside the social room and Today screen.
  Future<void> updateMyRoomHabitProgress({
    required String roomId,
    required RoomHabit habit,
    bool? isCompleted,
    int? value,
    Duration? timerDuration,
    String? subtaskId,
    bool? subtaskCompleted,
  }) async {
    final uid = _currentUid;
    if (uid == null) return;

    final now = DateTime.now();
    final dayKey =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    MemberProgress? prev;
    try {
      prev = await _repo.getMemberProgress(roomId, habit.id, uid);
    } catch (_) {}

    final target = habit.targetCount > 0 ? habit.targetCount : 1;
    bool newCompleted = isCompleted ?? false;
    int newValue = value ?? (prev?.isToday == true ? prev!.value : 0);
    List<String> completedSubtasks = List<String>.from(
      prev?.isToday == true ? prev!.completedSubtaskIds : [],
    );

    if (timerDuration != null) {
      // Timer habit: add duration in minutes
      int gainedMinutes = timerDuration.inMinutes;
      if (gainedMinutes <= 0 && timerDuration.inSeconds > 0) {
        gainedMinutes = 1;
      }
      newValue = (prev?.isToday == true ? prev!.value : 0) + gainedMinutes;
      newCompleted = newValue >= target;
    } else if (subtaskId != null) {
      // Subtasks habit: toggle subtask
      if (subtaskCompleted == true) {
        if (!completedSubtasks.contains(subtaskId)) {
          completedSubtasks.add(subtaskId);
        }
      } else {
        completedSubtasks.remove(subtaskId);
      }
      final allDone = habit.subtasks.isNotEmpty &&
          habit.subtasks.every((s) => completedSubtasks.contains(s.id));
      newCompleted = allDone;
      newValue = completedSubtasks.length;
    } else if (habit.isNumerical || habit.habitType == HabitType.timer) {
      if (value != null) {
        newValue = value;
        newCompleted = newValue >= target;
      } else if (isCompleted != null) {
        newCompleted = isCompleted;
        newValue = newCompleted ? target : 0;
      }
    } else {
      if (isCompleted != null) {
        newCompleted = isCompleted;
        newValue = newCompleted ? 1 : 0;
      } else {
        final wasCompletedToday = prev?.isCompletedToday ?? false;
        newCompleted = !wasCompletedToday;
        newValue = newCompleted ? 1 : 0;
      }
    }

    int streak = 0;
    if (prev != null) {
      final lastDate = prev.lastUpdated;
      final dayDiff = DateTime(now.year, now.month, now.day)
          .difference(DateTime(lastDate.year, lastDate.month, lastDate.day))
          .inDays;

      if (newCompleted) {
        if (dayDiff == 0) {
          streak = prev.streak > 0 ? prev.streak : 1;
        } else if (dayDiff == 1) {
          streak = prev.streak + 1;
        } else {
          streak = 1;
        }
      } else {
        if (dayDiff == 0) {
          streak = (prev.streak > 1) ? prev.streak - 1 : 0;
        } else {
          streak = 0;
        }
      }
    } else {
      streak = newCompleted ? 1 : 0;
    }

    final progress = MemberProgress(
      uid: uid,
      displayName: _displayName,
      avatarUrl: _avatarUrl,
      value: newValue,
      target: target,
      isCompleted: newCompleted,
      lastUpdated: now,
      streak: streak,
      completedSubtaskIds: completedSubtasks,
    );

    // Optimistically update memory
    final progressKey = '$roomId:${habit.id}';
    _memberProgressMap[progressKey] = progress;
    _recomputeCachedHabits();
    notifyListeners();

    await _repo.updateMemberProgress(
      roomId: roomId,
      habitId: habit.id,
      uid: uid,
      progress: progress,
    );

    try {
      final historyEntry = ProgressHistoryEntry(
        uid: uid,
        date: dayKey,
        value: newValue,
        target: target,
        isCompleted: newCompleted,
      );
      await _repo.saveProgressHistory(
        roomId: roomId,
        habitId: habit.id,
        entry: historyEntry,
      );
    } catch (_) {}
  }

  /// Add timer duration to a room habit (e.g. from Timer screen).
  Future<void> addTimerProgressToRoomHabit(
    String roomId,
    String habitId,
    Duration duration,
  ) async {
    final habit = findRoomHabit(roomId, habitId);
    if (habit == null) return;
    await updateMyRoomHabitProgress(
      roomId: roomId,
      habit: habit,
      timerDuration: duration,
    );
  }

  /// Toggle a subtask for a room habit.
  Future<void> toggleMyRoomHabitSubtask({
    required String roomId,
    required RoomHabit habit,
    required String subtaskId,
    required bool isCompleted,
  }) {
    return updateMyRoomHabitProgress(
      roomId: roomId,
      habit: habit,
      subtaskId: subtaskId,
      subtaskCompleted: isCompleted,
    );
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

  // ─── Progress History ──────────────────────────────────

  Future<List<ProgressHistoryEntry>> getProgressHistory({
    required String roomId,
    required String habitId,
    required String uid,
  }) {
    return _repo.getProgressHistory(
      roomId: roomId,
      habitId: habitId,
      uid: uid,
    );
  }

  Stream<List<ProgressHistoryEntry>> streamProgressHistory({
    required String roomId,
    required String habitId,
    required String uid,
    int limit = 365,
  }) {
    return _repo.streamProgressHistory(
      roomId: roomId,
      habitId: habitId,
      uid: uid,
      limit: limit,
    );
  }

  // ─── Nudges (Dürtme) ───────────────────────────────────

  Future<void> sendNudge({
    required String roomId,
    required String toUid,
    required String toName,
    String message = '',
  }) async {
    final uid = _currentUid;
    if (uid == null) return;

    final nudge = RoomNudge(
      id: '',
      fromUid: uid,
      fromName: _displayName,
      fromAvatarUrl: _avatarUrl,
      toUid: toUid,
      toName: toName,
      message: message.isEmpty
          ? '💪 $_displayName seni dürtüyor! Alışkanlıklarını tamamla!'
          : message,
      createdAt: DateTime.now(),
    );
    await _repo.sendNudge(roomId, nudge);
  }

  Stream<List<RoomNudge>> streamMyNudges(String roomId) {
    final uid = _currentUid;
    if (uid == null) return const Stream.empty();
    return _repo.streamMyNudges(roomId, uid);
  }

  Future<void> markNudgeRead(String roomId, String nudgeId) =>
      _repo.markNudgeRead(roomId, nudgeId);
}
