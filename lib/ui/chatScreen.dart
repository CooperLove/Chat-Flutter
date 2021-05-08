import 'dart:io';

import 'package:chat_flutter/enums/signInMethod.dart';
import 'package:chat_flutter/signInMethods/facebookSignIn.dart';
import 'package:chat_flutter/signInMethods/googleSignIn.dart';
import 'package:chat_flutter/ui/chatMessage.dart';
import 'package:chat_flutter/ui/textComposer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  static FirebaseUser _currentUser;
  static FirebaseUser get getCurrentUser => _currentUser;
  static set setCurrentUser(FirebaseUser user) => _currentUser = user;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      setState(() {
        print("Atualizando user $user");
        ChatScreen.setCurrentUser = user;
      });
    });
  }

  bool _isLoadingImage = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void _sendMessage({String text, File imgFile}) async {
    // final FirebaseUser user =
    //     await GoogleLogin.instance.getUser(ChatScreen.getCurrentUser);
    final FirebaseUser user = await _getUser();

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Não foi possível realizar o login! Tente Novamente")));
    }
    Map<String, dynamic> data = {
      "uid": user.uid,
      "senderName": user.displayName,
      "senderPhotoUrl": user.photoUrl,
      "time": Timestamp.now()
    };

    if (imgFile != null) {
      StorageUploadTask task = FirebaseStorage.instance
          .ref()
          .child(user.uid + DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imgFile);

      setState(() {
        _isLoadingImage = true;
      });

      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      print(url);
      if (url != null) data["imgUrl"] = url;
    }
    if (text != null) data["text"] = text;
    setState(() {
      _isLoadingImage = false;
    });

    Firestore.instance.collection("mensagens").add(data);
  }

  Future<FirebaseUser> _getUser() async {
    print("Getting user ${UserSignInMethod.getCurrentSignInMethod}");
    switch (UserSignInMethod.getCurrentSignInMethod) {
      case SignInMethod.Email:
      case SignInMethod.Google:
        return await GoogleLogin.instance.getUser(ChatScreen._currentUser);
      case SignInMethod.Facebook:
        return await FacebookLoginHandler.instance.handleLogin();
      default:
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: ChatScreen.getCurrentUser != null
            ? Text(ChatScreen.getCurrentUser.displayName ?? "")
            : Text("Chat App"),
        actions: <Widget>[
          ChatScreen.getCurrentUser != null
              ? IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    GoogleLogin.instance.signOut();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Logout realizado com sucesso!")));
                    Navigator.pop(context);
                  })
              : Container()
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: StreamBuilder(
            stream: Firestore.instance
                .collection("mensagens")
                .orderBy("time")
                .snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  List<DocumentSnapshot> documents =
                      snapshot.data.documents.reversed.toList();

                  return ListView.builder(
                      reverse: true,
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        return ChatMessage(
                            documents[index].data,
                            documents[index].data["uid"] ==
                                ChatScreen.getCurrentUser?.uid);
                      });
              }
            },
          )),
          _isLoadingImage ? LinearProgressIndicator() : Container(),
          TextComposer(_sendMessage)
        ],
      ),
    );
  }
}
