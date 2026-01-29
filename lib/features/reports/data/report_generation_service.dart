import 'package:flutter/foundation.dart';
import '../domain/report_model.dart';
import 'report_repository.dart';
import '../../habit/domain/habit_repository.dart';
import '../../habit/domain/daily_task_repository.dart';
import '../../habit/domain/habit_model.dart';
import '../../mood/data/detailed_mood_repository.dart';
import '../../finance/data/transaction_repository.dart';
import '../../finance/data/transaction_model.dart';
import '../../habit/data/server_ai_habit_service.dart';
import '../../../core/config/api_config.dart';

/// Service for generating AI-powered weekly reports
class ReportGenerationService {
  ReportGenerationService._();
  static final ReportGenerationService instance = ReportGenerationService._();

  final HabitRepository _habitRepo = HabitRepository.instance;
  final DailyTaskRepository _taskRepo = DailyTaskRepository.instance;
  final DetailedMoodRepository _moodRepo = DetailedMoodRepository();
  final TransactionRepository _financeRepo = TransactionRepository();
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
    await _financeRepo.initialize();
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

    // --- HABITS DATA ---
    if (type == ReportType.habits || type == ReportType.combined) {
      final habits = _habitRepo.habits;
      int totalCompletions = 0;
      int expectedCompletions = 0;
      final dailyRates = <String, double>{};

      // Calculate daily rates
      for (int i = 0; i < 7; i++) {
        final date = start.add(Duration(days: i));
        final dateKey = _formatDateKey(date);

        int dayCompleted = 0;
        int dayTotal = 0;

        for (final h in habits) {
          // Check active
          if (dateKey.compareTo(h.startDate) >= 0 &&
              (h.endDate == null ||
                  (h.endDate != null && dateKey.compareTo(h.endDate!) <= 0))) {
            dayTotal++;
            if (HabitRepository.evaluateCompletionFromLog(h, dateKey)) {
              dayCompleted++;
            }
          }
        }

        totalCompletions += dayCompleted;
        expectedCompletions += dayTotal;
        dailyRates[dateKey] =
            dayTotal > 0 ? (dayCompleted / dayTotal) * 100 : 0.0;
      }

      // Identify top/struggling habits with full data
      final sorted = List<Habit>.from(habits)
        ..sort((a, b) => b.currentStreak.compareTo(a.currentStreak));

      final topHabits = sorted
          .where((h) => h.currentStreak > 0)
          .take(3)
          .map((h) => {
                'id': h.id,
                'title': h.title,
                'emoji': h.emoji ?? '',
                'streak': h.currentStreak,
                'color': h.color.value.toString(),
              })
          .toList();

      final strugglingHabits = habits
          .where((h) => h.currentStreak == 0 && !h.isCompleted)
          .take(3)
          .map((h) => {
                'id': h.id,
                'title': h.title,
                'emoji': h.emoji ?? '',
                'streak': h.currentStreak,
              })
          .toList();

      // Find most productive hour (placeholder - would need completion timestamps)
      // For now derive from daily patterns
      final bestDay =
          dailyRates.entries.reduce((a, b) => a.value > b.value ? a : b);

      data['habitStats'] = {
        'totalHabits': habits.length,
        'completions': totalCompletions,
        'expected': expectedCompletions,
        'rate': expectedCompletions > 0
            ? (totalCompletions / expectedCompletions * 100).round()
            : 0,
        'dailyRates': dailyRates,
        'topHabits': topHabits,
        'strugglingHabits': strugglingHabits,
        'bestDay': bestDay.key,
        'bestDayRate': bestDay.value.round(),
      };
    }

    // --- MOOD DATA ---
    if (type == ReportType.mood || type == ReportType.combined) {
      try {
        final stats =
            await _moodRepo.getMoodStatistics(startDate: start, endDate: end);
        if (stats.totalEntries > 0) {
          data['moodStats'] = {
            'entries': stats.totalEntries,
            'avgScore': stats.averageMoodScore,
            'mostCommon': stats.mostCommonMood.name,
            'distribution':
                stats.moodDistribution.map((k, v) => MapEntry(k.name, v)),
          };
        } else {
          data['moodStats'] = {'entries': 0};
        }
      } catch (e) {
        data['moodStats'] = {'entries': 0};
      }
    }

