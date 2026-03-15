import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/api_config.dart';
import '../domain/ai_finance_dto.dart';

class AiFinanceService {
  final String apiKey;
  final String model;

  static const String _baseUrl =
      'https://api.groq.com/openai/v1/chat/completions';

  AiFinanceService({
    String? apiKey,
    this.model = 'llama-3.3-70b-versatile',
  }) : apiKey = apiKey ?? ApiConfig.groqApiKey;

  Future<AiFinanceResponse> analyzeStatement({
    String? imageBase64,
    String? pdfText,
  }) async {
    final systemPrompt = '''
You are an expert financial assistant.
Your goal is to extract transactions (income and expenses) from a user's bank statement, receipt, or plain text financial record.

IMPORTANT RULES:
1. ONLY return a JSON object. No extra text or explanations.
2. Carefully identify the transaction title (Name of the place, person, or service).
3. Carefully identify the transaction amount as a numeric value. Try to extract the positive value.
4. Carefully identify whether it is an "income" (money received) or "expense" (money spent).
5. Extract the date in YYYY-MM-DD format if possible. If no date is found, use the current date or an educated guess.
6. Provide an appropriate single emoji that accurately represents the transaction's title and category (e.g. 🛒 for groceries, ☕ for coffee, 🚗 for transport).
7. The JSON MUST follow this strict schema:
{
  "transactions": [
    {
      "title": "String (Name of the item/merchant)",
      "amount": number (positive decimal),
      "date": "YYYY-MM-DD",
      "type": "income" | "expense",
      "emoji": "String (Single emoji)"
    }
  ]
}
''';

    List<Map<String, dynamic>> messages = [
      {"role": "system", "content": systemPrompt},
    ];

    if (imageBase64 != null) {
      messages.add({
        "role": "user",
        "content": [
          {"type": "text", "text": "Extract all financial transactions from this image."},
          {
            "type": "image_url",
            "image_url": {"url": "data:image/jpeg;base64,$imageBase64"},
          },
        ],
      });
    } else if (pdfText != null) {
      messages.add({
        "role": "user",
        "content": "Extract all financial transactions from the following text:\n\n$pdfText",
      });
    } else {
      throw ArgumentError('Either imageBase64 or pdfText must be provided');
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
        'temperature': 0.1,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final content = data['choices'][0]['message']['content'];

      try {
        final jsonContent = jsonDecode(content);
        return AiFinanceResponse.fromJson(jsonContent);
      } catch (e) {
        throw FormatException('Failed to parse AI Finance response JSON: $content');
      }
    } else {
      throw Exception(
        'Groq API Error: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
