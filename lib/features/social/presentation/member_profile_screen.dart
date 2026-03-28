import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/room_service.dart';
import '../domain/room_habit_model.dart';
import '../domain/room_member_model.dart';
import '../domain/room_progress_models.dart';

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
                label: const Text('Dürt'),
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
                            'Alışkanlık Seç',
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
                        tabs: const [
                          Tab(text: 'Haftalık'),
                          Tab(text: 'Aylık'),
                          Tab(text: 'Yıllık'),
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
                        'Henüz alışkanlık eklenmemiş',
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
                            'Tüm Alışkanlıklar',
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
      '💪 Haydi, alışkanlıklarını tamamla!',
      '🔥 Serini kırma, devam et!',
      '⏰ Alışkanlık zamanı!',
      '🎯 Bugünkü hedeflerini unutma!',
      '🏆 Sıralamada yükselmeni bekliyorum!',
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
                  '${widget.member.displayName} kişisini dürt 👊',
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
                '${widget.member.displayName} dürtüldü! 👊'),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 32,
            backgroundImage: member.avatarUrl != null
                ? NetworkImage(member.avatarUrl!)
                : null,
            child: member.avatarUrl == null
                ? Text(
                    member.displayName.isNotEmpty
                        ? member.displayName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w700),
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
                    Text(
                      member.displayName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
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
                          'Sen',
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
                  'Katılım: ${_formatDate(member.joinedAt)}',
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
  }

  String _formatDate(DateTime dt) {
    const months = [
      '',
      'Oca',
      'Şub',
      'Mar',
      'Nis',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Eki',
      'Kas',
      'Ara'
    ];
    return '${dt.day} ${months[dt.month]} ${dt.year}';
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
                          'Henüz ilerleme yok',
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
                          '${myProgress.streak}',
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
  List<ProgressHistoryEntry> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(covariant _ProgressChart old) {
    super.didUpdateWidget(old);
    if (old.habitId != widget.habitId || old.period != widget.period) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final entries = await RoomService.instance.getProgressHistory(
        roomId: widget.roomId,
        habitId: widget.habitId,
        uid: widget.uid,
      );
      if (mounted) {
        setState(() {
          _entries = entries;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final chartData = _buildChartData();

    if (chartData.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart_rounded,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3)),
            const SizedBox(height: 8),
            Text(
              'Henüz yeterli veri yok',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Alışkanlık tamamlandıkça grafik oluşacak',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomPaint(
        painter: _BarChartPainter(
          data: chartData,
          barColor: widget.color,
          completedColor: const Color(0xFF22C55E),
          gridColor: theme.colorScheme.outlineVariant.withOpacity(0.3),
          textColor: theme.colorScheme.onSurfaceVariant,
          isDark: theme.brightness == Brightness.dark,
        ),
        size: const Size(double.infinity, 240),
      ),
    );
  }

  List<_BarData> _buildChartData() {
    final now = DateTime.now();

    switch (widget.period) {
      case _ChartPeriod.weekly:
        return _buildWeeklyData(now);
      case _ChartPeriod.monthly:
        return _buildMonthlyData(now);
      case _ChartPeriod.yearly:
        return _buildYearlyData(now);
    }
  }

  List<_BarData> _buildWeeklyData(DateTime now) {
    final result = <_BarData>[];
    const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    // Get last 7 days
    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final key =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      final entry = _entries.where((e) => e.date == key).firstOrNull;

      result.add(_BarData(
        label: days[(day.weekday - 1) % 7],
        value: entry?.completionRatio ?? 0.0,
        isCompleted: entry?.isCompleted ?? false,
        isToday: i == 0,
      ));
    }
    return result;
  }

  List<_BarData> _buildMonthlyData(DateTime now) {
    final result = <_BarData>[];

    // Get last 30 days grouped by 5-day periods
    for (int week = 5; week >= 0; week--) {
      final periodStart = now.subtract(Duration(days: (week + 1) * 5));
      final periodEnd = now.subtract(Duration(days: week * 5));

      double totalRatio = 0;
      int count = 0;
      int completedDays = 0;

      for (final entry in _entries) {
        final entryDate = DateTime.tryParse(entry.date);
        if (entryDate != null &&
            entryDate.isAfter(periodStart) &&
            !entryDate.isAfter(periodEnd)) {
          totalRatio += entry.completionRatio;
          count++;
          if (entry.isCompleted) completedDays++;
        }
      }

      final avgRatio = count > 0 ? totalRatio / count : 0.0;
      final label =
          '${periodEnd.day}/${periodEnd.month}';

      result.add(_BarData(
        label: label,
        value: avgRatio,
        isCompleted: count > 0 && completedDays == count,
        isToday: week == 0,
      ));
    }
    return result;
  }

  List<_BarData> _buildYearlyData(DateTime now) {
    final result = <_BarData>[];
    const months = [
      '',
      'Oca',
      'Şub',
      'Mar',
      'Nis',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Eki',
      'Kas',
      'Ara'
    ];

    // Last 12 months
    for (int i = 11; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthKey =
          '${month.year}-${month.month.toString().padLeft(2, '0')}';

      double totalRatio = 0;
      int count = 0;
      int completedDays = 0;

      for (final entry in _entries) {
        if (entry.date.startsWith(monthKey)) {
          totalRatio += entry.completionRatio;
          count++;
          if (entry.isCompleted) completedDays++;
        }
      }

      final avgRatio = count > 0 ? totalRatio / count : 0.0;

      result.add(_BarData(
        label: months[month.month],
        value: avgRatio,
        isCompleted: count > 0 && completedDays == count,
        isToday: i == 0,
      ));
    }
    return result;
  }
}

