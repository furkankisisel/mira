import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/room_service.dart';
import '../domain/room_habit_model.dart';
import '../domain/room_member_model.dart';
import '../domain/room_progress_models.dart';
import '../../profile/profile_repository.dart';
import '../../../l10n/app_localizations.dart';

/// Full-screen profile view showing a member's progress across all room habits.
/// Includes weekly/monthly/yearly bar charts and a nudge button.
class MemberProfileScreen extends StatefulWidget {
  const MemberProfileScreen({
    super.key,
    required this.roomId,
    required this.member,
  });

  final String roomId;
  final RoomMember member;

  @override
  State<MemberProfileScreen> createState() => _MemberProfileScreenState();
}

class _MemberProfileScreenState extends State<MemberProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;
  List<RoomHabit> _habits = [];
  bool _loading = true;
  String? _selectedHabitId;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    try {
      final habits = await RoomService.instance.getRoomHabits(widget.roomId);
      if (mounted) {
        setState(() {
          _habits = habits;
          _selectedHabitId = habits.isNotEmpty ? habits.first.id : null;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  bool get _isCurrentUser =>
      FirebaseAuth.instance.currentUser?.uid == widget.member.uid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.member.displayName),
        actions: [
          if (!_isCurrentUser)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilledButton.tonalIcon(
                icon: const Icon(Icons.notifications_active_outlined, size: 18),
                label: Text(AppLocalizations.of(context).nudgeButtonLabel),
                onPressed: () => _sendNudge(context),
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                children: [
                  // Profile header
                  _ProfileHeader(
                    member: widget.member,
                    isCurrentUser: _isCurrentUser,
                  ),

                  const Divider(height: 32),

                  // Habit selector
                  if (_habits.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(Icons.track_changes,
                              size: 18, color: theme.colorScheme.primary),
                          const SizedBox(width: 6),
                          Text(
                            AppLocalizations.of(context).selectHabitLabel,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 42,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: _habits.length,
                        itemBuilder: (ctx, i) {
                          final h = _habits[i];
                          final selected = h.id == _selectedHabitId;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              avatar: Text(h.emoji ?? '🎯',
                                  style: const TextStyle(fontSize: 14)),
                              label: Text(h.title),
                              selected: selected,
                              onSelected: (_) =>
                                  setState(() => _selectedHabitId = h.id),
                              selectedColor: h.color.withOpacity(0.15),
                              labelStyle: TextStyle(
                                fontWeight:
                                    selected ? FontWeight.w700 : FontWeight.w500,
                                fontSize: 12,
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Tab bar
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? theme.colorScheme.surfaceContainerHighest
                                .withOpacity(0.5)
                            : theme.colorScheme.surfaceContainerHighest
                                .withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        controller: _tabCtrl,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: theme.colorScheme.primary,
                        ),
                        labelColor: theme.colorScheme.onPrimary,
                        unselectedLabelColor:
                            theme.colorScheme.onSurfaceVariant,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        tabs: [
                          Tab(text: AppLocalizations.of(context).weekly),
                          Tab(text: AppLocalizations.of(context).monthly),
                          Tab(text: AppLocalizations.of(context).yearly),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Chart area
                    if (_selectedHabitId != null)
                      SizedBox(
                        height: 280,
                        child: TabBarView(
                          controller: _tabCtrl,
                          children: [
                            _ProgressChart(
                              roomId: widget.roomId,
                              habitId: _selectedHabitId!,
                              uid: widget.member.uid,
                              period: _ChartPeriod.weekly,
                              color: _selectedHabitColor,
                            ),
                            _ProgressChart(
                              roomId: widget.roomId,
                              habitId: _selectedHabitId!,
                              uid: widget.member.uid,
                              period: _ChartPeriod.monthly,
                              color: _selectedHabitColor,
                            ),
                            _ProgressChart(
                              roomId: widget.roomId,
                              habitId: _selectedHabitId!,
                              uid: widget.member.uid,
                              period: _ChartPeriod.yearly,
                              color: _selectedHabitColor,
                            ),
                          ],
                        ),
                      ),
                  ] else
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        AppLocalizations.of(context).noHabitsAdded,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // All habits summary
                  if (_habits.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(Icons.format_list_bulleted_rounded,
                              size: 18, color: theme.colorScheme.primary),
                          const SizedBox(width: 6),
                          Text(
                            AppLocalizations.of(context).allHabitsLabel,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._habits.map((h) => _HabitProgressSummary(
                          roomId: widget.roomId,
                          habit: h,
                          uid: widget.member.uid,
                        )),
                  ],
                ],
              ),
            ),
    );
  }

  Color get _selectedHabitColor {
    final habit = _habits.where((h) => h.id == _selectedHabitId).firstOrNull;
    return habit?.color ?? Colors.blue;
  }

  void _sendNudge(BuildContext context) async {
    final messages = [
      AppLocalizations.of(context).nudgeDefaultMessage,
    ];

    final selectedMessage = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Text(
                  AppLocalizations.of(ctx).nudgeTitle(widget.member.displayName),
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              ...messages.map((msg) => ListTile(
                    leading: Text(msg.substring(0, 2),
                        style: const TextStyle(fontSize: 20)),
                    title: Text(msg.substring(2).trim()),
                    onTap: () => Navigator.pop(ctx, msg),
                  )),
            ],
          ),
        ),
      ),
    );

    if (selectedMessage != null && context.mounted) {
      await RoomService.instance.sendNudge(
        roomId: widget.roomId,
        toUid: widget.member.uid,
        toName: widget.member.displayName,
        message: selectedMessage,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context).nudgeSuccessSnackbar(widget.member.displayName)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

// ─── Profile Header ─────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.member,
    required this.isCurrentUser,
  });

  final RoomMember member;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: ProfileRepository.instance,
      builder: (context, _) {
        final profile = ProfileRepository.instance;
        final name = isCurrentUser ? (profile.name.isNotEmpty ? profile.name : member.displayName) : member.displayName;

        ImageProvider? avatar;
        if (isCurrentUser) {
          if (profile.avatarPath != null && profile.avatarPath!.isNotEmpty) {
            avatar = FileImage(io.File(profile.avatarPath!));
          } else if (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty) {
            avatar = NetworkImage(profile.avatarUrl!);
          }
        } else if (member.avatarUrl != null) {
          avatar = NetworkImage(member.avatarUrl!);
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 32,
                backgroundImage: avatar,
                backgroundColor: avatar == null ? theme.colorScheme.primaryContainer : null,
                child: avatar == null
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: TextStyle(
                          fontSize: 24, 
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isCurrentUser) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              AppLocalizations.of(context).youLabel,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context).joinedAtLabel(_formatDate(context, member.joinedAt)),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(BuildContext context, DateTime dt) {
    final months = AppLocalizations.of(context).monthsShort.split(',');
    // months is usually comma separated in ARB
    // If not, adjust. Jan,Feb...
    return '${dt.day} ${months[(dt.month - 1) % 12]} ${dt.year}';
  }
}

// ─── Habit Progress Summary Tile ─────────────────────────────

class _HabitProgressSummary extends StatelessWidget {
  const _HabitProgressSummary({
    required this.roomId,
    required this.habit,
    required this.uid,
  });

  final String roomId;
  final RoomHabit habit;
  final String uid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder<List<MemberProgress>>(
      stream: RoomService.instance.streamHabitProgress(roomId, habit.id),
      builder: (ctx, snap) {
        final allProgress = snap.data ?? [];
        final myProgress =
            allProgress.where((p) => p.uid == uid).firstOrNull;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: habit.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    habit.emoji ?? '🎯',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (myProgress != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            // Progress bar
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: myProgress.completionRatio,
                                  minHeight: 6,
                                  backgroundColor: theme.colorScheme
                                      .surfaceContainerHighest,
                                  color: myProgress.isCompleted
                                      ? const Color(0xFF22C55E)
                                      : habit.color,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '%${myProgress.completionPercent}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: myProgress.isCompleted
                                    ? const Color(0xFF22C55E)
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ] else
                        Text(
                          AppLocalizations.of(context).noProgressYet,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ),
                if (myProgress != null && myProgress.streak > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_fire_department_rounded,
                            size: 14, color: Color(0xFFFF6B35)),
                        const SizedBox(width: 2),
                        Text(
                          AppLocalizations.of(context).streakDays(myProgress.streak),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFFF6B35),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Progress Chart ──────────────────────────────────────────

enum _ChartPeriod { weekly, monthly, yearly }

class _ProgressChart extends StatefulWidget {
  const _ProgressChart({
    required this.roomId,
    required this.habitId,
    required this.uid,
    required this.period,
    required this.color,
  });

  final String roomId;
  final String habitId;
  final String uid;
  final _ChartPeriod period;
  final Color color;

  @override
  State<_ProgressChart> createState() => _ProgressChartState();
}

class _ProgressChartState extends State<_ProgressChart> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return StreamBuilder<List<ProgressHistoryEntry>>(
      stream: RoomService.instance.streamProgressHistory(
        roomId: widget.roomId,
        habitId: widget.habitId,
        uid: widget.uid,
      ),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final entries = snap.data ?? [];
        final chartData = _buildChartData(entries);

        if (chartData.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome_rounded,
                    size: 48,
                    color: widget.color.withOpacity(0.2)),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context).progressJourneyStarts,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppLocalizations.of(context).progressJourneyMessage,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                    fontSize: 12,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: CustomPaint(
            painter: _LineChartPainter(
              data: chartData,
              lineColor: widget.color,
              dotColor: widget.color.withOpacity(0.8),
              fillColor: widget.color.withOpacity(isDark ? 0.08 : 0.05),
              gridColor: theme.colorScheme.outlineVariant.withOpacity(0.2),
              textColor: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
              isDark: isDark,
            ),
            size: const Size(double.infinity, 200),
          ),
        );
      },
    );
  }

  List<_ChartData> _buildChartData(List<ProgressHistoryEntry> entries) {
    final now = DateTime.now();

    switch (widget.period) {
      case _ChartPeriod.weekly:
        return _buildWeeklyData(now, entries);
      case _ChartPeriod.monthly:
        return _buildMonthlyData(now, entries);
      case _ChartPeriod.yearly:
        return _buildYearlyData(now, entries);
    }
  }

  List<_ChartData> _buildWeeklyData(DateTime now, List<ProgressHistoryEntry> entries) {
    final result = <_ChartData>[];
    final days = AppLocalizations.of(context).weekDaysShort.split(',');

    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final key =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      final entry = entries.where((e) => e.date == key).firstOrNull;

      result.add(_ChartData(
        label: days[(day.weekday - 1) % 7],
        value: entry?.completionRatio ?? 0.0,
        isToday: i == 0,
      ));
    }
    return result;
  }

  List<_ChartData> _buildMonthlyData(DateTime now, List<ProgressHistoryEntry> entries) {
    final result = <_ChartData>[];

    for (int week = 5; week >= 0; week--) {
      final periodStart = now.subtract(Duration(days: (week + 1) * 5));
      final periodEnd = now.subtract(Duration(days: week * 5));

      double totalRatio = 0;
      int count = 0;

      for (final entry in entries) {
        final entryDate = DateTime.tryParse(entry.date);
        if (entryDate != null &&
            entryDate.isAfter(periodStart) &&
            !entryDate.isAfter(periodEnd)) {
          totalRatio += entry.completionRatio;
          count++;
        }
      }

      final avgRatio = count > 0 ? totalRatio / count : 0.0;
      final label = '${periodEnd.day}/${periodEnd.month}';

      result.add(_ChartData(
        label: label,
        value: avgRatio,
        isToday: week == 0,
      ));
    }
    return result;
  }

  List<_ChartData> _buildYearlyData(DateTime now, List<ProgressHistoryEntry> entries) {
    final result = <_ChartData>[];
    final months = AppLocalizations.of(context).monthsShort.split(',');

    for (int i = 11; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthKey = '${month.year}-${month.month.toString().padLeft(2, '0')}';

      double totalRatio = 0;
      int count = 0;

      for (final entry in entries) {
        if (entry.date.startsWith(monthKey)) {
          totalRatio += entry.completionRatio;
          count++;
        }
      }

      final avgRatio = count > 0 ? totalRatio / count : 0.0;

      result.add(_ChartData(
        label: months[(month.month - 1) % 12],
        value: avgRatio,
        isToday: i == 0,
      ));
    }
    return result;
  }
}

