import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseMethods {
  void sendMessage(String person, String chat) {
    FirebaseFirestore.instance.collection("chat").add({
      "chatmessage": chat,
      "isanushka": person == "Anushka" ? true : false,
      "chat_sent": DateTime.now()
    });
  }
}
