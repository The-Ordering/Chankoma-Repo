import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final Color color;
  final String sms;
  final Timestamp time ;
  const ChatBubble({super.key , required this.sms ,required this.time ,required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("${time.toDate().hour} : ${time.toDate().minute}" , style: const TextStyle(
            color: Colors.grey,
            fontSize: 10
          ),),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: color
            ),
            child: Text(sms , style: TextStyle(fontSize: kDefaultFontSize*1.25),),
          )
        ],
      ),
    );
  }
}
