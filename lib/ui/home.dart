import 'package:chat_flutter/enums/signInMethod.dart';
import 'package:chat_flutter/signInMethods/googleSignIn.dart';
import 'package:chat_flutter/signInMethods/facebookSignIn.dart';
import 'package:chat_flutter/ui/chatScreen.dart';
import 'package:chat_flutter/ui/createAccount.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoginIn = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool hidePassword = true;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat Flutter"), centerTitle: true, actions: <
          Widget>[
        ChatScreen.getCurrentUser != null
            ? IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  GoogleLogin.instance.signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Logout realizado com sucesso!")));
                })
            : IconButton(icon: Icon(Icons.label_important), onPressed: () {})
      ]),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 250,
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                      ),
                    ),
                  ),
                  Container(
                    width: 250,
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          labelText: "Senha",
                          suffixIcon: IconButton(
                              icon: Icon(hidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              })),
                      obscureText: hidePassword,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                        onPressed: () {
                          print("Login com email e senha");
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text)
                              .then((result) => {
                                    if (result.user != null)
                                      {
                                        UserSignInMethod
                                                .setCurrentSignInMethod =
                                            SignInMethod.Email,
                                        // _emailController.clear(),
                                        // _passwordController.clear(),
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        ChatScreen()))
                                      }
                                  });
                        },
                        child: Text("Log in",
                            style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white))),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25, bottom: 25),
                    child: Text("or"),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _createSignInButton(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CreateAccount()));
                      }),
                      _createLoginMethodsIcon("images/GoogleLogo.png",
                          () async {
                        print("Logando com google");
                        setState(() {
                          isLoginIn = true;
                        });

                        FirebaseUser user = await GoogleLogin.instance
                            .getUser(ChatScreen.getCurrentUser);

                        if (user == null) {
                          print("Login falhou!");
                        } else {
                          setState(() {
                            isLoginIn = false;
                            print("User -> $user ${ChatScreen.getCurrentUser}");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ChatScreen()));
                          });
                        }
                      }, "Google"),
                      _createLoginMethodsIcon("images/FacebookLogo.png",
                          () async {
                        print("Logando com facebook");
                        FirebaseUser user =
                            await FacebookLoginHandler.instance.handleLogin();

                        if (user == null) {
                          print("Login falhou!");
                        } else {
                          setState(() {
                            isLoginIn = false;
                            print("User -> $user ${user.isAnonymous}");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ChatScreen()));
                          });
                        }
                      }, "Facebook"),
                      _createLoginMethodsIcon("images/MicrosoftLogo.png", () {
                        print("Logando com microsoft");
                      }, "Microsoft"),
                    ],
                  ),
                  isLoginIn ? LinearProgressIndicator() : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createSignInButton(Function signInFunction) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
      child: ElevatedButton(
        onPressed: signInFunction,
        child: GestureDetector(
          child: Container(
            // color: Colors.white,
            width: 250,
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  widthFactor: 1.15,
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          ),
          // onTap: authFunc,
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.white)))),
      ),
    );
  }

  Widget _createLoginMethodsIcon(
      String imagePath, Function authFunc, String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
      child: ElevatedButton(
        onPressed: authFunc,
        child: GestureDetector(
          child: Container(
            // color: Colors.white,
            width: 250,
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imagePath.isNotEmpty
                              ? AssetImage(imagePath)
                              : null)),
                ),
                Align(
                  widthFactor: 1.15,
                  child: Text(
                    "Login with $name",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          ),
          // onTap: authFunc,
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.white)))),
      ),
    );
  }
}

//padding: const EdgeInsets.only(left: 10.0, right: 10.0),
