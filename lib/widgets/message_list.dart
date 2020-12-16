import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user.dart';
import '../network/chat_service.dart';

class MessageList extends StatefulWidget {
  final DocumentSnapshot messageSnapshot;
  final Animation animation;
  final UserModel user;
  final String chatRoomId;
  MessageList(
      {this.messageSnapshot, this.animation, this.user, this.chatRoomId});

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  ChatServices chatServices = ChatServices();

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.messageSnapshot.data()['message']);
    // print(widget.user.firstName);
    // print(widget.user.lastName);
    // print(widget.messageSnapshot.data());
    // print(widget.chatRoomId);
    if (widget.user.firstName + widget.user.lastName !=
        widget.messageSnapshot.data()['sendBy']) {
      chatServices.updateReadyBy(
          widget.messageSnapshot.id, widget.chatRoomId, widget.user.email);
      chatServices.markRead(widget.chatRoomId, widget.user.email);
    }
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: widget.animation, curve: Curves.decelerate),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Row(
            children: widget.user.firstName + widget.user.lastName ==
                    widget.messageSnapshot.data()['sendBy']
                ? messagesSent()
                : messagesRecieved()),
      ),
    );
  }

  List<Widget> messagesSent() {
    return <Widget>[
      Expanded(
        child: Container(
          padding: EdgeInsets.only(top: 8, left: 0, right: 24),
          alignment: Alignment.centerRight,
          child: Container(
            margin: EdgeInsets.only(left: 30),
            padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23),
              ),
              gradient: LinearGradient(
                  colors: [const Color(0xff007EF4), const Color(0xff2A75BC)]),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    widget.messageSnapshot.data()['message'],
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w300),
                  ),
                ),
                Icon(
                  widget.messageSnapshot.data()['readBy']
                      ? Icons.check_circle
                      : Icons.check_circle_outline_rounded,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      )
    ];
  }

  List<Widget> messagesRecieved() {
    return <Widget>[
      Expanded(
        child: Container(
          padding: EdgeInsets.only(top: 8, left: 24, right: 0),
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(right: 30),
            padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23),
              ),
              gradient:
                  LinearGradient(colors: [Colors.black38, Colors.black12]),
            ),
            child: Text(widget.messageSnapshot.data()['message'],
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300)),
          ),
        ),
      )
    ];
  }
}
