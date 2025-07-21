import 'package:flutter/material.dart';
import '../models/chat_models.dart';
import '../services/conversation_storage.dart';
import 'chat_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _storage = ConversationStorage();
  List<Conversation> _conversations = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _storage.load();
    setState(() => _conversations = data);
  }

  Future<void> _openConversation(Conversation c) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage(conversation: c, storage: _storage),
      ),
    );
    await _storage.save(_conversations);
    _load();
  }

  Future<void> _newConversation() async {
    final conv = Conversation(id: DateTime.now().toIso8601String(), messages: []);
    _conversations.add(conv);
    await _openConversation(conv);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversations')),
      body: ListView.builder(
        itemCount: _conversations.length,
        itemBuilder: (context, index) {
          final conv = _conversations[index];
          return ListTile(
            title: Text(conv.title),
            onTap: () => _openConversation(conv),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newConversation,
        child: const Icon(Icons.add),
      ),
    );
  }
}
