import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chat_flutter/ui/chatScreen.dart';
import 'package:chat_flutter/enums/signInMethod.dart';

class GoogleLogin {
  static final GoogleLogin instance = GoogleLogin._internal();
  GoogleLogin._internal();

  final GoogleSignIn googleSignIn = GoogleSignIn();

  void signOut() {
    print(
        "Google logout ${googleSignIn.clientId} ${ChatScreen.getCurrentUser}");
    FirebaseAuth.instance.signOut();
    googleSignIn.signOut();
  }

  Future<FirebaseUser> getUser(FirebaseUser _currentUser) async {
    if (_currentUser != null) return _currentUser;
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      final AuthResult authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final FirebaseUser user = authResult.user;
      if (user != null) {
        ChatScreen.setCurrentUser = user;
        UserSignInMethod.setCurrentSignInMethod = SignInMethod.Google;
      }
      return user;
    } catch (e) {
      return null;
    }
  }
}