class _ChartData {
  const _ChartData({
    required this.label,
    required this.value,
    this.isToday = false,
  });
  final String label;
  final double value;
  final bool isToday;
}

class _LineChartPainter extends CustomPainter {
  const _LineChartPainter({
    required this.data,
    required this.lineColor,
    required this.dotColor,
    required this.fillColor,
    required this.gridColor,
    required this.textColor,
    required this.isDark,
  });

  final List<_ChartData> data;
  final Color lineColor;
  final Color dotColor;
  final Color fillColor;
  final Color gridColor;
  final Color textColor;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final margin = 30.0;
    final chartHeight = size.height - margin * 1.5;
    final chartWidth = size.width;
    final stepX = chartWidth / (data.length - 1);

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    // Draw Grid Lines (Horizontal)
    final gridSteps = 4;
    for (int i = 0; i <= gridSteps; i++) {
        final y = chartHeight - (i * chartHeight / gridSteps);
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
        
        // PCT Label
        final pctLabel = '${(i * 25)}%';
        final tp = TextPainter(
          text: TextSpan(
            text: pctLabel,
            style: TextStyle(
              fontSize: 8,
              color: textColor.withOpacity(0.4),
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(0, y - tp.height - 2));
    }

    final path = Path();
    final fillPath = Path();

    // Calculate points
    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = chartHeight - (data[i].value * chartHeight);
      points.add(Offset(x, y));
    }

    // Start fill path
    fillPath.moveTo(0, chartHeight);

    // Draw smooth line using Bezier
    if (points.length > 1) {
      path.moveTo(points[0].dx, points[0].dy);
      fillPath.lineTo(points[0].dx, points[0].dy);

      for (int i = 0; i < points.length - 1; i++) {
        final p0 = points[i];
        final p1 = points[i + 1];
        final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
        final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
        path.cubicTo(controlPoint1.dx, controlPoint1.dy, 
                   controlPoint2.dx, controlPoint2.dy, 
                   p1.dx, p1.dy);
        fillPath.cubicTo(controlPoint1.dx, controlPoint1.dy, 
                       controlPoint2.dx, controlPoint2.dy, 
                       p1.dx, p1.dy);
      }
    }

    fillPath.lineTo(points.last.dx, chartHeight);
    fillPath.lineTo(0, chartHeight);
    fillPath.close();

    // Draw Fill
    canvas.drawPath(fillPath, fillPaint);
    
    // Draw Line
    canvas.drawPath(path, linePaint);

    // Draw Dots and Labels
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < points.length; i++) {
      // Dot
      canvas.drawCircle(points[i], 5, dotPaint);
      canvas.drawCircle(points[i], 3, Paint()..color = Colors.white..style = PaintingStyle.fill);

      // Label
      textPainter.text = TextSpan(
        text: data[i].label,
        style: TextStyle(color: textColor, fontSize: 10, fontWeight: data[i].isToday ? FontWeight.w900 : FontWeight.w500),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(points[i].dx - textPainter.width/2, chartHeight + 10));
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter old) => true;
}
