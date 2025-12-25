import 'package:flutter/foundation.dart';
import 'ai_habit_service.dart';

import 'ai_habit_dto.dart';
import '../../vision/domain/ai_vision_dto.dart'; // Added
import 'habit_repository.dart';

/// Repository responsible for AI habit generation interactions.
/// Handles retries, prompt engineering/refinement, and error propagation.
class AiHabitRepository {
  final AiHabitService _service;

  AiHabitRepository(this._service);

  /// Generates habits with implicit retry logic for stability.
  ///
  /// [prompt] User's raw input.
  /// [imageBase64] Optional image data.
  ///
  /// Throws [AiGenerationException] if all attempts fail.
  Future<List<AiHabitDto>> generateHabits({
    required String prompt,
    String? imageBase64,
  }) async {
    int attempts = 0;
    const maxAttempts = 2; // Original try + 1 retry

    String currentPrompt = prompt;

    while (attempts < maxAttempts) {
      attempts++;
      try {
        final response = await _service.generateHabits(
          currentPrompt,
          imageBase64: imageBase64,
        );

        // Additional business validation if needed
        if (response.habits.isEmpty) {
          throw FormatException("Empty habit list returned");
        }

        return response.habits;
      } catch (e) {
        debugPrint('AiHabitRepository: Attempt $attempts failed. Error: $e');

        if (attempts >= maxAttempts) {
          // All attempts failed
          throw AiGenerationException(
            'Failed to generate habits after $attempts attempts. Last error: $e',
          );
        }

        // Prepare for retry: Refine prompt to be stricter
        currentPrompt =
            '$prompt\n\nIMPORTANT: Return VALID JSON ONLY. Strictly follow schema.';
      }
    }
    return []; // Should not reach here
  }

  Future<AiChatResponse> sendMessage(List<Map<String, String>> history) async {
    // We could add retry logic here too if needed, but for chat it's less critical strictly.
    // However, if JSON generation fails in chat, we might want to retry.
    // For now, let's just pass through.

    // Inject Context: Get current habits
    final habitRepo = HabitRepository.instance;
    final List<String> currentHabitContext = habitRepo.habits
        .map((h) => "${h.title} (${h.categoryName ?? h.habitType.name})")
        .toList();

    return _service.sendMessage(history, existingHabits: currentHabitContext);
  }

  /// Generates a Vision Board plan.
  Future<AiVisionDto> generateVisionBoard({required String prompt}) async {
    return _service.generateVisionBoard(prompt);
  }

  /// Sends a message for Vision Board creation flow.
  Future<AiChatResponse> sendVisionMessage(
    List<Map<String, String>> history,
  ) async {
    return _service.sendVisionMessage(history);
  }
}

class AiGenerationException implements Exception {
  final String message;
  AiGenerationException(this.message);
  @override
  String toString() => 'AiGenerationException: $message';
}
