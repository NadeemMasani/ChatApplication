import 'package:flutter/material.dart';
import '../screens/chat/user_list.dart';
import '../screens/chat/user_chats.dart';
import '../main.dart';

class AppNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chap Application"),
          actions: [
            GestureDetector(
              onTap: () {
                //FireBase Logout functionality
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return MyApp();
                }));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.exit_to_app)),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.message)),
              Tab(icon: Icon(Icons.list)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UserChats(),
            UserList(),
          ],
        ),
      ),
    );
  }
}
