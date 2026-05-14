import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  GeminiMessage({
    required this.content,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class GeminiService {
  final String _apiKey;
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  final List<Map<String, dynamic>> _conversationHistory = [];

  GeminiService({required String apiKey}) : _apiKey = apiKey;

  Future<String> sendMessage(String message) async {
    _conversationHistory.add({
      'role': 'user',
      'parts': [
        {'text': message}
      ],
    });

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': _conversationHistory,
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 2048,
          },
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_HARASSMENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
            {
              'category': 'HARM_CATEGORY_HATE_SPEECH',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]
                ?['text'] as String? ??
            'មិនអាចទទួលការឆ្លើយតប';

        _conversationHistory.add({
          'role': 'model',
          'parts': [
            {'text': text}
          ],
        });

        return text;
      } else {
        return 'មានកំហុស: ${response.statusCode}';
      }
    } catch (e) {
      return 'មានកំហុសក្នុងការភ្ជាប់ទៅ AI: $e';
    }
  }

  void clearHistory() {
    _conversationHistory.clear();
  }
}
