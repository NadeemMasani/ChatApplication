import 'package:ChatApplication/model/user.dart';
import 'package:ChatApplication/network/chat_service.dart';
import 'package:ChatApplication/widgets/alerts.dart';
import 'package:ChatApplication/widgets/input_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupChat extends StatefulWidget {
  final UserModel user;
  GroupChat({this.user});

  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  TextEditingController searchTextController = new TextEditingController();
  String searchText = "";
  List userList = List();
  List userNameList = List();
  ChatServices chatServices = new ChatServices();

  @override
  Widget build(BuildContext context) {
    ChatServices chatServices = new ChatServices();
    final currUserEmail = widget.user.email;
    TextEditingController groupChatNameController = new TextEditingController();

    void addUserToList(String email, String name) {
      if (userList.length < 10) {
        if (!userList.contains(email)) {
          setState(() {
            userList.add(email);
            userNameList.add(name);
          });
        } else {
          showAlertDialog(
              context, "User is already added to the list", "Attention");
        }
      } else {
        showAlertDialog(
            context, "Maximum user in group chat allowed are 5", "Attention");
      }
    }

    void startGroupChat(List userEmailList, List userNameList) {
      if (groupChatNameController.text.isEmpty) {
        showAlertDialog(
            context, "Group chat name cannot be empty", "Attention");
        return;
      }
      userNameList.add(widget.user.firstName + widget.user.lastName);
      userEmailList.add(widget.user.email);
      Map<String, dynamic> chatRoom = {
        "users": userNameList,
        "emails": userEmailList,
        "isGroupChat": true,
        "name": groupChatNameController.text,
      };

      chatServices.addGroupChat(chatRoom);

      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Group chat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 80,
                  child: TextFormField(
                    controller: searchTextController,
                    decoration:
                        formInputDecoration.copyWith(hintText: "Search"),
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
            Wrap(
              children: <Widget>[
                for (int i = 0; i < userList.length; i++)
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.all(5),
                    child: Wrap(
                      children: [
                        Text(userList[i]),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                userList.removeAt(i);
                              });
                            },
                            child: Icon(
                              Icons.highlight_remove,
                              size: 15,
                            )),
                      ],
                    ),
                  )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                decoration: formInputDecoration.copyWith(labelText: 'Name'),
                controller: groupChatNameController,
                validator: (val) {
                  return val.isEmpty || val.trim().isEmpty
                      ? "Please enter some text"
                      : null;
                }),
            SizedBox(
              height: 10,
            ),
            if (userList.length >= 2)
              GestureDetector(
                onTap: () {
                  startGroupChat(userList, userNameList);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: boxDecoration,
                  child: Text(
                    "Create Group Chat",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            StreamBuilder<QuerySnapshot>(
              stream: chatServices.getUserByName(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                            addUserToList(snapshot.data.docs[index]['email'],
                                snapshot.data.docs[index]['name']);
                          },
                          child: ListTile(
                            title: Text(snapshot.data.docs[index]['name']),
                            subtitle: Text(snapshot.data.docs[index]['email']),
                            trailing: snapshot.data.docs[index]['email'] !=
                                    currUserEmail
                                ? Icon(Icons.add)
                                : Text("me"),
                          ),
                        );
                      } else {
                        if (name.contains(searchText.toLowerCase()) ||
                            email.contains(searchText.toLowerCase())) {
                          return GestureDetector(
                            onTap: () {
                              addUserToList(snapshot.data.docs[index]['email'],
                                  snapshot.data.docs[index]['name']);
                            },
                            child: ListTile(
                              title: Text(snapshot.data.docs[index]['name']),
                              subtitle:
                                  Text(snapshot.data.docs[index]['email']),
                              trailing: snapshot.data.docs[index]['email'] !=
                                      currUserEmail
                                  ? Icon(Icons.add)
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
      ),
    );
  }
}
