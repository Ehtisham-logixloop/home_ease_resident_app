class ChatMessage {
  final String name;
  final String role;
  final String message;
  final String time;
  final String image;
  final int unreadCount;

  ChatMessage({
    required this.name,
    required this.role,
    required this.message,
    required this.time,
    required this.image,
    this.unreadCount = 0,
  });
}

