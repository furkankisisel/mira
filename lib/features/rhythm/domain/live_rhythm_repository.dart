import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'live_rhythm_model.dart';

/// Repository for managing live rhythm profile and state
class LiveRhythmRepository extends ChangeNotifier {
  LiveRhythmRepository._();
  static final LiveRhythmRepository instance = LiveRhythmRepository._();

  static const String _profileKey = 'rhythm_profile_v1';
  static const String _behaviorLogKey = 'rhythm_behavior_log_v1';

  RhythmProfile? _profile;
  bool _initialized = false;

  /// Current rhythm profile, null if not set up
  RhythmProfile? get profile => _profile;

  /// Whether the user has completed rhythm onboarding
  bool get hasProfile => _profile != null;

  /// Get current rhythm window
  RhythmWindow? get currentWindow => _profile?.getCurrentWindow();

  /// Initialize the repository
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_profileKey);

      if (raw != null) {
        final json = jsonDecode(raw) as Map<String, dynamic>;
        _profile = RhythmProfile.fromJson(json);
        debugPrint('[LiveRhythm] Profile loaded: ${_profile?.chronoType}');
      }
    } catch (e) {
      debugPrint('[LiveRhythm] Error loading profile: $e');
      _profile = null;
    }

    _initialized = true;
    notifyListeners();
  }

  /// Save a new rhythm profile
  Future<void> saveProfile(RhythmProfile profile) async {
    _profile = profile;
    await _persist();
    notifyListeners();
    debugPrint('[LiveRhythm] Profile saved: ${profile.chronoType}');
  }

  /// Clear the rhythm profile
  Future<void> clearProfile() async {
    _profile = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
    notifyListeners();
  }

  /// Persist profile to SharedPreferences
  Future<void> _persist() async {
    if (_profile == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_profileKey, jsonEncode(_profile!.toJson()));
    } catch (e) {
      debugPrint('[LiveRhythm] Error persisting profile: $e');
    }
  }

  /// Log a habit completion with timestamp for evolution analysis
  Future<void> logHabitCompletion({
    required String habitId,
    required DateTime completedAt,
    required RhythmWindow? assignedWindow,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_behaviorLogKey);
      List<Map<String, dynamic>> logs = [];

      if (raw != null) {
        logs = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      }

      logs.add({
        'habitId': habitId,
        'completedAt': completedAt.toIso8601String(),
        'assignedWindow': assignedWindow?.name,
        'actualWindow': _profile?.getCurrentWindow(completedAt).name,
      });

      // Keep only last 7 days of logs
      final weekAgo = DateTime.now().subtract(const Duration(days: 7));
      logs = logs.where((log) {
        final completedAt = DateTime.parse(log['completedAt'] as String);
        return completedAt.isAfter(weekAgo);
      }).toList();

      await prefs.setString(_behaviorLogKey, jsonEncode(logs));
    } catch (e) {
      debugPrint('[LiveRhythm] Error logging completion: $e');
    }
  }

  /// Get behavior logs for evolution analysis
  Future<List<Map<String, dynamic>>> getBehaviorLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_behaviorLogKey);
      if (raw == null) return [];
      return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('[LiveRhythm] Error reading behavior logs: $e');
      return [];
    }
  }

  /// Reload data from storage
  Future<void> reload() async {
    _initialized = false;
    _profile = null;
    await initialize();
  }

  /// Wipe all stored data
  Future<void> wipeAllStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
    await prefs.remove(_behaviorLogKey);
    _profile = null;
    notifyListeners();
  }
}
