import 'package:flutter/material.dart';
import 'dart:math' show max;

import '../../../design_system/theme/theme_variations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/schedule_event.dart';
import '../domain/weekly_schedule_repository.dart';

/// Weekly timetable view that displays habits and custom events in a
/// university-style schedule grid (hours × days of week).
class WeeklyScheduleScreen extends StatefulWidget {
  const WeeklyScheduleScreen({super.key, this.variant});

  final ThemeVariant? variant;

  @override
  State<WeeklyScheduleScreen> createState() => _WeeklyScheduleScreenState();
}

class _WeeklyScheduleScreenState extends State<WeeklyScheduleScreen> {
  final _repo = WeeklyScheduleRepository.instance;
  final _scrollController = ScrollController();
  final _horizontalScrollController = ScrollController();
  final GlobalKey _gridKey = GlobalKey();
  List<ScheduleEvent> _allEvents = [];
  bool _loading = true;
  late DateTime _selectedWeekStart;

  // Grid constants
  static const int _startHour = 6;
  static const int _endHour = 24;
  static const double _hourHeight = 60.0;
  static const double _timeColumnWidth = 48.0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedWeekStart = now.subtract(Duration(days: now.weekday - 1));
    _initData();
    _repo.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _repo.removeListener(_onDataChanged);
    _scrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    await _repo.initialize();
    _loadEvents();
    _scrollToCurrentTime();
  }

  void _onDataChanged() => _loadEvents();

  void _loadEvents() {
    if (!mounted) return;
    setState(() {
      _allEvents = _repo.getEventsForWeek(_selectedWeekStart);
      _loading = false;
    });
  }

  void _scrollToCurrentTime() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      if (_scrollController.hasClients) {
        final offset = ((now.hour - _startHour) * _hourHeight +
                (now.minute / 60.0) * _hourHeight -
                _hourHeight * 2)
            .clamp(0.0, _scrollController.position.maxScrollExtent);
        _scrollController.jumpTo(offset);
      }

      if (_horizontalScrollController.hasClients) {
        const double dayWidth = 120.0; // matching build method
        final screenWidth = MediaQuery.of(context).size.width;
        final hOffset = ((now.weekday - 1) * dayWidth +
                _timeColumnWidth -
                (screenWidth / 2) +
                (dayWidth / 2))
            .clamp(0.0, _horizontalScrollController.position.maxScrollExtent);
        _horizontalScrollController.jumpTo(hOffset);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    // Monday=1 ... Sunday=7
    final todayDow = now.weekday;

    const double dayWidth = 120.0;
    final double totalWidth = _timeColumnWidth + (dayWidth * 7);

    return Stack(
      children: [
        SingleChildScrollView(
          controller: _horizontalScrollController,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: totalWidth,
            child: Column(
              children: [
                // Day headers
                _buildDayHeaders(l10n, todayDow, colorScheme, dayWidth),
                const Divider(height: 1),
                // Timetable grid
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: SizedBox(
                      height: (_endHour - _startHour) * _hourHeight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Time column
                          _buildTimeColumn(theme),
                          // Day columns
                          SizedBox(
                            width: dayWidth * 7,
                            child: DragTarget<ScheduleEvent>(
                              onWillAcceptWithDetails: (_) => true,
                              onAcceptWithDetails: (details) =>
                                  _onEventDropped(details, dayWidth),
                              builder: (context, candidateData, rejectedData) =>
                                  AnimationLimiter(
                                child: Stack(
                                  key: _gridKey,
                                  children: [
                                    // Grid lines
                                    _buildGridLines(theme, dayWidth),
                                    // Current time indicator
                                    _buildCurrentTimeIndicator(
                                        now, dayWidth, todayDow),
                                    // Event blocks
                                    ..._buildEventBlocks(dayWidth, theme),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // FAB
        Positioned(
          right: 16,
          bottom: 16 + MediaQuery.of(context).viewPadding.bottom,
          child: FloatingActionButton(
            heroTag: 'schedule_fab',
            onPressed: () => _showAddEventSheet(context),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  // ─── Day Headers ──────────────────────────────────────────────────────

  Widget _buildDayHeaders(AppLocalizations l10n, int todayDow,
      ColorScheme colorScheme, double dayWidth) {
    final dayLabels = [
      l10n.dayMonShort,
      l10n.dayTueShort,
      l10n.dayWedShort,
      l10n.dayThuShort,
      l10n.dayFriShort,
      l10n.daySatShort,
      l10n.daySunShort,
    ];

    final now = DateTime.now();
    // Check if the viewed week includes today
    final isCurrentWeek = now.year == _selectedWeekStart.year &&
        now.month == _selectedWeekStart.month &&
        now.day - now.weekday ==
            _selectedWeekStart.day - _selectedWeekStart.weekday;

    return SizedBox(
      height: 50,
      child: Row(
        children: [
          // Week Selector
          InkWell(
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedWeekStart,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (pickedDate != null) {
                setState(() {
                  _selectedWeekStart = pickedDate
                      .subtract(Duration(days: pickedDate.weekday - 1));
                  _loadEvents();
                });
              }
            },
            child: SizedBox(
              width: _timeColumnWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_month, size: 20),
                  Text(
                    '${_selectedWeekStart.day}/${_selectedWeekStart.month}',
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          ...List.generate(7, (i) {
            final dateForColumn = _selectedWeekStart.add(Duration(days: i));
            final isToday = isCurrentWeek && (i + 1) == todayDow;

            return SizedBox(
              width: dayWidth,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isToday
                      ? colorScheme.primary.withOpacity(0.10)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayLabels[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                        color: isToday
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${dateForColumn.day}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isToday ? FontWeight.bold : FontWeight.normal,
                        color: isToday
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─── Time Column ──────────────────────────────────────────────────────

  Widget _buildTimeColumn(ThemeData theme) {
    return SizedBox(
      width: _timeColumnWidth,
      child: Stack(
        children: List.generate(_endHour - _startHour, (i) {
          final hour = _startHour + i;
          return Positioned(
            top: i * _hourHeight - 6,
            left: 0,
            right: 4,
            child: Text(
              '${hour.toString().padLeft(2, '0')}:00',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 10,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─── Grid Lines ───────────────────────────────────────────────────────

  Widget _buildGridLines(ThemeData theme, double dayWidth) {
    final lineColor = theme.dividerColor.withOpacity(0.3);

    return CustomPaint(
      size: Size(dayWidth * 7, (_endHour - _startHour) * _hourHeight),
      painter: _GridPainter(
        hourHeight: _hourHeight,
        hourCount: _endHour - _startHour,
        dayWidth: dayWidth,
        dayCount: 7,
        lineColor: lineColor,
      ),
    );
  }

  // ─── Current Time Indicator ───────────────────────────────────────────

  Widget _buildCurrentTimeIndicator(
      DateTime now, double dayWidth, int todayDow) {
    if (now.hour < _startHour || now.hour >= _endHour) {
      return const SizedBox.shrink();
    }

    // Check if viewing current week
    final isCurrentWeek = now.year == _selectedWeekStart.year &&
        now.month == _selectedWeekStart.month &&
        now.day - now.weekday ==
            _selectedWeekStart.day - _selectedWeekStart.weekday;
    if (!isCurrentWeek) return const SizedBox.shrink();

    final top =
        (now.hour - _startHour) * _hourHeight + (now.minute / 60) * _hourHeight;
    final left = (todayDow - 1) * dayWidth;

    return Positioned(
      top: top,
      left: left,
      width: dayWidth,
      child: Container(
        height: 2,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(1),
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.4),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Event Blocks ─────────────────────────────────────────────────────

  List<Widget> _buildEventBlocks(double dayWidth, ThemeData theme) {
    final widgets = <Widget>[];

    for (final event in _allEvents) {
      if (event.dayOfWeek < 1 || event.dayOfWeek > 7) continue;
      if (event.startHour < _startHour) continue;

      final top = (event.startHour - _startHour) * _hourHeight +
          (event.startMinute / 60) * _hourHeight;
      final bottom = (event.endHour - _startHour) * _hourHeight +
          (event.endMinute / 60) * _hourHeight;
      final height = max(bottom - top, 20.0);
      final left = (event.dayOfWeek - 1) * dayWidth + 1;

      final blockWidget = Container(
        margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 0.5),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: event.color.withOpacity(0.85),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: event.color.withOpacity(0.3),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: event.color.withOpacity(0.2),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (height > 28)
              Text(
                event.timeRangeText,
                style: const TextStyle(
                  fontSize: 8,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            Text.rich(
              TextSpan(
                children: [
                  if (event.emoji != null) ...[
                    TextSpan(
                      text: '${event.emoji} ',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                  TextSpan(
                    text: event.title,
                    style: TextStyle(
                      fontSize: height > 40 ? 10 : 8,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
              maxLines: height > 60 ? 3 : (height > 30 ? 2 : 1),
              overflow: TextOverflow.ellipsis,
            ),
            if (height > 50 && event.location != null)
              Text(
                event.location!,
                style: const TextStyle(
                  fontSize: 8,
                  color: Colors.white70,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      );

      widgets.add(
        Positioned(
          top: top,
          left: left,
          width: dayWidth - 2,
          height: height,
          child: AnimationConfiguration.staggeredList(
            position: widgets.length,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 20.0,
              child: FadeInAnimation(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: LongPressDraggable<ScheduleEvent>(
                        data: event,
                        feedback: Material(
                          type: MaterialType.transparency,
                          child: SizedBox(
                            width: dayWidth - 2,
                            height: height,
                            child: Opacity(
                              opacity: 0.8,
                              child: blockWidget,
                            ),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.3,
                          child: blockWidget,
                        ),
                        child: GestureDetector(
                          onTap: () => _showEventDetailDialog(event),
                          child: blockWidget,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 12,
                      child: GestureDetector(
                        onVerticalDragUpdate: (details) =>
                            _onEventResizeUpdate(details, event),
                        onVerticalDragEnd: (_) => _repo.updateEvent(event),
                        child: Container(
                          color: Colors.transparent,
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 24,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 2),
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  void _onEventDropped(
      DragTargetDetails<ScheduleEvent> details, double dayWidth) {
    final RenderBox? gridBox =
        _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (gridBox == null) return;

    final localPosition = gridBox.globalToLocal(details.offset);
    final event = details.data;

    int newDayOfWeek = (localPosition.dx / dayWidth).floor() + 1;
    newDayOfWeek = newDayOfWeek.clamp(1, 7);

    double totalHoursDec = (localPosition.dy / _hourHeight) + _startHour;
    int hour = totalHoursDec.floor();
    int minute = ((totalHoursDec - hour) * 60).round();

    // Snap to 15 mins
    minute = (minute / 15).round() * 15;
    if (minute == 60) {
      hour += 1;
      minute = 0;
    }

    hour = hour.clamp(_startHour, _endHour - 1);

    final duration = event.durationMinutes;

    event.dayOfWeek = newDayOfWeek;
    event.startHour = hour;
    event.startMinute = minute;

    int endTotalMinutes = hour * 60 + minute + duration;
    event.endHour = endTotalMinutes ~/ 60;
    event.endMinute = endTotalMinutes % 60;

    _repo.updateEvent(event);
  }

  void _onEventResizeUpdate(DragUpdateDetails details, ScheduleEvent event) {
    final RenderBox? gridBox =
        _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (gridBox == null) return;

    final localPos = gridBox.globalToLocal(details.globalPosition);

    final totalHours = (localPos.dy / _hourHeight) + _startHour;
    int endHour = totalHours.floor();
    int endMin = ((totalHours - endHour) * 60).round();

    endMin = (endMin / 15).round() * 15;
    if (endMin == 60) {
      endHour += 1;
      endMin = 0;
    }

    final startTotal = event.startHour * 60 + event.startMinute;
    int endTotal = endHour * 60 + endMin;

    if (endTotal <= startTotal) {
      endTotal = startTotal + 15;
      endHour = endTotal ~/ 60;
      endMin = endTotal % 60;
    }
    if (endTotal > _endHour * 60) {
      endHour = _endHour;
      endMin = 0;
    }

    setState(() {
      event.endHour = endHour;
      event.endMinute = endMin;
    });
  }

  // ─── Event Detail Dialog ──────────────────────────────────────────────

  void _showEventDetailDialog(ScheduleEvent event) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    final dayLabels = [
      l10n.dayMonShort,
      l10n.dayTueShort,
      l10n.dayWedShort,
      l10n.dayThuShort,
      l10n.dayFriShort,
      l10n.daySatShort,
      l10n.daySunShort,
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Color header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: event.color.withOpacity(0.9),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (event.emoji != null) ...[
                        Text(event.emoji!,
                            style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 14, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text(
                        event.timeRangeText,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.white70),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.calendar_today,
                          size: 14, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text(
                        event.dayOfWeek >= 1 && event.dayOfWeek <= 7
                            ? dayLabels[event.dayOfWeek - 1]
                            : '',
                        style: const TextStyle(
                            fontSize: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (event.description.isNotEmpty) ...[
                    Text(
                      event.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (event.location != null && event.location!.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 16, color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _showAddEventSheet(context, editEvent: event);
                        },
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: Text(l10n.edit),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _confirmDeleteEvent(event);
                        },
                        icon: Icon(Icons.delete_outline,
                            size: 18, color: colorScheme.error),
                        label: Text(
                          l10n.delete,
                          style: TextStyle(color: colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteEvent(ScheduleEvent event) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteEvent),
        content: Text('${event.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _repo.removeEvent(event.id);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  // ─── Add / Edit Event Bottom Sheet ────────────────────────────────────

  void _showAddEventSheet(BuildContext context, {ScheduleEvent? editEvent}) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final titleCtrl = TextEditingController(text: editEvent?.title ?? '');
    final descCtrl = TextEditingController(text: editEvent?.description ?? '');
    final locationCtrl = TextEditingController(text: editEvent?.location ?? '');

    List<int> selectedDays =
        editEvent != null ? [editEvent.dayOfWeek] : [DateTime.now().weekday];
    int durationWeeks = 1;
    TimeOfDay startTime = editEvent != null
        ? TimeOfDay(hour: editEvent.startHour, minute: editEvent.startMinute)
        : const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay endTime = editEvent != null
        ? TimeOfDay(hour: editEvent.endHour, minute: editEvent.endMinute)
        : const TimeOfDay(hour: 10, minute: 0);

    final presetColors = [
      const Color(0xFF5C6BC0), // indigo
      const Color(0xFF42A5F5), // blue
      const Color(0xFF26A69A), // teal
      const Color(0xFF66BB6A), // green
      const Color(0xFFFFA726), // orange
      const Color(0xFFEF5350), // red
      const Color(0xFFAB47BC), // purple
      const Color(0xFF78909C), // blue-grey
      const Color(0xFFEC407A), // pink
      const Color(0xFF8D6E63), // brown
    ];

    const List<String> quickEmojis = [
      '🎯', '⭐', '❤️', '🔥', '📚', '💪', '🧘‍♀️', '🏃‍♂️', '🎨', '✈️', '💰', '🎵',
      '✨', '✅', '🚀', '💡', '⏰', '🥗', '☕', '💤', '🏠', '🌱', '☀️', '🌊',
      '🌈', '💻', '📱', '✍️', '🎮', '🎬', '🐶', '🍕', '🛒', '🎁', '🔔'
    ];

    Color selectedColor = editEvent?.color ?? presetColors[0];
    String? selectedEmoji = editEvent?.emoji;

    final dayLabels = [
      l10n.dayMonShort,
      l10n.dayTueShort,
      l10n.dayWedShort,
      l10n.dayThuShort,
      l10n.dayFriShort,
      l10n.daySatShort,
      l10n.daySunShort,
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          String? errorMessage; // Declare errorMessage here
          return Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              0,
              20,
              MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    editEvent != null ? l10n.editEvent : l10n.addEvent,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Event title
                  TextField(
                    controller: titleCtrl,
                    decoration: InputDecoration(
                      labelText: l10n.eventTitle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.title),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 12),

                  // Description
                  TextField(
                    controller: descCtrl,
                    decoration: InputDecoration(
                      labelText: l10n.eventDescription,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.notes),
                    ),
                    maxLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 12),

                  // Location (optional)
                  TextField(
                    controller: locationCtrl,
                    decoration: InputDecoration(
                      labelText: '${l10n.eventDescription} (${l10n.custom})',
                      hintText: 'Yer / Salon / Link',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.location_on_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Emoji picker
                  Text('İkon / Emoji (İsteğe Bağlı)',
                      style: theme.textTheme.labelLarge),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // No emoji option
                        GestureDetector(
                          onTap: () =>
                              setSheetState(() => selectedEmoji = null),
                          child: Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: selectedEmoji == null
                                  ? colorScheme.primary.withOpacity(0.2)
                                  : colorScheme.surfaceContainerHighest
                                      .withOpacity(0.5),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedEmoji == null
                                    ? colorScheme.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Icon(Icons.do_not_disturb_alt,
                                size: 20, color: colorScheme.onSurfaceVariant),
                          ),
                        ),
                        ...quickEmojis.map((emoji) {
                          final isSelected = emoji == selectedEmoji;
                          return GestureDetector(
                            onTap: () =>
                                setSheetState(() => selectedEmoji = emoji),
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(right: 8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? colorScheme.primary.withOpacity(0.2)
                                    : colorScheme.surfaceContainerHighest
                                        .withOpacity(0.5),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? colorScheme.primary
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Text(emoji,
                                  style: const TextStyle(fontSize: 20)),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Day selector
                  Text(l10n.selectDay, style: theme.textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: List.generate(7, (i) {
                      final dow = i + 1;
                      final isSelected = selectedDays.contains(dow);
                      if (editEvent != null) {
                        // Single selection for editing
                        return ChoiceChip(
                          label: Text(dayLabels[i]),
                          selected: isSelected,
                          selectedColor: colorScheme.primary.withOpacity(0.2),
                          onSelected: (_) =>
                              setSheetState(() => selectedDays = [dow]),
                        );
                      } else {
                        // Multiple selection for new events
                        return FilterChip(
                          label: Text(dayLabels[i]),
                          selected: isSelected,
                          selectedColor: colorScheme.primary.withOpacity(0.2),
                          onSelected: (selected) {
                            setSheetState(() {
                              if (selected) {
                                if (!selectedDays.contains(dow))
                                  selectedDays.add(dow);
                              } else {
                                if (selectedDays.length > 1) {
                                  selectedDays.remove(dow);
                                } else {
                                  // Prevent deselecting the last day for new events
                                  errorMessage = l10n.selectAtLeastOneDay;
                                }
                              }
                            });
                          },
                        );
                      }
                    }),
                  ),
                  const SizedBox(height: 16),

                  if (editEvent == null) ...[
                    // Duration selector (Only for new events)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Süre (Hafta)', style: theme.textTheme.labelLarge),
                        Text('$durationWeeks Hafta',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                      value: durationWeeks.toDouble(),
                      min: 1,
                      max: 12,
                      divisions: 11,
                      label: durationWeeks.toString(),
                      onChanged: (val) {
                        setSheetState(() => durationWeeks = val.round());
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Error message
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        errorMessage!,
                        style:
                            TextStyle(color: colorScheme.error, fontSize: 13),
                      ),
                    ),

                  // Action buttons
                  const SizedBox(height: 16),

                  // Time pickers
                  Row(
                    children: [
                      Expanded(
                        child: _TimeTile(
                          label: l10n.startTime,
                          time: startTime,
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: ctx,
                              initialTime: startTime,
                            );
                            if (picked != null) {
                              setSheetState(() => startTime = picked);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _TimeTile(
                          label: l10n.endTime,
                          time: endTime,
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: ctx,
                              initialTime: endTime,
                            );
                            if (picked != null) {
                              setSheetState(() => endTime = picked);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Color selector
                  Text(l10n.colorLabel, style: theme.textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: presetColors.map((c) {
                      final isSelected = c.value == selectedColor.value;
                      return GestureDetector(
                        onTap: () => setSheetState(() => selectedColor = c),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(
                                    color: colorScheme.onSurface, width: 2.5)
                                : null,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: c.withOpacity(0.4),
                                      blurRadius: 6,
                                    )
                                  ]
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check,
                                  size: 16, color: Colors.white)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        if (titleCtrl.text.trim().isEmpty) return;

                        if (editEvent != null) {
                          final event = ScheduleEvent(
                            id: editEvent.id,
                            title: titleCtrl.text.trim(),
                            description: descCtrl.text.trim(),
                            dayOfWeek: selectedDays.first,
                            startHour: startTime.hour,
                            startMinute: startTime.minute,
                            endHour: endTime.hour,
                            endMinute: endTime.minute,
                            color: selectedColor,
                            location: locationCtrl.text.trim().isEmpty
                                ? null
                                : locationCtrl.text.trim(),
                            emoji: selectedEmoji,
                            startDate: editEvent.startDate ??
                                '${_selectedWeekStart.year}-${_selectedWeekStart.month.toString().padLeft(2, '0')}-${_selectedWeekStart.day.toString().padLeft(2, '0')}',
                          );
                          _repo.updateEvent(event);
                        } else {
                          final List<ScheduleEvent> generatedEvents = [];
                          final baseId =
                              DateTime.now().millisecondsSinceEpoch.toString();

                          for (int w = 0; w < durationWeeks; w++) {
                            // Calculate the start date of the target week (always a Monday)
                            final targetWeekStart =
                                _selectedWeekStart.add(Duration(days: w * 7));
                            final startDateStr =
                                '${targetWeekStart.year}-${targetWeekStart.month.toString().padLeft(2, '0')}-${targetWeekStart.day.toString().padLeft(2, '0')}';

                            for (final d in selectedDays) {
                              generatedEvents.add(ScheduleEvent(
                                id: '${baseId}_w${w}_d$d',
                                title: titleCtrl.text.trim(),
                                description: descCtrl.text.trim(),
                                dayOfWeek: d,
                                startHour: startTime.hour,
                                startMinute: startTime.minute,
                                endHour: endTime.hour,
                                endMinute: endTime.minute,
                                color: selectedColor,
                                location: locationCtrl.text.trim().isEmpty
                                    ? null
                                    : locationCtrl.text.trim(),
                                emoji: selectedEmoji,
                                startDate: startDateStr,
                              ));
                            }
                          }
                          _repo.addEvents(generatedEvents);
                        }

                        Navigator.pop(ctx);
                      },
                      icon: Icon(editEvent != null ? Icons.check : Icons.add),
                      label:
                          Text(editEvent != null ? l10n.apply : l10n.addEvent),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────

class _TimeTile extends StatelessWidget {
  const _TimeTile({
    required this.label,
    required this.time,
    required this.onTap,
  });

  final String label;
  final TimeOfDay time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 10,
                        color: theme.colorScheme.onSurfaceVariant)),
                Text(
                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Grid Painter ─────────────────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  _GridPainter({
    required this.hourHeight,
    required this.hourCount,
    required this.dayWidth,
    required this.dayCount,
    required this.lineColor,
  });

  final double hourHeight;
  final int hourCount;
  final double dayWidth;
  final int dayCount;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 0.5;

    // Horizontal hour lines
    for (int i = 0; i <= hourCount; i++) {
      final y = i * hourHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Vertical day lines
    for (int i = 0; i <= dayCount; i++) {
      final x = i * dayWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) =>
      old.lineColor != lineColor || old.dayWidth != dayWidth;
}
