import '../domain/room_member_model.dart';
import '../domain/room_habit_model.dart';

/// Represents an aggregated competitive score profile for a member in a social room.
class RoomMemberScore {
  final String uid;
  final String displayName;
  final String? avatarUrl;
  final int totalPoints;
  final int completedHabitsCount;
  final int totalHabitsCount;
  final int maxStreak;
  final int rank; // 1-based (1 = Leader)
  final int pointsBehindLeader; // 0 for 1st place
  final int pointsBehindPrevious; // Difference from the person directly ahead

  const RoomMemberScore({
    required this.uid,
    required this.displayName,
    this.avatarUrl,
    required this.totalPoints,
    required this.completedHabitsCount,
    required this.totalHabitsCount,
    required this.maxStreak,
    required this.rank,
    required this.pointsBehindLeader,
    required this.pointsBehindPrevious,
  });

  /// Completion percentage across all room habits.
  double get completionRatio =>
      totalHabitsCount > 0 ? (completedHabitsCount / totalHabitsCount) : 0.0;

  int get completionPercent => (completionRatio * 100).round();

  bool get isLeader => rank == 1;

  String get rankMedal {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '#$rank';
    }
  }

  /// Calculates competitive scores and ranks for all members in a room.
  static List<RoomMemberScore> computeScores({
    required List<RoomMember> members,
    required List<RoomHabit> habits,
    required Map<String, List<MemberProgress>> habitProgressMap,
  }) {
    if (members.isEmpty) return [];

    final rawList = <_RawMemberScore>[];

    for (final member in members) {
      int points = 0;
      int completedCount = 0;
      int memberMaxStreak = 0;

      for (final habit in habits) {
        final progressList = habitProgressMap[habit.id] ?? [];
        final p = progressList.where((item) => item.uid == member.uid).firstOrNull;

        if (p != null) {
          if (p.isCompletedToday) {
            points += 50; // Base completion points
            completedCount++;
          } else if (p.target > 0 && p.todayValue > 0) {
            final ratio = (p.todayValue / p.target).clamp(0.0, 1.0);
            points += (ratio * 25).round(); // Partial progress points
          }

          if (p.streak > memberMaxStreak) {
            memberMaxStreak = p.streak;
          }
        }
      }

      // Streak multiplier bonus (+12 XP per streak day, up to 120 XP)
      points += (memberMaxStreak * 12).clamp(0, 120);

      // Perfect day bonus (+35 XP if all habits completed)
      if (habits.isNotEmpty && completedCount == habits.length) {
        points += 35;
      }

      rawList.add(
        _RawMemberScore(
          uid: member.uid,
          displayName: member.displayName.isNotEmpty ? member.displayName : 'Üye',
          avatarUrl: member.avatarUrl,
          points: points,
          completedCount: completedCount,
          totalHabits: habits.length,
          maxStreak: memberMaxStreak,
        ),
      );
    }

    // Sort: highest points first, then max streak, then completed count
    rawList.sort((a, b) {
      final pCompare = b.points.compareTo(a.points);
      if (pCompare != 0) return pCompare;
      final sCompare = b.maxStreak.compareTo(a.maxStreak);
      if (sCompare != 0) return sCompare;
      return b.completedCount.compareTo(a.completedCount);
    });

    final leaderPoints = rawList.isNotEmpty ? rawList.first.points : 0;
    final results = <RoomMemberScore>[];

    for (int i = 0; i < rawList.length; i++) {
      final curr = rawList[i];
      final rank = i + 1;
      final behindLeader = (leaderPoints - curr.points).clamp(0, 999999);
      final behindPrev = i > 0
          ? (rawList[i - 1].points - curr.points).clamp(0, 999999)
          : 0;

      results.add(
        RoomMemberScore(
          uid: curr.uid,
          displayName: curr.displayName,
          avatarUrl: curr.avatarUrl,
          totalPoints: curr.points,
          completedHabitsCount: curr.completedCount,
          totalHabitsCount: curr.totalHabits,
          maxStreak: curr.maxStreak,
          rank: rank,
          pointsBehindLeader: behindLeader,
          pointsBehindPrevious: behindPrev,
        ),
      );
    }

    return results;
  }
}

class _RawMemberScore {
  final String uid;
  final String displayName;
  final String? avatarUrl;
  final int points;
  final int completedCount;
  final int totalHabits;
  final int maxStreak;

  _RawMemberScore({
    required this.uid,
    required this.displayName,
    this.avatarUrl,
    required this.points,
    required this.completedCount,
    required this.totalHabits,
    required this.maxStreak,
  });
}
