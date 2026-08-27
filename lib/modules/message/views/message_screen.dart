import 'package:flutter/material.dart';
import '../../../core/utils/routes/routes_name.dart';
import '../../../data/models/message_model.dart';
import '../../../view_model/message_view_model.dart';
import '../../Bottom_navigation/views/bottom_navigation.dart';


class MessageScreen extends StatelessWidget {
  final MessagesViewModel viewModel = MessagesViewModel();
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.white60 : Colors.grey;
    final dividerColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final searchFill = isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100;
    List<ChatMessage> messages = viewModel.getMessages();
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
            child: ListView.separated(
              itemCount: messages.length,
              separatorBuilder: (context, index) =>
                  Divider(color: dividerColor, height: 1),
              itemBuilder: (context, index) {
                final msg = messages[index];
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoutesName.chat,
                      arguments: {
                        'name': msg.name,
                        'image': msg.image,
                        'role': msg.role,
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
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 2),
    );
  }
}
