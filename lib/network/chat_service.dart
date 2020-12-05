import 'package:cloud_firestore/cloud_firestore.dart';

class ChatServices {
  Future<void> addChatRoom(chatRoom, chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  getUsers() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  getChatRooms(int currUserPhone) {
    return FirebaseFirestore.instance
        .collection('chatRoom')
        .where('phoneNos', arrayContains: currUserPhone)
        .snapshots();
  }

  addMessage(String chatRoomId, chatMessageData) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }
}
