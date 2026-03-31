import 'dart:math';
import 'package:flutter/material.dart';
import '../../habit/domain/habit_repository.dart';
import '../../habit/domain/daily_task_repository.dart';
import '../../mood/data/detailed_mood_repository.dart';
import '../../habit/data/server_ai_habit_service.dart';
import '../../../core/config/api_config.dart';


/// Data class for user insights
class UserInsight {
  final int totalHabits;
  final int completedToday;
  final int incompleteToday;
  final int longestStreak;
  final int currentStreak;
  final String? todayMood;
  final double completionRate;

  UserInsight({
    required this.totalHabits,
    required this.completedToday,
    required this.incompleteToday,
    required this.longestStreak,
    required this.currentStreak,
    this.todayMood,
    required this.completionRate,
  });
}

// Removed PremiumReportData - now using WeeklyReport

/// Quick action that can navigate the user
class QuickAction {
  final String label;
  final IconData icon;
  final String routeId;

  const QuickAction({
    required this.label,
    required this.icon,
    required this.routeId,
  });
}

/// Response from the assistant
class AssistantResponse {
  final String message;
  final List<QuickAction>? actions;
  final List<String>? quickReplies;
  final UserInsight? insight;

  AssistantResponse({
    required this.message,
    this.actions,
    this.quickReplies,
    this.insight,
  });
}

/// Service for the enhanced Mira AI Assistant
class MiraAssistantService {
  final HabitRepository _habitRepo = HabitRepository.instance;
  final DailyTaskRepository _taskRepo = DailyTaskRepository.instance;
  final DetailedMoodRepository _moodRepo = DetailedMoodRepository();
  ServerAiHabitService? _aiService;

  MiraAssistantService() {
    final apiKey = ApiConfig.groqApiKey;
    if (apiKey.isNotEmpty) {
      _aiService = ServerAiHabitService(apiKey: apiKey);
    }
  }

  /// Collects current user data for AI context
  Future<UserInsight> getUserInsight() async {
    await _habitRepo.initialize();
    await _taskRepo.initialize();

    final habits = _habitRepo.habits;
    final now = DateTime.now();
    final todayKey =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    int completedToday = 0;
    int incompleteToday = 0;
    int longestStreak = 0;

    for (final habit in habits) {
      final isCompleted = habit.isCompleted ||
          HabitRepository.evaluateCompletionFromLog(habit, todayKey);
      if (isCompleted) {
        completedToday++;
      } else {
        incompleteToday++;
      }

      final streak = _habitRepo.consecutiveStreak(habit.id, upTo: now);
      if (streak > longestStreak) longestStreak = streak;
    }

    // Try to get today's mood
    String? todayMood;
    try {
      final latestMood = await _moodRepo.getLatestMoodEntry();
      if (latestMood != null) {
        final moodDate = latestMood.timestamp;
        if (moodDate.year == now.year &&
            moodDate.month == now.month &&
            moodDate.day == now.day) {
          todayMood = latestMood.mood.name;
        }
      }
    } catch (_) {}

    final total = habits.length;
    final rate = total > 0 ? (completedToday / total * 100) : 0.0;

    return UserInsight(
      totalHabits: total,
      completedToday: completedToday,
      incompleteToday: incompleteToday,
      longestStreak: longestStreak,
      currentStreak: longestStreak,
      todayMood: todayMood,
      completionRate: rate,
    );
  }

  // Removed getWeeklyReportData

  /// Predefined quick replies for common questions
  List<String> getDefaultQuickReplies({String languageCode = 'tr'}) {
    final isTr = languageCode == 'tr';
    return isTr
        ? [
            'Bugün ne yapmalıyım?',
            'Beni motive et',
            '🎮 Oyun oynayalım',
            'Günün önerisi',
          ]
        : [
            'What should I do today?',
            'Motivate me',
            '🎮 Let\'s play a game',
            'Today\'s suggestion',
          ];
  }

