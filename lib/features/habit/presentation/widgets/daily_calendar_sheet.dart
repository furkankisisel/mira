import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../design_system/theme/theme_variations.dart';
import '../../../../l10n/app_localizations.dart';

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

/// Displays an interactive modal bottom sheet to pick a day from a monthly calendar.
Future<DateTime?> showDailyCalendarSheet({
  required BuildContext context,
  required DateTime initialDate,
  ThemeVariant? variant,
}) async {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final colorScheme = theme.colorScheme;
  final l10n = AppLocalizations.of(context);
  final locale = Localizations.localeOf(context).toString();

  DateTime selectedDay = DateTime(initialDate.year, initialDate.month, initialDate.day);
  DateTime displayMonth = DateTime(selectedDay.year, selectedDay.month, 1);

  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setPickerState) {
          final firstDayOfMonth = DateTime(displayMonth.year, displayMonth.month, 1);
          final daysInMonth = DateTime(displayMonth.year, displayMonth.month + 1, 0).day;
          final startWeekday = firstDayOfMonth.weekday; // 1 to 7
          final prevMonthDays = DateTime(displayMonth.year, displayMonth.month, 0).day;
          final totalCells = ((startWeekday - 1 + daysInMonth) / 7).ceil() * 7;
          final monthYearStr = DateFormat.yMMMM(locale).format(displayMonth);
          final now = DateTime.now();

          final weekdayLabels = [
            l10n.dayMonShort,
            l10n.dayTueShort,
            l10n.dayWedShort,
            l10n.dayThuShort,
            l10n.dayFriShort,
            l10n.daySatShort,
            l10n.daySunShort,
          ];

          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh.withValues(
                    alpha: 0.94,
                  ),
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
                  children: [
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
                            Icons.calendar_month_rounded,
                            size: 20,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            monthYearStr,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                              fontFamily: 'Outfit',
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setPickerState(() {
                              displayMonth = DateTime(
                                displayMonth.year,
                                displayMonth.month - 1,
                                1,
                              );
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.surfaceContainerHigh,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.95),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.chevron_left_rounded,
                              size: 20,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setPickerState(() {
                              displayMonth = DateTime(
                                displayMonth.year,
                                displayMonth.month + 1,
                                1,
                              );
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.surfaceContainerHigh,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.95),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
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
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _buildQuickDateChip(
                          label: l10n.yesterday,
                          targetDate: now.subtract(const Duration(days: 1)),
                          selectedDate: selectedDay,
                          colorScheme: colorScheme,
                          onTap: (d) {
                            HapticFeedback.selectionClick();
                            setPickerState(() {
                              selectedDay = d;
                              displayMonth = DateTime(d.year, d.month, 1);
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildQuickDateChip(
                          label: l10n.today,
                          targetDate: now,
                          selectedDate: selectedDay,
                          colorScheme: colorScheme,
                          onTap: (d) {
                            HapticFeedback.selectionClick();
                            setPickerState(() {
                              selectedDay = d;
                              displayMonth = DateTime(d.year, d.month, 1);
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildQuickDateChip(
                          label: l10n.tomorrow,
                          targetDate: now.add(const Duration(days: 1)),
                          selectedDate: selectedDay,
                          colorScheme: colorScheme,
                          onTap: (d) {
                            HapticFeedback.selectionClick();
                            setPickerState(() {
                              selectedDay = d;
                              displayMonth = DateTime(d.year, d.month, 1);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: weekdayLabels.map((lbl) {
                        return SizedBox(
                          width: 38,
                          child: Center(
                            child: Text(
                              lbl,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                        childAspectRatio: 1,
                      ),
                      itemCount: totalCells,
                      itemBuilder: (context, index) {
                        final dayOffset = index - (startWeekday - 1);
                        DateTime cellDate;
                        bool isCurrentMonth = true;

                        if (dayOffset < 0) {
                          final prevDay = prevMonthDays + dayOffset + 1;
                          cellDate = DateTime(
                            displayMonth.year,
                            displayMonth.month - 1,
                            prevDay,
                          );
                          isCurrentMonth = false;
                        } else if (dayOffset >= daysInMonth) {
                          final nextDay = dayOffset - daysInMonth + 1;
                          cellDate = DateTime(
                            displayMonth.year,
                            displayMonth.month + 1,
                            nextDay,
                          );
                          isCurrentMonth = false;
                        } else {
                          cellDate = DateTime(
                            displayMonth.year,
                            displayMonth.month,
                            dayOffset + 1,
                          );
                        }

                        final isSelected = _isSameDay(cellDate, selectedDay);
                        final isToday = _isSameDay(cellDate, now);

                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setPickerState(() {
                              selectedDay = cellDate;
                              if (!isCurrentMonth) {
                                displayMonth = DateTime(cellDate.year, cellDate.month, 1);
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        colorScheme.primary,
                                        colorScheme.primary.withValues(alpha: 0.85),
                                      ],
                                    )
                                  : null,
                              color: isSelected
                                  ? null
                                  : (isToday
                                      ? colorScheme.primary.withValues(alpha: 0.12)
                                      : Colors.transparent),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.4)
                                    : (isToday
                                        ? colorScheme.primary.withValues(alpha: 0.5)
                                        : Colors.transparent),
                                width: isSelected || isToday ? 1.5 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: colorScheme.primary.withValues(alpha: 0.35),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                      const BoxShadow(
                                        color: Colors.white24,
                                        blurRadius: 1.5,
                                        offset: Offset(0, -1),
                                      ),
                                    ]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${cellDate.day}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected || isToday
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : (!isCurrentMonth
                                        ? colorScheme.onSurface.withValues(alpha: 0.25)
                                        : (isToday
                                            ? colorScheme.primary
                                            : colorScheme.onSurface)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        Navigator.of(context).pop(selectedDay);
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary,
                              colorScheme.primary.withValues(alpha: 0.85),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.4),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                            const BoxShadow(
                              color: Colors.white24,
                              blurRadius: 2,
                              offset: Offset(0, -1),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          l10n.selectDate,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildQuickDateChip({
  required String label,
  required DateTime targetDate,
  required DateTime selectedDate,
  required ColorScheme colorScheme,
  required ValueChanged<DateTime> onTap,
}) {
  final isSelected = _isSameDay(targetDate, selectedDate);
  return Expanded(
    child: GestureDetector(
      onTap: () => onTap(targetDate),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 36,
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant.withValues(alpha: 0.4),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : colorScheme.onSurface,
          ),
        ),
      ),
    ),
  );
}
