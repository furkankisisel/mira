import 'dart:async';
import 'package:flutter/material.dart';

import '../data/room_service.dart';
import '../domain/room_habit_model.dart';

/// Glassmorphism-styled stats card shown at the top of the room detail screen.
/// Shows today's completion rate, top performer, and overall room streak.
class RoomStatsCard extends StatelessWidget {
  const RoomStatsCard({super.key, required this.roomId});
  final String roomId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RoomHabit>>(
      stream: RoomService.instance.streamRoomHabits(roomId),
      builder: (context, habitsSnap) {
        final habits = habitsSnap.data ?? [];
        if (habits.isEmpty) return const SizedBox.shrink();

        return _StatsContent(roomId: roomId, habits: habits);
      },
    );
  }
}

class _StatsContent extends StatefulWidget {
  const _StatsContent({required this.roomId, required this.habits});
  final String roomId;
  final List<RoomHabit> habits;

  @override
  State<_StatsContent> createState() => _StatsContentState();
}

class _StatsContentState extends State<_StatsContent> {
  final Map<String, List<MemberProgress>> _progressMap = {};
  final List<StreamSubscription> _subs = [];

  @override
  void initState() {
    super.initState();
    _listenProgress();
  }

  @override
  void didUpdateWidget(covariant _StatsContent old) {
    super.didUpdateWidget(old);
    if (old.habits.length != widget.habits.length) {
      _cancelSubs();
      _listenProgress();
    }
  }

  void _listenProgress() {
    for (final h in widget.habits) {
      final sub = RoomService.instance
          .streamHabitProgress(widget.roomId, h.id)
          .listen((list) {
        if (mounted) setState(() => _progressMap[h.id] = list);
      });
      _subs.add(sub);
    }
  }

  void _cancelSubs() {
    for (final s in _subs) {
      s.cancel();
    }
    _subs.clear();
  }

  @override
  void dispose() {
    _cancelSubs();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Calculate stats
    int totalCompletions = 0;
    int totalPossible = 0;
    String topPerformer = '';
    int topCompletions = 0;
    int maxStreak = 0;
    String streakHolder = '';
    final Map<String, int> memberCompletions = {};

    for (final h in widget.habits) {
      final progress = _progressMap[h.id] ?? [];
      for (final p in progress) {
        totalPossible++;
        if (p.isCompleted) {
          totalCompletions++;
          memberCompletions[p.displayName] =
              (memberCompletions[p.displayName] ?? 0) + 1;
        }
        if (p.streak > maxStreak) {
          maxStreak = p.streak;
          streakHolder = p.displayName;
        }
      }
    }

    // Find top performer
    memberCompletions.forEach((name, count) {
      if (count > topCompletions) {
        topCompletions = count;
        topPerformer = name;
      }
    });

    final completionRate = totalPossible > 0
        ? ((totalCompletions / totalPossible) * 100).round()
        : 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    theme.colorScheme.primary.withOpacity(0.15),
                    theme.colorScheme.tertiary.withOpacity(0.10),
                  ]
                : [
                    theme.colorScheme.primary.withOpacity(0.08),
                    theme.colorScheme.tertiary.withOpacity(0.06),
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(isDark ? 0.2 : 0.12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.insights_rounded,
                      size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 6),
                  Text(
                    'Oda Özeti',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _StatTile(
                    icon: Icons.check_circle_outline_rounded,
                    label: 'Tamamlama',
                    value: '%$completionRate',
                    color: _completionColor(completionRate),
                  ),
                  const SizedBox(width: 12),
                  _StatTile(
                    icon: Icons.local_fire_department_rounded,
                    label: 'En Uzun Seri',
                    value: '$maxStreak gün',
                    subtitle: streakHolder.isNotEmpty ? streakHolder : null,
                    color: const Color(0xFFFF6B35),
                  ),
                  const SizedBox(width: 12),
                  _StatTile(
                    icon: Icons.emoji_events_rounded,
                    label: 'En Aktif',
                    value: topPerformer.isNotEmpty ? topPerformer : '—',
                    subtitle: topPerformer.isNotEmpty
                        ? '$topCompletions/${widget.habits.length}'
                        : null,
                    color: const Color(0xFFFFB800),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _completionColor(int rate) {
    if (rate >= 80) return const Color(0xFF22C55E);
    if (rate >= 50) return const Color(0xFFFFB800);
    return const Color(0xFFEF4444);
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: color,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
