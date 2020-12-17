import 'dart:convert';
import 'dart:io';

import 'package:ChatApplication/model/user.dart';
import 'package:ChatApplication/navigation/app_navigator.dart';
import 'package:ChatApplication/network/chat_service.dart';
import 'package:ChatApplication/screens/authentication/signin_screen.dart';
import 'package:ChatApplication/widgets/alerts.dart';
import 'package:ChatApplication/widgets/image_display.dart';
import 'package:ChatApplication/widgets/input_decoration.dart';
import 'package:ChatApplication/network/authentication.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  UserModel currentUser;
  final ChatServices chatServices = ChatServices();
  bool success = false;
  String errorMessage;
  final picker = ImagePicker();
  bool isImageSelected = false;
  String base64Image;

  signUpWithEmailAndPassword() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      UserModel user;
      try {
        user = await authMethods.signUpWithEmailAndPassword(
            emailController.text, passwordController.text);
        setState(() {
          success = true;
        });
      } catch (e) {
        setState(() {
          success = false;
          isLoading = false;
          errorMessage = e.toString().substring(e.toString().indexOf(']') + 1);
        });
      }

      if (success) {
        user.firstName = firstNameController.text;
        user.lastName = lastNameController.text;
        user.email = emailController.text;
        user.phoneNumber = int.parse(phoneNumberController.text);
        user.password = passwordController.text;
        user.base64Image = base64Image;

        setState(() {
          currentUser = user;
        });

        Map<String, dynamic> userDataMap = {
          "name": firstNameController.text + lastNameController.text,
          "email": emailController.text,
          "phone": int.parse(phoneNumberController.text),
          "image": base64Image
        };

        chatServices.addUserInfo(userDataMap);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AppNavigator(user: currentUser)));
      } else {
        showAlertDialog(context, errorMessage, 'Alert');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 50,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ///Display Uploaded Image
                    if (base64Image != null) ImageDisplay(base64: base64Image),

                    ///SignUp Form
                    Form(
                        key: formKey,
                        child: Column(children: [
                          TextFormField(
                              decoration: formInputDecoration.copyWith(
                                  labelText: 'First Name'),
                              controller: firstNameController,
                              validator: (val) {
                                return val.isEmpty || val.trim().isEmpty
                                    ? "Please enter some text"
                                    : null;
                              }),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                              decoration: formInputDecoration.copyWith(
                                  labelText: 'Last Name'),
                              controller: lastNameController,
                              validator: (val) {
                                return val.isEmpty || val.trim().isEmpty
                                    ? "Please enter some text"
                                    : null;
                              }),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                              decoration: formInputDecoration.copyWith(
                                  labelText: 'Email'),
                              controller: emailController,
                              validator: (val) {
                                if (val.isEmpty || val.trim().isEmpty) {
                                  return "Please enter some text";
                                } else if (val.contains("_")) {
                                  return "_ is not allowed in email id";
                                } else
                                  return null;
                              }),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                              decoration: formInputDecoration.copyWith(
                                  labelText: 'Phone Number'),
                              controller: phoneNumberController,
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                return val.isEmpty || val.trim().isEmpty
                                    ? "Please enter some text"
                                    : null;
                              }),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                              decoration: formInputDecoration.copyWith(
                                  labelText: 'Password'),
                              controller: passwordController,
                              obscureText: true,
                              validator: (val) {
                                return val.isEmpty ||
                                        val.trim().isEmpty ||
                                        val.length < 5
                                    ? "Please enter password greater than 5 char"
                                    : null;
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            title: Text('Upload a Photo'),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.image,
                                color: Color.fromRGBO(72, 72, 74, 1),
                              ),
                              onPressed: () async {
                                PickedFile pickedFile = await picker.getImage(
                                    source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  File image = File(pickedFile.path);
                                  setState(() {
                                    isImageSelected = true;
                                    base64Image =
                                        base64Encode(image.readAsBytesSync());
                                  });
                                }
                              },
                            ),
                          ),
                        ])),
                    GestureDetector(
                      onTap: () {
                        signUpWithEmailAndPassword();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(20),
                        decoration: boxDecoration,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignIn()));
                        },
                        child: Text(
                          'Already have a account, Sign In',
                          style: TextStyle(
                              fontSize: 15,
                              decoration: TextDecoration.underline),
                        ))
                  ],
                ),
              ),
            ),
    );
  }
}