  /// Handles user message and returns structured response
  Future<AssistantResponse> sendMessage(
    String userMessage,
    List<Map<String, String>> history, {
    String languageCode = 'tr',
  }) async {
    final insight = await getUserInsight();
    final lowerMessage = userMessage.toLowerCase();

    // Local keyword handling
    if (_matchesPattern(lowerMessage, [
      'bugün',
      'ne yapmalı',
      'durum',
      'today',
      'what should i do',
      'status',
    ])) {
      return _buildTodayReportResponse(insight, languageCode: languageCode);
    }
    if (_matchesPattern(lowerMessage, [
      'rapor',
      'istatistik',
      'haftalık',
      'report',
      'stats',
      'weekly',
    ])) {
      return _buildReportResponse(insight, languageCode: languageCode);
    }
    if (_matchesPattern(lowerMessage, [
      'motive',
      'vazgeç',
      'pes',
      'motivate',
      'give up',
    ])) {
      return _buildMotivationResponse(insight, languageCode: languageCode);
    }
    if (_matchesPattern(lowerMessage, [
      'nasıl',
      'oluştur',
      'ekle',
      'how',
      'create',
      'add',
    ])) {
      return _buildHowToCreateHabitResponse(languageCode: languageCode);
    }
    if (_matchesPattern(lowerMessage, [
      'öneri',
      'başka',
      'ne var',
      'suggestion',
      'what else',
      'recommend',
    ])) {
      return _buildFeatureSuggestionResponse(languageCode: languageCode);
    }
    if (_matchesPattern(lowerMessage, [
      'zamanla',
      'timer',
      'pomodoro',
      'focus timer',
    ])) {
      return _buildTimerGuideResponse(languageCode: languageCode);
    }
    if (_matchesPattern(lowerMessage, [
      'ruh',
      'mood',
      'nasıl his',
      'how i feel',
      'feeling',
    ])) {
      return _buildMoodGuideResponse(languageCode: languageCode);
    }

    // Fall back to AI for free-form questions
    if (_aiService != null) {
      try {
        final contextPrompt = _buildContextPrompt(insight);
        final fullHistory = [
          {'role': 'user', 'content': contextPrompt},
          ...history,
          {'role': 'user', 'content': userMessage},
        ];

        final responseMap = await _aiService!.sendSupportMessage(
          fullHistory,
          languageCode: languageCode,
        );

        // Parse message
        final messageText = responseMap['message'] as String? ?? '';

        // Parse action if present
        List<QuickAction>? actions;
        if (responseMap.containsKey('action')) {
          final actionMap = responseMap['action'];
          if (actionMap is Map && actionMap['route_id'] != null) {
            IconData icon = Icons.star;
            final iconName = (actionMap['icon'] as String? ?? '').toLowerCase();
            if (iconName.contains('timer'))
              icon = Icons.timer;
            else if (iconName.contains('add'))
              icon = Icons.add_circle_outline;
            else if (iconName.contains('terrain') ||
                iconName.contains('vision'))
              icon = Icons.terrain;
            else if (iconName.contains('mood'))
              icon = Icons.mood;
            else if (iconName.contains('eco') || iconName.contains('habit'))
              icon = Icons.eco;
            else if (iconName.contains('water') || iconName.contains('finance'))
              icon = Icons.water_drop;

            actions = [
              QuickAction(
                label: actionMap['label'] as String? ?? 'Go',
                icon: icon,
                routeId: actionMap['route_id'] as String,
              ),
            ];
          }
        }

        // Parse quick replies
        List<String>? quickReplies;
        if (responseMap.containsKey('suggested_replies')) {
          quickReplies = (responseMap['suggested_replies'] as List?)
              ?.map((e) => e.toString())
              .toList();
        }

        return AssistantResponse(
          message: _truncateMessage(messageText),
          actions: actions,
          quickReplies:
              quickReplies ??
                  getDefaultQuickReplies(languageCode: languageCode).take(3).toList(),
        );
      } catch (e) {
        return _buildFallbackResponse(languageCode: languageCode);
      }
    }

    return _buildFallbackResponse(languageCode: languageCode);
  }

  bool _matchesPattern(String text, List<String> keywords) {
    return keywords.any((k) => text.contains(k));
  }

  String _buildContextPrompt(UserInsight insight) {
    return '''
Kullanıcı Durumu:
- Toplam alışkanlık: ${insight.totalHabits}
- Bugün tamamlanan: ${insight.completedToday}
- Bugün kalan: ${insight.incompleteToday}
- En uzun seri: ${insight.longestStreak} gün
- Bugünkü ruh hali: ${insight.todayMood ?? 'Bilinmiyor'}
- Tamamlama oranı: %${insight.completionRate.round()}

ÖNEMLİ: Kısa ve öz cevap ver (maks 2 cümle). Samimi ol. Emoji kullanabilirsin.
''';
  }

