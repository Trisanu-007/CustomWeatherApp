
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class CurrentUser{
  final String uid;
  CurrentUser({this.uid});
}

class Authenticate{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  CurrentUser _convertToCurrentUser(FirebaseUser user){
    return user !=null ? CurrentUser(uid: user.uid) : null;
  }

  Future signIn(String password,String email) async{
    try{
      AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
      FirebaseUser user = result.user;
      print(user);
      return _convertToCurrentUser(user);
    }on PlatformException catch (error){
      print (error);
      return error.toString();
    }catch(error){
      print (error);
      return error.toString();
    }
  }

  Future register(String password,String email) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      FirebaseUser user = result.user;
      return _convertToCurrentUser(user);
    } on PlatformException catch (error){
      print (error);
      return error.toString();
    }catch(error){
      print (error);
      return error.toString();
    }
  }

  Future signOut() async {
    try{
      return await _firebaseAuth.signOut();
    }catch(error){
      print(error.toString());
      return null;
    }
  }

  Stream<CurrentUser> get user{
    return _firebaseAuth.onAuthStateChanged.map(_convertToCurrentUser);
  }
}
