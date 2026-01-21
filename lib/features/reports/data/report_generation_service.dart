import 'package:flutter/foundation.dart';
import '../domain/report_model.dart';
import 'report_repository.dart';
import '../../habit/domain/habit_repository.dart';
import '../../habit/domain/daily_task_repository.dart';
import '../../mood/data/detailed_mood_repository.dart';
import '../../habit/data/server_ai_habit_service.dart';
import '../../../core/config/api_config.dart';

/// Service for generating AI-powered weekly reports
class ReportGenerationService {
  ReportGenerationService._();
  static final ReportGenerationService instance = ReportGenerationService._();

  final HabitRepository _habitRepo = HabitRepository.instance;
  final DailyTaskRepository _taskRepo = DailyTaskRepository.instance;
  final DetailedMoodRepository _moodRepo = DetailedMoodRepository();
  ServerAiHabitService? _aiService;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    final apiKey = ApiConfig.groqApiKey;
    if (apiKey.isNotEmpty) {
      _aiService = ServerAiHabitService(apiKey: apiKey);
    }

    await _habitRepo.initialize();
    await _taskRepo.initialize();
    _initialized = true;
  }

  /// Generate a weekly report
  Future<WeeklyReport?> generateReport(ReportType type) async {
    await initialize();

    // Calculate week bounds
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    // Check if report already exists
    if (ReportRepository.instance.hasReportForWeek(weekStart, type)) {
      debugPrint('[ReportGeneration] Report already exists for this week');
      return null;
    }

    // Collect data for the week
    final weekData = await _collectWeekData(weekStart, weekEnd, type);

    // Generate AI content
    String content;
    if (_aiService != null) {
      content = await _generateAiContent(weekData, type);
    } else {
      content = _generateFallbackContent(weekData, type);
    }

    // Create report
    final report = WeeklyReport(
      id: 'report_${DateTime.now().millisecondsSinceEpoch}',
      weekStart: weekStart,
      weekEnd: weekEnd,
      type: type,
      title: '${type.displayName} - ${_formatDate(weekStart)}',
      content: content,
      generatedAt: DateTime.now(),
      metadata: weekData,
    );

    // Save report
    await ReportRepository.instance.addReport(report);

    return report;
  }

  /// Collect week data based on report type
  Future<Map<String, dynamic>> _collectWeekData(
    DateTime start,
    DateTime end,
    ReportType type,
  ) async {
    final data = <String, dynamic>{
      'weekStart': start.toIso8601String(),
      'weekEnd': end.toIso8601String(),
    };

    if (type == ReportType.habits || type == ReportType.combined) {
      // Habit stats - simplified (count all habits for each day)
      final habits = _habitRepo.habits;
      int totalCompletions = 0;

      for (final habit in habits) {
        for (int i = 0; i < 7; i++) {
          final date = start.add(Duration(days: i));
          final dateKey = _formatDateKey(date);

          if (HabitRepository.evaluateCompletionFromLog(habit, dateKey)) {
            totalCompletions++;
          }
        }
      }

      // Expected = habits * 7 days (simplified)
      final totalExpected = habits.length * 7;

      data['habitStats'] = {
        'totalHabits': habits.length,
        'completions': totalCompletions,
        'expected': totalExpected,
        'rate': totalExpected > 0
            ? (totalCompletions / totalExpected * 100).round()
            : 0,
      };
    }

    if (type == ReportType.mood || type == ReportType.combined) {
      // Mood entries - simplified
      try {
        final latestEntry = await _moodRepo.getLatestMoodEntry();
        if (latestEntry != null) {
          data['moodStats'] = {
            'entries': 1,
            'latestMood': latestEntry.mood.name,
          };
        } else {
          data['moodStats'] = {'entries': 0};
        }
      } catch (e) {
        data['moodStats'] = {'entries': 0};
      }
    }

    return data;
  }

  /// Generate AI content
  Future<String> _generateAiContent(
    Map<String, dynamic> data,
    ReportType type,
  ) async {
    try {
      final prompt = _buildReportPrompt(data, type);

      final response = await _aiService!.sendSupportMessage(
        [
          {'role': 'user', 'content': prompt}
        ],
        languageCode: 'tr',
      );

      return response['message'] as String? ??
          _generateFallbackContent(data, type);
    } catch (e) {
      debugPrint('[ReportGeneration] AI error: $e');
      return _generateFallbackContent(data, type);
    }
  }

  String _buildReportPrompt(Map<String, dynamic> data, ReportType type) {
    final sb = StringBuffer();
    sb.writeln(
        'Haftalık ${type.displayName} için detaylı bir analiz ve öneriler hazırla.');
    sb.writeln();
    sb.writeln('VERİLER:');

    if (data.containsKey('habitStats')) {
      final stats = data['habitStats'] as Map<String, dynamic>;
      sb.writeln('- Toplam alışkanlık: ${stats['totalHabits']}');
      sb.writeln('- Tamamlanan: ${stats['completions']}/${stats['expected']}');
      sb.writeln('- Başarı oranı: %${stats['rate']}');
    }

    if (data.containsKey('moodStats')) {
      final stats = data['moodStats'] as Map<String, dynamic>;
      sb.writeln('- Ruh hali kayıtları: ${stats['entries']}');
    }

    sb.writeln();
    sb.writeln('KURALLAR:');
    sb.writeln('- Markdown formatında yaz');
    sb.writeln('- 3-4 paragraf');
    sb.writeln('- Pozitif ve motive edici ol');
    sb.writeln('- Somut öneriler ver');

    return sb.toString();
  }

  String _generateFallbackContent(Map<String, dynamic> data, ReportType type) {
    final sb = StringBuffer();

    sb.writeln('## ${type.emoji} ${type.displayName}');
    sb.writeln();

    if (data.containsKey('habitStats')) {
      final stats = data['habitStats'] as Map<String, dynamic>;
      sb.writeln('### Alışkanlık Performansı');
      sb.writeln(
          'Bu hafta **${stats['completions']}/${stats['expected']}** alışkanlık tamamlandı.');
      sb.writeln('Başarı oranı: **%${stats['rate']}**');
      sb.writeln();

      if (stats['rate'] >= 80) {
        sb.writeln('🎉 Harika bir hafta geçirdin! Bu tempoyu koru.');
      } else if (stats['rate'] >= 50) {
        sb.writeln(
            '💪 İyi gidiyorsun! Biraz daha odaklanarak daha iyi sonuçlar alabilirsin.');
      } else {
        sb.writeln(
            '🌱 Bu hafta biraz zorlandın. Alışkanlıklarını gözden geçirmeni öneririm.');
      }
    }

    if (data.containsKey('moodStats')) {
      final stats = data['moodStats'] as Map<String, dynamic>;
      sb.writeln();
      sb.writeln('### Ruh Hali');
      sb.writeln('Bu hafta **${stats['entries']}** ruh hali kaydı yapıldı.');
    }

    return sb.toString();
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
