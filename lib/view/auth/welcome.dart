import 'package:chat_app/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    double dWidth = MediaQuery.of(context).size.width;
    double dHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Welcome to Chat",
                  style: TextStyle(
                    fontFamily: "poppin",
                    fontSize: kDefaultFontSize*2.25,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(
                  height: dWidth*0.1,
                ),
                Hero(
                    tag: "logo",
                    child: Image.asset("assets/icons/chat.png" , width: dWidth*0.2,))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: kDefaultFontSize*2),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CupertinoButton(
                  color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(50),
                    child: Text("Next"),
                    onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage(),) , (route) => false,);
                    },),
              ),
            )
          ],
        ),
      ),
    );
  }
}
