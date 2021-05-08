import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chat_flutter/ui/chatScreen.dart';

class LoginWithEmail {
  void algo() {
    // FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
    FirebaseUser user;
    user.sendEmailVerification();
  }
}
