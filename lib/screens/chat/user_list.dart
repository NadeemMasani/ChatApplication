import 'package:ChatApplication/model/user.dart';
import 'package:ChatApplication/screens/shared/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './chat_screen.dart';
import '../../network/chat_service.dart';

class UserList extends StatefulWidget {

  final UserModel user;
  UserList({this.user});

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  TextEditingController searchTextController = new TextEditingController();
  String searchText ="";
  @override
  Widget build(BuildContext context) {
    ChatServices chatServices = new ChatServices();
    //get data of current user from either constructor or shared prefs
    final currUserPhone = widget.user.phoneNumber;
    final currName = widget.user.firstName+widget.user.lastName;

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
          return ChatScreen(name:userName, chatRoomId:chatRoomId, user: widget.user);
        }),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width-80,
                child: TextFormField(
                  controller: searchTextController,
                  decoration: formInputDecoration.copyWith(hintText: "Search"),
                ),
              ),
               SizedBox(width: 15),
               Container(
                 width: 40,
                 child: IconButton(
                   icon: Icon(Icons.search),
                   onPressed: () {
                       setState(() {
                           searchText = searchTextController.text;
                       });
                   },
                 ),
               ),
            ],
          ),
           StreamBuilder<QuerySnapshot>(
            // stream: chatServices.getUsers() ,
            stream: chatServices.getUserByName(searchText) ,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              return Expanded(
                child: new ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
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
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
