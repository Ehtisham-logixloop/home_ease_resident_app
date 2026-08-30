
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/routes/routes_name.dart';
import '../../../data/models/notification_model.dart';
import '../../../view_model/message_view_model.dart';
import '../../Bottom_navigation/views/bottom_navigation.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MessagesViewModel>(context, listen: false).fetchNotifications();
    });
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'booking_accepted':
        return Icons.check_circle;
      case 'booking_rejected':
        return Icons.cancel;
      case 'new_message':
        return Icons.chat;
      case 'service_started':
        return Icons.play_circle;
      case 'service_completed':
        return Icons.task_alt;
      case 'payment_received':
        return Icons.payment;
      default:
        return Icons.notifications;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'booking_accepted':
        return Colors.green;
      case 'booking_rejected':
        return Colors.red;
      case 'new_message':
        return Colors.blue;
      case 'service_started':
        return Colors.orange;
      case 'service_completed':
        return Colors.teal;
      case 'payment_received':
        return Colors.purple;
      default:
        return Colors.blueGrey;
    }
  }

  void _onTapNotification(NotificationModel notification) {
    final vm = Provider.of<MessagesViewModel>(context, listen: false);
    if (notification.id != null) {
      vm.markNotificationRead(notification.id!);
    }
    if (notification.relatedType == 'booking' &&
        notification.relatedId != null &&
        notification.relatedId!.isNotEmpty) {
      if (notification.type == 'booking_accepted' ||
          notification.type == 'booking_rejected') {
        Navigator.pushNamed(
          context,
          RoutesName.booking,
        );
      } else {
        Navigator.pushNamed(
          context,
          RoutesName.chat,
          arguments: {
            'name': 'Service Provider',
            'image': 'assets/images/worker.png',
            'role': notification.type,
            'bookingId': notification.relatedId,
            'providerId': null,
            'userId': null,
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.white60 : Colors.grey;
    final dividerColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final cardBg = Theme.of(context).cardColor;
    final unreadBg = isDark ? Colors.blue.withValues(alpha: 0.15) : Colors.blue.shade50;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: scaffoldBg,
        title: Text(
          "Notifications",
          style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: titleColor),
        actions: [
          Consumer<MessagesViewModel>(
            builder: (context, vm, child) {
              if (vm.unreadNotificationCount == 0) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.done_all, color: Colors.blue),
                onPressed: () {
                  Provider.of<MessagesViewModel>(context, listen: false)
                      .markAllNotificationsRead();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All notifications marked as read')),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<MessagesViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading && vm.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = vm.notifications;
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 80, color: subColor),
                  const SizedBox(height: 12),
                  Text(
                    "No notifications yet",
                    style: TextStyle(fontSize: 16, color: subColor),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => vm.fetchNotifications(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final n = items[index];
                
                final isUnread = !n.isRead;
                final cardColor = isDark 
                    ? (isUnread ? const Color(0xFF233040) : const Color(0xFF1E1E1E))
                    : (isUnread ? Colors.blue.shade50 : Colors.white);
                final shadowColor = isDark ? Colors.black45 : Colors.grey.shade200;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: isUnread 
                      ? Border.all(color: Colors.blue.withValues(alpha: 0.5), width: 1.5)
                      : Border.all(color: isDark ? Colors.white12 : Colors.grey.shade300, width: 1),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _onTapNotification(n),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: _colorForType(n.type).withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _iconForType(n.type),
                                color: _colorForType(n.type),
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          n.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                            color: titleColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        n.formattedTime,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isUnread ? Colors.blue : subColor,
                                          fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    n.body,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isUnread ? (isDark ? Colors.white70 : Colors.black87) : subColor, 
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 2),
    );
  }
}
