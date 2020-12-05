import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../chat/chat_screen.dart';
import '../../network/chat_service.dart';

class UserChats extends StatelessWidget {
  //to be replaced  by current logged in user (constructor or shared prefs)
  final currUser = "Tejas Patil";
  final currPhone = 6199999999;

  //to make network call to firebase
  final ChatServices chatServices = ChatServices();

  @override
  Widget build(BuildContext context) {
    String getChatRoomId(int curNo, int msgNo) {
      if (curNo > msgNo) {
        return curNo.toString() + "_" + msgNo.toString();
      } else {
        return msgNo.toString() + "_" + curNo.toString();
      }
    }

    goToChatScreen(String userName, int phoneNo) {
      String chatRoomId = getChatRoomId(currPhone, phoneNo);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return ChatScreen(userName, chatRoomId);
        }),
      );
    }

    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: chatServices.getChatRooms(currPhone),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              final toUser = document.data()['users'][0] == currUser
                  ? document.data()['users'][1]
                  : document.data()['users'][0];
              final toPhone = document
                  .data()['chatRoomId']
                  .replaceAll("_", "")
                  .replaceAll(currPhone.toString(), "");
              print(toUser);
              print(toPhone);
              return Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black26))),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    goToChatScreen(toUser, int.parse(toPhone));
                  },
                  child: ListTile(
                      title: Text(toUser),
                      subtitle: Text(toPhone),
                      trailing: Icon(Icons.message)),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
