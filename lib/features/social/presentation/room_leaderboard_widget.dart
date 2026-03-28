import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/room_habit_model.dart';

/// Leaderboard widget for a single room habit.
/// Shows members ranked by completion with medals and streak badges.
class RoomLeaderboard extends StatelessWidget {
  const RoomLeaderboard({
    super.key,
    required this.progressList,
    required this.habitColor,
    required this.habitTitle,
  });

  final List<MemberProgress> progressList;
  final Color habitColor;
  final String habitTitle;

  @override
  Widget build(BuildContext context) {
    if (progressList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(14),
        child: Text(
          'Henüz ilerleme yok',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }

    // Sort: completed first, then by completion ratio desc, then streak desc
    final sorted = List<MemberProgress>.from(progressList);
    sorted.sort((a, b) {
      // Completed first
      if (a.isCompleted && !b.isCompleted) return -1;
      if (!a.isCompleted && b.isCompleted) return 1;
      // Then by completion ratio
      final ratioCompare = b.completionRatio.compareTo(a.completionRatio);
      if (ratioCompare != 0) return ratioCompare;
      // Then by streak
      return b.streak.compareTo(a.streak);
    });

    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Column(
        children: List.generate(sorted.length, (index) {
          return _LeaderboardEntry(
            rank: index + 1,
            progress: sorted[index],
            habitColor: habitColor,
            isCurrentUser: sorted[index].uid == currentUid,
            totalMembers: sorted.length,
          );
        }),
      ),
    );
  }
}

class _LeaderboardEntry extends StatelessWidget {
  const _LeaderboardEntry({
    required this.rank,
    required this.progress,
    required this.habitColor,
    required this.isCurrentUser,
    required this.totalMembers,
  });

  final int rank;
  final MemberProgress progress;
  final Color habitColor;
  final bool isCurrentUser;
  final int totalMembers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? theme.colorScheme.primary.withOpacity(isDark ? 0.12 : 0.06)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser
            ? Border.all(
                color: theme.colorScheme.primary.withOpacity(0.2),
                width: 1,
              )
            : null,
      ),
      child: Row(
        children: [
          // Rank badge
          _RankBadge(rank: rank),
          const SizedBox(width: 10),

          // Avatar
          _buildAvatar(theme),
          const SizedBox(width: 10),

          // Name + Streak
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        progress.displayName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight:
                              isCurrentUser ? FontWeight.w700 : FontWeight.w600,
                          color: isCurrentUser
                              ? theme.colorScheme.primary
                              : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 4),
                      Text(
                        '(sen)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          color: theme.colorScheme.primary.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
                if (progress.streak > 0) ...[
                  const SizedBox(height: 2),
                  _StreakBadge(streak: progress.streak),
                ],
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Circular progress
          SizedBox(
            width: 38,
            height: 38,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 38,
                  height: 38,
                  child: CircularProgressIndicator(
                    value: progress.completionRatio,
                    strokeWidth: 3.5,
                    backgroundColor:
                        theme.colorScheme.surfaceContainerHighest,
                    color: progress.isCompleted
                        ? const Color(0xFF22C55E)
                        : habitColor,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  '${progress.completionPercent}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    color: progress.isCompleted
                        ? const Color(0xFF22C55E)
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Value / Target
          SizedBox(
            width: 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${progress.value}/${progress.target}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: progress.isCompleted
                        ? const Color(0xFF22C55E)
                        : theme.colorScheme.onSurface,
                  ),
                ),
                if (progress.isCompleted) ...[
                  const SizedBox(height: 2),
                  const Icon(Icons.check_circle_rounded,
                      size: 14, color: Color(0xFF22C55E)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    final size = 28.0;
    if (progress.avatarUrl != null) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(progress.avatarUrl!),
      );
    }
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: habitColor.withOpacity(0.15),
      child: Text(
        progress.displayName.isNotEmpty
            ? progress.displayName[0].toUpperCase()
            : '?',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: habitColor,
        ),
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});
  final int rank;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (rank <= 3) {
      return SizedBox(
        width: 24,
        child: Text(
          _medal,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );
    }

    return SizedBox(
      width: 24,
      child: Text(
        '$rank',
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  String get _medal {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '$rank';
    }
  }
}

class _StreakBadge extends StatelessWidget {
  const _StreakBadge({required this.streak});
  final int streak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color badgeColor;
    if (streak >= 30) {
      badgeColor = const Color(0xFFFF4500);
    } else if (streak >= 7) {
      badgeColor = const Color(0xFFFF6B35);
    } else {
      badgeColor = const Color(0xFFFFB800);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department_rounded,
              size: 11, color: badgeColor),
          const SizedBox(width: 2),
          Text(
            '$streak gün',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }
}
