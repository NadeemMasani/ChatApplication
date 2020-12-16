import 'package:ChatApplication/model/user.dart';
import 'package:flutter/material.dart';
import '../../network/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/firestore_ui.dart';
import '../../widgets/message_list.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String chatRoomId;
  final UserModel user;
  ChatScreen({this.name, this.chatRoomId, this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //to be replaced by logged in user either shared prefs or constructor....
  ChatServices chatServices = ChatServices();

  @override
  Widget build(BuildContext context) {
    String currUser = widget.user.firstName + widget.user.lastName;
    TextEditingController messageEditingController =
        new TextEditingController();

    Widget chatMessages(UserModel user, String chatRoomId) {
      return Expanded(
        child: FirestoreAnimatedList(
          query: chatServices.getChats(widget.chatRoomId),
          reverse: true,
          itemBuilder: (BuildContext context, DocumentSnapshot snapshot,
              Animation<double> animation, int index) {
            return MessageList(
                messageSnapshot: snapshot,
                animation: animation,
                user: user,
                chatRoomId: chatRoomId);
          },
        ),
      );
    }

    addMessage() {
      if (messageEditingController.text.isNotEmpty) {
        Map<String, dynamic> chatMessageMap = {
          "sendBy": currUser,
          "message": messageEditingController.text,
          'time': DateTime.now().millisecondsSinceEpoch,
          "readBy": false,
        };
        chatServices.addMessage(
            widget.chatRoomId, chatMessageMap, widget.user.email);
        setState(() {
          messageEditingController.text = "";
          FocusScope.of(context).unfocus();
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Container(
        child: Column(
          children: [
            chatMessages(widget.user, widget.chatRoomId),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: Colors.black12,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageEditingController,
                        decoration: InputDecoration(
                          hintText: "Message ...",
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