  String _truncateMessage(String message) {
    // Keep messages concise - max 200 chars
    if (message.length > 200) {
      final truncated = message.substring(0, 197);
      final lastSpace = truncated.lastIndexOf(' ');
      return '${truncated.substring(0, lastSpace)}...';
    }
    return message;
  }

  AssistantResponse _buildTodayReportResponse(
    UserInsight insight, {
    String languageCode = 'tr',
  }) {
    final isTr = languageCode == 'tr';
    String message;
    List<QuickAction> actions = [];

    if (insight.totalHabits == 0) {
      message = isTr
          ? 'Henüz alışkanlık oluşturmadın. Hadi başlayalım! 🌱'
          : 'You have not created a habit yet. Let\'s start! 🌱';
      actions = [
        QuickAction(
          label: isTr ? 'Alışkanlık Oluştur' : 'Create Habit',
          icon: Icons.add_circle_outline,
          routeId: 'create_habit',
        ),
      ];
    } else if (insight.incompleteToday == 0) {
      message = isTr
          ? 'Harika! Bugün tüm alışkanlıklarını tamamladın! 🎉'
          : 'Awesome! You completed all your habits today! 🎉';
    } else {
      message = isTr
          ? '${insight.completedToday}/${insight.totalHabits} alışkanlık tamam. ${insight.incompleteToday} tane kaldı, yapabilirsin! 💪'
          : '${insight.completedToday}/${insight.totalHabits} habits done. ${insight.incompleteToday} left, you can do it! 💪';
      actions = [
        QuickAction(
          label: isTr ? 'Alışkanlıklara Git' : 'Go to Habits',
          icon: Icons.eco,
          routeId: 'habits',
        ),
      ];
    }

    return AssistantResponse(
      message: message,
      actions: actions,
      insight: insight,
      quickReplies: isTr
          ? ['Beni motive et', 'Günün önerisi']
          : ['Motivate me', 'Today\'s suggestion'],
    );
  }

  Future<AssistantResponse> _buildReportResponse(
    UserInsight insight, {
    String languageCode = 'tr',
  }) async {
    final isTr = languageCode == 'tr';
    return AssistantResponse(
      message: isTr
          ? 'Haftalık raporlar bu sürümde mevcut değil. Bugünkü durumunu görmek için "Bugün ne yapmalıyım?" diyebilirsin! 📊'
          : 'Weekly reports are not available in this version yet. Ask "What should I do today?" to see your status. 📊',
      quickReplies: getDefaultQuickReplies(languageCode: languageCode),
    );
  }

  AssistantResponse _buildMotivationResponse(
    UserInsight insight, {
    String languageCode = 'tr',
  }) {
    final isTr = languageCode == 'tr';
    final messages = [
      if (isTr) ...[
        'Her küçük adım seni hedefe yaklaştırıyor. Devam et! 🚀',
        'Dün attığın adımlar bugünü inşa etti. Yarın için de at! 💫',
        'Mükemmel olmak zorunda değilsin, sadece devam etmen yeterli. 🌟',
        'Başarı bir maraton, sprint değil. Adım adım ilerliyorsun! 🏃',
        'Kendine inan, yarı yolu geçtin bile! 💪',
      ] else ...[
        'Every small step brings you closer to your goal. Keep going! 🚀',
        'Yesterday\'s effort built today. Build tomorrow too! 💫',
        'You do not have to be perfect, just keep moving. 🌟',
        'Success is a marathon, not a sprint. One step at a time! 🏃',
        'Believe in yourself, you are already halfway there! 💪',
      ],
    ];

    if (insight.longestStreak > 0) {
      messages.add(isTr
          ? '${insight.longestStreak} günlük serin var! Bu ivmeyi koru 🔥'
          : 'You have a ${insight.longestStreak}-day streak! Keep the momentum 🔥');
    }

    final random = Random();
    final message = messages[random.nextInt(messages.length)];

    return AssistantResponse(
      message: message,
      quickReplies: isTr
          ? ['Bugün ne yapmalıyım?', 'Günün önerisi']
          : ['What should I do today?', 'Today\'s suggestion'],
    );
  }

