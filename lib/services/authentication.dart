import 'package:ChatApplication/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import  '../model/user.dart';
class AuthMethods{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel _userFromFirebase(User firebaseUser){
    if(firebaseUser==null) return null;
    return UserModel(uid : firebaseUser.uid);
  }

  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      final UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      print(result);
      final User firebaseUser = result.user;
      return _userFromFirebase(firebaseUser);
    }catch(e){
      print(e.toString());
    }
  }

  Future<UserModel> signUpWithEmailAndPassword(String email, String password) async{
    try{
      print("enter");
      print(_auth);
      final UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print(result);
      final User firebaseUser = result.user;
      return _userFromFirebase(firebaseUser);
    }catch(e){
      print("error occured");
      print(e.toString());
    }
  }

  Future resetPassword(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }

}