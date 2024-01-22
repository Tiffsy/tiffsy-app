import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  User? FirebaseUser;

  Future<void> signInWithPhoneNumber(
      {required String phoneNumber,
      required Function(PhoneAuthCredential) verificationCompleted,
      required Function(FirebaseAuthException) verificationFailed,
      required Function(String, int?) codeSent,
      required Function(String) codeAutoRetrievalTimeout}) async {
    await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future<void> storePhoneNumber({required String phoneNumber}) async {
    CollectionReference users = firestore.collection('users_phone');
    
    await users.add({
      'phoneNumber': phoneNumber,
    });
  }

  Future<bool> checkPhoneNumber({required String phoneNumber}) async {
    CollectionReference users = firestore.collection('users_phone');
    QuerySnapshot querySnapshot =
        await users.where('phoneNumber', isEqualTo: phoneNumber).get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> storeEmail({required String mailId}) async {
    CollectionReference users = firestore.collection('email');
    await users.add({
      'email': mailId,
    });
  }

  Future<bool> checkEmail({required String mailId}) async {
    CollectionReference users = firestore.collection('email');
    QuerySnapshot querySnapshot =
        await users.where('email', isEqualTo: mailId).get();
    return querySnapshot.docs.isNotEmpty;
  }
}
