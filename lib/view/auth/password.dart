import 'package:chat_app/view/home/home_screen.dart';
import 'package:chat_app/widgets/label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PassPage extends StatefulWidget {
  const PassPage({super.key});

  @override
  State<PassPage> createState() => _PassPageState();
}

class _PassPageState extends State<PassPage> {
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

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
                  Label.label(context: context, "Set your password"),
                  const SizedBox(
                    height: kDefaultFontSize * 3,
                  ),
                  // Label.label("Name", context: context, fade: true),
                  AppInput.textField(
                      context: context,
                      controller: passController,
                      hint: "password"),
                  const SizedBox(
                    height: kDefaultFontSize * 3,
                  ),
                  // Label.label("phone", context: context ,fade: true),
                  AppInput.textField(
                    context: context,
                    controller: confirmPassController,
                    hint: "confirm your password",
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CupertinoButton(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50),
                  child: const Text("Done"),
                  onPressed: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false,);
                  },),
              )
            ],
          ),
        ),
      ),
    );
  }
}
