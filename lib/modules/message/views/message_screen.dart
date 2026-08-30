import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/routes/routes_name.dart';
import '../../../view_model/message_view_model.dart';
import '../../Bottom_navigation/views/bottom_navigation.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<MessagesViewModel>(context, listen: false);
      vm.fetchChatThreads();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.white60 : Colors.grey;
    final dividerColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final searchFill = isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: scaffoldBg,
        title: Text(
          "All Messages",
          style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: titleColor),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              style: TextStyle(color: titleColor),
              decoration: InputDecoration(
                hintText: "Search here",
                hintStyle: TextStyle(color: subColor),
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
                filled: true,
                fillColor: searchFill,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<MessagesViewModel>(
              builder: (context, vm, child) {
                if (vm.isLoading && vm.threads.isEmpty && vm.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (vm.threads.isNotEmpty) {
                  return ListView.separated(
                    itemCount: vm.threads.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: dividerColor, height: 1),
                    itemBuilder: (context, index) {
                      final thread = vm.threads[index];
                      return ListTile(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RoutesName.chat,
                            arguments: {
                              'name': thread.providerName,
                              'image': thread.providerImage,
                              'role': thread.providerRole,
                              'bookingId': thread.bookingId,
                              'providerId': thread.providerId,
                              'userId': null,
                            },
                          );
                        },
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(thread.providerImage),
                        ),
                        title: Text(
                          "${thread.providerName} (${thread.providerRole})",
                          style: TextStyle(fontWeight: FontWeight.bold, color: titleColor),
                        ),
                        subtitle: Text(
                          thread.lastMessage,
                          style: TextStyle(color: subColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              thread.lastMessageTime,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: titleColor,
                              ),
                            ),
                            if (thread.unreadCount > 0)
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  thread.unreadCount.toString(),
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                }
                final fallback = MessagesViewModel().getSampleMessages();
                return ListView.separated(
                  itemCount: fallback.length,
                  separatorBuilder: (context, index) =>
                      Divider(color: dividerColor, height: 1),
                  itemBuilder: (context, index) {
                    final msg = fallback[index];
                    return ListTile(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RoutesName.chat,
                          arguments: {
                            'name': msg.name,
                            'image': msg.image,
                            'role': msg.role,
                            'bookingId': (index + 1).toString(),
                            'providerId': 'p${index + 1}',
                            'userId': null,
                          },
                        );
                      },
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(msg.image),
                      ),
                      title: Text(
                        "${msg.name} (${msg.role})",
                        style: TextStyle(fontWeight: FontWeight.bold, color: titleColor),
                      ),
                      subtitle: Text(msg.message, style: TextStyle(color: subColor)),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(msg.time,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500, color: titleColor)),
                          if (msg.unreadCount > 0)
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                msg.unreadCount.toString(),
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 2),
    );
  }
}
