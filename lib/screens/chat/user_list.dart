import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './chat_screen.dart';
import '../../network/chat_service.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    ChatServices chatServices = new ChatServices();
    //get data of current user from either constructor or shared prefs
    final currUserPhone = 6199999999;
    final currName = "Tejas Patil";

    String getChatRoomId(int curNo, int msgNo) {
      if (curNo > msgNo) {
        return curNo.toString() + "_" + msgNo.toString();
      } else {
        return msgNo.toString() + "_" + curNo.toString();
      }
    }

    sendMessage(String userName, int phoneNo) {
      //create chat room id
      List<String> users = [currName, userName];
      List<int> phoneNos = [currUserPhone, phoneNo];
      String chatRoomId = getChatRoomId(currUserPhone, phoneNo);
      Map<String, dynamic> chatRoom = {
        "users": users,
        "chatRoomId": chatRoomId,
        "phoneNos": phoneNos,
      };
      chatServices.addChatRoom(chatRoom, chatRoomId);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return ChatScreen(userName, chatRoomId);
        }),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: chatServices.getUsers(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return ListTile(
              title: Text(document.data()['name']),
              subtitle: Text(document.data()['phone'].toString()),
              trailing: document.data()['phone'] != currUserPhone
                  ? GestureDetector(
                      onTap: () {
                        sendMessage(
                            document.data()['name'], document.data()['phone']);
                      },
                      child: Icon(Icons.message),
                    )
                  : Text("me"),
            );
          }).toList(),
        );
      },
    );
  }
}
