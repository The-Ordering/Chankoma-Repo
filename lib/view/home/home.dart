import 'package:chat_app/view/home/contact_page.dart';
import 'package:chat_app/view/home/home_screen.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Widget> pages = [ HomeScreen() , ContactPage() ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          itemCount: 2,
          itemBuilder: (context, index) {
              return pages[index];
          },
      ),
    );
  }
}
