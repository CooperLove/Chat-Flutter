import 'package:chat_flutter/signInMethods/googleSignIn.dart';
import 'package:chat_flutter/ui/chatScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  bool hidePassword = true;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passConfirmationController = TextEditingController();
  String photoUrl = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create new account"),
          centerTitle: true,
        ),
        body: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
                child: Container(
              alignment: Alignment.center,
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        width: 150,
                        height: 150,
                        child: IconButton(
                          icon: CircleAvatar(
                            radius: 120.0,
                            backgroundImage: NetworkImage(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTE1lNuQFDKXF_-VkBuS-c_4fkyF8pCBjJef2D8F5zezUmvZ8XjVk4eeCGyT7I5aB3PDS4&usqp=CAU"),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    _buildTextFormField(
                        "Usuário", _usernameController, Icons.person),
                    _buildTextFormField("Email", _emailController, Icons.email),
                    _createPasswordFormField(
                        "Senha", _passwordController, Icons.lock_open),
                    _createPasswordFormField("Confirmar senha",
                        _passConfirmationController, Icons.lock),
                    _buildCreateButton()
                  ],
                ),
              ),
            ))));
  }

  void _createNewAccount() {
    UserUpdateInfo newUser = UserUpdateInfo();
    newUser.displayName = _usernameController.text;
    newUser.photoUrl = photoUrl.isNotEmpty ? photoUrl : "";
    print(
        "Criando nova conta {${_emailController.text}, {${_passwordController.text}}}");
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .then((result) => {
              if (result.user != null)
                {
                  print("${result.user}"),
                  result.user.updateProfile(newUser),
                  result.user.sendEmailVerification(),
                  print(result.additionalUserInfo.profile)
                },
            });
  }

  Widget _buildTextFormField(
      String name, TextEditingController controller, IconData icon) {
    return Container(
      width: 300,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: name, icon: Icon(icon)),
      ),
    );
  }

  Widget _buildCreateButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
      child: ElevatedButton(
        onPressed: _createNewAccount,
        child: GestureDetector(
          child: Container(
            // color: Colors.white,
            width: 140,
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  widthFactor: 1.15,
                  child: Text(
                    "Create account",
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
                    side: BorderSide(color: Colors.blueAccent)))),
      ),
    );
  }

  Widget _createPasswordFormField(
      String name, TextEditingController controller, IconData icon) {
    return Container(
      width: 300,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            labelText: name,
            icon: Icon(icon),
            suffixIcon: IconButton(
                icon: Icon(
                    hidePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                })),
        obscureText: hidePassword,
      ),
    );
  }
}
