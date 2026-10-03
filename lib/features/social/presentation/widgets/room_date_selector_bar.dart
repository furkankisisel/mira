import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../habit/presentation/widgets/daily_calendar_sheet.dart';

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

/// A calendar and day navigator bar designed for the Social Room.
/// Allows room members to easily swipe or jump between days, view habits scheduled
/// for that day, and visually understand future vs today constraints.
class RoomDateSelectorBar extends StatelessWidget {
  const RoomDateSelectorBar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.onOpenCalendar,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback? onOpenCalendar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final isTr = locale.startsWith('tr');

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final currentDay =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final isToday = currentDay == today;
    final isTomorrow = currentDay == today.add(const Duration(days: 1));
    final isYesterday = currentDay == today.subtract(const Duration(days: 1));
    final isFuture = currentDay.isAfter(today);

    // Compute the 7 days of the week containing selectedDate (Monday to Sunday)
    final monday = currentDay.subtract(Duration(days: currentDay.weekday - 1));
    final weekDays = List.generate(7, (i) => monday.add(Duration(days: i)));

    // Formatted title for the center pill with complete multi-language support
    String dateTitle;
    final formattedDatePart = DateFormat.MMMMd(locale).format(selectedDate);
    if (isToday) {
      dateTitle = '${l10n.today}, $formattedDatePart';
    } else if (isTomorrow) {
      dateTitle = '${l10n.tomorrow}, $formattedDatePart';
    } else if (isYesterday) {
      dateTitle = '${l10n.yesterday}, $formattedDatePart';
    } else {
      dateTitle = DateFormat.MMMMEEEEd(locale).format(selectedDate);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 6),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.65)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : colorScheme.outlineVariant.withValues(alpha: 0.28),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── Header: Navigation & Date Center Pill ───
            Row(
              children: [
                // Previous Day Button
                _buildCircleIconButton(
                  context,
                  icon: Icons.chevron_left_rounded,
                  tooltip: l10n.previous,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onDateSelected(
                        selectedDate.subtract(const Duration(days: 1)));
                  },
                ),
                const SizedBox(width: 5),

                // Center Date Pill (Tapping opens month calendar sheet)
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () async {
                        HapticFeedback.lightImpact();
                        if (onOpenCalendar != null) {
                          onOpenCalendar!();
                        } else {
                          final picked = await showDailyCalendarSheet(
                            context: context,
                            initialDate: selectedDate,
                          );
                          if (picked != null) {
                            onDateSelected(picked);
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.18),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_month_rounded,
                              size: 15,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                dateTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.2,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                            const SizedBox(width: 3),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 15,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),

                // Next Day Button
                _buildCircleIconButton(
                  context,
                  icon: Icons.chevron_right_rounded,
                  tooltip: l10n.next,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onDateSelected(selectedDate.add(const Duration(days: 1)));
                  },
                ),

                // Quick 'Today' Reset Pill if not on today
                if (!isToday) ...[
                  const SizedBox(width: 5),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onDateSelected(DateTime.now());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 5),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.outlineVariant
                                .withValues(alpha: 0.45),
                            width: 0.9,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.replay_rounded,
                              size: 12,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 2.5),
                            Text(
                              l10n.today,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 7),

            // ─── 7-Day Horizontal Week Strip (Compact & Refined Squircle Pills) ───
            Row(
              children: weekDays.map((day) {
                final isSelected = _isSameDay(day, selectedDate);
                final isDayToday = _isSameDay(day, now);
                final isDayFuture =
                    DateTime(day.year, day.month, day.day).isAfter(today);

                // Weekday Short (e.g. Pzt, Sal, Mon, Tue)
                final dayLabel = DateFormat.E(locale).format(day);

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          HapticFeedback.selectionClick();
                          onDateSelected(day);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(vertical: 4.5),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      colorScheme.primary,
                                      colorScheme.primary
                                          .withValues(alpha: 0.88),
                                    ],
                                  )
                                : null,
                            color: isSelected
                                ? null
                                : (isDayToday
                                    ? colorScheme.primary
                                        .withValues(alpha: 0.08)
                                    : (isDark
                                        ? Colors.white.withValues(alpha: 0.025)
                                        : const Color(0xFFF8FAFC))),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : (isDayToday
                                      ? colorScheme.primary
                                          .withValues(alpha: 0.40)
                                      : colorScheme.outlineVariant
                                          .withValues(alpha: 0.22)),
                              width: isDayToday || isSelected ? 1.2 : 0.9,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: colorScheme.primary
                                          .withValues(alpha: 0.30),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                dayLabel,
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: isSelected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  letterSpacing: 0.1,
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.95)
                                      : (isDayToday
                                          ? colorScheme.primary
                                          : colorScheme.onSurfaceVariant
                                              .withValues(
                                                  alpha: isDayFuture
                                                      ? 0.55
                                                      : 0.75)),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${day.day}',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: isSelected
                                      ? FontWeight.w800
                                      : (isDayToday
                                          ? FontWeight.w800
                                          : FontWeight.w600),
                                  color: isSelected
                                      ? Colors.white
                                      : (isDayToday
                                          ? colorScheme.primary
                                          : colorScheme.onSurface.withValues(
                                              alpha:
                                                  isDayFuture ? 0.65 : 0.95)),
                                ),
                              ),
                              const SizedBox(height: 1.5),
                              // Tiny dot indicator for 'Today'
                              Container(
                                width: 3.5,
                                height: 3.5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? (isDayToday
                                          ? Colors.white
                                          : Colors.transparent)
                                      : (isDayToday
                                          ? colorScheme.primary
                                          : Colors.transparent),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // ─── Future Date Information Banner (Slim & Subtle) ───
            if (isFuture) ...[
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                decoration: BoxDecoration(
                  color: isDark
                      ? colorScheme.primary.withValues(alpha: 0.10)
                      : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark
                        ? colorScheme.primary.withValues(alpha: 0.20)
                        : const Color(0xFFBFDBFE),
                    width: 0.9,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_clock_rounded,
                      size: 13,
                      color: isDark
                          ? colorScheme.primary
                          : const Color(0xFF2563EB),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        isTr
                            ? 'Gelecek gün seçili • Hedefler gününde tamamlanabilir'
                            : 'Future day selected • Habits can be completed on their day',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? colorScheme.primary
                              : const Color(0xFF1D4ED8),
                        ),
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
  }

  Widget _buildCircleIconButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : const Color(0xFFF1F5F9),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          width: 0.9,
        ),
      ),
      child: IconButton(
        icon: Icon(icon, size: 16),
        padding: EdgeInsets.zero,
        tooltip: tooltip,
        color: colorScheme.onSurface,
        onPressed: onTap,
      ),
    );
  }
}
