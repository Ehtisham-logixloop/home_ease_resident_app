
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
    if (notification.relatedType == 'booking' &&
        notification.relatedId != null &&
        notification.relatedId!.isNotEmpty) {
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
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              separatorBuilder: (context, index) =>
                  Divider(color: dividerColor, height: 1, indent: 72),
              itemBuilder: (context, index) {
                final n = items[index];
                final bg = n.isRead ? cardBg : unreadBg;
                return InkWell(
                  onTap: () => _onTapNotification(n),
                  child: Container(
                    color: bg,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _colorForType(n.type).withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _iconForType(n.type),
                            color: _colorForType(n.type),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
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
                                        fontWeight:
                                            n.isRead ? FontWeight.normal : FontWeight.bold,
                                        color: titleColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    n.formattedTime,
                                    style: TextStyle(fontSize: 11, color: subColor),
                                  ),
                                  if (!n.isRead) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                n.body,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: subColor, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
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
