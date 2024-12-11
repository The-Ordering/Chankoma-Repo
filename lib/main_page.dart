import 'package:chat_app/services/auth_firebase.dart';
import 'package:chat_app/view/auth/auth_page.dart';
import 'package:chat_app/view/home/home.dart';
import 'package:chat_app/view/home/home_screen.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: Auth().authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Home();
            } else {
              return AuthPage();
            }
          },
      ),
    );
  }
}
