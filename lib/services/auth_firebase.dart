import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Sign IN
  Future<void> signInWithEmailAndPw({
    required String email,
    required String pw,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: pw);

    _firestore.collection("users").doc(_firebaseAuth.currentUser!.uid).set({
      "uid" :_firebaseAuth.currentUser!.uid,
      "email" : email,
    } , SetOptions(merge: true));
  }

  //Sign UP
  Future<void> signUpWithEmailAndPw({
    required String email,
    required String pw,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pw);
    
    _firestore.collection("users").doc(_firebaseAuth.currentUser!.uid).set({
      "uid" :_firebaseAuth.currentUser!.uid,
      "email" : email,
    });
    
  }

  // Sign Out

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
