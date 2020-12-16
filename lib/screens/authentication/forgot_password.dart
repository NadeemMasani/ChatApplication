import 'package:ChatApplication/screens/authentication/signin_screen.dart';
import 'package:ChatApplication/screens/shared/alerts.dart';
import 'package:ChatApplication/screens/shared/input_decoration.dart';
import 'package:ChatApplication/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  AuthMethods auth = new AuthMethods();
  bool isSuccess = false;
  String errorMessage ="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SignIn'),
        ),
        body: isLoading ? Container(
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
                      GestureDetector(
                        onTap: () async{
                          if(formKey.currentState.validate()) {
                            try {
                              await auth.resetPassword(emailController.text);
                              setState(() {
                                isSuccess = true;
                              });
                            } catch (e) {
                                setState(() {
                                  errorMessage = e.toString().substring(
                                      e.toString().indexOf(']') + 2);
                                });

                            }

                            if (isSuccess) {
                              showAlertDialog(context,
                                  "Password reset email has been sent to your email Id",
                                  "Attention");
                            }else{
                              showAlertDialog(context, errorMessage, "Attention");
                            }

                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(20),
                          decoration: boxDecoration,
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(height:10),
                      GestureDetector(
                          onTap: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) => SignIn()
                            ));
                          },
                          child: Text('SignIn', style: TextStyle(fontSize: 15, decoration: TextDecoration.underline),))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
