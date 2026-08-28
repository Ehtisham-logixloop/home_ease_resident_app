class ChatMessage {
  final String? id;
  final String? bookingId;
  final String? senderId;
  final String? receiverId;
  final String? content;
  final DateTime? timestamp;
  final bool? isRead;
  final String? messageType;

  final String name;
  final String role;
  final String message;
  final String time;
  final String image;
  final int unreadCount;

  ChatMessage({
    this.id,
    this.bookingId,
    this.senderId,
    this.receiverId,
    this.content,
    this.timestamp,
    this.isRead,
    this.messageType,
    required this.name,
    required this.role,
    required this.message,
    required this.time,
    required this.image,
    this.unreadCount = 0,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      bookingId: json['booking_id']?.toString() ?? json['bookingId']?.toString(),
      senderId: json['sender_id']?.toString() ?? json['senderId']?.toString(),
      receiverId: json['receiver_id']?.toString() ?? json['receiverId']?.toString(),
      content: json['content']?.toString() ?? json['message']?.toString(),
      timestamp: json['created_at'] != null || json['timestamp'] != null
          ? DateTime.tryParse((json['created_at'] ?? json['timestamp']).toString())
          : null,
      isRead: json['is_read'] ?? json['isRead'],
      messageType: json['message_type']?.toString() ?? json['messageType']?.toString(),
      name: json['sender_name']?.toString() ?? json['name']?.toString() ?? '',
      role: json['sender_role']?.toString() ?? json['role']?.toString() ?? '',
      message: json['content']?.toString() ?? json['message']?.toString() ?? '',
      time: _formatTime(json['created_at'] ?? json['timestamp']),
      image: json['sender_image']?.toString() ?? json['image']?.toString() ?? 'assets/images/user.png',
      unreadCount: json['unread_count'] ?? json['unreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (bookingId != null) 'booking_id': bookingId,
      if (senderId != null) 'sender_id': senderId,
      if (receiverId != null) 'receiver_id': receiverId,
      'content': content ?? message,
    };
  }

  static String _formatTime(dynamic raw) {
    try {
      if (raw == null) return '';
      final dt = DateTime.tryParse(raw.toString());
      if (dt == null) return raw.toString();
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    } catch (_) {
      return '';
    }
  }
}

class ChatThread {
  final String bookingId;
  final String providerId;
  final String providerName;
  final String providerRole;
  final String providerImage;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final bool bookingAccepted;

  ChatThread({
    required this.bookingId,
    required this.providerId,
    required this.providerName,
    required this.providerRole,
    required this.providerImage,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.bookingAccepted = false,
  });

  factory ChatThread.fromJson(Map<String, dynamic> json) {
    return ChatThread(
      bookingId: json['booking_id']?.toString() ?? json['bookingId']?.toString() ?? '',
      providerId: json['provider_id']?.toString() ?? json['providerId']?.toString() ?? '',
      providerName: json['provider_name']?.toString() ?? json['providerName']?.toString() ?? '',
      providerRole: json['provider_role']?.toString() ?? json['providerRole']?.toString() ?? '',
      providerImage: json['provider_image']?.toString() ?? json['providerImage']?.toString() ?? 'assets/images/user.png',
      lastMessage: json['last_message']?.toString() ?? json['lastMessage']?.toString() ?? '',
      lastMessageTime: json['last_message_time']?.toString() ?? json['lastMessageTime']?.toString() ?? '',
      unreadCount: json['unread_count'] ?? json['unreadCount'] ?? 0,
      bookingAccepted: json['booking_accepted'] ?? json['bookingAccepted'] ?? false,
    );
  }
}

