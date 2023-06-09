import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference reportCollection =
      FirebaseFirestore.instance.collection('reports');
  final CollectionReference leaderboardCollection =
      FirebaseFirestore.instance.collection('leaderboard');

  Future<void> anonLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      // handle error
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().disconnect();
    } catch (e) {
      //catch error
    }
  }

  Future<void> googleLogin() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final user = (await _auth.signInWithCredential(authCredential)).user;
      final userDoc = await userCollection.doc(user?.uid).get();
      if (!userDoc.exists) {
        await userCollection.doc(user?.uid).set({
          'displayName': user?.displayName ?? user?.email?.split("@")[0],
          'email': user?.email,
          'uid': user?.uid,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp()
          // add more user data fields as needed
        });
        await reportCollection.doc(user?.uid).set({
          'trips': 0,
          'totalDistance': double.minPositive,
          'totalGrievances': 0
        });
        await leaderboardCollection.doc(user?.uid).set({
          'displayName': user?.displayName ?? user?.email?.split("@")[0],
          'email': user?.email,
          'totalDistance': double.minPositive,
        });
      }

      await FirebaseAuth.instance.signInWithCredential(authCredential);
    } on FirebaseAuthException catch (e) {
      // handle error
    }
  }
}
