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

  //create a new chatroom between 2 people
  Future<void> addChatRoom(chatRoom, chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      return null;
    });
  }

//create a new group chat
  Future<void> addGroupChat(chatRoom) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .add(chatRoom)
        .catchError((e) {
      return null;
    });
  }

//get all chat messages for the given chat room id
  getChats(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true);
  }

  //get group chat messages for the id
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
    user.base64Image = snapshot.docs.first.data()['image'];

    return user;
  }

//get all chat rooms the user is involved in
  getChatRooms(String email) {
    return FirebaseFirestore.instance
        .collection('chatRoom')
        .where('isGroupChat', isEqualTo: false)
        .where('emails', arrayContains: email)
        .snapshots();
  }

//send a new messgae in the chat room
  addMessage(String chatRoomId, chatMessageData, String email) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      return null;
    });

    String unreadEmail = chatRoomId
        .replaceAll("_", "")
        .replaceAll(email, "")
        .replaceAll(".", "")
        .replaceAll("com", "");
    String unreadMsgskey = "unreadMsgs" + "." + unreadEmail;

    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .update({unreadMsgskey: FieldValue.increment(1)});
  }

//add new message in the groupchat
  addGroupChatMessage(String groupChatId, messageMap) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(groupChatId)
        .collection("chats")
        .add(messageMap);
  }

//make the message as read by the user
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

  //set the count for unread messages
  markRead(String chatRoomId, String email) {
    email = email.replaceAll(".", "").replaceAll("com", "");
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

//get all group chats for the user
  getGroupChats(String email) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .where('isGroupChat', isEqualTo: true)
        .where('emails', arrayContains: email)
        .snapshots();
  }
}
