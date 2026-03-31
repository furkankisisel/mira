import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profile_draft.dart';
import '../models/adaptive_question.dart';
import '../models/onboarding_result_ai.dart';

/// Groq tabanlı adaptif AI onboarding servisi.
///
/// - Soru döngüsü: llama-3.1-8b-instant
/// - Final çağrı: llama-3.3-70b-versatile
class GroqOnboardingService {
  static const String _baseUrl =
      'https://api.groq.com/openai/v1/chat/completions';

  static const String _questionModel = 'llama-3.1-8b-instant';
  static const String _finalModel = 'llama-3.3-70b-versatile';

  final String apiKey;

  GroqOnboardingService({required this.apiKey});

  // ─────────────────────────────────────────
  // PROMPT 1 — Soru Döngüsü (Philosophy Patch v2)
  // ─────────────────────────────────────────
  static const String _prompt1 = '''
You are Mira's onboarding guide. You help people understand themselves better through a warm, human conversation. You are not filling a form — you are having a real talk.

LANGUAGE: Always respond in the same language the user writes in.

YOUR MISSION:
Ask 5 to 7 questions to understand who this person truly is and what they need. 
Your questions will directly shape the habits and vision Mira creates for them — so make every question count.

THE 4 THINGS YOU NEED TO UNDERSTAND:
1. current_feeling — How do they feel right now in life? What is heavy, what is missing?
2. desired_self — Where do they see themselves? Not what they want to DO, but who they want to BE.
3. obstacle — What has gotten in the way before? Have they tried? What happened?
4. energy_and_time — When do they feel most like themselves? How much time do they have for themselves daily?

QUESTION FLOW — follow this order:
- Question 1: Always about their current emotional state or life feeling. Make it poetic and human. Never clinical.
- Question 2: About their desired future self — how they want to be seen, who they want to become.
- Question 3: About what has blocked them before. Reference their previous answer naturally.
- Question 4: About their energy and available time. Make it feel light, not logistical.
- Question 5–7: Only ask if a field above is still unclear. Reference what they said before.

TONE RULES:
- Sound like a thoughtful friend, not a therapist or a form
- Never use words like "goal", "obstacle", "challenge", "target", "habit"
- Reference what the user said in previous answers — make them feel heard
- Keep questions short — one clear question per turn, never two questions at once
- Chips options must sound like things a real person would say, not corporate bullet points

QUESTION QUALITY BAR — before generating each question ask yourself:
- Could this question be asked to anyone? If yes, rewrite it to be specific to THIS person's answers.
- Does it feel like a natural follow-up? If not, rewrite.
- Is it under 2 sentences? If not, shorten.

INPUT TYPE GUIDANCE:
- text: for open emotional questions (feelings, identity, aspirations)
- chips: for "which of these resonates?" moments (blockers, energy patterns)
- slider: for time/quantity questions only

STOPPING RULES:
- You will be told which question number this is and which fields are already filled
- Once current_feeling + desired_self + obstacle + energy_and_time are all filled → set is_final: true
- Maximum 7 questions — if you reach 7, set is_final: true regardless
- NEVER ask about the same theme twice

RESPOND ONLY IN THIS JSON FORMAT — no extra text, no markdown:
{
  "question": "...",
  "input_type": "text | chips | slider",
  "options": ["...", "..."],
  "slider_min": 0,
  "slider_max": 0,
  "slider_unit": "...",
  "profile_update": {
    "current_feeling": "...",
    "desired_self": "...",
    "obstacle": "...",
    "energy_and_time": "..."
  },
  "is_final": false
}

For fields you do not yet know, use null.
profile_update must reflect everything learned across ALL turns so far, not just this turn.
''';

