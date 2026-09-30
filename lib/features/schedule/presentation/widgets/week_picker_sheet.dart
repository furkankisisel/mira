import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../design_system/theme/theme_variations.dart';

class WeekItem {
  final int weekNumber;
  final DateTime startDate; // Monday
  final DateTime endDate; // Sunday

  const WeekItem({
    required this.weekNumber,
    required this.startDate,
    required this.endDate,
  });
}

/// Formats a week start date into localized text like "Ekim • 1. Hafta" or "October • Week 1".
String formatWeekTitle(DateTime weekStart, {String? locale}) {
  final loc = locale ?? 'tr';
  final monday = weekStart.subtract(Duration(days: weekStart.weekday - 1));
  final normalizedMonday = DateTime(monday.year, monday.month, monday.day);
  final thursday = normalizedMonday.add(const Duration(days: 3));
  final month = DateTime(thursday.year, thursday.month, 1);
  final firstDay = DateTime(month.year, month.month, 1);
  DateTime currentMonday = DateTime(
    firstDay.year,
    firstDay.month,
    firstDay.day,
  ).subtract(Duration(days: firstDay.weekday - 1));

  int weekNum = 1;
  while (true) {
    if (currentMonday.year == normalizedMonday.year &&
        currentMonday.month == normalizedMonday.month &&
        currentMonday.day == normalizedMonday.day) {
      break;
    }
    currentMonday = currentMonday.add(const Duration(days: 7));
    weekNum++;
    if (weekNum > 6) break;
  }

  final isTr = loc.startsWith('tr');
  final monthName = DateFormat.MMMM(loc).format(month);
  return isTr ? '$monthName • $weekNum. Hafta' : '$monthName • Week $weekNum';
}

Future<DateTime?> showWeekPickerSheet({
  required BuildContext context,
  required DateTime initialWeekStart,
  ThemeVariant? variant,
}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _WeekPickerSheetContent(
      initialWeekStart: initialWeekStart,
    ),
  );
}

class _WeekPickerSheetContent extends StatefulWidget {
  const _WeekPickerSheetContent({
    required this.initialWeekStart,
  });

  final DateTime initialWeekStart;

  @override
  State<_WeekPickerSheetContent> createState() => _WeekPickerSheetContentState();
}

class _WeekPickerSheetContentState extends State<_WeekPickerSheetContent> {
  late DateTime _displayMonth;

  @override
  void initState() {
    super.initState();
    // Anchor to the month represented by the middle of the selected week (Thursday)
    final thursday = widget.initialWeekStart.add(const Duration(days: 3));
    _displayMonth = DateTime(thursday.year, thursday.month, 1);
  }

  List<WeekItem> _generateWeeksForMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    // Find the Monday of the week that contains firstDay
    DateTime currentMonday = DateTime(
      firstDay.year,
      firstDay.month,
      firstDay.day,
    ).subtract(Duration(days: firstDay.weekday - 1));

    final weeks = <WeekItem>[];
    int weekNum = 1;

    while (true) {
      final sunday = currentMonday.add(const Duration(days: 6));
      weeks.add(
        WeekItem(
          weekNumber: weekNum,
          startDate: currentMonday,
          endDate: sunday,
        ),
      );
      weekNum++;
      currentMonday = currentMonday.add(const Duration(days: 7));
      // Stop when currentMonday is strictly past the last day of the month
      if (currentMonday.isAfter(lastDay)) {
        break;
      }
    }

