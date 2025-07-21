class Message {
  final String role;
  final String content;

  Message({required this.role, required this.content});

  Map<String, dynamic> toJson() => {'role': role, 'content': content};

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(role: json['role'], content: json['content']);
  }
}

class Conversation {
  final String id;
  List<Message> messages;

  Conversation({required this.id, required this.messages});

  Map<String, dynamic> toJson() => {
        'id': id,
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      messages: (json['messages'] as List<dynamic>)
          .map((e) => Message.fromJson(e))
          .toList(),
    );
  }

  String get title {
    for (final m in messages) {
      if (m.role == 'user') return m.content;
    }
    return 'Conversation';
  }
}
