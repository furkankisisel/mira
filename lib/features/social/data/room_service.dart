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
import '../../notifications/services/notification_service.dart';

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
  final Map<String, StreamSubscription<List<MemberProgress>>> _progressSubs = {};
  final Map<String, StreamSubscription<List<RoomPost>>> _postsSubs = {};
  final Map<String, StreamSubscription<List<RoomNudge>>> _nudgesSubs = {};
  final Set<String> _initializedPostRooms = {};
  final Set<String> _knownPostIds = {};
  final Set<String> _initializedNudgeRooms = {};
  final Set<String> _knownNudgeIds = {};
  final Map<String, Map<String, int>> _lastKnownMemberValues = {};
  final Map<String, Map<String, bool>> _lastKnownMemberCompleted = {};
  final Set<String> _initializedHabitsForNotifications = {};

  List<Room> _myRooms = [];
  final Map<String, List<RoomHabit>> _roomHabitsMap = {}; // roomId -> habits
  final Map<String, MemberProgress> _memberProgressMap =
      {}; // '$roomId:$habitId' -> progress of current user
  final Map<String, int> _roomHabitLeftoverSeconds =
      {}; // '$roomId:$habitId' -> leftover seconds not yet completing a minute
  final Map<String, List<MemberProgress>> _allHabitProgressMap =
      {}; // '$roomId:$habitId' -> list of all members' progress

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

  /// Get cached current user's progress for a habit directly from memory (0 ms).
  MemberProgress? getMemberProgressInMemory(String roomId, String habitId) {
    return _memberProgressMap['$roomId:$habitId'];
  }

  /// Get cached all members' progress for a habit directly from memory (0 ms).
  List<MemberProgress> getHabitProgressInMemory(String roomId, String habitId) {
    return _allHabitProgressMap['$roomId:$habitId'] ?? const [];
  }

  /// Returns room habits formatted as Habit objects that are valid for [date].
  List<Habit> getRoomHabitsForDate(DateTime date) {
    final dayOnly = DateTime(date.year, date.month, date.day);
    final list = <Habit>[];
    for (final room in _myRooms) {
      final habits = _roomHabitsMap[room.id] ?? [];
      for (final habit in habits) {
        if (!habit.isScheduledForDate(dayOnly)) continue;
        final progress = _memberProgressMap['${room.id}:${habit.id}'];
        final h = habit.toHabit(
          myProgress: progress,
          roomId: room.id,
          roomName: room.name,
          date: date,
        );
        list.add(h);
      }
    }
    return list;
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
    if (_currentUid != null) {
      _startRoomsSync();
    }
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
    for (final sub in _postsSubs.values) {
      sub.cancel();
    }
    _postsSubs.clear();
    _initializedPostRooms.clear();
    _knownPostIds.clear();
    for (final sub in _nudgesSubs.values) {
      sub.cancel();
    }
    _nudgesSubs.clear();
    _initializedNudgeRooms.clear();
    _knownNudgeIds.clear();
    _lastKnownMemberValues.clear();
    _lastKnownMemberCompleted.clear();
    _initializedHabitsForNotifications.clear();
    _myRooms.clear();
    _roomHabitsMap.clear();
    _memberProgressMap.clear();
    _roomHabitLeftoverSeconds.clear();
    _allHabitProgressMap.clear();
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
        _postsSubs[rId]?.cancel();
        _postsSubs.remove(rId);
        _initializedPostRooms.remove(rId);
        _nudgesSubs[rId]?.cancel();
        _nudgesSubs.remove(rId);
        _initializedNudgeRooms.remove(rId);
        final prefix = '$rId:';
        _progressSubs.keys
            .where((k) => k.startsWith(prefix))
            .toList()
            .forEach((k) {
          _progressSubs[k]?.cancel();
          _progressSubs.remove(k);
          _memberProgressMap.remove(k);
          _allHabitProgressMap.remove(k);
        });
      });

      // Subscribe to all active rooms
      for (final room in rooms) {
        // Subscribe to room posts for realtime notifications
        if (!_postsSubs.containsKey(room.id)) {
          _postsSubs[room.id] = _repo.streamRoomPosts(room.id).listen((posts) {
            final isFirstLoad = !_initializedPostRooms.contains(room.id);
            if (isFirstLoad) {
              for (final p in posts) {
                _knownPostIds.add(p.id);
              }
              _initializedPostRooms.add(room.id);
              return;
            }

            for (final post in posts) {
              if (!_knownPostIds.contains(post.id)) {
                _knownPostIds.add(post.id);
                // Only notify if post is from another member and recent (< 10 mins)
                if (post.authorUid != uid) {
                  final diff = DateTime.now().difference(post.createdAt).abs();
                  if (diff.inMinutes < 120) {
                    final notifId = post.id.hashCode.abs() % 2147483647;
                    final currentRoomName =
                        findRoomById(room.id)?.name ?? room.name;
                    NotificationService.instance.showSocialNotification(
                      id: notifId,
                      title: '📝 ${post.authorName} • $currentRoomName',
                      body: post.content,
                      payload: 'room:${room.id}',
                      subText: 'Mira • $currentRoomName Notu',
                    );
                  }
                }
              }
            }
          }, onError: (_) {});
        }

        // Subscribe to nudges sent to current user in this room
        if (!_nudgesSubs.containsKey(room.id)) {
          _nudgesSubs[room.id] =
              _repo.streamMyNudges(room.id, uid).listen((nudges) {
            final isFirstLoad = !_initializedNudgeRooms.contains(room.id);
            if (isFirstLoad) {
              for (final n in nudges) {
                _knownNudgeIds.add(n.id);
              }
              _initializedNudgeRooms.add(room.id);
              return;
            }

            for (final nudge in nudges) {
              if (!_knownNudgeIds.contains(nudge.id)) {
                _knownNudgeIds.add(nudge.id);
                // Only notify if sent by someone else, unread, and recent (< 10 mins)
                if (nudge.fromUid != uid && !nudge.isRead) {
                  final diff = DateTime.now().difference(nudge.createdAt).abs();
                  if (diff.inMinutes < 120) {
                    final notifId = nudge.id.hashCode.abs() % 2147483647;
                    final currentRoomName =
                        findRoomById(room.id)?.name ?? room.name;
                    NotificationService.instance.showSocialNotification(
                      id: notifId,
                      title: '👊 ${nudge.fromName} seni dürtüyor!',
                      body: '$currentRoomName: ${nudge.message}',
                      payload: 'room:${room.id}',
                      subText: 'Mira • $currentRoomName Dürtme',
                    );
                  }
                }
              }
            }
          }, onError: (_) {});
        }

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
              _allHabitProgressMap.remove(k);
            });

            // Listen to all members' progress for each habit
            for (final habit in habits) {
              final progressKey = '${room.id}:${habit.id}';
              if (!_progressSubs.containsKey(progressKey)) {
                _progressSubs[progressKey] = _repo
                    .streamHabitProgress(room.id, habit.id)
                    .listen((allProgress) {
                  _allHabitProgressMap[progressKey] = allProgress;
                  final myProg =
                      allProgress.where((p) => p.uid == uid).firstOrNull;
                  if (myProg != null) {
                    _memberProgressMap[progressKey] = myProg;
                  } else {
                    _memberProgressMap.remove(progressKey);
                  }

                  // Competitive Progress Notifications
                  final isFirstProgressLoad =
                      !_initializedHabitsForNotifications.contains(progressKey);
                  if (isFirstProgressLoad) {
                    final values = <String, int>{};
                    final completed = <String, bool>{};
                    for (final p in allProgress) {
                      values[p.uid] = p.todayValue;
                      completed[p.uid] = p.isCompletedToday;
                    }
                    _lastKnownMemberValues[progressKey] = values;
                    _lastKnownMemberCompleted[progressKey] = completed;
                    _initializedHabitsForNotifications.add(progressKey);
                  } else {
                    final prevValues =
                        _lastKnownMemberValues[progressKey] ??= {};
                    final prevCompletedMap =
                        _lastKnownMemberCompleted[progressKey] ??= {};

                    for (final p in allProgress) {
                      if (p.uid == uid) continue; // Don't notify self

                      final prevComp = prevCompletedMap[p.uid] ?? false;
                      final prevVal = prevValues[p.uid] ?? 0;
                      final nowComp = p.isCompletedToday;
                      final nowVal = p.todayValue;
                      final memberName = p.displayName.isNotEmpty
                          ? p.displayName
                          : 'Bir üye';
                      final currentRoomName =
                          findRoomById(room.id)?.name ?? room.name;

                      // Completed habit
                      if (!prevComp && nowComp) {
                        final notifId =
                            ('comp_${room.id}_${habit.id}_${p.uid}_${DateTime.now().minute}')
                                    .hashCode
                                    .abs() %
                                2147483647;
                        NotificationService.instance.showSocialNotification(
                          id: notifId,
                          title: '🏆 $memberName hedefini tamamladı!',
                          body:
                              '$currentRoomName odasında "${habit.title}" görevini bitirdi! Sıralamayı kaptırma, sen de yap! 🔥',
                          payload: 'room:${room.id}',
                          subText: 'Mira • $currentRoomName Rekabeti',
                        );
                      }
                      // Progress step in numerical/timer habit
                      else if (nowVal > prevVal && !nowComp) {
                        final diff = nowVal - prevVal;
                        final unit = (habit.unit != null && habit.unit!.isNotEmpty)
                            ? ' ${habit.unit}'
                            : '';
                        final notifId =
                            ('prog_${room.id}_${habit.id}_${p.uid}_${DateTime.now().minute}')
                                    .hashCode
                                    .abs() %
                                2147483647;
                        NotificationService.instance.showSocialNotification(
                          id: notifId,
                          title: '⚡ $memberName hız kesmiyor!',
                          body:
                              '$currentRoomName odasında "${habit.title}" için +$diff$unit ilerledi ($nowVal/${habit.targetCount}). Rekabete katıl! 🚀',
                          payload: 'room:${room.id}',
                          subText: 'Mira • $currentRoomName Rekabeti',
                        );
                      }

                      prevValues[p.uid] = nowVal;
                      prevCompletedMap[p.uid] = nowComp;
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
  /// Strictly preserves existing startDate and endDate (dates can only be set at creation),
  /// as well as createdBy and createdAt.
  Future<void> updateRoomHabitFull(
    String roomId,
    RoomHabit updatedHabit,
  ) async {
    final existingHabit = await _repo.getRoomHabit(roomId, updatedHabit.id);
    final habitData = updatedHabit.toJson();
    if (existingHabit != null) {
      habitData['startDate'] = existingHabit.startDate;
      habitData['endDate'] = existingHabit.endDate;
      habitData['createdBy'] = existingHabit.createdBy;
      habitData['createdAt'] = existingHabit.createdAt.toIso8601String();
    } else {
      habitData.remove('startDate');
      habitData.remove('endDate');
    }

    await _repo.updateRoomHabit(
      roomId,
      updatedHabit.id,
      habitData,
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

  /// Helper to evaluate completion based on room habit target types
  bool _evaluateRoomHabitCompletion(
    RoomHabit habit,
    int progress,
    List<String> completedSubtaskIds,
  ) {
    switch (habit.habitType) {
      case HabitType.simple:
      case HabitType.checkbox:
        return progress >= habit.targetCount;
      case HabitType.subtasks:
        return habit.subtasks.isNotEmpty &&
            habit.subtasks.every((s) => completedSubtaskIds.contains(s.id));
      case HabitType.numerical:
        switch (habit.numericalTargetType) {
          case NumericalTargetType.minimum:
            return progress >= habit.targetCount;
          case NumericalTargetType.exact:
            return progress == habit.targetCount;
          case NumericalTargetType.maximum:
            return progress <= habit.targetCount && progress > 0;
        }
      case HabitType.timer:
        switch (habit.timerTargetType) {
          case TimerTargetType.minimum:
            return progress >= habit.targetCount;
          case TimerTargetType.exact:
            return progress == habit.targetCount;
          case TimerTargetType.maximum:
            return progress <= habit.targetCount && progress > 0;
        }
    }
  }

  /// Directly toggle or update the current user's progress on a room habit.
  /// Works in real-time inside the social room and Today screen with 0 ms UI latency.
  Future<void> updateMyRoomHabitProgress({
    required String roomId,
    RoomHabit? habit,
    String? habitId,
    bool? isCompleted,
    int? value,
    Duration? timerDuration,
    String? subtaskId,
    bool? subtaskCompleted,
    DateTime? date,
  }) async {
    final uid = _currentUid;
    if (uid == null) return;

    final targetHabitId = habit?.id ?? habitId;
    if (targetHabitId == null) return;

    final actualHabit = findRoomHabit(roomId, targetHabitId) ?? habit;
    if (actualHabit == null) return;

    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final targetDate = date ?? now;
    final targetDayOnly =
        DateTime(targetDate.year, targetDate.month, targetDate.day);

    // Defense-in-depth: Never allow recording progress for future dates!
    if (targetDayOnly.isAfter(todayDate)) {
      debugPrint('[RoomService] Blocked attempt to update progress for future date: $targetDate');
      return;
    }

    final isToday = targetDayOnly == todayDate;
    final dayKey =
        '${targetDayOnly.year}-${targetDayOnly.month.toString().padLeft(2, '0')}-${targetDayOnly.day.toString().padLeft(2, '0')}';

    final progressKey = '$roomId:${actualHabit.id}';
    final prev = _memberProgressMap[progressKey];

    final target = actualHabit.targetCount > 0 ? actualHabit.targetCount : 1;
    bool newCompleted = isCompleted ?? false;
    int newValue = value ?? (prev?.isToday == true ? prev!.value : 0);
    List<String> completedSubtasks = List<String>.from(
      prev?.isToday == true ? prev!.completedSubtaskIds : [],
    );

    if (timerDuration != null) {
      final isSecondsUnit = actualHabit.unit != null &&
          (actualHabit.unit!.toLowerCase() == 'sn' ||
              actualHabit.unit!.toLowerCase() == 'saniye' ||
              actualHabit.unit!.toLowerCase() == 'sec' ||
              actualHabit.unit!.toLowerCase() == 'seconds');

      if (isSecondsUnit) {
        newValue = (prev?.isToday == true ? prev!.value : 0) + timerDuration.inSeconds;
        newCompleted = _evaluateRoomHabitCompletion(actualHabit, newValue, completedSubtasks);
      } else {
        // Timer habit: accumulate seconds accurately into minutes without falsely rounding up
        final totalSeconds = (_roomHabitLeftoverSeconds[progressKey] ?? 0) + timerDuration.inSeconds;
        final gainedMinutes = totalSeconds ~/ 60;
        _roomHabitLeftoverSeconds[progressKey] = totalSeconds % 60;

        newValue = (prev?.isToday == true ? prev!.value : 0) + gainedMinutes;
        newCompleted = _evaluateRoomHabitCompletion(actualHabit, newValue, completedSubtasks);
      }
    } else if (subtaskId != null) {
      // Subtasks habit: toggle subtask
      if (subtaskCompleted == true) {
        if (!completedSubtasks.contains(subtaskId)) {
          completedSubtasks.add(subtaskId);
        }
      } else {
        completedSubtasks.remove(subtaskId);
      }
      newValue = completedSubtasks.length;
      newCompleted = actualHabit.subtasks.isNotEmpty &&
          actualHabit.subtasks.every((s) => completedSubtasks.contains(s.id));
    } else if (actualHabit.isNumerical || actualHabit.habitType == HabitType.timer) {
      if (value != null) {
        newValue = value;
        newCompleted = _evaluateRoomHabitCompletion(actualHabit, newValue, completedSubtasks);
      } else if (isCompleted != null) {
        newCompleted = isCompleted;
        newValue = newCompleted ? target : 0;
      }
    } else {
      if (isCompleted != null) {
        newCompleted = isCompleted;
        newValue = newCompleted ? target : 0;
      } else {
        final wasCompletedToday = prev?.isCompletedToday ?? false;
        newCompleted = !wasCompletedToday;
        newValue = newCompleted ? target : 0;
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

    if (isToday) {
      // 1. Optimistically update local memory immediately (0 ms UI response)
      _memberProgressMap[progressKey] = progress;
      final currentList =
          List<MemberProgress>.from(_allHabitProgressMap[progressKey] ?? []);
      final idx = currentList.indexWhere((p) => p.uid == uid);
      if (idx != -1) {
        currentList[idx] = progress;
      } else {
        currentList.add(progress);
      }
      _allHabitProgressMap[progressKey] = currentList;

      _recomputeCachedHabits();
      notifyListeners();

      // 2. Persist to Firestore in the background
      _repo.updateMemberProgress(
        roomId: roomId,
        habitId: actualHabit.id,
        uid: uid,
        progress: progress,
      );
    }

    try {
      final historyEntry = ProgressHistoryEntry(
        uid: uid,
        date: dayKey,
        value: newValue,
        target: target,
        isCompleted: newCompleted,
        completedSubtaskIds: completedSubtasks,
      );
      _repo.saveProgressHistory(
        roomId: roomId,
        habitId: actualHabit.id,
        entry: historyEntry,
      );
    } catch (_) {}
  }

  /// Add timer duration to a room habit (e.g. from Timer screen).
  Future<void> addTimerProgressToRoomHabit(
    String roomId,
    String habitId,
    Duration duration, {
    DateTime? date,
  }) async {
    final habit = findRoomHabit(roomId, habitId);
    await updateMyRoomHabitProgress(
      roomId: roomId,
      habit: habit,
      habitId: habitId,
      timerDuration: duration,
      date: date,
    );
  }

  /// Toggle a subtask for a room habit.
  Future<void> toggleMyRoomHabitSubtask({
    required String roomId,
    RoomHabit? habit,
    String? habitId,
    required String subtaskId,
    required bool isCompleted,
    DateTime? date,
  }) {
    return updateMyRoomHabitProgress(
      roomId: roomId,
      habit: habit,
      habitId: habitId,
      subtaskId: subtaskId,
      subtaskCompleted: isCompleted,
      date: date,
    );
  }

  /// Stream of progress history for all members on a habit for a specific date.
  Stream<List<ProgressHistoryEntry>> streamHabitProgressHistoryForDate({
    required String roomId,
    required String habitId,
    required String date,
  }) =>
      _repo.streamHabitProgressHistoryForDate(
        roomId: roomId,
        habitId: habitId,
        date: date,
      );

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