    // --- FINANCE DATA ---
    if (type == ReportType.finance || type == ReportType.combined) {
      final allTx =
          _financeRepo.all(); // Assuming all loaded, better to filter by date
      // Filter for this week
      final weekTx = allTx.where((tx) {
        // Handle recurrence properly in real app, simplified here to use date check
        // Or better use _financeRepo.forRange similar to forMonth logic.
        // For now, let's just filter explicit dates if repository doesn't support range
        // If repo loads ALL transactions, we can check date roughly.
        // Assuming non-recurring for simplicity or reusing logic needs access to forMonth logic.
        // Let's rely on simple date check + basic recurring.
        // Ideally _financeRepo.forRange(start, end)
        return tx.date
                .isAfter(start.subtract(const Duration(milliseconds: 1))) &&
            tx.date.isBefore(end.add(const Duration(days: 1)));
      }).toList();

      double income = 0;
      double expense = 0;
      final categoryExpenses = <String, double>{};

      for (final tx in weekTx) {
        if (tx.type == TransactionType.income) {
          income += tx.amount;
        } else {
          expense += tx.amount;
          final catId = tx.categoryId ?? 'Diğer';
          categoryExpenses[catId] = (categoryExpenses[catId] ?? 0) + tx.amount;
        }
      }

      // Sort categories by spending
      final sortedCategories = categoryExpenses.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      String? topCategory;
      String? lowestCategory;
      String? warningCategory;

      if (sortedCategories.isNotEmpty) {
        topCategory = sortedCategories.first.key;
        lowestCategory = sortedCategories.last.key;
        // Warning if any category exceeds 40% of total
        final warningThreshold = expense * 0.4;
        for (final entry in sortedCategories) {
          if (entry.value >= warningThreshold) {
            warningCategory = entry.key;
            break;
          }
        }
      }

      data['financeStats'] = {
        'income': income,
        'expense': expense,
        'savings': income - expense,
        'txCount': weekTx.length,
        'categoryBreakdown': categoryExpenses,
        'topCategory': topCategory,
        'lowestCategory': lowestCategory,
        'warningCategory': warningCategory,
      };
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
        'Sen bir kişisel gelişim koçusun. Haftalık ${type.displayName} için analiz hazırla.');
    sb.writeln();
    sb.writeln('=== VERİLER ===');

    if (data.containsKey('habitStats')) {
      final stats = data['habitStats'] as Map<String, dynamic>;
      final topHabits = stats['topHabits'] as List? ?? [];
      final strugglingHabits = stats['strugglingHabits'] as List? ?? [];

      sb.writeln('ALIŞKANLIKLAR:');
      sb.writeln('• Toplam: ${stats['totalHabits']} alışkanlık');
      sb.writeln('• Tamamlanan: ${stats['completions']}/${stats['expected']}');
      sb.writeln('• Başarı Oranı: %${stats['rate']}');
      sb.writeln(
          '• En Verimli Gün: ${stats['bestDay']} (%${stats['bestDayRate']})');
      if (topHabits.isNotEmpty) {
        sb.writeln(
            '• En Başarılı: ${topHabits.map((h) => h['title']).join(', ')}');
      }
      if (strugglingHabits.isNotEmpty) {
        sb.writeln(
            '• Zorlananlar: ${strugglingHabits.map((h) => h['title']).join(', ')}');
      }
    }

    if (data.containsKey('moodStats')) {
      final stats = data['moodStats'] as Map<String, dynamic>;
      sb.writeln('RUH HALİ:');
      sb.writeln('• Kayıt: ${stats['entries']} adet');
      if (stats['avgScore'] != null)
        sb.writeln('• Ort. Puan: ${stats['avgScore']}');
      if (stats['mostCommon'] != null)
        sb.writeln('• Baskın Mod: ${stats['mostCommon']}');
    }

    if (data.containsKey('financeStats')) {
      final stats = data['financeStats'] as Map<String, dynamic>;
      sb.writeln('FİNANS:');
      sb.writeln('• Gelir: ${stats['income']}₺');
      sb.writeln('• Gider: ${stats['expense']}₺');
      sb.writeln('• Net: ${stats['savings']}₺');
      if (stats['topCategory'] != null)
        sb.writeln('• En Çok Harcanan: ${stats['topCategory']}');
      if (stats['warningCategory'] != null)
        sb.writeln('• Dikkat: ${stats['warningCategory']}');
    }

    sb.writeln();
    sb.writeln('=== ÇIKTI FORMATI ===');
    sb.writeln('Aşağıdaki başlıkları AYNEN kullan ve her bölümü doldur:');
    sb.writeln();
    sb.writeln('## 📊 Genel Değerlendirme');
    sb.writeln('(2-3 cümle özet)');
    sb.writeln();
    sb.writeln('## ✅ Başarılar');
    sb.writeln('• (madde 1)');
    sb.writeln('• (madde 2)');
    sb.writeln();
    sb.writeln('## ⚠️ Gelişim Alanları');
    sb.writeln('• (madde 1)');
    sb.writeln('• (madde 2)');
    sb.writeln();
    sb.writeln('## 💡 Öneriler');
    sb.writeln('• (somut aksiyon 1)');
    sb.writeln('• (somut aksiyon 2)');
    sb.writeln();
    sb.writeln('## 🎯 Haftalık Hedef');
    sb.writeln('(tek cümle motivasyon)');
    sb.writeln();
    sb.writeln('=== KURALLAR ===');
    sb.writeln('• Kısa ve net cümleler kullan');
    sb.writeln('• Her madde tek satır olsun');
    sb.writeln('• Emoji kullan ama abartma');
    sb.writeln('• Türkçe yaz, samimi ve motive edici ol');

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
