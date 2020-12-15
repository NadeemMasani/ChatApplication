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
  String searchText = "";
  @override
  Widget build(BuildContext context) {
    ChatServices chatServices = new ChatServices();
    //get data of current user from either constructor or shared prefs
    final currUserPhone = widget.user.phoneNumber;
    final currName = widget.user.firstName + widget.user.lastName;
    final currUserEmail = widget.user.email;

    String getChatRoomId(
      String currUserEmail,
      String email,
    ) {
      if (currUserEmail.compareTo(email) == 1) {
        return currUserEmail + "_" + email;
      } else {
        return email + "_" + currUserEmail;
      }
    }

    sendMessage(String userName, int phoneNo, String email) {
      //create chat room id
      List<String> users = [currName, userName];
      List<int> phoneNos = [currUserPhone, phoneNo];
      List<String> emails = [currUserEmail, email];
      List<Map<String, String>> unreadMsgs = [
        {currUserEmail: "0"},
        {email: "0"}
      ];
      // String chatRoomId = getChatRoomId(currUserPhone, phoneNo);
      String chatRoomId = getChatRoomId(currUserEmail, email);

      Map<String, dynamic> chatRoom = {
        "users": users,
        "chatRoomId": chatRoomId,
        "phoneNos": phoneNos,
        "emails": emails,
        "unreadMsgs": unreadMsgs,
      };
      chatServices.addChatRoom(chatRoom, chatRoomId);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return ChatScreen(
              name: userName, chatRoomId: chatRoomId, user: widget.user);
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
                width: MediaQuery.of(context).size.width - 80,
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
            stream: chatServices.getUserByName(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              return Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final name =
                        snapshot.data.docs[index]['name'].toLowerCase();
                    final email =
                        snapshot.data.docs[index]['email'].toLowerCase();

                    if (searchText == "") {
                      return GestureDetector(
                        onTap: () {
                          sendMessage(
                              snapshot.data.docs[index]['name'],
                              snapshot.data.docs[index]['phone'],
                              snapshot.data.docs[index]['email']);
                        },
                        child: ListTile(
                          title: Text(snapshot.data.docs[index]['name']),
                          subtitle: Text(snapshot.data.docs[index]['email']),
                          trailing: snapshot.data.docs[index]['email'] !=
                                  currUserEmail
                              ? Icon(Icons.message)
                              : Text("me"),
                        ),
                      );
                    } else {
                      if (name.contains(searchText.toLowerCase()) ||
                          email.contains(searchText.toLowerCase())) {
                        print(snapshot.data.docs[index]['name']);
                        return GestureDetector(
                          onTap: () {
                            sendMessage(
                                snapshot.data.docs[index]['name'],
                                snapshot.data.docs[index]['phone'],
                                snapshot.data.docs[index]['email']);
                          },
                          child: ListTile(
                            title: Text(snapshot.data.docs[index]['name']),
                            subtitle: Text(snapshot.data.docs[index]['email']),
                            trailing: snapshot.data.docs[index]['email'] !=
                                    currUserEmail
                                ? Icon(Icons.message)
                                : Text("me"),
                          ),
                        );
                      } else
                        return Container();
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
