import 'dart:developer';

import 'package:chat_app/services/auth_firebase.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/widgets/app_widget.dart';
import 'package:chat_app/widgets/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = Auth().currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatService chatService = ChatService();


  bool isWait = true;

  List<String> usersId = [];
  List<dynamic> usersEmail = [];
  List<dynamic> usersEmailField = [];
  String currentEmail = "";
  void fetchUsersData() async {
    String fectchCurrentEmail = _auth.currentUser!.email.toString();
    // Fetch the users asynchronously
    List<String> fetchedUsersId = await chatService.getUsersId("users");
    // List<dynamic> fetchedUsersEmail = await chatService.getUsersEmail("users");
    List<dynamic> fetchedUsersEmail = await chatService.getUserEmailByField( currentEmail:user!.email.toString());
    // List<dynamic> fetchEmail = await chatService.getUserEmailByField( currentEmail: currentEmail);

    // Update the state once data is fetched
    setState(() {
      currentEmail = fectchCurrentEmail;
      usersId = fetchedUsersId;
      usersEmail = fetchedUsersEmail;
      // usersEmailField = fetchEmail;
      log("userEmail : ${usersEmail.join("__")}");
      isWait = false; // Update any loading state if necessary
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUsersData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppWidget(
        appbar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(currentEmail),
          actions: [
            IconButton(
              onPressed: () {
                Auth().signOut();
              },
              icon: const Icon(Icons.logout_rounded),
            )
          ],
        ),
      ),
      body:
          isWait ? const Center(child: CircularProgressIndicator()) :
          StreamBuilder(
              stream: chatService.getEmailHasChat(currentEmail: currentEmail),
              builder: (context, snapshot) {
                if( snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return const Center(child: Text("something went wrong!!"),);
                }

                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder:
                        (context, index) =>
                        Contact(
                          contactEmail: snapshot.data![index],
                          currentEmail: currentEmail, index: index,)
                );
              },)
    );
  }
}
