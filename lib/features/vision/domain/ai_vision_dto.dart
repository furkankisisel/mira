import '../../habit/domain/ai_habit_dto.dart';

class AiVisionDto {
  final String title;
  final String description;
  final String emoji;
  final String colorCode;
  final String
  motivationSentence; // "You’re building freedom, one step at a time."
  final String timeHorizon; // "3 months", "1 year"
  final List<String> tasks; // One-off actions
  final List<AiHabitDto> habits; // Recurring habits

  AiVisionDto({
    required this.title,
    required this.description,
    required this.emoji,
    required this.colorCode,
    required this.motivationSentence,
    required this.timeHorizon,
    required this.tasks,
    required this.habits,
  });

  static AiVisionDto? tryFromJson(Map<String, dynamic> json) {
    try {
      final vision = json['vision'] as Map<String, dynamic>?;
      if (vision == null) return null;

      final title = vision['title'] as String?;
      final description = vision['description'] as String?;
      final emoji = vision['emoji'] as String?;
      final colorCode = vision['color_code'] as String?;
      final motivationSentence = vision['motivation_sentence'] as String?;
      final timeHorizon = vision['time_horizon'] as String?;

      if (title == null || description == null) return null;

      final tasks =
          (vision['tasks'] as List?)?.map((e) => e.toString()).toList() ?? [];

      final habitsList = vision['habits'] as List?;
      final parsedHabits =
          habitsList
              ?.map((e) => AiHabitDto.tryFromJson(e as Map<String, dynamic>))
              .whereType<AiHabitDto>()
              .toList() ??
          [];

      return AiVisionDto(
        title: title,
        description: description,
        emoji: emoji ?? '🎯',
        colorCode: colorCode ?? '#FF5733',
        motivationSentence: motivationSentence ?? '',
        timeHorizon: timeHorizon ?? '3 months',
        tasks: tasks,
        habits: parsedHabits,
      );
    } catch (e) {
      return null;
    }
  }
}
