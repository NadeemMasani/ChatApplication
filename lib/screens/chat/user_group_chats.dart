import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/user.dart';
import '../chat/add_group_chat.dart';
import '../../network/chat_service.dart';
import '../chat/group_chat_screen.dart';

class UserGroupChats extends StatelessWidget {
  final UserModel user;
  UserGroupChats({this.user});

  @override
  Widget build(BuildContext context) {
    print(user.email);
    ChatServices chatServices = ChatServices();

    goToGroupChatScreen(String groupChatId, String groupName) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return GroupChatScreen(
              groupChatId: groupChatId, user: user, groupName: groupName);
        }),
      );
    }

    return Stack(children: [
      Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: chatServices.getGroupChats(user.email),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                final String groupChatId = document.id;
                final String groupName = document.data()['name'];
                return Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black26))),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      goToGroupChatScreen(groupChatId, groupName);
                    },
                    child: ListTile(
                      title: Text(document.data()['name']),
                      trailing: Icon(Icons.message),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
        alignment: Alignment.bottomRight,
        child: (FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return GroupChat(user: user);
              }),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
        )),
      ),
    ]);
  }
}
