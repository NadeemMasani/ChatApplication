import 'package:ChatApplication/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatServices {
  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      print("Error Caught while adding User Info");
      print(e.toString());
    });
    print("Added UserInfo");
  }

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

  getUserByName(String userName) {
    if (userName != null && userName.isNotEmpty) {
      return FirebaseFirestore.instance
          .collection('users')
          .where("name", isEqualTo: userName)
          .snapshots();
    } else {
      print("Null Searhc text entered");
      return FirebaseFirestore.instance.collection('users').snapshots();
    }
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

    print(user.firstName +
        " " +
        user.lastName +
        " " +
        user.email +
        " " +
        user.phoneNumber.toString());
    return user;
  }

  getChatRooms(String email) {
    return FirebaseFirestore.instance
        .collection('chatRoom')
        .where('emails', arrayContains: email)
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
