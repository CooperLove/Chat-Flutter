import 'package:chat_flutter/ui/chatScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:chat_flutter/enums/signInMethod.dart';

class FacebookLoginHandler {
  static final FacebookLoginHandler instance = FacebookLoginHandler._internal();
  FacebookLoginHandler._internal();

  FacebookLogin _facebookLogin = FacebookLogin();
  bool isLoggedIn = false;

  Future<FirebaseUser> handleLogin() async {
    if (ChatScreen.getCurrentUser != null) return ChatScreen.getCurrentUser;
    FacebookLoginResult _result =
        await _facebookLogin.logIn(permissions: [FacebookPermission.email]);

    switch (_result.status) {
      case FacebookLoginStatus.cancel:
        print("Cancelado pelo usuário");
        break;
      case FacebookLoginStatus.error:
        print("Erro ao logar");
        break;
      case FacebookLoginStatus.success:
        return await _logIn(_result);
        break;
      default:
        return null;
    }
    return null;
  }

  Future<FirebaseUser> _logIn(FacebookLoginResult _result) async {
    FacebookAccessToken _token = _result.accessToken;
    AuthCredential credential =
        FacebookAuthProvider.getCredential(accessToken: _token.token);
    var authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    ;
    if (user != null) {
      print(
          "Logado com sucesso  ${authResult.additionalUserInfo.profile.entries} ${authResult.additionalUserInfo.profile["picture"]["data"]["url"]}");

      UserUpdateInfo newUser = UserUpdateInfo();
      newUser.photoUrl =
          authResult.additionalUserInfo.profile["picture"]["data"]["url"];
      user.updateProfile(newUser);
      ChatScreen.setCurrentUser = user;
      UserSignInMethod.setCurrentSignInMethod = SignInMethod.Facebook;
    }

    return user;
  }
}
