import 'package:ChatApplication/model/user.dart';
import 'package:ChatApplication/navigation/app_navigator.dart';
import 'package:ChatApplication/network/chat_service.dart';
import 'package:ChatApplication/screens/authentication/signin_screen.dart';
import 'package:ChatApplication/screens/shared/alerts.dart';
import 'package:ChatApplication/screens/shared/input_decoration.dart';
import 'package:ChatApplication/services/authentication.dart';
import 'package:flutter/material.dart';

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

        setState(() {
          currentUser = user;
        });

        Map<String, dynamic> userDataMap = {
          "name": firstNameController.text + lastNameController.text,
          "email": emailController.text,
          "phone": int.parse(phoneNumberController.text),
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
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
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
                                return val.isEmpty || val.trim().isEmpty
                                    ? "Please enter some text"
                                    : null;
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
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
