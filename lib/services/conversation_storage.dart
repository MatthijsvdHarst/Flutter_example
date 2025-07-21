import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_models.dart';

class ConversationStorage {
  static const _key = 'conversations';

  Future<List<Conversation>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString(_key);
    if (text == null) return [];
    final List<dynamic> data = jsonDecode(text);
    return data.map((e) => Conversation.fromJson(e)).toList();
  }

  Future<void> save(List<Conversation> conversations) async {
    final prefs = await SharedPreferences.getInstance();
    final text = jsonEncode(conversations.map((e) => e.toJson()).toList());
    await prefs.setString(_key, text);
  }
}
