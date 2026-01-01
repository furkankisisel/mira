import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/ai_habit_service.dart';
import '../domain/ai_habit_dto.dart';
import '../../vision/domain/ai_vision_dto.dart'; // Added

class ServerAiHabitService implements AiHabitService {
  final String apiKey;
  final String model;

  // Using the OpenAI-compatible endpoint for Server AI (Groq/OpenAI/etc)
  static const String _baseUrl =
      'https://api.groq.com/openai/v1/chat/completions';

  ServerAiHabitService({
    required this.apiKey,
    this.model = 'llama-3.3-70b-versatile',
  });

  String _getLanguageInstruction(String? code) {
    if (code == null)
      return "Detect user language (Turkish/English) and reply in that language.";
    final langName = code.toLowerCase() == 'tr' ? 'Turkish' : 'English';
    return "IMPORTANT: You MUST reply in $langName. Language Code: $code";
  }

  @override
  Future<AiHabitResponse> generateHabits(
    String prompt, {
    String? imageBase64,
    String? languageCode,
  }) async {
    final langInstruction = _getLanguageInstruction(languageCode);
    // Construct the system prompt with strict schema for one-shot generation
    final systemPrompt =
        '''
You are a "Science-informed habit design assistant". 
Your goal is to suggest niche, scientifically-grounded habits to solve the user's specific problem.

IMPORTANT SAFETY RULES:
1. NO MEDICAL ADVICE: Do NOT diagnose or prescribe. If the user mentions pain, depression, insomnia, or severe symptoms, output a DISCLAIMER first, then general lifestyle suggestions only if safe.
2. SOURCE INTEGRITY: You must provide a "rationale" for each habit. Reference specific FIELDS (e.g. "Chronobiology", "Behavioral Psychology") or WELL-KNOWN RESEARCHERS (e.g. "Andrew Huberman", "Matthew Walker", "BJ Fogg").
3. NO FAKE URLS: Do NOT provide http links.
4. PERSONA: Empathetic, educational, non-authoritative.

Output MUST be valid JSON strictly matching this schema:
{
  "habits": [
    {
      "title": "Short title (max 40 chars)",
      "description": "Motivational description",
      "rationale": "Scientific explanation referencing a field or researcher. Why this helps?",
      "frequency": "daily" | "weekly",
      "days": ["mon", "tue", "wed", "thu", "fri", "sat", "sun"],
      "type": "simple" | "numerical" | "timer" | "subtasks",
      "target_value": number (required if numerical),
      "duration_minutes": number (required if timer),
      "subtasks": ["Step 1", "Step 2"] (required if subtasks),
      "category": "Health" | "Productivity" | "Mindfulness" | "Finance" | "Social" | "Activity" | "Task",
      "difficulty": "easy" | "medium" | "hard",
      "emoji": "Single emoji char",
      "color_code": "Hex color e.g. #FF5733",
      "duration_days": number (optional, e.g. 21 for a challenge, null for infinite),
      "is_task": boolean (true if this is a one-off daily task like 'Buy shoes', false for habits)
    }
  ]
}
Context: $langInstruction
Ensure "days" is a list of strings: mon, tue, wed, thu, fri, sat, sun.
Max 5 habits.
IMPORTANT:
- If the user needs a one-time action (e.g. "Buy a mat"), set "is_task": true.
- If the user needs a temporary challenge (e.g. "21-day detox"), set "duration_days": 21.
- Suggest distinct colors/emojis.
''';

    // Build messages
    List<Map<String, dynamic>> messages = [
      {"role": "system", "content": systemPrompt},
    ];

    if (imageBase64 != null) {
      messages.add({
        "role": "user",
        "content": [
          {"type": "text", "text": prompt},
          {
            "type": "image_url",
            "image_url": {"url": "data:image/jpeg;base64,$imageBase64"},
          },
        ],
      });
    } else {
      messages.add({"role": "user", "content": prompt});
    }

    final targetModel = imageBase64 != null
        ? 'llama-3.2-11b-vision-preview'
        : model;

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': targetModel,
        'messages': messages,
        'response_format': {'type': 'json_object'},
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final content = data['choices'][0]['message']['content'];

      try {
        final jsonContent = jsonDecode(content);
        return AiHabitResponse.fromJson(jsonContent);
      } catch (e) {
        throw FormatException('Failed to parse AI response JSON: $content');
      }
    } else {
      throw Exception(
        'Groq API Error: ${response.statusCode} - ${response.body}',
      );
    }
  }

  @override
  Future<AiChatResponse> sendMessage(
    List<Map<String, String>> history, {
    List<String>? existingHabits,
    String? languageCode,
  }) async {
    final langInstruction = _getLanguageInstruction(languageCode);
    final systemPrompt =
        '''
You are a "Science-informed habit design assistant".
Your goal is to help the user build niche, effective habits based on scientific principles.

CRITICAL SAFETY & BEHAVIOR:
1. NO DIAGNOSIS: Do NOT ask "Where does it hurt?" or "How long have you felt this?".
2. PATTERN SELECTION: If the user describes a problem (e.g. "I can't focus"), describe 2-3 common patterns and ask them to select.
   Example: "Focus issues often stem from A) Sleep inertia, B) Dopamine overload, or C) Stress. Which resonates with you?"
3. NO MEDICAL ADVICE: If user mentions pain, depression, insomnia -> Give a safety disclaimer. Suggest consulting a doctor.
3. NO MEDICAL ADVICE: If user mentions pain, depression, insomnia -> Give a safety disclaimer. Suggest consulting a doctor.
4. RATIONALE: When suggesting habits, explain the mechanism based on fields like "Chronobiology", "Neuroscience". Cite experts like "Huberman", "Walker", "Fogg".

CONTEXT:
The user CURRENTLY has these habits: ${existingHabits?.join(', ') ?? 'None'}.
If relevant, suggest habits that "stack" well with existing ones, or fill missing gaps.

INTERACTIVITY:
To guide the conversation, provide 2-3 short "Suggested Replies" for the user.
Example: If asking about sleep, suggest ["I wake up tired", "I can't fall asleep", "I sleep fine"].

When you have enough information to form a plan OR the user asks to generate:
   - Output a helpful message explaining the science briefly.
   - AND Output a VALID JSON block wrapped in ```json``` containing the habits.

RESPONSE FORMAT:
You can output normal text.
If you want to provide suggested replies, output them as a JSON block (can be separate from habits):
```json
{
  "suggested_replies": ["Option A", "Option B"]
}
```

If generating habits, use this schema:

The JSON schema MUST match:
{
  "habits": [
    {
      "title": "Short title",
      "description": "Motivational description",
      "rationale": "Scientific explanation (source field/researcher)",
      "frequency": "daily" | "weekly",
      "days": ["mon", "tue", "wed", "thu", "fri", "sat", "sun"],
      "type": "simple" | "numerical" | "timer" | "subtasks",
      "target_value": number (required if numerical),
      "duration_minutes": number (required if timer),
      "subtasks": ["step 1"] (required if subtasks),
      "category": "Health" | "Productivity" | "Mindfulness" | "Finance" | "Social" | "Activity" | "Task",
      "difficulty": "easy" | "medium" | "hard",
      "emoji": "string",
      "color_code": "hex string",
      "duration_days": number (optional, e.g. 21),
      "is_task": boolean (true for one-off tasks)
    }
  ]
}
Max 5 habits.
Language: $langInstruction
''';

    final List<Map<String, dynamic>> fullMessages = [
      {"role": "system", "content": systemPrompt},
      ...history,
    ];

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': model,
        'messages': fullMessages,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final content = data['choices'][0]['message']['content'] as String;

      // Detect JSON block
      final jsonBlockRegex = RegExp(r'```json\s*([\s\S]*?)\s*```');
      final match = jsonBlockRegex.firstMatch(content);

      List<AiHabitDto>? habits;
      List<String>? options;
      String message = content;

      if (match != null) {
        final jsonStr = match.group(1);
        try {
          if (jsonStr != null) {
            final decoded = jsonDecode(jsonStr);

            // Try parsing habits
            if (decoded.containsKey('habits')) {
              final aiResponse = AiHabitResponse.fromJson(decoded);
              habits = aiResponse.habits;
            }

            // Try parsing suggested replies
            if (decoded.containsKey('suggested_replies')) {
              options = (decoded['suggested_replies'] as List?)
                  ?.map((e) => e.toString())
                  .toList();
            }

            // Remove the JSON block from the message to show only text
            message = content.replaceFirst(match.group(0)!, '').trim();
            if (message.isEmpty && (habits != null || options != null)) {
              // If message is empty but we have data, keep it empty or set a default?
              // Usually there is intro text. If purely JSON, message is empty.
              // Let's keep it empty, the UI handles chips/preview.
            }
          }
        } catch (e) {
          // JSON parsing failed, treat as pure text
        }
      }

      return AiChatResponse(message: message, habits: habits, options: options);
    } else {
      throw Exception(
        'Groq API Error: ${response.statusCode} - ${response.body}',
      );
    }
  }

  @override
  Future<AiVisionDto> generateVisionBoard(
    String prompt, {
    String? languageCode,
  }) async {
    final langInstruction = _getLanguageInstruction(languageCode);
    final systemPrompt =
        '''
You are a "Vision Board Coach" & "Habit Architect".
Your goal is to turn the user's dream into a COMPLETE, ACTIONABLE PROGRAM.

INPUT: User's dream (e.g. "I want to be a digital nomad").
OUTPUT: A structured plan including:
1. Vision Details: Inspiring title, deeply motivating description, color, emoji.
2. Motivation: A powerful "motivation_sentence".
3. Time Horizon: Realistic timeframe.
4. Tasks: 3-5 one-off actions to get started immediately.
5. Habits: 3-5 recurring habits that form a "Weekly Routine". These are CRITICAL.

JSON SCHEMA:
{
  "vision": {
    "title": "Inspiring Title",
    "description": "Detailed description of the lifestyle.",
    "emoji": "Char",
    "color_code": "Hex",
    "motivation_sentence": "You are building freedom...",
    "time_horizon": "6 months",
    "tasks": ["Task 1", "Task 2", "Task 3"],
    "habits": [
      {
         "title": "Habit Title",
         "description": "Actionable description",
         "frequency": "daily" | "weekly",
         "days": ["mon", "tue", "wed", "thu", "fri", "sat", "sun"],
         "type": "simple" | "numerical" | "timer",
         "target_value": 1,
         "color_code": "#FF5733",
         "emoji": "🔥",
         "category": "Health" | "Productivity" | "Study" | "Finance"
      }
    ]
  }
}

RULES:
- "days" MUST be provided for every habit. Use ["mon", "tue", "wed", "thu", "fri", "sat", "sun"] for daily.
- "habits" must contain at least 3 items.
- Language: $langInstruction
''';

    final messages = [
      {"role": "system", "content": systemPrompt},
      {"role": "user", "content": prompt},
    ];

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': model,
        'messages': messages,
        'response_format': {'type': 'json_object'},
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final content = data['choices'][0]['message']['content'];

      try {
        final jsonContent = jsonDecode(content);
        final dto = AiVisionDto.tryFromJson(jsonContent);
        if (dto != null) return dto;
        throw FormatException('Parsed JSON is not a valid Vision object');
      } catch (e) {
        throw FormatException('Failed to parse AI Vision response: $content');
      }
    } else {
      throw Exception(
        'Groq API Error: ${response.statusCode} - ${response.body}',
      );
    }
  }

  @override
  Future<AiChatResponse> sendVisionMessage(
    List<Map<String, String>> history, {
    String? languageCode,
  }) async {
    final langInstruction = _getLanguageInstruction(languageCode);
    final systemPrompt =
        '''
You are a "Vision Board Coach" & "Habit Architect".
Phase 1: Ask 1-2 powerful questions to clarify the user's dream and find their deep motivation.
Phase 2: Once you have enough clarity, generate the "COMPLETE, ACTIONABLE PROGRAM".

If you need more info, just reply with text(questions).
If you have enough info, reply with the JSON object. You CAN wrap it in ```json ... ``` but it is not required.

JSON SCHEMA for Phase 2:
{
  "vision": {
    "title": "Inspiring Title",
    "description": "Detailed description of the lifestyle.",
    "emoji": "Char",
    "color_code": "Hex",
    "motivation_sentence": "Your motivation...",
    "time_horizon": "e.g. 1 Year",
    "tasks": ["Task 1", "Task 2", "Task 3"],
    "habits": [
       { "title": "...", "description": "...", "frequency": "daily" | "weekly", "days": ["mon", ...], "category": "...", "type": "timer" | "simple" | "numerical", "target_value": ... }
    ]
  }
}

RULES:
- Do not output JSON until you are sure.
- Language: $langInstruction
''';

    final messages = [
      {'role': 'system', 'content': systemPrompt},
      ...history,
    ];

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': model,
        'messages': messages,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final content = data['choices'][0]['message']['content'] as String;

      // 1. Try finding markdown block
      final jsonBlockRegex = RegExp(r'```json\s*([\s\S]*?)\s*```');
      final match = jsonBlockRegex.firstMatch(content);
      String? jsonStr;

      if (match != null) {
        jsonStr = match.group(1);
      } else {
        // 2. Fallback: Look for the first opening brace and last closing brace
        final start = content.indexOf('{');
        final end = content.lastIndexOf('}');
        if (start != -1 && end != -1 && end > start) {
          // Basic check if it likely contains our target key
          final candidate = content.substring(start, end + 1);
          if (candidate.contains('"vision"')) {
            jsonStr = candidate;
          }
        }
      }

      if (jsonStr != null) {
        try {
          final json = jsonDecode(jsonStr);
          final vision = AiVisionDto.tryFromJson(json);
          if (vision != null) {
            // Clean message by removing the JSON part
            // Be careful not to remove too much if there was intro text
            String cleanMsg = content;
            if (match != null) {
              cleanMsg = content.replaceFirst(match.group(0)!, '');
            } else {
              cleanMsg = content.replaceFirst(jsonStr, '');
            }
            cleanMsg = cleanMsg.trim();

            return AiChatResponse(
              message: cleanMsg.isEmpty ? "Here is your plan!" : cleanMsg,
              vision: vision,
            );
          }
        } catch (e) {
          // Failed parse, treat as text
        }
      }

      return AiChatResponse(message: content);
    } else {
      throw Exception('Groq API Error: ${response.statusCode}');
    }
  }

  @override
  Future<AiVisionDto> analyzePersonality(
    String prompt, {
    String? languageCode,
  }) async {
    final langInstruction = _getLanguageInstruction(languageCode);
    final systemPrompt =
        '''
You are an expert Personality Psychologist and Habit Coach.
Analyze the user's answers to find their "Character Archetype".
Return a JSON object with their profile and 3-5 recommended habits.

JSON SCHEMA:
{
  "vision": {
    "title": "Archetype Name",
    "description": "Personality analysis",
    "emoji": "Char",
    "color_code": "Hex",
    "motivation_sentence": "Affirmation",
    "time_horizon": "Life",
    "tasks": ["Quick Win 1", "Quick Win 2"], 
    "habits": [
      {
         "title": "Habit Title",
         "description": "Why this fits",
         "frequency": "daily",
         "days": ["mon", "tue", "wed", "thu", "fri", "sat", "sun"], 
         "type": "simple",
         "target_value": 1,
         "color_code": "Hex",
         "emoji": "Char",
         "category": "Health"
      }
    ]
  }
}

IMPORTANT RULES:
1. "habits" ARRAY MUST NOT BE EMPTY. PROVIDE 3-5 HABITS.
2. "days" property is REQUIRED for every habit (e.g. ["mon", "tue"...]).
3. "tasks" should be 2-3 one-time actions.
4. Language: $langInstruction
''';

    final messages = [
      {"role": "system", "content": systemPrompt},
      {"role": "user", "content": prompt},
    ];

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': model,
        'messages': messages,
        'response_format': {'type': 'json_object'},
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final content = data['choices'][0]['message']['content'];

      try {
        final jsonContent = jsonDecode(content);
        final dto = AiVisionDto.tryFromJson(jsonContent);
        if (dto != null) return dto;
        throw FormatException(
          'Parsed JSON is not a valid Vision/Personality object',
        );
      } catch (e) {
        throw FormatException(
          'Failed to parse AI Personality response: $content',
        );
      }
    } else {
      throw Exception(
        'Groq API Error: ${response.statusCode} - ${response.body}',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> sendSupportMessage(
    List<Map<String, String>> history, {
    String? languageCode,
  }) async {
    final langInstruction = _getLanguageInstruction(languageCode);
    final systemPrompt =
        '''
You are Mira’s intelligent in-app assistant.
Your goal is to have a natural, helpful conversation with the user and guide them to the right features.

Mira Features & Route IDs:
- "create_habit": Create a new habit
- "habits": Go to Today/Habits view
- "vision": Go to Vision Board
- "timer": Go to Focus Timer
- "mood": Go to Mood Log
- "finance": Go to Finance Tracker

INSTRUCTIONS:
1. Answer the user's question naturally and briefly.
2. If the user asks to DO something (e.g. "set a timer", "help me focus", "add a habit", "show my vision"), valid JSON MUST be included.
3. If the user just wants to chat, just return the message field in JSON.

JSON SCHEMA:
{
  "message": "Your natural language response here...",
  "action": {
    "label": "Button Label (e.g. Open Timer)",
    "route_id": "route_id_from_list_above",
    "icon": "icon_name" (e.g. timer, add, terrain, mood, eco)
  },
  "suggested_replies": ["Short Reply 1", "Short Reply 2"]
}

IMPORTANT:
- Output MUST be valid JSON.
- Language: $langInstruction
''';

    final messages = [
      {"role": "system", "content": systemPrompt},
      ...history,
    ];

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': model,
        'messages': messages,
        'response_format': {'type': 'json_object'},
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final content = data['choices'][0]['message']['content'] as String;
      try {
        return jsonDecode(content) as Map<String, dynamic>;
      } catch (e) {
        // Fallback if valid JSON isn't returned
        return {'message': content};
      }
    } else {
      throw Exception(
        'Groq API Error: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
