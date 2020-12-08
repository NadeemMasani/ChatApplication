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

  signUpWithEmailAndPassword(){
      if(formKey.currentState.validate()){
          setState(() {
            isLoading = true;
          });
          authMethods.signUpWithEmailAndPassword(emailController.text, passwordController.text)
              .then((value) => print(value));
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: isLoading? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ):SingleChildScrollView(
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
                      decoration: formInputDecoration.copyWith(labelText: 'First Name'),
                      controller: firstNameController,
                      validator:(val){
                        return val.isEmpty || val.trim().isEmpty ? "Please enter some text" : null;
                      }
                    ),
                    SizedBox(height: 8,),
                    TextFormField(
                      decoration: formInputDecoration.copyWith(labelText: 'Last Name'),
                      controller: lastNameController,
                      validator:(val){
                        return val.isEmpty || val.trim().isEmpty ? "Please enter some text" : null;
                      }
                    ),
                    SizedBox(height: 8,),
                    TextFormField(
                      decoration: formInputDecoration.copyWith(labelText: 'Email'),
                      controller: emailController,
                      validator:(val){
                        return val.isEmpty || val.trim().isEmpty ? "Please enter some text" : null;
                      }
                    ),
                    SizedBox(height: 8,),
                    TextFormField(
                      decoration: formInputDecoration.copyWith(labelText: 'Phone Number'),
                      controller: phoneNumberController,
                      keyboardType: TextInputType.number,
                      validator:(val){
                        return val.isEmpty || val.trim().isEmpty ? "Please enter some text" : null;
                      }
                    ),
                    SizedBox(height: 8,),
                    TextFormField(
                      decoration: formInputDecoration.copyWith(labelText: 'Password'),
                      controller: passwordController,
                      obscureText: true,
                      validator:(val){
                        return val.isEmpty || val.trim().isEmpty  || val.length <5 ? "Please enter password greater than 5 char" : null;
                      }
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: (){
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
              SizedBox(height: 10,),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(20),
                decoration:boxDecoration,
                child: Text('Sign Up with Google', style: TextStyle(color: Colors.white, fontSize: 18),),
              ),
              SizedBox(height: 5,),
              Text('Sign In', style: TextStyle(fontSize: 15, decoration: TextDecoration.underline),)
            ],
          ),
        ),
      ),
    );
  }
}
