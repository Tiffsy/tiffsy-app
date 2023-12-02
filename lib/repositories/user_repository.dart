import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tiffsy_app/screens/LoginScreen/bloc/login_bloc.dart';

class UserRepository{

  late final FirebaseAuth _firebaseAuth;
  late final GoogleSignIn _googleSignIn; 

  String? _verificationId;
  String? state;

  UserRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(); 


  Future<User?> signInWithGoogle() async { 
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if(googleUser == null){
      return null;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = authResult.user;
      return user;
    } 
    catch (e) {
      return null;
    }
    
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser!;
    return currentUser != null;
  }

  Future<String?> getUser() async {
    return (await _firebaseAuth.currentUser!).email;
  }

  Future<Future<List<void>>> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<void> handleSignOut() => GoogleSignIn().disconnect();

}


