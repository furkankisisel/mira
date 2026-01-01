import 'dart:math';

import 'server_ai_habit_service.dart';

/// Service for generating AI-powered motivational messages for focus items.
///
/// This service creates personalized, context-aware motivational messages
/// based on the type of focus item, its progress, and target.
class FocusMotivationService {
  FocusMotivationService({required this.apiKey})
    : _aiService = ServerAiHabitService(apiKey: apiKey);

  final String apiKey;
  final ServerAiHabitService _aiService;

  /// Generates a motivational message for the focus item.
  ///
  /// Falls back to a local message if AI generation fails.
  Future<String> generateMotivation({
    required String focusTitle,
    String? focusDescription,
    required String type,
    required int currentProgress,
    required int targetCount,
    String? unit,
    bool isCompleted = false,
    int streak = 0,
    String? category,
    String? startDate,
    String? frequency,
    int missedDays = 0,
    String? habitType,
  }) async {
    // If already completed, return a celebration message
    if (isCompleted) {
      return _getCompletionMessage(focusTitle);
    }

    // Build context for AI
    final progressPercent = targetCount > 0
        ? ((currentProgress / targetCount) * 100).round()
        : 0;

    final unitStr = unit ?? '';

    // Try AI-generated message first
    try {
      final prompt = _buildPrompt(
        title: focusTitle,
        description: focusDescription,
        type: type,
        currentProgress: currentProgress,
        targetCount: targetCount,
        unit: unitStr,
        progressPercent: progressPercent,
        streak: streak,
        category: category,
        startDate: startDate,
        frequency: frequency,
        missedDays: missedDays,
        habitType: habitType,
      );

      // Use sendSupportMessage with a focused motivation request
      final motivationRequest =
          '''
Sen Mira'sın, kullanıcının kişisel asistanı ve yol arkadaşısın. Aşağıdaki aktivite için kullanıcıya özel, o aktiviteyle doğrudan ilgili, motive edici ve samimi bir mesaj yaz.

ÖNEMLİ KURALLAR:
- Mesaj KESİNLİKLE aktivitenin başlığı, açıklaması ve özelliklerine göre kişiselleştirilmiş olsun.
- Eğer "gündür yapılmadı" bilgisi varsa, bunu nazikçe hatırlat ve küçük bir adımla başlamayı öner (örneğin: timer alışkanlıksa "3 gündür koşmadın, belki 5 dakikayla başlarsın?" gibi).
- Eğer yüksek bir seri (streak) varsa, bunu öv ve devam etmeye teşvik et.
- Alışkanlık tipine göre mesajı özelleştir:
  - Timer: süre veya dakika bazlı öneriler
  - Numerical: sayı bazlı küçük hedefler
  - Subtasks: adım adım ilerleme
  - Simple: basit tamamlama teşviki
- Çok kısa ve öz ol (maksimum 1-2 cümle).
- Samimi, destekleyici ve neşeli bir ton kullan.
- Emoji kullanabilirsin.
- Yakın bir arkadaş gibi konuş, formal veya koç gibi olma.
- Sadece mesajı yaz, tırnak işareti veya ek açıklama kullanma.

$prompt
''';

      final response = await _aiService.sendSupportMessage([
        {'role': 'user', 'content': motivationRequest},
      ], languageCode: 'tr');

      if (response.isNotEmpty) {
        return response.trim();
      }
    } catch (e) {
      // Fall back to local messages on error
    }

    // Fallback to local messages
    return _getLocalMotivation(
      focusTitle: focusTitle,
      type: type,
      currentProgress: currentProgress,
      targetCount: targetCount,
      unit: unitStr,
      progressPercent: progressPercent,
    );
  }

  String _buildPrompt({
    required String title,
    String? description,
    required String type,
    required int currentProgress,
    required int targetCount,
    required String unit,
    required int progressPercent,
    required int streak,
    String? category,
    String? startDate,
    String? frequency,
    int missedDays = 0,
    String? habitType,
  }) {
    final typeStr = type == 'habit' ? 'alışkanlık' : 'günlük görev';
    final habitTypeStr = habitType ?? 'simple';

    final sb = StringBuffer();
    sb.writeln('Aktivite: "$title"');
    sb.writeln('Tür: $typeStr');
    sb.writeln('Alışkanlık Tipi: $habitTypeStr');
    if (description != null && description.isNotEmpty) {
      sb.writeln('Detay: $description');
    }
    if (category != null && category.isNotEmpty) {
      sb.writeln('Kategori: $category');
    }

    sb.writeln(
      'Durum: ${targetCount > 0 ? '$progressPercent% tamamlandı ($currentProgress/$targetCount $unit)' : 'Henüz başlanmadı'}',
    );

    if (streak > 0) {
      sb.writeln('Mevcut Seri (Streak): $streak gün 🔥');
    } else {
      sb.writeln('Mevcut Seri: Henüz seri yok');
    }

    if (missedDays > 0) {
      sb.writeln('Son $missedDays gündür bu alışkanlık yapılmadı ⚠️');
    }

    if (startDate != null) {
      sb.writeln('Başlangıç Tarihi: $startDate');
    }

    if (frequency != null) {
      sb.writeln('Sıklık: $frequency');
    }

    return sb.toString();
  }

  String _getLocalMotivation({
    required String focusTitle,
    required String type,
    required int currentProgress,
    required int targetCount,
    required String unit,
    required int progressPercent,
  }) {
    final random = Random();

    // Progress-based messages
    if (progressPercent == 0) {
      final messages = [
        'Harika bir gün için mükemmel bir başlangıç! 🌟',
        'Bugün "$focusTitle" ile fark yarat!',
        'Küçük bir adımla başla, gerisi gelir 💪',
        'Her ustanın bir zamanlar acemi olduğunu unutma!',
        'Bugün senin günün! Haydi başlayalım 🚀',
      ];
      return messages[random.nextInt(messages.length)];
    }

    if (progressPercent > 0 && progressPercent < 50) {
      final messages = [
        'Güzel gidiyorsun! Yarı yola kadar az kaldı 💪',
        'Her adım seni hedefe yaklaştırıyor!',
        'Momentumu koru, harika ilerliyorsun!',
        'Bu tempoda devam et, başarı yakın 🌟',
      ];
      return messages[random.nextInt(messages.length)];
    }

    if (progressPercent >= 50 && progressPercent < 100) {
      final messages = [
        'Yarısından fazlasını tamamladın! Harika gidiyorsun 🔥',
        'Bitiş çizgisi görünüyor, son hamle senin!',
        'Bu kadar yol geldin, bırakma! 💪',
        'Neredeyse tamam, son bir gayret!',
      ];
      return messages[random.nextInt(messages.length)];
    }

    return 'Bugün senin günün! 🌟';
  }

  String _getCompletionMessage(String focusTitle) {
    final random = Random();
    final messages = [
      'Tebrikler! "$focusTitle" hedefini tamamladın! 🎉',
      'Harika iş! Bugünkü odak noktanı başarıyla bitirdin 🏆',
      'Bu başarıyı kutla! Hedefine ulaştın ⭐',
      'Süpersin! "$focusTitle" tamam, kendini ödüllendir 🌟',
      'Başardın! Bu azim takdire değer 💪🎉',
    ];
    return messages[random.nextInt(messages.length)];
  }
}
