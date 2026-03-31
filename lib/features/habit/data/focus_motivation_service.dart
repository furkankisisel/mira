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
    String languageCode = 'tr',
  }) async {
    // If already completed, return a celebration message
    if (isCompleted) {
      return _getCompletionMessage(focusTitle, languageCode: languageCode);
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
        languageCode: languageCode,
      );

      // Use sendSupportMessage with a focused motivation request
      final motivationRequest =
          languageCode == 'tr'
          ? '''
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
'''
          : '''
You are Mira, the user's personal assistant and companion. Write a warm, specific motivational message directly related to the activity below.

IMPORTANT RULES:
- Personalize the message based on title, description, and activity properties.
- If there is missed-day info, gently acknowledge it and suggest a tiny restart step.
- If streak is high, praise consistency and encourage continuation.
- Adapt by habit type:
  - Timer: suggest minutes/time-based steps
  - Numerical: suggest small number-based steps
  - Subtasks: suggest step-by-step momentum
  - Simple: clear completion encouragement
- Keep it very short (max 1-2 sentences).
- Tone should be friendly, supportive, and upbeat.
- Emojis are allowed.
- Sound like a close friend, not formal.
- Return only the message, no quotes or extra text.

$prompt
''';

      final responseMap = await _aiService.sendSupportMessage([
        {'role': 'user', 'content': motivationRequest},
      ], languageCode: languageCode);

      final message = responseMap['message'] as String? ?? '';
      if (message.isNotEmpty) {
        return message.trim();
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
      languageCode: languageCode,
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
    String languageCode = 'tr',
  }) {
    final bool isTr = languageCode == 'tr';
    final typeStr = type == 'habit'
        ? (isTr ? 'alışkanlık' : 'habit')
        : (isTr ? 'günlük görev' : 'daily task');
    final habitTypeStr = habitType ?? 'simple';

    final sb = StringBuffer();
    sb.writeln('${isTr ? 'Aktivite' : 'Activity'}: "$title"');
    sb.writeln('${isTr ? 'Tür' : 'Type'}: $typeStr');
    sb.writeln('${isTr ? 'Alışkanlık Tipi' : 'Habit Type'}: $habitTypeStr');
    if (description != null && description.isNotEmpty) {
      sb.writeln('${isTr ? 'Detay' : 'Details'}: $description');
    }
    if (category != null && category.isNotEmpty) {
      sb.writeln('${isTr ? 'Kategori' : 'Category'}: $category');
    }

    sb.writeln(
      '${isTr ? 'Durum' : 'Status'}: ${targetCount > 0 ? '$progressPercent% ${isTr ? 'tamamlandı' : 'completed'} ($currentProgress/$targetCount $unit)' : (isTr ? 'Henüz başlanmadı' : 'Not started yet')}',
    );

    if (streak > 0) {
      sb.writeln(
        '${isTr ? 'Mevcut Seri (Streak)' : 'Current Streak'}: $streak ${isTr ? 'gün' : 'days'} 🔥',
      );
    } else {
      sb.writeln(
        '${isTr ? 'Mevcut Seri' : 'Current Streak'}: ${isTr ? 'Henüz seri yok' : 'No streak yet'}',
      );
    }

    if (missedDays > 0) {
      sb.writeln(
        isTr
            ? 'Son $missedDays gündür bu alışkanlık yapılmadı ⚠️'
            : 'This habit has not been done for $missedDays days ⚠️',
      );
    }

    if (startDate != null) {
      sb.writeln('${isTr ? 'Başlangıç Tarihi' : 'Start Date'}: $startDate');
    }

    if (frequency != null) {
      sb.writeln('${isTr ? 'Sıklık' : 'Frequency'}: $frequency');
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
    String languageCode = 'tr',
  }) {
    final bool isTr = languageCode == 'tr';
    final random = Random();

    // Progress-based messages
    if (progressPercent == 0) {
      final messages = [
        isTr
            ? 'Harika bir gün için mükemmel bir başlangıç! 🌟'
            : 'A perfect start for a great day! 🌟',
        isTr
            ? 'Bugün "$focusTitle" ile fark yarat!'
            : 'Make a difference with "$focusTitle" today!',
        isTr
            ? 'Küçük bir adımla başla, gerisi gelir 💪'
            : 'Start with a tiny step, the rest will follow 💪',
        isTr
            ? 'Her ustanın bir zamanlar acemi olduğunu unutma!'
            : 'Every master was once a beginner!',
        isTr ? 'Bugün senin günün! Haydi başlayalım 🚀' : 'Today is your day. Let\'s go 🚀',
      ];
      return messages[random.nextInt(messages.length)];
    }

    if (progressPercent > 0 && progressPercent < 50) {
      final messages = [
        isTr
            ? 'Güzel gidiyorsun! Yarı yola kadar az kaldı 💪'
            : 'Great progress! Halfway is close 💪',
        isTr
            ? 'Her adım seni hedefe yaklaştırıyor!'
            : 'Every step brings you closer to your goal!',
        isTr
            ? 'Momentumu koru, harika ilerliyorsun!'
            : 'Keep the momentum, you are doing great!',
        isTr
            ? 'Bu tempoda devam et, başarı yakın 🌟'
            : 'Keep this pace, success is near 🌟',
      ];
      return messages[random.nextInt(messages.length)];
    }

    if (progressPercent >= 50 && progressPercent < 100) {
      final messages = [
        isTr
            ? 'Yarısından fazlasını tamamladın! Harika gidiyorsun 🔥'
            : 'You are past halfway! Amazing progress 🔥',
        isTr
            ? 'Bitiş çizgisi görünüyor, son hamle senin!'
            : 'The finish line is in sight, one final push!',
        isTr
            ? 'Bu kadar yol geldin, bırakma! 💪'
            : 'You have come this far, do not stop! 💪',
        isTr
            ? 'Neredeyse tamam, son bir gayret!'
            : 'Almost done, one last effort!',
      ];
      return messages[random.nextInt(messages.length)];
    }

    return isTr ? 'Bugün senin günün! 🌟' : 'Today is your day! 🌟';
  }

  String _getCompletionMessage(String focusTitle, {String languageCode = 'tr'}) {
    final bool isTr = languageCode == 'tr';
    final random = Random();
    final messages = [
      isTr
          ? 'Tebrikler! "$focusTitle" hedefini tamamladın! 🎉'
          : 'Congrats! You completed your "$focusTitle" goal! 🎉',
      isTr
          ? 'Harika iş! Bugünkü odak noktanı başarıyla bitirdin 🏆'
          : 'Great work! You successfully finished today\'s focus 🏆',
      isTr
          ? 'Bu başarıyı kutla! Hedefine ulaştın ⭐'
          : 'Celebrate this win! You reached your goal ⭐',
      isTr
          ? 'Süpersin! "$focusTitle" tamam, kendini ödüllendir 🌟'
          : 'Awesome! "$focusTitle" is done, reward yourself 🌟',
      isTr
          ? 'Başardın! Bu azim takdire değer 💪🎉'
          : 'You did it! Your consistency is impressive 💪🎉',
    ];
    return messages[random.nextInt(messages.length)];
  }
}