  AssistantResponse _buildHowToCreateHabitResponse({
    String languageCode = 'tr',
  }) {
    final isTr = languageCode == 'tr';
    return AssistantResponse(
      message: isTr
          ? 'Alışkanlık oluşturmak için aşağıdaki butona tıkla! Basit veya gelişmiş seçenekler var. 🌱'
          : 'Tap the button below to create a habit! You can choose simple or advanced. 🌱',
      actions: [
        QuickAction(
          label: isTr ? 'Alışkanlık Oluştur' : 'Create Habit',
          icon: Icons.add_circle_outline,
          routeId: 'create_habit',
        ),
      ],
      quickReplies: isTr
          ? ['Zamanlayıcı nasıl kullanırım?', 'Ruh hali takibi nedir?']
          : ['How do I use the timer?', 'What is mood tracking?'],
    );
  }

  AssistantResponse _buildFeatureSuggestionResponse({
    String languageCode = 'tr',
  }) {
    final isTr = languageCode == 'tr';
    final suggestions = [
      AssistantResponse(
        message: isTr
            ? 'Zamanlayıcı ile odaklanma seansları yapabilirsin. Pomodoro tekniğini dene! ⏱️'
            : 'Use the timer for focused sessions. Try the Pomodoro technique! ⏱️',
        actions: [
          QuickAction(
            label: isTr ? 'Zamanlayıcıya Git' : 'Go to Timer',
            icon: Icons.timer,
            routeId: 'timer',
          ),
        ],
      ),
      AssistantResponse(
        message: isTr
            ? 'Ruh halini takip etmek, alışkanlık performansını anlamana yardımcı olur! 😊'
            : 'Tracking your mood helps you understand your habit performance! 😊',
        actions: [
          QuickAction(
            label: isTr ? 'Ruh Hali Kaydet' : 'Log Mood',
            icon: Icons.mood,
            routeId: 'mood',
          ),
        ],
      ),
      AssistantResponse(
        message: isTr
            ? 'Vizyon tahtası oluşturarak büyük hedeflerini görselleştirebilirsin! 🎯'
            : 'Create a vision board to visualize your bigger goals! 🎯',
        actions: [
          QuickAction(
            label: isTr ? 'Vizyon Oluştur' : 'Create Vision',
            icon: Icons.terrain,
            routeId: 'vision',
          ),
        ],
      ),
    ];

    final random = Random();
    return suggestions[random.nextInt(suggestions.length)];
  }

  AssistantResponse _buildTimerGuideResponse({
    String languageCode = 'tr',
  }) {
    final isTr = languageCode == 'tr';
    return AssistantResponse(
      message: isTr
          ? 'Zamanlayıcı ile odaklanma seansları, geri sayım veya kronometre kullanabilirsin. Hadi dene! ⏱️'
          : 'With the timer, you can run focus sessions, countdowns, or a stopwatch. Give it a try! ⏱️',
      actions: [
        QuickAction(
          label: isTr ? 'Zamanlayıcıya Git' : 'Go to Timer',
          icon: Icons.timer,
          routeId: 'timer',
        ),
      ],
      quickReplies: isTr
          ? ['Alışkanlık nasıl oluştururum?', 'Günün önerisi']
          : ['How do I create a habit?', 'Today\'s suggestion'],
    );
  }

  AssistantResponse _buildMoodGuideResponse({
    String languageCode = 'tr',
  }) {
    final isTr = languageCode == 'tr';
    return AssistantResponse(
      message: isTr
          ? 'Günlük ruh halini kaydetmek, kalıpları anlamana yardımcı olur. Bugün nasıl hissediyorsun? 😊'
          : 'Logging your daily mood helps you understand patterns. How are you feeling today? 😊',
      actions: [
        QuickAction(
          label: isTr ? 'Ruh Hali Kaydet' : 'Log Mood',
          icon: Icons.mood,
          routeId: 'mood',
        ),
      ],
      quickReplies: isTr
          ? ['Bugün ne yapmalıyım?', 'Beni motive et']
          : ['What should I do today?', 'Motivate me'],
    );
  }

  AssistantResponse _buildFallbackResponse({String languageCode = 'tr'}) {
    final isTr = languageCode == 'tr';
    return AssistantResponse(
      message: isTr
          ? 'Sana nasıl yardımcı olabilirim? Aşağıdaki seçeneklerden birini seçebilirsin! 😊'
          : 'How can I help you? You can pick one of the options below! 😊',
      quickReplies: getDefaultQuickReplies(languageCode: languageCode),
    );
  }
}
