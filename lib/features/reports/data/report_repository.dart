import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/report_model.dart';

/// Repository for storing and retrieving weekly reports
class ReportRepository extends ChangeNotifier {
  ReportRepository._();
  static final ReportRepository instance = ReportRepository._();

  static const String _reportsKey = 'weekly_reports_v1';

  List<WeeklyReport> _reports = [];
  bool _initialized = false;

  /// All stored reports, sorted by date (newest first)
  List<WeeklyReport> get reports => List.unmodifiable(_reports);

  /// Get reports by type
  List<WeeklyReport> getReportsByType(ReportType type) {
    return _reports.where((r) => r.type == type).toList();
  }

  /// Get most recent report
  WeeklyReport? get latestReport => _reports.isNotEmpty ? _reports.first : null;

  /// Initialize repository
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_reportsKey);

      if (raw != null) {
        final list = jsonDecode(raw) as List;
        _reports = list
            .map((e) => WeeklyReport.fromJson(e as Map<String, dynamic>))
            .toList();
        // Sort by generatedAt descending
        _reports.sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
      }

      _initialized = true;
      notifyListeners();
      debugPrint('[ReportRepository] Loaded ${_reports.length} reports');
    } catch (e) {
      debugPrint('[ReportRepository] Error loading reports: $e');
    }
  }

  /// Add a new report
  Future<void> addReport(WeeklyReport report) async {
    _reports.insert(0, report); // Add to beginning (newest first)
    await _persist();
    notifyListeners();
    debugPrint('[ReportRepository] Added report: ${report.title}');
  }

  /// Delete a report
  Future<void> deleteReport(String id) async {
    _reports.removeWhere((r) => r.id == id);
    await _persist();
    notifyListeners();
  }

  /// Check if a report already exists for this week and type
  bool hasReportForWeek(DateTime weekStart, ReportType type) {
    return _reports.any((r) =>
        r.type == type &&
        r.weekStart.year == weekStart.year &&
        r.weekStart.month == weekStart.month &&
        r.weekStart.day == weekStart.day);
  }

  /// Persist reports to storage
  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(_reports.map((r) => r.toJson()).toList());
      await prefs.setString(_reportsKey, json);
    } catch (e) {
      debugPrint('[ReportRepository] Error persisting reports: $e');
    }
  }

  /// Clear all reports
  Future<void> clearAll() async {
    _reports.clear();
    await _persist();
    notifyListeners();
  }
}
