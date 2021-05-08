enum SignInMethod { Facebook, Google, Microsoft, Email }

class UserSignInMethod {
  static SignInMethod _currentSignInMethod;
  static SignInMethod get getCurrentSignInMethod => _currentSignInMethod;
  static set setCurrentSignInMethod(SignInMethod method) =>
      _currentSignInMethod = method;
}
