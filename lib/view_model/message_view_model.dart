import '../data/models/message_model.dart';


class MessagesViewModel {
  List<ChatMessage> getMessages() {
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
}

