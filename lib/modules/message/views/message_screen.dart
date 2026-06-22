import 'package:flutter/material.dart';
import '../../../data/models/message_model.dart';
import '../../../view_model/message_view_model.dart';
import '../../main/views/bottom_navigation.dart';



class MessageScreen extends StatelessWidget {
  final MessagesViewModel viewModel = MessagesViewModel();
  @override
  Widget build(BuildContext context) {
    List<ChatMessage> messages = viewModel.getMessages();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "All Messages",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search here",
                prefixIcon: Icon(Icons.search, color: Colors.blue),
                suffixIcon: Container(
                  margin: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.arrow_forward, color: Colors.white),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: messages.length,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.grey.shade300, height: 1),
              itemBuilder: (context, index) {
                final msg = messages[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(msg.image),
                ),
                title: Text(
                    "${msg.name} (${msg.role})",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(msg.message),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(msg.time,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500)),
                      if (msg.unreadCount > 0)
                        Container(
                          margin: EdgeInsets.only(top: 6),
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            msg.unreadCount.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
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

