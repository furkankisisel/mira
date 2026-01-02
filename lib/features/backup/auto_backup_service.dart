import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mira/features/profile/backup_repository.dart';
import 'package:mira/features/backup/backup_data_service.dart';

/// Service to handle automatic background backups to Google Drive.
/// Checks strict conditions (time elapsed along with user preference) before uploading data.
class AutoBackupService {
  AutoBackupService._();
  static final AutoBackupService instance = AutoBackupService._();

  static const String _prefAutoBackupEnabled = 'auto_backup_enabled';
  static const String _prefLastAutoBackupTime = 'last_auto_backup_time';
  static const Duration _backupInterval = Duration(hours: 24);

  /// Initialize and check if a backup is needed.
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isEnabled = prefs.getBool(_prefAutoBackupEnabled) ?? false;

      if (!isEnabled) {
        debugPrint('[AutoBackup] Feature disabled.');
        return;
      }

      final lastBackupStr = prefs.getString(_prefLastAutoBackupTime);
      final lastBackup = lastBackupStr != null
          ? DateTime.tryParse(lastBackupStr)
          : null;

      if (lastBackup != null &&
          DateTime.now().difference(lastBackup) < _backupInterval) {
        debugPrint('[AutoBackup] Not enough time passed since last backup.');
        return;
      }

      // Perform backup
      debugPrint('[AutoBackup] Starting auto-backup...');
      await _performBackup(prefs);
    } catch (e) {
      debugPrint('[AutoBackup] Error during initialization check: $e');
    }
  }

  /// Perform the actual backup logic.
  Future<void> _performBackup(SharedPreferences prefs) async {
    try {
      // 1. Collect data
      final data = await BackupDataService.instance.collectBackupData();

      // 2. Upload using BackupRepository (handles auth refresh internally)
      await BackupRepository.instance.uploadBackup(data);

      // 3. Update last backup time
      await prefs.setString(
        _prefLastAutoBackupTime,
        DateTime.now().toIso8601String(),
      );

      debugPrint('[AutoBackup] Backup completed successfully.');
    } catch (e) {
      // Logic failure (e.g. network, auth) - just log and retry next launch
      debugPrint('[AutoBackup] Backup failed: $e');
    }
  }

  /// Toggle ability
  Future<void> setAutoBackupEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefAutoBackupEnabled, enabled);
  }

  Future<bool> isAutoBackupEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefAutoBackupEnabled) ?? false;
  }
}
