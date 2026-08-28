import 'package:flutter/material.dart';
import '../core/res/app_url.dart';
import '../core/services/local_storage_service.dart';
import '../data/models/message_model.dart';
import '../data/models/notification_model.dart';
import '../data/services/api_service.dart';

class MessagesViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  List<ChatThread> _threads = [];
  List<ChatThread> get threads => _threads;

  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  int get unreadNotificationCount =>
      _notifications.where((n) => !n.isRead).length;

  List<ChatMessage> getSampleMessages() {
    return [
      ChatMessage(
        name: "Saad Mughal",
        role: "Carpenter",
        message: "ok boss",
        time: "14:32",
        image: "assets/images/message1.png",
        unreadCount: 2,
      ),
      ChatMessage(
        name: "Ehtisham",
        role: "Electrician",
        message: "I'll be there in 2 mins",
        time: "12:32",
        image: "assets/images/message2.png",
        unreadCount: 2,
      ),
      ChatMessage(
        name: "Nahil Shafiq",
        role: "Beautification",
        message: "Hey bro!",
        time: "01:42",
        image: "assets/images/message3.png",
        unreadCount: 2,
      ),
      ChatMessage(
        name: "Hamid",
        role: "Cleaner",
        message: "woohoooo",
        time: "01:22",
        image: "assets/images/message5.png",
      ),
      ChatMessage(
        name: "Naveed",
        role: "Painter",
        message: "How are you?",
        time: "Mon, 22:23",
        image: "assets/images/message4.png",
      ),
    ];
  }

  Future<List<ChatMessage>> fetchChatMessages(String bookingId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = AppUrl.getChat(bookingId);
      final result = await _apiService.getRequest(url, requireAuth: true);

      if (result['success'] == true) {
        final data = result['data'];
        final List<dynamic> rawMessages =
            data is List ? data : (data['messages'] ?? data['data'] ?? []);
        _messages = rawMessages
            .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        _messages = _fallbackDemoMessages();
      }
    } catch (e) {
      _errorMessage = e.toString();
      _messages = _fallbackDemoMessages();
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _messages;
  }

  Future<bool> sendMessage({
    required String bookingId,
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    try {
      final body = {
        'booking_id': bookingId,
        'sender_id': senderId,
        'receiver_id': receiverId,
        'content': content,
      };

      final result = await _apiService.postRequest(
        AppUrl.sendMessage,
        body,
        requireAuth: true,
      );

      if (result['success'] == true) {
        _messages.add(ChatMessage(
          bookingId: bookingId,
          senderId: senderId,
          receiverId: receiverId,
          content: content,
          timestamp: DateTime.now(),
          name: 'Me',
          role: 'Resident',
          message: content,
          time: _formatNow(),
          image: 'assets/images/user.png',
        ));
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'] ?? 'Failed to send message';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<List<NotificationModel>> fetchNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.getRequest(
        AppUrl.notifications,
        requireAuth: true,
      );

      if (result['success'] == true) {
        final data = result['data'];
        final List<dynamic> raw =
            data is List ? data : (data['notifications'] ?? data['data'] ?? []);
        _notifications = raw
            .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        _notifications = _fallbackDemoNotifications();
      }
    } catch (e) {
      _errorMessage = e.toString();
      _notifications = _fallbackDemoNotifications();
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _notifications;
  }

  Future<List<ChatThread>> fetchChatThreads() async {
    try {
      final url = '${AppUrl.baseUrl}/chat/threads';
      final result = await _apiService.getRequest(url, requireAuth: true);

      if (result['success'] == true) {
        final data = result['data'];
        final List<dynamic> raw =
            data is List ? data : (data['threads'] ?? data['data'] ?? []);
        _threads = raw
            .map((e) => ChatThread.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        _threads = _fallbackDemoThreads();
      }
    } catch (e) {
      _threads = _fallbackDemoThreads();
    }
    notifyListeners();
    return _threads;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  List<ChatMessage> _fallbackDemoMessages() {
    return [
      ChatMessage(
        senderId: 'provider',
        content: 'Hello! Your booking has been accepted.',
        name: 'Provider',
        role: 'Service Provider',
        message: 'Hello! Your booking has been accepted.',
        time: '10:00',
        image: 'assets/images/worker.png',
      ),
      ChatMessage(
        senderId: 'me',
        content: 'Great! What time will you arrive?',
        name: 'Me',
        role: 'Resident',
        message: 'Great! What time will you arrive?',
        time: '10:02',
        image: 'assets/images/user.png',
      ),
      ChatMessage(
        senderId: 'provider',
        content: 'I will be there around 2 PM as scheduled.',
        name: 'Provider',
        role: 'Service Provider',
        message: 'I will be there around 2 PM as scheduled.',
        time: '10:05',
        image: 'assets/images/worker.png',
      ),
    ];
  }

  List<ChatThread> _fallbackDemoThreads() {
    return [
      ChatThread(
        bookingId: '1',
        providerId: 'p1',
        providerName: 'Saad Mughal',
        providerRole: 'Carpenter',
        providerImage: 'assets/images/message1.png',
        lastMessage: 'ok boss',
        lastMessageTime: '14:32',
        unreadCount: 2,
        bookingAccepted: true,
      ),
      ChatThread(
        bookingId: '2',
        providerId: 'p2',
        providerName: 'Ehtisham',
        providerRole: 'Electrician',
        providerImage: 'assets/images/message2.png',
        lastMessage: "I'll be there in 2 mins",
        lastMessageTime: '12:32',
        unreadCount: 2,
        bookingAccepted: true,
      ),
    ];
  }

  List<NotificationModel> _fallbackDemoNotifications() {
    return [
      NotificationModel(
        id: '1',
        title: 'Booking Accepted',
        body: 'Your carpenter service booking has been accepted by Saad Mughal.',
        type: 'booking_accepted',
        relatedId: '1',
        relatedType: 'booking',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      NotificationModel(
        id: '2',
        title: 'New Message',
        body: 'You have a new message from your electrician.',
        type: 'new_message',
        relatedId: '2',
        relatedType: 'booking',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      NotificationModel(
        id: '3',
        title: 'Service Completed',
        body: 'Your AC repair service has been marked as completed.',
        type: 'service_completed',
        relatedId: '3',
        relatedType: 'booking',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  static String _formatNow() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}

