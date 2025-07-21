import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_models.dart';
import '../openai_config.dart';

class ChatService {
  Future<Message> send(List<Message> history, String prompt) async {
    final uri = Uri.parse('https://api.openai.com/v1/chat/completions');
    final body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        ...history.map((m) => m.toJson()),
        {'role': 'user', 'content': prompt},
      ],
    });

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $openAIApiKey',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'];
      return Message(role: 'assistant', content: content.trim());
    } else {
      throw Exception('OpenAI request failed: ${response.body}');
    }
  }
}
