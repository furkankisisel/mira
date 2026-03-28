import 'dart:async';
import 'package:flutter/material.dart';

import '../data/room_service.dart';
import '../domain/room_habit_model.dart';
import '../../../design_system/tokens/colors.dart';
import '../../../l10n/app_localizations.dart';

/// Mira-themed Room Stats Card with soft, organic, and "Cotton" style aesthetic.
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

    memberCompletions.forEach((name, count) {
      if (count > topCompletions) {
        topCompletions = count;
        topPerformer = name;
      }
    });

    final completionRatio = totalPossible > 0 ? (totalCompletions / totalPossible) : 0.0;
    final completionPercent = (completionRatio * 100).round();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Soft "Cotton" Background
          Container(
            height: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: isDark ? theme.colorScheme.surfaceContainer : AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : theme.colorScheme.primary).withOpacity(0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          ),

          // Content Layer
          Container(
            height: 170,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.6),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Completion Ring (Main Focus)
                _CompletionDisplay(
                  percent: completionPercent,
                  isDark: isDark,
                  primaryColor: theme.colorScheme.primary,
                ),

                const SizedBox(width: 24),

                // Stats Details
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _MiraStatTile(
                        icon: Icons.local_fire_department_rounded,
                        label: AppLocalizations.of(context).longestStreakLabel,
                        value: AppLocalizations.of(context).streakDays(maxStreak),
                        subtitle: streakHolder,
                        accentColor: AppColors.accentGold,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                      _MiraStatTile(
                        icon: Icons.emoji_events_rounded,
                        label: AppLocalizations.of(context).mostActiveMemberLabel,
                        value: topPerformer.isNotEmpty ? topPerformer : '—',
                        subtitle: topPerformer.isNotEmpty ? AppLocalizations.of(context).completionsCount(topCompletions) : null,
                        accentColor: AppColors.accentMatcha,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionDisplay extends StatelessWidget {
  const _CompletionDisplay({
    required this.percent,
    required this.isDark,
    required this.primaryColor,
  });

  final int percent;
  final bool isDark;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: percent / 100,
                strokeWidth: 8,
                backgroundColor: (isDark ? Colors.white : Colors.black).withOpacity(0.04),
                color: isDark ? AppColors.accentMatcha : primaryColor,
                strokeCap: StrokeCap.round,
              ),
            ),
            Text(
              '%$percent',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          AppLocalizations.of(context).roomSummaryHeader,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: (isDark ? Colors.white : primaryColor).withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

class _MiraStatTile extends StatelessWidget {
  const _MiraStatTile({
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
    required this.accentColor,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final Color accentColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = isDark ? Colors.white : Colors.black;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(isDark ? 0.12 : 0.18),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, size: 18, color: isDark ? accentColor : accentColor.withOpacity(0.9)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  height: 1.1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: surfaceColor.withOpacity(0.5),
                ),
              ),
              if (subtitle != null) ...[
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: accentColor.withOpacity(isDark ? 0.8 : 1),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
