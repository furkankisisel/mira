import '../domain/ai_habit_service.dart';
import '../domain/ai_habit_dto.dart';
import '../../vision/domain/ai_vision_dto.dart'; // Added

/// Mock implementation of [AiHabitService] for testing and demo purposes.
/// This simulates an AI response by checking keywords in the prompt.
class MockAiHabitService implements AiHabitService {
  @override
  Future<AiHabitResponse> generateHabits(
    String prompt, {
    String? imageBase64,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final p = prompt.toLowerCase();

    // Check for "fail" keyword to test error handling
    if (p.contains('fail') || p.contains('hata')) {
      throw FormatException('Mock Service Force Fail');
    }

    // Keyword-based response generation
    List<Map<String, dynamic>> rawHabits = [];

    if (p.contains('water') || p.contains('su')) {
      rawHabits.add({
        'title': 'Su İç',
        'description': 'Günde en az 8 bardak su iç',
        'frequency': 'daily',
        'days': ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'],
        'target_value': 8,
        'category': 'Health',
      });
    }

    if (p.contains('study') ||
        p.contains('ders') ||
        p.contains('exam') ||
        p.contains('sınav')) {
      rawHabits.add({
        'title': 'Ders Çalış',
        'description': 'Günde 2 saat odaklı çalışma',
        'frequency': 'daily',
        'days': ['mon', 'tue', 'wed', 'thu', 'fri'],
        'target_value': 2,
        'category': 'Study',
      });
      rawHabits.add({
        'title': 'Kitap Oku',
        'description': 'Her akşam 30 sayfa kitap oku',
        'frequency': 'daily',
        'days': ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'],
        'target_value': 30,
        'category': 'Personal',
      });
    }

    if (p.contains('gym') || p.contains('spor') || p.contains('fitness')) {
      rawHabits.add({
        'title': 'Spor Yap',
        'description': 'Haftada 3 gün spor salonuna git',
        'frequency': 'weekly',
        'days': ['mon', 'wed', 'fri'],
        'target_value': 1,
        'category': 'Health',
      });
    }

    if (p.contains('code') || p.contains('yazılım')) {
      rawHabits.add({
        'title': 'Kod Yaz',
        'description': 'Her gün Git commit at',
        'frequency': 'daily',
        'days': ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'],
        'target_value': 1,
        'category': 'Study',
      });
    }

    // Default fallback if no keywords matched
    if (rawHabits.isEmpty) {
      rawHabits.add({
        'title': 'Erken Kalk',
        'description': 'Her sabah 07:00\'de uyan',
        'frequency': 'daily',
        'days': ['mon', 'tue', 'wed', 'thu', 'fri'],
        'target_value': 1,
        'category': 'Personal',
      });
      rawHabits.add({
        'title': 'Yürüyüş Yap',
        'description': 'Günde 30 dakika yürüyüş',
        'frequency': 'daily',
        'days': ['sat', 'sun'],
        'target_value': 30,
        'category': 'Health',
      });
    }

    final responseJson = {'habits': rawHabits};

    // Simulate "Strict JSON" issues by randomly corrupting if 'garbage' keyword is used?
    // Not needed for now, let's keep it simple.

    return AiHabitResponse.fromJson(responseJson);
  }

  @override
  Future<AiChatResponse> sendMessage(
    List<Map<String, String>> history, {
    List<String>? existingHabits,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return AiChatResponse(
      message:
          "Bu bir mock cevaptır. Gerçek AI servisi (Groq) kullanıldığında burada sohbet edebilirsiniz.",
    );
  }

  @override
  Future<AiVisionDto> generateVisionBoard(String prompt) async {
    await Future.delayed(const Duration(seconds: 2));

    // Mock response
    return AiVisionDto(
      title: "Digital Nomad Life",
      description: "Working remotely from beaches around the world.",
      emoji: "🌍",
      colorCode: "#00BCD4",
      motivationSentence: "The world is your office.",
      timeHorizon: "1 Year",
      tasks: ["Buy a laptop stand", "Get a travel insurance", "Sell furniture"],
      habits: [
        AiHabitDto(
          title: "Learn Spanish",
          description: "Practice 15 mins a day",
          frequency: "daily",
          days: ["mon", "tue", "wed", "thu", "fri", "sat", "sun"],
          category: "Study",

          type: "timer",
        ),
      ],
    );
  }

  @override
  Future<AiChatResponse> sendVisionMessage(
    List<Map<String, String>> history,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    // Simulate a short conversation before generating
    if (history.length < 3) {
      return AiChatResponse(
        message: "Great! Tell me more about why this is important to you?",
      );
    }

    // Finalize after a few turns
    final vision = await generateVisionBoard(
      history.last['content'] ?? "Dream",
    );
    return AiChatResponse(
      message: "I've created your Vision Board plan based on our conversation.",
      vision: vision,
    );
  }

  @override
  Future<AiVisionDto> analyzePersonality(String prompt) async {
    await Future.delayed(const Duration(seconds: 2));

    // Simple keyword-based mock
    if (prompt.contains('likertStronglyAgree')) {
      return AiVisionDto(
        title: "The Visionary Leader",
        description:
            "You have a natural ability to see the big picture and inspire others.",
        emoji: "🚀",
        colorCode: "#FF9800",
        motivationSentence: "Lead with courage and clarity.",
        timeHorizon: "Life",
        tasks: ["Write 3 goals", "Read a leadership book"],
        habits: [
          AiHabitDto(
            title: "Morning Strategic Review",
            description: "15 mins to plan the day's big moves",
            frequency: "daily",
            days: ["mon", "tue", "wed", "thu", "fri"],
            category: "Productivity",
            type: "timer",
            targetValue: 15,
            emoji: "📅",
          ),
          AiHabitDto(
            title: "Mentorship",
            description: "Share knowledge with someone",
            frequency: "weekly",
            days: ["fri"],
            category: "Social",
            type: "simple",
            emoji: "🤝",
          ),
        ],
      );
    }

    return AiVisionDto(
      title: "The Balanced Harmonizer",
      description:
          "You seek balance in all things and bring peace to your environment.",
      emoji: "⚖️",
      colorCode: "#4CAF50",
      motivationSentence:
          "Balance is not something you find, it's something you create.",
      timeHorizon: "Life",
      tasks: ["Declutter desk", "Download a meditation app"],
      habits: [
        AiHabitDto(
          title: "Meditation",
          description: "10 mins mindfulness",
          frequency: "daily",
          days: ["mon", "tue", "wed", "thu", "fri", "sat", "sun"],
          category: "Mindfulness",
          type: "timer",
          targetValue: 10,
          emoji: "🧘",
        ),
      ],
    );
  }
}
