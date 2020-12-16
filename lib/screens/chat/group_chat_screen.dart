import 'package:flutter/material.dart';
import '../../model/user.dart';
import '../../network/chat_service.dart';
import 'package:firestore_ui/firestore_ui.dart';
import '../../widgets/group_message_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChatScreen extends StatefulWidget {
  final UserModel user;
  final String groupChatId;
  final String groupName;
  GroupChatScreen({this.groupChatId, this.user, this.groupName});
  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  @override
  Widget build(BuildContext context) {
    String currUser = widget.user.firstName + widget.user.lastName;
    TextEditingController messageEditingController =
        new TextEditingController();
    ChatServices chatServices = ChatServices();

    addMessage() {
      if (messageEditingController.text.isNotEmpty) {
        Map<String, dynamic> chatMessageMap = {
          "sendBy": currUser,
          "message": messageEditingController.text,
          'time': DateTime.now().millisecondsSinceEpoch,
          // "readBy": false,
        };
        chatServices.addGroupChatMessage(widget.groupChatId, chatMessageMap);
        setState(() {
          messageEditingController.text = "";
          FocusScope.of(context).unfocus();
        });
      }
    }

    Widget chatMessages(UserModel user, String groupChatId) {
      return Expanded(
        child: FirestoreAnimatedList(
          query: chatServices.getGroupChatsMessage(groupChatId),
          reverse: true,
          itemBuilder: (BuildContext context, DocumentSnapshot snapshot,
              Animation<double> animation, int index) {
            return GroupMessageList(
              messageSnapshot: snapshot,
              animation: animation,
              user: user,
              chatRoomId: groupChatId,
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
      ),
      body: Container(
        child: Column(
          children: [
            chatMessages(widget.user, widget.groupChatId),
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
