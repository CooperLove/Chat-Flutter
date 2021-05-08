import 'package:flutter/material.dart';
import 'package:chat_flutter/ui/home.dart';

void main() {
  runApp(MyApp());

  // Firestore.instance
  //     .collection("col")
  //     .document("doc")
  //     .setData({"texto": "pedro"});
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          iconTheme: IconThemeData(color: Colors.blue),
          primarySwatch: Colors.blue,
        ),
        home: Home());
  }
}
