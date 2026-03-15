import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'schedule_event.dart';

/// Repository for persisting custom schedule events and merging habit-based
/// events into a unified weekly grid.
class WeeklyScheduleRepository extends ChangeNotifier {
  WeeklyScheduleRepository._();
  static final WeeklyScheduleRepository instance = WeeklyScheduleRepository._();

  static const _storageKey = 'weekly_schedule_events_v1';

  final List<ScheduleEvent> _events = [];
  bool _initialized = false;

  List<ScheduleEvent> get events => List.unmodifiable(_events);

  // ── Initialization ──────────────────────────────────────────────────────

  Future<void> initialize() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List;
        _events.clear();
        for (final item in list) {
          _events.add(ScheduleEvent.fromJson(item as Map<String, dynamic>));
        }
      } catch (_) {
        // corrupted data – start fresh
        _events.clear();
      }
    }
    _initialized = true;
    notifyListeners();
  }

  /// Reloads data from storage (e.g., after restoring a backup)
  Future<void> reload() async {
    _initialized = false;
    await initialize();
  }

  // ── CRUD ────────────────────────────────────────────────────────────────

  Future<void> addEvent(ScheduleEvent event) async {
    _events.add(event);
    await _persist();
    notifyListeners();
  }

  Future<void> addEvents(List<ScheduleEvent> events) async {
    _events.addAll(events);
    await _persist();
    notifyListeners();
  }

  Future<void> updateEvent(ScheduleEvent event) async {
    final idx = _events.indexWhere((e) => e.id == event.id);
    if (idx != -1) {
      _events[idx] = event;
      await _persist();
      notifyListeners();
    }
  }

  Future<void> removeEvent(String id) async {
    _events.removeWhere((e) => e.id == id);
    await _persist();
    notifyListeners();
  }

  // ── Queries ─────────────────────────────────────────────────────────────

  /// All custom events for a specific week (identified by its Monday date).
  List<ScheduleEvent> getEventsForWeek(DateTime startOfWeek) {
    final String weekKey = _weekStartString(startOfWeek);
    return _events.where((e) {
      if (e.startDate == null)
        return true; // legacy events show on all weeks until edited
      return e.startDate == weekKey;
    }).toList();
  }

  /// Helper to get the canonical string for a week (always Monday)
  static String _weekStartString(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  // ── Persistence ─────────────────────────────────────────────────────────

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(_events.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, json);
  }

  /// Clear all custom events.
  Future<void> wipeAllStoredData() async {
    _events.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    notifyListeners();
  }
}
