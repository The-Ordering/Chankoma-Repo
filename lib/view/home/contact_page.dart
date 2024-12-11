import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/widgets/app_widget.dart';
import 'package:chat_app/widgets/contact.dart';
import 'package:chat_app/widgets/label.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ChatService chatService = ChatService();

  List<dynamic> contacts = [];
  String currentEmail = FirebaseAuth.instance.currentUser!.email.toString();


  Future<void> fectContacts( ) async {
    List list = await chatService.getUserEmailByField( currentEmail: currentEmail);
    setState(() {
      contacts = list;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fectContacts();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidget(appbar: AppBar(
        title: Label.label("Contacts", context: context),
      )),
      body:  ListView.builder(

              itemCount: contacts.length,
              itemBuilder: (context, index) => Contact(contactEmail: contacts[index], currentEmail: currentEmail, index: index),
      ),
    );
  }
}
