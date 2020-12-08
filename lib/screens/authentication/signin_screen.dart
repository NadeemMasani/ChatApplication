import 'package:ChatApplication/screens/shared/input_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SignIn'),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height-50,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: formInputDecoration.copyWith(labelText: 'Email'),
                ),
                SizedBox(height: 8,),
                TextField(
                  decoration: formInputDecoration.copyWith(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text('Forgot Password', style: TextStyle(fontSize: 15, decoration: TextDecoration.underline),),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  decoration: boxDecoration,
                  child: Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  decoration:boxDecoration,
                  child: Text('Sign In with Google', style: TextStyle(color: Colors.white, fontSize: 18),),
                ),
                SizedBox(height: 5,),
                Text('Register Now', style: TextStyle(fontSize: 15, decoration: TextDecoration.underline),)
              ],
            ),
          ),
        ));
  }
}
