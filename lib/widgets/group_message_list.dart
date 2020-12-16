import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart';

class GroupMessageList extends StatefulWidget {
  final DocumentSnapshot messageSnapshot;
  final Animation animation;
  final UserModel user;
  final String chatRoomId;
  GroupMessageList(
      {this.messageSnapshot, this.animation, this.user, this.chatRoomId});

  @override
  _GroupMessageListState createState() => _GroupMessageListState();
}

class _GroupMessageListState extends State<GroupMessageList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizeTransition(
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
            child: Text(
              widget.messageSnapshot.data()['message'],
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'OverpassRegular',
                  fontWeight: FontWeight.w300),
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
          padding: EdgeInsets.only(top: 8, left: 14, right: 0),
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
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.messageSnapshot.data()['sendBy'] + ": ",
                    style: TextStyle(color: Colors.indigo, fontSize: 16),
                  ),
                  Text(widget.messageSnapshot.data()['message'],
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w300)),
                ]),
          ),
        ),
      )
    ];
  }
}
