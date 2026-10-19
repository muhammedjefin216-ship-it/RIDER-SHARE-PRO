// Matches the message payload shape from socketHandler.js's
// join_chat / receive_message events exactly:
// { id, bookingId, sender: {id, name, photo}, text, readBy: [...], createdAt }

class ChatMessageSender {
  final String id;
  final String name;
  final String photo;

  ChatMessageSender({required this.id, required this.name, required this.photo});

  factory ChatMessageSender.fromJson(Map<String, dynamic> json) {
    return ChatMessageSender(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? 'Unknown').toString(),
      photo: (json['photo'] ?? '').toString(),
    );
  }
}

class ChatMessage {
  final String id;
  final String bookingId;
  final ChatMessageSender sender;
  final String text;
  final List<String> readBy;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.bookingId,
    required this.sender,
    required this.text,
    required this.readBy,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: (json['id'] ?? '').toString(),
      bookingId: (json['bookingId'] ?? '').toString(),
      sender: ChatMessageSender.fromJson(
        (json['sender'] as Map<String, dynamic>?) ?? {},
      ),
      text: (json['text'] ?? '').toString(),
      readBy: ((json['readBy'] as List?) ?? []).map((e) => e.toString()).toList(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}