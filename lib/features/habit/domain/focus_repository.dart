import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'focus_model.dart';

/// Repository for managing the daily focus item.
///
/// Handles persistence and retrieval of which habit or task
/// is set as the user's daily focus.
class FocusRepository extends ChangeNotifier {
  FocusRepository._();
  static final FocusRepository instance = FocusRepository._();

  static const String _storageKey = 'focus_item_v1';

  FocusItem? _currentFocus;
  bool _initialized = false;

  /// The current focus item, null if none is set
  FocusItem? get currentFocus => _currentFocus;

  /// Whether a focus is currently set for today
  bool get hasFocus => _currentFocus != null && _isTodayFocus();

  /// Check if the current focus is for today
  bool _isTodayFocus() {
    if (_currentFocus == null) return false;
    return _currentFocus!.dateKey == _todayKey();
  }

  /// Initialize the repository
  Future<void> initialize() async {
    if (_initialized) return;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);

    if (raw != null) {
      try {
        final json = jsonDecode(raw) as Map<String, dynamic>;
        _currentFocus = FocusItem.fromJson(json);
        
        // Clear if it's not for today
        if (!_isTodayFocus()) {
          _currentFocus = null;
          await _persist();
        }
      } catch (e) {
        debugPrint('[FocusRepository] Error loading focus: $e');
        _currentFocus = null;
      }
    }

    _initialized = true;
    notifyListeners();
  }

  /// Set a habit or task as the focus for today
  Future<void> setFocus({
    required String id,
    required FocusType type,
  }) async {
    _currentFocus = FocusItem(
      id: id,
      type: type,
      dateKey: _todayKey(),
    );
    await _persist();
    notifyListeners();
  }

  /// Clear the current focus
  Future<void> clearFocus() async {
    _currentFocus = null;
    await _persist();
    notifyListeners();
  }

  /// Update the AI motivation message for the current focus
  Future<void> updateAiMessage(String message) async {
    if (_currentFocus == null) return;

    _currentFocus = _currentFocus!.copyWith(
      aiMotivationMessage: message,
      lastAiUpdate: DateTime.now(),
    );
    await _persist();
    notifyListeners();
  }

  /// Check if the AI message needs refresh (older than 1 hour)
  bool get needsAiRefresh {
    if (_currentFocus == null) return false;
    if (_currentFocus!.aiMotivationMessage == null) return true;
    if (_currentFocus!.lastAiUpdate == null) return true;

    final hourAgo = DateTime.now().subtract(const Duration(hours: 1));
    return _currentFocus!.lastAiUpdate!.isBefore(hourAgo);
  }

  /// Persist to SharedPreferences
  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentFocus == null) {
      await prefs.remove(_storageKey);
    } else {
      await prefs.setString(_storageKey, jsonEncode(_currentFocus!.toJson()));
    }
  }

  /// Get today's date key in YYYY-MM-DD format
  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Reload data from storage (useful after restore)
  Future<void> reload() async {
    _initialized = false;
    _currentFocus = null;
    await initialize();
  }

  /// Wipe all stored data
  Future<void> wipeAllStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    _currentFocus = null;
    notifyListeners();
  }
}
