import 'dart:async';
import 'dart:developer';

import 'package:chat_app/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<void> sendMessage(String receiverId, String message) async {
  //   final String currentUserId = _firebaseAuth.currentUser!.uid;
  //   final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
  //   final Timestamp timestamp = Timestamp.now();
  //
  //   Message newMessage = Message(
  //     senderId: currentUserId,
  //     senderEmail: currentUserEmail,
  //     receiverId: receiverId,
  //     message: message,
  //     timestamp: timestamp,
  //   );
  //
  //   List<String> ids = [currentUserId, receiverId];
  //   ids.sort();
  //   String chatRoomId = ids.join("_");
  //   await _firestore
  //       .collection("chat_rooms")
  //       .doc(chatRoomId)
  //       .collection("messages")
  //       .add(newMessage.toMap());
  // }

  Stream<QuerySnapshot> getMessage(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Future<List<String>> getUsersId(String collName) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection(collName).get();
      List<String> docId = querySnapshot.docs.map((doc) => doc.id).toList();
      return docId;
    } catch (e) {
      log("Error getting Doc: $e");
      return [];
    }
  }

  Future<List> getUsersEmail(String collName) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection(collName).get();
      List docEmail = querySnapshot.docs.map((doc) {
        final userEmail = doc.data() as Map<String, dynamic>;
        return userEmail["email"] ?? "Error Server";
      }).toList();
      return docEmail;
    } catch (e) {
      log("Error getting Doc: $e");
      return [];
    }
  }

  Future<List> getUserEmailByField({required String currentEmail}) async {
    QuerySnapshot querySnapshot = await _firestore.collection("users").get();

    List emails = querySnapshot.docs
        .map((doc) {
          return doc.get("email").toString();
        })
        .where((email) => email != currentEmail && email.isNotEmpty)
        .toList();
    return emails;
  }

  Future<List> getEmailHasChat2({required String currentEmail}) async {
    final dbChat = _firestore.collection("chats").snapshots();
    List chatNames = [];
    List emailsHasChat = [];

    await dbChat.forEach((chatRooms) {
      for (var chatRoom in chatRooms.docs) {
        if (chatRoom.id.contains(currentEmail) &&
            chatRoom.id != "${currentEmail}_$currentEmail") {
          chatNames.add(chatRoom.id);
          log(chatRoom.id);
        }
      }
    });

    for (String chatName in chatNames) {
      final dbChat = _firestore.collection("chats");
      final chatNameSnapshot =
          await dbChat.doc(chatName).collection("message").get();
      if (chatNameSnapshot.docs.isNotEmpty) {
        List emailNameList = chatName.split("_");
        emailNameList.remove(currentEmail);
        String emailHasData = emailNameList.join();
        log(emailHasData);
        log("$chatName : has data");
        emailsHasChat.add(emailHasData);
      } else {
        log("$chatName : has no data");
      }
    }
    return emailsHasChat;
  }


  Stream<List<String>> getEmailHasChat({required String currentEmail}) async* {



    final dbChat = _firestore.collection("chats");

    List<String> emailsHasChat = [];
    List<String> chatNames = [];
    // Listen for real-time updates in the "chats" collection
    await for (var chatRooms in dbChat.snapshots()) {

      // Filter chats containing the current email
      for (var chatRoom in chatRooms.docs) {
        if (chatRoom.id.contains(currentEmail) &&
            chatRoom.id != "${currentEmail}_$currentEmail") {
          chatNames.add(chatRoom.id);
        }
      }

      // Check messages in each chat
      for (String chatName in chatNames) {
        final chatNameSnapshot = await dbChat.doc(chatName).collection("message").get();
        if (chatNameSnapshot.docs.isNotEmpty) {
          List<String> emailNameList = chatName.split("_");
          emailNameList.remove(currentEmail);
          String emailHasData = emailNameList.join();
          emailsHasChat.add(emailHasData);
        }
      }

      // Emit the updated list of emails
      yield emailsHasChat;
    }
  }



  // Future<List> getEmailHasChat ( {required String currentEmail }) async {
  //   final dbChat = _firestore.collection("chats");
  //
  //   List chatNames = [];
  //
  //   List emailsHasChat = [];
  //
  //   await dbChat.get().then((chatRooms) {
  //     for (var chatRoom in chatRooms.docs)  {
  //       if (chatRoom.id.contains(currentEmail) && chatRoom.id != "${currentEmail}_$currentEmail") {
  //         chatNames.add(chatRoom.id);
  //         log(chatRoom.id);
  //       }
  //     }
  //   });
  //
  //   for ( String chatName in chatNames) {
  //     final chatNameSnapshot = await dbChat.doc(chatName).collection("message").get();
  //     if(chatNameSnapshot.docs.isNotEmpty) {
  //       List emailNameList =  chatName.split("_");
  //       emailNameList.remove(currentEmail);
  //       String emailHasData = emailNameList.join();
  //       log(emailHasData);
  //       log("$chatName : has data");
  //       emailsHasChat.add(emailHasData);
  //     } else {
  //       log( "$chatName : has no data");
  //     }
  //
  //   }
  //   return emailsHasChat;
  // }



  Stream<List<String>> getEmailsWithChatsRealTime({
    required String currentEmail,
    required List<String> chatNames,
  }) async* {
    final dbChat = _firestore.collection("chats");
    final StreamController<List<String>> controller = StreamController();
    List<String> emailsHasChat = [];

    // Loop through each chat name to set up real-time listeners
    for (String chatName in chatNames) {
      dbChat
          .doc(chatName)
          .collection("message")
          .snapshots()
          .listen((chatNameSnapshot) {
        if (chatNameSnapshot.docs.isNotEmpty) {
          // Extract the other email from the chat name
          List<String> emailNameList = chatName.split("_");
          emailNameList.remove(currentEmail);
          String emailHasData = emailNameList.join();

          // Add the email if not already in the list
          if (!emailsHasChat.contains(emailHasData)) {
            emailsHasChat.add(emailHasData);
          }
        } else {
          // Optional: Remove email if no messages exist
          emailsHasChat.removeWhere((email) =>
          email == chatName.replaceFirst("${currentEmail}_", "").replaceFirst("_${currentEmail}", ""));
        }

        // Update the stream with the latest list
        controller.add(emailsHasChat);
      });
    }

    // Return the stream
    yield* controller.stream;
  }


  Future<bool> addChatRoom(
      {required String currentEmail, required contactEmail}) async {
    final List<String> emails = [currentEmail, contactEmail];
    emails.sort();
    final String chatNanme = emails.join("_");
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("chats")
        .doc(chatNanme)
        .get();
    if (!documentSnapshot.exists) {
      try {
        await FirebaseFirestore.instance
            .collection("chats")
            .doc(chatNanme)
            .set({"chatName": chatNanme});
        return true;
      } catch (e) {
        log('error addChatRoom by : $e}');
        return false;
      }
    } else {
      log("doc already exists");
      return true;
    }
  }

  Future<void> addMessage(
      {required String message,
      required String chatName,
      required String currentEmail}) async {
    try {
      await _firestore
          .collection("chats")
          .doc(chatName)
          .collection("message")
          .add({
        "sender": currentEmail,
        "message": message,
        "timestamp": Timestamp.now(),
      });
    } catch (e) {
      log("Error adding message: $e");
    }
  }
}
