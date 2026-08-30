
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../view_model/message_view_model.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String image;
  final String role;
  final String? bookingId;
  final String? providerId;
  final String? userId;

  const ChatScreen({
    super.key,
    required this.name,
    required this.image,
    required this.role,
    this.bookingId,
    this.providerId,
    this.userId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _currentUserId;
  Timer? _refreshTimer;
  Timer? _autoReplyTimer;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _currentUserId = widget.userId ?? await LocalStorageService.getUserIdString();
    final effectiveBookingId = widget.bookingId ?? '1';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<MessagesViewModel>(context, listen: false);
      vm.setActiveChat(effectiveBookingId);
      vm.fetchChatMessages(effectiveBookingId);
    });
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        final vm = Provider.of<MessagesViewModel>(context, listen: false);
        vm.fetchChatMessages(widget.bookingId ?? '1');
      }
    });
  }

  bool _isMessageFromMe(dynamic msg) {
    if (_currentUserId == null || msg.senderId == null) {
      return msg.name == 'Me' || msg.senderId == 'me';
    }
    return msg.senderId?.toString() == _currentUserId.toString();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    final vm = Provider.of<MessagesViewModel>(context, listen: false);

    final senderId = _currentUserId ?? 'resident_user';
    final receiverId = widget.providerId ?? 'provider_user';
    final bookingId = widget.bookingId ?? '1';

    final ok = await vm.sendMessage(
      bookingId: bookingId,
      senderId: senderId,
      receiverId: receiverId,
      content: text,
    );

    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage ?? 'Failed to send message')),
      );
    } else {
      _messageController.clear();
      _scrollToBottom();

      vm.simulateProviderReply(
        bookingId: bookingId,
        providerName: widget.name,
        providerRole: widget.role,
        providerImage: widget.image,
        lastUserMessage: text,
        receiverId: senderId,
      );
    }
    setState(() => _isSending = false);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.white70 : Colors.grey;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final otherBubble = isDark ? const Color(0xFF2A2A2A) : Colors.grey[200];
    final borderCol = isDark ? Colors.grey.shade700 : Colors.grey.shade300;
    final inputFill = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: titleColor),
          onPressed: () {
            final vm = Provider.of<MessagesViewModel>(context, listen: false);
            vm.setActiveChat(null);
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(widget.image),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                        BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Consumer<MessagesViewModel>(
                builder: (context, vm, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: titleColor),
                      ),
                      Text(
                        vm.isProviderTyping
                            ? 'typing...'
                            : 'Online • ${widget.role}',
                        style: TextStyle(
                          color: vm.isProviderTyping ? Colors.green : subColor,
                          fontSize: 12,
                          fontStyle: vm.isProviderTyping ? FontStyle.italic : FontStyle.normal,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<MessagesViewModel>(
              builder: (context, vm, child) {
                if (vm.isLoading && vm.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = vm.messages;
                final showTyping = vm.isProviderTyping;
                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length + (showTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (showTyping && index == 0) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: otherBubble,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _typingDot(1),
                              const SizedBox(width: 4),
                              _typingDot(2),
                              const SizedBox(width: 4),
                              _typingDot(3),
                            ],
                          ),
                        ),
                      );
                    }
                    final msgIndex = showTyping ? index - 1 : index;
                    final msg = messages[messages.length - 1 - msgIndex];
                    final isMe = _isMessageFromMe(msg);
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : otherBubble,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.content ?? msg.message,
                              style: TextStyle(
                                color: isMe ? Colors.white : titleColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  msg.time,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isMe ? Colors.white70 : subColor,
                                  ),
                                ),
                                if (isMe) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.done_all,
                                    size: 12,
                                    color: isMe ? Colors.white70 : subColor,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(color: titleColor),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: subColor),
                      filled: true,
                      fillColor: inputFill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: borderCol),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: borderCol),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: _isSending
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _typingDot(int order) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + order * 200),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: 0.3 + (value * 0.7),
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _autoReplyTimer?.cancel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        Provider.of<MessagesViewModel>(context, listen: false).setActiveChat(null);
      } catch (_) {}
    });
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
