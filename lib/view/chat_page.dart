import 'dart:developer';
import 'dart:ui';

import 'package:chat_app/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/app_widget.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/label.dart';

class ChatPage extends StatefulWidget {
  final int index;
  final String contactEmail;
  final String currentEmail;
  final String chatName;

  const ChatPage({
    super.key,
    required this.contactEmail,
    required this.currentEmail,
    required this.chatName,
    required this.index,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final messageController = TextEditingController();
  final ScrollController controller = ScrollController();
 final ChatService chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppWidget(
        appbar: AppBar(
          actions: [
            Hero(
              tag: "pf_${widget.index}",
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(100, 255, 100, 0.5),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black.withOpacity(0.5)),
                ),
                alignment: Alignment.center,
                child: Material(
                  color: Colors.transparent,
                  child: Label.label(
                    context: context,
                    "${widget.contactEmail[0].toUpperCase()}",
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
          ],
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: Hero(
            tag: "email_${widget.index}",
            child: Material(
                type: MaterialType.transparency,
                child: Text(widget.contactEmail)),
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ChatMessages(
              chatName: widget.chatName,
              currentEmail: widget.currentEmail,
              controller: controller,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 80,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 30, sigmaX: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: 80,
                        alignment: Alignment.center,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Message...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest.withOpacity(0.75),
                          ),
                          controller: messageController,
                          onSubmitted: (value) {
                            if (messageController.text.isNotEmpty) {
                              chatService.addMessage(message: messageController.text , currentEmail: widget.currentEmail , chatName: widget.chatName);
                              setState(() {
                                messageController.clear();
                              });
                            }
                          },
                        ),
                      ),
                      AnimatedContainer(
                        width: MediaQuery.of(context).size.width * 0.1,
                        duration: const Duration(milliseconds: 300),
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: () {
                            if (messageController.text.isNotEmpty) {
                              chatService.addMessage(message: messageController.text , currentEmail: widget.currentEmail , chatName: widget.chatName);
                              setState(() {
                                messageController.clear();
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.send_rounded,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessages extends StatelessWidget {
  final String chatName;
  final String currentEmail;
  final ScrollController controller;

  const ChatMessages({
    super.key,
    required this.chatName,
    required this.currentEmail,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return StreamBuilder(
      stream: firestore
          .collection("chats")
          .doc(chatName)
          .collection("message")
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No message yet!!"),
          );
        }

        final messages = snapshot.data!.docs;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (controller.hasClients) {
            controller.jumpTo(controller.position.maxScrollExtent);
            // controller.animateTo(
            //   controller.position.maxScrollExtent,
            //   duration: const Duration(milliseconds: 300),
            //   curve: Curves.easeOutBack,
            // );
          }
        });

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: controller,
          child: Column(
            children: [
                  Container(
                    height: 100,
                  )
                ] +
                List.generate(
                  messages.length,
                  (index) {
                    final message = messages[index];
                    final sender = message["sender"];
                    final text = message["message"];
                    final time = message["timestamp"];

                    return Container(
                      alignment: sender == currentEmail
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: ChatBubble(
                        sms: text,
                        time: time,
                        color: sender == currentEmail
                            ? Colors.lightBlue.withOpacity(0.75)
                            : Colors.grey.withOpacity(0.25),
                      ),
                    );
                  },
                ) +
                [
                  Container(
                    height: 100,
                  )
                ],
          ),
        );
      },
    );
  }
}
