import 'ai_habit_dto.dart';
import '../../vision/domain/ai_vision_dto.dart'; // Added

class AiChatResponse {
  final String message;
  final List<AiHabitDto>? habits;
  final List<String>? options; // Suggestion chips

  final AiVisionDto? vision; // New field

  AiChatResponse({
    required this.message,
    this.habits,
    this.vision,
    this.options,
  });
}

/// Abstract service for AI-assisted habit generation.
abstract class AiHabitService {
  /// Generates a list of suggested habits based on the user's prompt and optional image.
  /// (Deprecated/Legacy single-shot mode)
  Future<AiHabitResponse> generateHabits(
    String prompt, {
    String? imageBase64,
    String? languageCode,
  });

  /// Sends a message in a conversation flow.
  ///
  /// [history] List of messages including system, user, and assistant roles.
  /// [existingHabits] Optional list of current habit titles to provide context.
  /// [languageCode] Optional language code (e.g. 'tr', 'en') to force response language.
  /// Returns [AiChatResponse] which may contain text and/or generated habits.
  Future<AiChatResponse> sendMessage(
    List<Map<String, String>> history, {
    List<String>? existingHabits,
    String? languageCode,
  });

  /// Generates a full Vision Board (Vision + Tasks + Habits)
  /// (Legacy/One-shot mode - kept for fallback or testing)
  Future<AiVisionDto> generateVisionBoard(
    String prompt, {
    String? languageCode,
  });

  /// Sends a message in the Vision Board creation flow.
  /// Returns [AiChatResponse] which may contain text (clarification questions)
  /// or a [vision] object (when ready).
  Future<AiChatResponse> sendVisionMessage(
    List<Map<String, String>> history, {
    String? languageCode,
  });

  /// Analyzes the user's personality based on quiz answers and suggests a profile and habits.
  Future<AiVisionDto> analyzePersonality(String prompt, {String? languageCode});

  /// Sends a message to the AI Support Assistant.
  /// Returns a simple string response.
  Future<String> sendSupportMessage(
    List<Map<String, String>> history, {
    String? languageCode,
  });
}
