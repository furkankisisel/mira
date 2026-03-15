import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../habit/domain/habit_repository.dart';
import '../gamification/gamification_repository.dart';
import '../schedule/domain/weekly_schedule_repository.dart';

/// Service to collect all app data for backup and restore from backup
class BackupDataService {
  BackupDataService._();
  static final BackupDataService instance = BackupDataService._();

  // All SharedPreferences keys that need to be backed up
  static const List<String> _backupKeys = [
    'habits_v2',
    'habits_v1', // legacy migration support
    'habits_streak_visibility_v1',
    'gamification_v1',
    'lists_v1', // habit lists
    'focus_config_v1', // focus settings
    'daily_tasks_v1', // daily tasks
    'categories_v1', // categories
    'finance_transactions_v1', // finance data
    'finance_categories_v1',
    'finance_budgets_v1',
    'visions_v1', // vision board
    'app_settings_v1', // general app settings
    'theme_variant', // theme preference
    'theme_mode', // dark/light mode
    'locale', // language setting
    'onboarding_complete',
    'notification_settings_v1',
    'weekly_schedule_events_v1', // weekly schedules
  ];

  /// Collects all app data into a JSON string for backup
  Future<String> collectBackupData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final backupData = <String, dynamic>{
        'version': 2,
        'createdAt': DateTime.now().toIso8601String(),
        'appName': 'Mira',
        'data': <String, dynamic>{},
      };

      for (final key in _backupKeys) {
        final value = prefs.get(key);
        if (value != null) {
          backupData['data'][key] = value;
          debugPrint('[BackupDataService] Collected key: $key');
        }
      }

      // Also backup any keys we might have missed that start with common prefixes
      final allKeys = prefs.getKeys();
      for (final key in allKeys) {
        if (!_backupKeys.contains(key) &&
            (key.endsWith('_v1') || key.endsWith('_v2'))) {
          final value = prefs.get(key);
          if (value != null) {
            backupData['data'][key] = value;
            debugPrint('[BackupDataService] Collected extra key: $key');
          }
        }
      }

      final jsonString = jsonEncode(backupData);
      debugPrint(
        '[BackupDataService] Backup data size: ${jsonString.length} bytes',
      );
      debugPrint(
        '[BackupDataService] Keys backed up: ${(backupData['data'] as Map).length}',
      );

      return jsonString;
    } catch (e) {
      debugPrint('[BackupDataService] Error collecting backup data: $e');
      rethrow;
    }
  }

  /// Restores app data from a backup JSON string
  Future<void> restoreBackupData(String jsonString) async {
    try {
      debugPrint('[BackupDataService] Starting restore...');
      debugPrint(
        '[BackupDataService] Backup data size: ${jsonString.length} bytes',
      );

      final backupData = jsonDecode(jsonString) as Map<String, dynamic>;

      // Validate backup format
      if (!backupData.containsKey('data')) {
        throw Exception('Geçersiz yedekleme formatı: data alanı bulunamadı');
      }

      final version = backupData['version'] as int? ?? 1;
      debugPrint('[BackupDataService] Backup version: $version');

      final data = backupData['data'] as Map<String, dynamic>;
      debugPrint('[BackupDataService] Keys to restore: ${data.length}');

      final prefs = await SharedPreferences.getInstance();

      // Restore each key
      int restoredCount = 0;
      for (final entry in data.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is String) {
          await prefs.setString(key, value);
          debugPrint('[BackupDataService] Restored key (String): $key');
          restoredCount++;
        } else if (value is bool) {
          await prefs.setBool(key, value);
          debugPrint('[BackupDataService] Restored key (bool): $key');
          restoredCount++;
        } else if (value is int) {
          await prefs.setInt(key, value);
          debugPrint('[BackupDataService] Restored key (int): $key');
          restoredCount++;
        } else if (value is double) {
          await prefs.setDouble(key, value);
          debugPrint('[BackupDataService] Restored key (double): $key');
          restoredCount++;
        } else if (value is List<String>) {
          await prefs.setStringList(key, value);
          debugPrint('[BackupDataService] Restored key (List<String>): $key');
          restoredCount++;
        } else if (value != null) {
          // If value is already decoded (e.g., Map or List), encode it back
          await prefs.setString(key, jsonEncode(value));
          debugPrint('[BackupDataService] Restored key (encoded): $key');
          restoredCount++;
        }
      }

      debugPrint('[BackupDataService] Total keys restored: $restoredCount');

      // Reload all repositories to reflect restored data
      await _reloadAllRepositories();

      debugPrint('[BackupDataService] Restore completed successfully');
    } catch (e) {
      debugPrint('[BackupDataService] Error restoring backup data: $e');
      rethrow;
    }
  }

  /// Reloads all repositories after restore to refresh in-memory state
  Future<void> _reloadAllRepositories() async {
    debugPrint('[BackupDataService] Reloading all repositories...');

    try {
      await HabitRepository.instance.reload();
      debugPrint('[BackupDataService] HabitRepository reloaded');
    } catch (e) {
      debugPrint('[BackupDataService] Error reloading HabitRepository: $e');
    }

    try {
      await GamificationRepository.instance.reload();
      debugPrint('[BackupDataService] GamificationRepository reloaded');
    } catch (e) {
      debugPrint(
        '[BackupDataService] Error reloading GamificationRepository: $e',
      );
    }

    // Add other repository reloads as needed
    // FocusRepository, ListRepository, etc. can be added here
    try {
      await WeeklyScheduleRepository.instance.reload();
      debugPrint('[BackupDataService] WeeklyScheduleRepository reloaded');
    } catch (e) {
      debugPrint(
        '[BackupDataService] Error reloading WeeklyScheduleRepository: $e',
      );
    }

    debugPrint('[BackupDataService] All repositories reloaded');
  }
}
