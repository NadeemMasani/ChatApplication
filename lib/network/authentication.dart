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
      final User firebaseUser = result.user;
      return _userFromFirebase(firebaseUser);
    }catch(e){
      return null;
    }
  }

  Future<UserModel> signUpWithEmailAndPassword(String email, String password) async{

      final UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final User firebaseUser = result.user;
      return _userFromFirebase(firebaseUser);

  }

  Future resetPassword(String email) async{

      return await _auth.sendPasswordResetEmail(email: email);

  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      return null;
    }
  }

}