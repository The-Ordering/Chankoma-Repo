import 'package:chat_app/services/auth_firebase.dart';
import 'package:chat_app/widgets/label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final VoidCallback showSignUp;
  const SignUp({super.key , required this.showSignUp});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  Future signUp() async {
    await Auth().signUpWithEmailAndPw(
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
                  Label.label(context: context, "Sign up a new account"),
                  const SizedBox(
                    height: kDefaultFontSize * 3,
                  ),
                  // Label.label("Name", context: context, fade: true),
                  AppInput.textField(
                      context: context,
                      controller: emailController,
                      hint: "user@exe.com"),
                  const SizedBox(
                    height: kDefaultFontSize * 3,
                  ),
                  // Label.label("phone", context: context ,fade: true),
                  AppInput.textField(
                    isHide: true,
                    context: context,
                    controller: pwController,
                    hint: "xxxxxxxxx",
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
                        onPressed: signUp,
                        child: const Text("Sign Up")
                    ),
                    TextButton(onPressed: () {
                     widget.showSignUp();
                    }, child: Text("Have an account?"))
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
