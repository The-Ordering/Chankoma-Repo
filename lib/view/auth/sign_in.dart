import 'package:chat_app/services/auth_firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/label.dart';

class SignIn extends StatefulWidget {
  final VoidCallback showSignUp;
  const SignIn({super.key , required this.showSignUp});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  Future signIn() async {
    await Auth().signInWithEmailAndPw(
        email: emailController.text,
        pw: pwController.text);
  }

  @override
  void dispose() {
    emailController.dispose();
    pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double dWidth = MediaQuery.of(context).size.width;
    double dHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                      tag: "logo",
                      child: Image.asset(
                        "assets/icons/chat.png",
                        width: dWidth * 0.2,
                      )),
                  const SizedBox(
                    height: kDefaultFontSize,
                  ),
                  Label.label(context: context, "Sign In to your account"),
                  const SizedBox(
                    height: kDefaultFontSize * 3,
                  ),
                  // Label.label("Name", context: context, fade: true),
                  AppInput.textField(
                      context: context,
                      controller: emailController,
                      hint: "Email"),
                  const SizedBox(
                    height: kDefaultFontSize * 3,
                  ),
                  // Label.label("phone", context: context ,fade: true),
                  AppInput.textField(
                    isHide: true,
                    context: context,
                    controller: pwController,
                    hint: "Password",
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(50),
                      child: const Text("Sign In"),
                      onPressed: signIn,),
                    TextButton(onPressed: () {
                      widget.showSignUp();
                    }, child: Text("Create a new account now!"))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
