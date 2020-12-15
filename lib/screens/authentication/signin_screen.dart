import 'package:ChatApplication/model/user.dart';
import 'package:ChatApplication/navigation/app_navigator.dart';
import 'package:ChatApplication/network/chat_service.dart';
import 'package:ChatApplication/screens/authentication/forgot_password.dart';
import 'package:ChatApplication/screens/authentication/signup_screen.dart';
import 'package:ChatApplication/screens/shared/alerts.dart';
import 'package:ChatApplication/screens/shared/input_decoration.dart';
import 'package:ChatApplication/screens/shared/utils.dart';
import 'package:ChatApplication/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  @override
  _SignInState createState() => _SignInState();

}

class _SignInState extends State<SignIn> {

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  AuthMethods auth = new AuthMethods();
  ChatServices chatServices = new ChatServices();

  @override
  Future<void> initState() {
    super.initState();
    Utils.retrieveUserInfo().then((user) {
      print("User Details");
      print(user.email);
      print(user.password);
        emailController.text = user.email != null ? user.email : "";
        passwordController.text = user.password != null ? user.password :"";
    }
    );


  }

  signIn()async {
    if(formKey.currentState.validate()){

      setState(() {
        isLoading = true;
      });

      UserModel user = new UserModel();
      bool isAuthenticated = false;
      await auth.signInWithEmailAndPassword(emailController.text, passwordController.text)
          .then((value) => {
            if(value!=null) isAuthenticated = true
      });

      if(isAuthenticated){
        user= await chatServices.getUserByEmail(emailController.text);
        user.password = passwordController.text;
        Utils.saveUserData(user);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => AppNavigator( user: user)
        ));
      }else{
        setState(() {
          isLoading = false;
        });
        showAlertDialog(
            context, 'Invalid id or password', 'Alert');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SignIn'),
        ),
        body: isLoading? Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ) :SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height-50,
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
                        decoration: formInputDecoration.copyWith(labelText: 'Email'),
                        controller: emailController,
                        validator:(val){
                          return val.isEmpty || val.trim().isEmpty ? "Please enter some text" : null;
                        }
                      ),
                      SizedBox(height: 8,),
                      TextFormField(
                        decoration: formInputDecoration.copyWith(labelText: 'Password'),
                        obscureText: true,
                        controller: passwordController,
                        validator:(val){
                          return val.isEmpty || val.trim().isEmpty ? "Please enter some text" : null;
                        }
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) => ForgotPassword()
                          ));
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text('Forgot Password', style: TextStyle(fontSize: 15, decoration: TextDecoration.underline),),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: (){
                          signIn();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(20),
                          decoration: boxDecoration,
                          child: Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      GestureDetector(
                          onTap: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) => SignUp()
                            ));
                          },
                          child: Text('Register Now', style: TextStyle(fontSize: 15, decoration: TextDecoration.underline),))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