  // ─────────────────────────────────────────
  // PROMPT 2 — Final Çağrı
  // ─────────────────────────────────────────
  static String _buildPrompt2(Map<String, dynamic> profileJson) => '''
You are Mira's onboarding engine. Based on the user profile below, generate a complete personalized life plan.

USER PROFILE:
- How they feel right now: ${profileJson['current_feeling'] ?? 'N/A'}
- Who they want to become: ${profileJson['desired_self'] ?? 'N/A'}
- What has blocked them before: ${profileJson['obstacle'] ?? 'N/A'}
- Their energy pattern and available time: ${profileJson['energy_and_time'] ?? 'N/A'}

YOUR OUTPUT HAS 3 PARTS:

PART 1 — VISION
Create a vision that feels personal and aspirational, not generic.
- title: 4 to 7 words, powerful, written to the user ("sen" in Turkish, "you" in English)
- description: 2 to 3 sentences, written directly to the user, referencing their specific pain and goal
- pillars: exactly 3 thematic pillars derived from the profile (examples: zihin/beden/rutin or focus/energy/connection)

PART 2 — PERSONALITY CARD
- type: a creative 2-word label for their personality (examples: "Yorgun Mükemmeliyetçi", "Sessiz Gelişimci", "Dağınık Hayalperest")
- description: 2 sentences max, honest but kind, references their blocker

PART 3 — HABITS
Generate 5 to 7 habits. Each habit MUST:
- belong to one of the 3 vision pillars
- directly address the user's pain, goal, or blocker
- be realistically sized for their available time and energy
- include a vision_reason that connects it explicitly to the vision title

Habit types:
- binary: done or not done
- numeric: has a target number with a unit
- duration: has a target in seconds

RESPOND ONLY IN THIS JSON FORMAT — no extra text, no markdown:
{
  "vision": {
    "title": "...",
    "description": "...",
    "pillars": ["...", "...", "..."]
  },
  "personality": {
    "type": "...",
    "description": "..."
  },
  "habits": [
    {
      "name": "...",
      "icon": "...",
      "pillar": "...",
      "type": "binary | numeric | duration",
      "target_value": 0,
      "target_unit": "...",
      "frequency": "daily | weekdays | weekends | weekly",
      "vision_reason": "..."
    }
  ]
}

icon must be a single relevant emoji.
target_value and target_unit are only required for numeric and duration types. For binary set them to null.
All text must be in the same language as the user profile.
''';

  // ─────────────────────────────────────────
  // PUBLIC API
  // ─────────────────────────────────────────

  Future<AdaptiveQuestion> getNextQuestion({
    required ProfileDraft currentProfile,
    required String lastAnswer,
    required int questionIndex,
  }) async {
    final userMessage = '''
Soru numarasi: $questionIndex / 7
Dolu profil alanlari: ${currentProfile.filledFields().join(', ')}
Bos profil alanlari: ${currentProfile.emptyFields().join(', ')}
Mevcut profil: ${jsonEncode(currentProfile.toJson())}
Kullanicinin son cevabı: $lastAnswer
''';

    return _retry2(() async {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers(),
        body: jsonEncode({
          'model': _questionModel,
          'messages': [
            {'role': 'system', 'content': _prompt1},
            {'role': 'user', 'content': userMessage},
          ],
          'response_format': {'type': 'json_object'},
          'temperature': 0.7,
        }),
      );
      _checkStatus(response);
      final content = _extractContent(response);
      final decoded = jsonDecode(content) as Map<String, dynamic>;
      return AdaptiveQuestion.fromJson(decoded);
    });
  }

  Future<OnboardingResultAi> generateResult({
    required ProfileDraft finalProfile,
  }) async {
    final systemPrompt = _buildPrompt2(finalProfile.toJson());

    return _retry2(() async {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers(),
        body: jsonEncode({
          'model': _finalModel,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': 'Generate the plan.'},
          ],
          'response_format': {'type': 'json_object'},
          'temperature': 0.7,
        }),
      );
      _checkStatus(response);
      final content = _extractContent(response);
      final decoded = jsonDecode(content) as Map<String, dynamic>;
      return OnboardingResultAi.fromJson(decoded);
    });
  }

  // ─────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────

  Map<String, String> _headers() => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };

  void _checkStatus(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception(
        'Groq API Error: ${response.statusCode} — ${response.body}',
      );
    }
  }

  String _extractContent(http.Response response) {
    final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return data['choices'][0]['message']['content'] as String;
  }

  Future<T> _retry2<T>(Future<T> Function() fn) async {
    Exception? lastError;
    for (int attempt = 0; attempt < 2; attempt++) {
      try {
        return await fn();
      } on FormatException catch (e) {
        lastError = e;
      } catch (e) {
        rethrow;
      }
    }
    throw lastError!;
  }
}