    return weeks;
  }

  bool _isSameWeek(DateTime a, DateTime b) {
    final aMon = a.subtract(Duration(days: a.weekday - 1));
    final bMon = b.subtract(Duration(days: b.weekday - 1));
    return aMon.year == bMon.year &&
        aMon.month == bMon.month &&
        aMon.day == bMon.day;
  }

  bool _isCurrentWeek(DateTime monday) {
    return _isSameWeek(monday, DateTime.now());
  }

  String _formatDateRange(WeekItem week, String locale) {
    final start = week.startDate;
    final end = week.endDate;

    if (start.month == end.month) {
      final monthName = DateFormat.MMMM(locale).format(start);
      return '${start.day} - ${end.day} $monthName';
    } else {
      final startMonth = DateFormat.MMM(locale).format(start);
      final endMonth = DateFormat.MMM(locale).format(end);
      return '${start.day} $startMonth - ${end.day} $endMonth';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).toString();
    final isTr = locale.startsWith('tr');

    final weeks = _generateWeeksForMonth(_displayMonth);
    final monthTitle = DateFormat.yMMMM(locale).format(_displayMonth);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF141923).withValues(alpha: 0.94)
                : Colors.white.withValues(alpha: 0.94),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(
              color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.95),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.10),
                blurRadius: 28,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            24 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title & Quick Jump & Close
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.date_range_rounded,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isTr ? 'Hafta Seçin' : 'Select Week',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        fontFamily: 'Outfit',
                      ),
                    ),
                  ),
                  // Quick "This Week" Button
                  GestureDetector(
                    onTap: () {
                      final now = DateTime.now();
                      final thisMonday = DateTime(
                        now.year,
                        now.month,
                        now.day,
                      ).subtract(Duration(days: now.weekday - 1));
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pop(thisMonday);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E2430)
                            : const Color(0xFFF2F4F7),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: isDark ? 0.08 : 0.9,
                          ),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.today_rounded,
                            size: 15,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isTr ? 'Bu Hafta' : 'This Week',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? const Color(0xFF1E2430) : Colors.white,
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: isDark ? 0.12 : 0.95,
                          ),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.25 : 0.05,
                            ),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Month navigation banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E2430)
                      : const Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(
                      alpha: isDark ? 0.08 : 0.95,
                    ),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.15 : 0.03,
                      ),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _displayMonth = DateTime(
                            _displayMonth.year,
                            _displayMonth.month - 1,
                            1,
                          );
                        });
                      },
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? const Color(0xFF252D3D) : Colors.white,
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: isDark ? 0.10 : 0.9,
                            ),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.chevron_left_rounded,
                          size: 20,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      monthTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _displayMonth = DateTime(
                            _displayMonth.year,
                            _displayMonth.month + 1,
                            1,
                          );
                        });
                      },
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? const Color(0xFF252D3D) : Colors.white,
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: isDark ? 0.10 : 0.9,
                            ),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Weeks list
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.45,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: weeks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final week = weeks[i];
                    final isSelected =
                        _isSameWeek(week.startDate, widget.initialWeekStart);
                    final isCurrent = _isCurrentWeek(week.startDate);
                    final dateRangeStr = _formatDateRange(week, locale);
                    final weekLabel = isTr
                        ? '${week.weekNumber}. Hafta'
                        : 'Week ${week.weekNumber}';

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop(week.startDate);
                        },
                        borderRadius: BorderRadius.circular(18),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(
                                    colors: [
                                      colorScheme.primary.withValues(alpha: 0.18),
                                      colorScheme.primary.withValues(alpha: 0.08),
                                    ],
                                  )
                                : null,
                            color: isSelected
                                ? null
                                : (isDark
                                    ? const Color(0xFF1E2430)
                                    : Colors.white),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected
                                  ? colorScheme.primary.withValues(alpha: 0.8)
                                  : Colors.white.withValues(
                                      alpha: isDark ? 0.08 : 0.95,
                                    ),
                              width: isSelected ? 1.5 : 1.2,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: colorScheme.primary.withValues(
                                        alpha: 0.25,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                    const BoxShadow(
                                      color: Colors.white24,
                                      blurRadius: 1.5,
                                      offset: Offset(0, -1),
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: isDark ? 0.18 : 0.02,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withValues(
                                        alpha: isDark ? 0.04 : 0.8,
                                      ),
                                      blurRadius: 1,
                                      offset: const Offset(0, -1),
                                    ),
                                  ],
                          ),
                          child: Row(
                            children: [
                              // Number squircle badge
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: isSelected
                                      ? LinearGradient(
                                          colors: [
                                            colorScheme.primary,
                                            colorScheme.primary.withValues(
                                              alpha: 0.85,
                                            ),
                                          ],
                                        )
                                      : null,
                                  color: isSelected
                                      ? null
                                      : (isDark
                                          ? const Color(0xFF262F3F)
                                          : const Color(0xFFEDF1F7)),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.white.withValues(alpha: 0.3)
                                        : Colors.white.withValues(
                                            alpha: isDark ? 0.08 : 0.9,
                                          ),
                                    width: 1,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${week.weekNumber}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.white
                                        : colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Text details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          weekLabel,
                                          style: TextStyle(
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w600,
                                            fontSize: 14.5,
                                            color: isSelected
                                                ? colorScheme.primary
                                                : colorScheme.onSurface,
                                          ),
                                        ),
                                        if (isCurrent) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: colorScheme.primary
                                                  .withValues(alpha: 0.15),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              isTr ? 'Bu Hafta' : 'Current',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: colorScheme.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      dateRangeStr,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: colorScheme.onSurface.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Trailing icon
                              if (isSelected)
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: colorScheme.primary,
                                  size: 22,
                                )
                              else
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.4,
                                  ),
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
