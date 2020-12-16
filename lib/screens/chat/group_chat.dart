import 'package:ChatApplication/model/user.dart';
import 'package:ChatApplication/network/chat_service.dart';
import 'package:ChatApplication/screens/shared/alerts.dart';
import 'package:ChatApplication/screens/shared/input_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

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
    //get data of current user from either constructor or shared prefs
    final currUserPhone = widget.user.phoneNumber;
    final currName = widget.user.firstName + widget.user.lastName;
    final currUserEmail = widget.user.email;

    void addUserToList(String email, String name){
      if(userList.length<5) {
        if (!userList.contains(email)) {
          setState(() {
            userList.add(email);
            userNameList.add(name);
          });
        }else{
          showAlertDialog(context, "User is already added to the list", "Attention");
        }
      }else{
        showAlertDialog(context, "Maximum user in group chat allowed are 5", "Attention");
      }
      print(userList);
    }

    void startGroupChat(List userEmailList, List userNameList){
      Map<String, dynamic> chatRoom = {
        "users": userNameList,
        "emails": userEmailList,
      };

      chatServices.addGroupChat(chatRoom);

      showAlertDialog(context, "Group CHat strted", "Attention");

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
          Wrap(
            children: <Widget>[
              for(int i =0 ; i <userList.length; i++)
                Card(
                  elevation: 5,
                  margin: EdgeInsets.all(5),
                  child: Wrap(
                    children: [
                      Text(userList[i]),
                      GestureDetector(
                          onTap: (){
                            setState(() {
                              userList.removeAt(i);
                            });
                          },
                          child: Icon(Icons.highlight_remove, size: 15,)
                      ),
                    ],
                  ),
                )
            ],
          ),
          SizedBox(height: 10,),
          if(userList.length>=2) GestureDetector(
            onTap: (){
              startGroupChat(userList, userNameList);
            },
            child: Container(
                padding: EdgeInsets.all(10),
                decoration: boxDecoration,
                child: Text("Start Chat", style: TextStyle(color: Colors.white),),
              ),
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
                          addUserToList(snapshot.data.docs[index]['email'], snapshot.data.docs[index]['name']);
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
                        print(snapshot.data.docs[index]['name']);
                        return GestureDetector(
                          onTap: () {
                            addUserToList(snapshot.data.docs[index]['email'], snapshot.data.docs[index]['name']);
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
