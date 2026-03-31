// AI onboarding final sonucu — vizyon, kişilik kartı ve alışkanlık önerileri.

class AiVision {
  final String title;
  final String description;
  final List<String> pillars; // 3 adet

  const AiVision({
    required this.title,
    required this.description,
    required this.pillars,
  });

  factory AiVision.fromJson(Map<String, dynamic> json) => AiVision(
        title: (json['title'] as String?) ?? '',
        description: (json['description'] as String?) ?? '',
        pillars:
            (json['pillars'] as List?)?.map((e) => e.toString()).toList() ??
                [],
      );
}

class AiPersonalityCard {
  final String type;
  final String description;

  const AiPersonalityCard({required this.type, required this.description});

  factory AiPersonalityCard.fromJson(Map<String, dynamic> json) =>
      AiPersonalityCard(
        type: (json['type'] as String?) ?? '',
        description: (json['description'] as String?) ?? '',
      );
}

class AiHabitSuggestion {
  final String name;
  final String icon; // emoji
  final String pillar; // vizyonun hangi sütunundan geldiği
  final String type; // 'binary' | 'numeric' | 'duration'
  final double? targetValue;
  final String? targetUnit;
  final String frequency; // 'daily' | 'weekdays' | 'weekends' | 'weekly'
  final String visionReason;

  const AiHabitSuggestion({
    required this.name,
    required this.icon,
    required this.pillar,
    required this.type,
    this.targetValue,
    this.targetUnit,
    required this.frequency,
    required this.visionReason,
  });

  factory AiHabitSuggestion.fromJson(Map<String, dynamic> json) =>
      AiHabitSuggestion(
        name: (json['name'] as String?) ?? '',
        icon: (json['icon'] as String?) ?? '✨',
        pillar: (json['pillar'] as String?) ?? '',
        type: (json['type'] as String?) ?? 'binary',
        targetValue: (json['target_value'] as num?)?.toDouble(),
        targetUnit: json['target_unit'] as String?,
        frequency: (json['frequency'] as String?) ?? 'daily',
        visionReason: (json['vision_reason'] as String?) ?? '',
      );
}

class OnboardingResultAi {
  final AiVision vision;
  final AiPersonalityCard personality;
  final List<AiHabitSuggestion> habits;

  const OnboardingResultAi({
    required this.vision,
    required this.personality,
    required this.habits,
  });

  factory OnboardingResultAi.fromJson(Map<String, dynamic> json) {
    final visionRaw = json['vision'] as Map<String, dynamic>? ?? {};
    final personalityRaw = json['personality'] as Map<String, dynamic>? ?? {};
    final habitsRaw = json['habits'] as List? ?? [];
    return OnboardingResultAi(
      vision: AiVision.fromJson(visionRaw),
      personality: AiPersonalityCard.fromJson(personalityRaw),
      habits: habitsRaw
          .map((e) => AiHabitSuggestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
