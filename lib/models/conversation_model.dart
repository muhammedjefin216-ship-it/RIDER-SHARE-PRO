// Matches the conversation object shape returned by
// GET /api/messages in messageRoutes.js exactly.

class ConversationOtherParty {
  final String name;
  final String photo;

  ConversationOtherParty({required this.name, required this.photo});

  factory ConversationOtherParty.fromJson(Map<String, dynamic> json) {
    return ConversationOtherParty(
      name: (json['name'] ?? '').toString(),
      photo: (json['photo'] ?? '').toString(),
    );
  }
}

class ConversationLastMessage {
  final String text;
  final DateTime? time;
  final String? senderName;

  ConversationLastMessage({required this.text, this.time, this.senderName});

  factory ConversationLastMessage.fromJson(Map<String, dynamic> json) {
    return ConversationLastMessage(
      text: (json['text'] ?? '').toString(),
      time: json['time'] != null ? DateTime.tryParse(json['time'].toString()) : null,
      senderName: json['senderName']?.toString(),
    );
  }
}

class Conversation {
  final String bookingId;
  final String? tripId;
  final String route;
  final String? date;
  final ConversationOtherParty otherParty;
  final ConversationLastMessage? lastMessage;
  final int unreadCount;

  Conversation({
    required this.bookingId,
    this.tripId,
    required this.route,
    this.date,
    required this.otherParty,
    this.lastMessage,
    required this.unreadCount,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      bookingId: (json['bookingId'] ?? '').toString(),
      tripId: json['tripId']?.toString(),
      route: (json['route'] ?? '').toString(),
      date: json['date']?.toString(),
      otherParty: ConversationOtherParty.fromJson(
        (json['otherParty'] as Map<String, dynamic>?) ?? {},
      ),
      lastMessage: json['lastMessage'] != null
          ? ConversationLastMessage.fromJson(
              json['lastMessage'] as Map<String, dynamic>,
            )
          : null,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
    );
  }
}