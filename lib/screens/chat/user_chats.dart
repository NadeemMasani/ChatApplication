import 'package:ChatApplication/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../chat/chat_screen.dart';
import '../../network/chat_service.dart';

class UserChats extends StatelessWidget {
  final UserModel user;
  UserChats({this.user});

  //to make network call to firebase
  final ChatServices chatServices = ChatServices();

  @override
  Widget build(BuildContext context) {
    final currUser = user.firstName + user.lastName;
    final currEmail = user.email;

    String getChatRoomId(String currEmail, String email) {
      if (currEmail.compareTo(email) == 1) {
        return currEmail + "_" + email;
      } else {
        return email + "_" + currEmail;
      }
    }

    goToChatScreen(String userName, String email) {
      String chatRoomId = getChatRoomId(currEmail, email);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return ChatScreen(name: userName, chatRoomId: chatRoomId, user: user);
        }),
      );
    }

    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: chatServices.getChatRooms(currEmail),
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
              final toEmail = document
                  .data()['chatRoomId']
                  .replaceAll("_", "")
                  .replaceAll(currEmail, "");
              return Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black26))),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    goToChatScreen(toUser, toEmail);
                  },
                  child: ListTile(
                      title: Text(toUser),
                      subtitle: Text(toEmail),
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
