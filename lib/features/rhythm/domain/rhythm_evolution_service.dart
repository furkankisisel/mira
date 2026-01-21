import 'package:flutter/foundation.dart';
import 'live_rhythm_model.dart';
import 'live_rhythm_repository.dart';

/// Analyzes weekly behavior logs and updates rhythm profile
class RhythmEvolutionService {
  RhythmEvolutionService._();
  static final RhythmEvolutionService instance = RhythmEvolutionService._();

  /// Checks if it's time for weekly evolution (Sunday after 20:00)
  bool shouldRunEvolution() {
    final now = DateTime.now();
    // Run on Sundays after 20:00
    return now.weekday == DateTime.sunday && now.hour >= 20;
  }

  /// Analyzes last week's behavior logs and returns suggested profile updates
  Future<Map<RhythmWindow, TimeRange>?> analyzeWeeklyBehavior() async {
    final repo = LiveRhythmRepository.instance;
    final logs = repo.behaviorLogs;

    if (logs.isEmpty) {
      debugPrint('[RhythmEvolution] No behavior logs to analyze');
      return null;
    }

    // Filter logs from last 7 days
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final recentLogs = logs.where((log) {
      final logDate = DateTime.tryParse(log['completedAt'] as String? ?? '');
      return logDate != null && logDate.isAfter(weekAgo);
    }).toList();

    if (recentLogs.length < 5) {
      debugPrint(
          '[RhythmEvolution] Not enough recent logs: ${recentLogs.length}');
      return null;
    }

    // Group completions by hour and window type
    final hourlyCompletions = <int, List<RhythmWindow>>{};

    for (final log in recentLogs) {
      final timestampStr = log['completedAt'] as String?;
      final windowStr = log['actualWindow'] as String?;

      if (timestampStr == null || windowStr == null) continue;

      final timestamp = DateTime.tryParse(timestampStr);
      if (timestamp == null) continue;

      final window = RhythmWindow.values.firstWhere(
        (w) => w.name == windowStr,
        orElse: () => RhythmWindow.focus,
      );

      final hour = timestamp.hour;
      hourlyCompletions.putIfAbsent(hour, () => []).add(window);
    }

    // Find peak hours for each window type
    final windowPeakHours = <RhythmWindow, List<int>>{};

    for (final entry in hourlyCompletions.entries) {
      final hour = entry.key;
      final windows = entry.value;

      // Count windows for this hour
      final windowCounts = <RhythmWindow, int>{};
      for (final w in windows) {
        windowCounts[w] = (windowCounts[w] ?? 0) + 1;
      }

      // If at least 3 completions for a window type at this hour, mark as peak
      for (final wEntry in windowCounts.entries) {
        if (wEntry.value >= 3) {
          windowPeakHours.putIfAbsent(wEntry.key, () => []).add(hour);
        }
      }
    }

    debugPrint('[RhythmEvolution] Peak hours detected: $windowPeakHours');

    // If significant shifts detected, suggest new time ranges
    if (windowPeakHours.isEmpty) {
      debugPrint('[RhythmEvolution] No significant patterns detected');
      return null;
    }

    // Build suggested windows from peak hours
    final suggestions = <RhythmWindow, TimeRange>{};

    for (final entry in windowPeakHours.entries) {
      final window = entry.key;
      final peakHours = entry.value..sort();

      if (peakHours.isEmpty) continue;

      // Use first and last peak hour as range
      final startHour = peakHours.first;
      final endHour = (peakHours.last + 2).clamp(0, 23); // +2 hour buffer

      suggestions[window] = TimeRange(
        startHour: startHour,
        endHour: endHour,
      );
    }

    debugPrint('[RhythmEvolution] Suggested window adjustments: $suggestions');
    return suggestions;
  }

  /// Runs the weekly evolution analysis and updates profile if needed
  Future<bool> runWeeklyEvolution({bool force = false}) async {
    if (!force && !shouldRunEvolution()) {
      return false;
    }

    final repo = LiveRhythmRepository.instance;
    final lastEvolution = repo.lastEvolutionDate;

    // Only run once per week
    if (!force && lastEvolution != null) {
      final daysSinceLastEvolution =
          DateTime.now().difference(lastEvolution).inDays;
      if (daysSinceLastEvolution < 7) {
        debugPrint('[RhythmEvolution] Already ran this week');
        return false;
      }
    }

    final suggestions = await analyzeWeeklyBehavior();

    if (suggestions != null && suggestions.isNotEmpty) {
      // Apply suggestions to profile
      await repo.applyEvolutionSuggestions(suggestions);
      debugPrint('[RhythmEvolution] Profile updated with new suggestions');
      return true;
    }

    // Update last evolution date even if no changes
    await repo.markEvolutionRan();
    return false;
  }
}
