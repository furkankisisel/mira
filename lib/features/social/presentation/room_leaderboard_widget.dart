import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/room_habit_model.dart';
import '../data/room_service.dart';
import '../../profile/profile_repository.dart';

/// Leaderboard widget for a single room habit.
/// Shows members ranked by completion with medals and streak badges.
class RoomLeaderboard extends StatelessWidget {
  final List<MemberProgress> progressList;
  final String roomId;
  final Color habitColor;
  final String habitTitle;

  const RoomLeaderboard({
    super.key,
    required this.progressList,
    required this.roomId,
    required this.habitColor,
    required this.habitTitle,
  });

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
      if (a.isCompleted && !b.isCompleted) return -1;
      if (!a.isCompleted && b.isCompleted) return 1;
      final ratioCompare = b.completionRatio.compareTo(a.completionRatio);
      if (ratioCompare != 0) return ratioCompare;
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
            roomId: roomId,
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
    required this.roomId,
    required this.habitColor,
    required this.isCurrentUser,
    required this.totalMembers,
  });

  final int rank;
  final MemberProgress progress;
  final String roomId;
  final Color habitColor;
  final bool isCurrentUser;
  final int totalMembers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Premium background for top 3
    BoxDecoration? decoration;
    if (rank == 1) {
      decoration = BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFFD700).withOpacity(isDark ? 0.3 : 0.2),
            const Color(0xFFFFA500).withOpacity(isDark ? 0.2 : 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );
    } else if (rank == 2) {
      decoration = BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFC0C0C0).withOpacity(isDark ? 0.25 : 0.15),
            const Color(0xFF808080).withOpacity(isDark ? 0.15 : 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC0C0C0).withOpacity(0.4)),
      );
    } else if (rank == 3) {
      decoration = BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFCD7F32).withOpacity(isDark ? 0.22 : 0.12),
            const Color(0xFF8B4513).withOpacity(isDark ? 0.12 : 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCD7F32).withOpacity(0.4)),
      );
    } else {
      decoration = BoxDecoration(
        color: isCurrentUser
            ? theme.colorScheme.primary.withOpacity(isDark ? 0.15 : 0.08)
            : theme.colorScheme.surfaceContainerLow.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCurrentUser
              ? theme.colorScheme.primary.withOpacity(0.3)
              : theme.colorScheme.outlineVariant.withOpacity(0.4),
          width: isCurrentUser ? 1.5 : 1,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 10),
      padding: const EdgeInsets.all(16),
      decoration: decoration,
      child: Row(
        children: [
          // Rank & Avatar
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              _buildAvatar(theme),
              Transform.translate(
                offset: const Offset(6, 6),
                child: _RankBadge(rank: rank),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: ListenableBuilder(
                        listenable: ProfileRepository.instance,
                        builder: (context, _) {
                          final profile = ProfileRepository.instance;
                          final name = isCurrentUser ? (profile.name.isNotEmpty ? profile.name : progress.displayName) : progress.displayName;
                          return Text(
                            name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isCurrentUser ? theme.colorScheme.primary : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'SEN',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (progress.streak > 0) ...[
                      _StreakBadge(streak: progress.streak),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      '${progress.value} / ${progress.target}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Actions & Progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Quick Nudge Button
                  if (!isCurrentUser && !progress.isCompleted)
                    _QuickNudgeButton(
                      roomId: roomId,
                      toUid: progress.uid,
                      toName: progress.displayName,
                    ),
                  
                  const SizedBox(width: 12),

                  // Circular Progress
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: progress.completionRatio,
                          strokeWidth: 4,
                          backgroundColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                          color: progress.isCompleted ? const Color(0xFF22C55E) : habitColor,
                          strokeCap: StrokeCap.round,
                        ),
                        if (progress.isCompleted)
                          const Icon(Icons.check_rounded, size: 20, color: Color(0xFF22C55E))
                        else
                          Text(
                            '${progress.completionPercent}%',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: habitColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    return ListenableBuilder(
      listenable: ProfileRepository.instance,
      builder: (context, _) {
        final profile = ProfileRepository.instance;
        final size = 42.0;

        ImageProvider? image;
        if (isCurrentUser) {
          if (profile.avatarPath != null && profile.avatarPath!.isNotEmpty) {
            image = FileImage(io.File(profile.avatarPath!));
          } else if (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty) {
            image = NetworkImage(profile.avatarUrl!);
          }
        } else {
          if (progress.avatarUrl != null) {
            image = NetworkImage(progress.avatarUrl!);
          }
        }

        final displayName = isCurrentUser ? (profile.name.isNotEmpty ? profile.name : progress.displayName) : progress.displayName;

        return Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: habitColor.withOpacity(0.3), width: 2),
          ),
          child: CircleAvatar(
            radius: size / 2,
            backgroundImage: image,
            backgroundColor: image == null ? habitColor.withOpacity(0.15) : null,
            child: image == null
                ? Text(
                    displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: habitColor,
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}

class _QuickNudgeButton extends StatelessWidget {
  const _QuickNudgeButton({
    required this.roomId,
    required this.toUid,
    required this.toName,
  });
  final String roomId;
  final String toUid;
  final String toName;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await RoomService.instance.sendNudge(
            roomId: roomId,
            toUid: toUid,
            toName: toName,
            message: '👊 Hadi dostum, bugün biraz daha gayret! Alışkanlıklarını tamamla.',
          );
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$toName dürtüldü! 👊'),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B35).withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFF6B35).withOpacity(0.2)),
          ),
          child: const Text('👊', style: TextStyle(fontSize: 18)),
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
      return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          _medal,
          style: const TextStyle(fontSize: 15),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 3,
          ),
        ],
      ),
      child: Text(
        '#$rank',
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w900,
          fontSize: 10,
          color: theme.colorScheme.onSurfaceVariant,
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department_rounded,
              size: 13, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            '$streak gün',
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }
}
