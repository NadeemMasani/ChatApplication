import 'package:ChatApplication/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatServices {
  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addChatRoom(chatRoom, chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> addGroupChat(chatRoom) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .add(chatRoom)
        .catchError((e) {
      print(e.toString());
    });
  }

  getChats(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true);
  }

  getGroupChatsMessage(String groupChatGroupChatId) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(groupChatGroupChatId)
        .collection("chats")
        .orderBy("time", descending: true);
  }

  getUsers() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  getUserByName() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  Future<UserModel> getUserByEmail(String email) async {
    QuerySnapshot snapshot;
    await FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: email)
        .get()
        .then((value) => snapshot = value);

    UserModel user = new UserModel();

    user.firstName = snapshot.docs.first.data()['name'];
    user.lastName = "";
    user.phoneNumber = snapshot.docs.first.data()['phone'];
    user.email = snapshot.docs.first.data()['email'];

    return user;
  }

  getChatRooms(String email) {
    return FirebaseFirestore.instance
        .collection('chatRoom')
        .where('isGroupChat', isEqualTo: false)
        .where('emails', arrayContains: email)
        .snapshots();
  }

  addMessage(String chatRoomId, chatMessageData, String email) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });

    String unreadEmail = chatRoomId
        .replaceAll("_", "")
        .replaceAll(email, "")
        .replaceAll(".com", "");
    String unreadMsgskey = "unreadMsgs" + "." + unreadEmail;

    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .update({unreadMsgskey: FieldValue.increment(1)});
  }

  addGroupChatMessage(String groupChatId, messageMap) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(groupChatId)
        .collection("chats")
        .add(messageMap);
  }

  updateReadyBy(String id, String chatRoomId, String email) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .doc(id)
        .update({
      "readBy": true,
    });
  }

  markRead(String chatRoomId, String email) {
    email = email.replaceAll(".com", "");
    String key = "unreadMsgs" + "." + email;
    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .update({key: 0});
  }

  Future<bool> checkChatRoomExists(String chatRoomId) async {
    bool exists;

    var collection = await FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .get();

    if (collection.data() == null) {
      exists = false;
    } else {
      exists = true;
    }

    return exists;
  }

  getGroupChats(String email) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .where('isGroupChat', isEqualTo: true)
        .where('emails', arrayContains: email)
        .snapshots();
  }
}
