import 'dart:developer';
import 'dart:ui';

import 'package:chat_app/R_to_LRoute.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/view/chat_page.dart';
import 'package:chat_app/widgets/label.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_spring_animation/elegant_spring_animation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Contact extends StatefulWidget {
  final int index;
  final String currentEmail;
  final String contactEmail;
  const Contact(
      {super.key,
      required this.contactEmail,
      required this.currentEmail,
      required this.index});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ChatService chatService = ChatService();
  bool isPress = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 100),
      curve: Easing.emphasizedAccelerate,
      scale: isPress ? 0.9 : 1,
      child: GestureDetector(
        child: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
          height: kDefaultFontSize * 6,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(30)),
          child: ListTile(
            onTap: () async {
              setState(() {
                isPress = true;
              });
              if (await chatService.addChatRoom(
                  currentEmail: widget.currentEmail,
                  contactEmail: widget.contactEmail)) {
                final List<String> emails = [
                  widget.currentEmail,
                  widget.contactEmail
                ];
                emails.sort();
                final chatName = emails.join("_");
                // Navigator.push(
                //   context,
                //   RightToLeftRoute(
                //     page: ChatPage(
                //         index: widget.index,
                //         contactEmail: widget.contactEmail,
                //         currentEmail: widget.currentEmail,
                //         chatName: chatName),
                //   ),
                // );
                Navigator.push(
                    context,
                    RightToLeftRoute(
                      page: ChatPage(
                          index: widget.index,
                          contactEmail: widget.contactEmail,
                          currentEmail: widget.currentEmail,
                          chatName: chatName),
                    ));
                log("Can be opened");
              } else {
                log("Can not open chat");
              }
              setState(() {
                isPress = false;
              });
            },
            leading: Hero(
              tag: "pf_${widget.index}",
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: Colors.black.withOpacity(0.5)),
                ),
                alignment: Alignment.center,
                child: Material(
                  color: Colors.transparent,
                  child: Label.label(
                      context: context,
                      widget.contactEmail[0].toUpperCase()),
                ),
              ),
            ),
            title: Hero(
              tag: "email_${widget.index}",
              child: Material(
                  type: MaterialType.transparency,
                  child: Text(widget.contactEmail)),
            ),
          ),
        ),
      ),
    );
  }
}