class _BarData {
  const _BarData({
    required this.label,
    required this.value,
    this.isCompleted = false,
    this.isToday = false,
  });

  final String label;
  final double value; // 0.0 – 1.0
  final bool isCompleted;
  final bool isToday;
}

// ─── Custom Bar Chart Painter ───────────────────────────────

class _BarChartPainter extends CustomPainter {
  _BarChartPainter({
    required this.data,
    required this.barColor,
    required this.completedColor,
    required this.gridColor,
    required this.textColor,
    required this.isDark,
  });

  final List<_BarData> data;
  final Color barColor;
  final Color completedColor;
  final Color gridColor;
  final Color textColor;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    const labelHeight = 24.0;
    const topPadding = 20.0;
    final chartHeight = size.height - labelHeight - topPadding;
    final barWidth = (size.width / data.length) * 0.55;
    final gap = (size.width - barWidth * data.length) / (data.length + 1);

    // Grid lines
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    for (int i = 0; i <= 4; i++) {
      final y = topPadding + chartHeight * (1 - i / 4);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );

      // Grid labels
      final pctLabel = '${(i * 25)}%';
      final tp = TextPainter(
        text: TextSpan(
          text: pctLabel,
          style: TextStyle(
            fontSize: 9,
            color: textColor.withOpacity(0.5),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height - 2));
    }

    // Bars
    for (int i = 0; i < data.length; i++) {
      final d = data[i];
      final x = gap + i * (barWidth + gap);
      final barHeight = chartHeight * d.value.clamp(0.0, 1.0);
      final barTop = topPadding + chartHeight - barHeight;

      // Bar background (ghost)
      final bgRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, topPadding, barWidth, chartHeight),
        const Radius.circular(6),
      );
      canvas.drawRRect(
        bgRect,
        Paint()..color = gridColor.withOpacity(0.3),
      );

      // Colored bar
      if (barHeight > 0) {
        final color = d.isCompleted ? completedColor : barColor;
        final barRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, barTop, barWidth, barHeight),
          const Radius.circular(6),
        );

        // Gradient fill
        final gradient = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color,
            color.withOpacity(0.7),
          ],
        );

        canvas.drawRRect(
          barRect,
          Paint()
            ..shader = gradient.createShader(
              Rect.fromLTWH(x, barTop, barWidth, barHeight),
            ),
        );

        // Value label on top of bar
        if (d.value > 0.05) {
          final valueLabel = '${(d.value * 100).round()}%';
          final valueTp = TextPainter(
            text: TextSpan(
              text: valueLabel,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: d.isCompleted
                    ? completedColor
                    : textColor,
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout();
          valueTp.paint(
            canvas,
            Offset(x + (barWidth - valueTp.width) / 2, barTop - 14),
          );
        }
      }

      // Today indicator
      if (d.isToday) {
        final dotPaint = Paint()
          ..color = barColor
          ..style = PaintingStyle.fill;
        final dotCenter = Offset(
          x + barWidth / 2,
          topPadding + chartHeight + labelHeight - 4,
        );
        canvas.drawCircle(dotCenter, 3, dotPaint);
      }

      // X-axis label
      final labelTp = TextPainter(
        text: TextSpan(
          text: d.label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: d.isToday ? FontWeight.w700 : FontWeight.w500,
            color: d.isToday ? barColor : textColor.withOpacity(0.7),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      labelTp.paint(
        canvas,
        Offset(
          x + (barWidth - labelTp.width) / 2,
          topPadding + chartHeight + 4,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter old) {
    return old.data != data || old.barColor != barColor;
  }
}
