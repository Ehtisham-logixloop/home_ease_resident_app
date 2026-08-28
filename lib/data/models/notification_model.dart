
class NotificationModel {
  final String? id;
  final String? userId;
  final String title;
  final String body;
  final String type;
  final String? relatedId;
  final String? relatedType;
  final bool isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NotificationModel({
    this.id,
    this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.relatedId,
    this.relatedType,
    this.isRead = false,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      userId: json['user_id']?.toString() ?? json['userId']?.toString(),
      title: json['title']?.toString() ?? json['notification_title']?.toString() ?? '',
      body: json['body']?.toString() ?? json['message']?.toString() ?? json['description']?.toString() ?? '',
      type: json['type']?.toString() ?? json['notification_type']?.toString() ?? 'general',
      relatedId: json['related_id']?.toString() ?? json['relatedId']?.toString() ?? json['booking_id']?.toString() ?? json['bookingId']?.toString(),
      relatedType: json['related_type']?.toString() ?? json['relatedType']?.toString() ?? 'booking',
      isRead: json['is_read'] ?? json['isRead'] ?? json['read'] ?? false,
      createdAt: json['created_at'] != null || json['createdAt'] != null
          ? DateTime.tryParse((json['created_at'] ?? json['createdAt']).toString())
          : null,
      updatedAt: json['updated_at'] != null || json['updatedAt'] != null
          ? DateTime.tryParse((json['updated_at'] ?? json['updatedAt']).toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      'title': title,
      'body': body,
      'type': type,
      if (relatedId != null) 'related_id': relatedId,
      if (relatedType != null) 'related_type': relatedType,
      'is_read': isRead,
    };
  }

  String get formattedTime {
    if (createdAt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(createdAt!);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}';
  }
}
