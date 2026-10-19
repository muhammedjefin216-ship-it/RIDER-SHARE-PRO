// Matches serializeNotification() in notificationRoutes.js exactly:
// { id, type, title, body, link, read, createdAt }

class NotificationItem {
  final String id;
  final String type;
  final String title;
  final String body;
  final String? link;
  final bool read;
  final DateTime? createdAt;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.link,
    required this.read,
    this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: (json['id'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      body: (json['body'] ?? '').toString(),
      link: json['link']?.toString(),
      read: json['read'] == true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  NotificationItem copyWith({bool? read}) {
    return NotificationItem(
      id: id,
      type: type,
      title: title,
      body: body,
      link: link,
      read: read ?? this.read,
      createdAt: createdAt,
    );
  }
}