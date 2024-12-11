import 'package:chat_app/view/auth/sign_in.dart';
import 'package:chat_app/view/auth/sign_up.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool showLoginPage = true;
  void toggleLog() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return SignIn(showSignUp: toggleLog);
    } else {
      return SignUp( showSignUp: toggleLog,);
    }
  }
}
