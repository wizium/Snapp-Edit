import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import '../main.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class SignIn {
  static Future<void> googleSignIn() async {
    try {
      final googleSignIn = await GoogleSignIn().signIn();
      final auth = await googleSignIn!.authentication;
      await firebaseAuth.signInWithCredential(
        GoogleAuthProvider.credential(
          idToken: auth.idToken,
          accessToken: auth.accessToken,
        ),
      );
      await firestore
          .collection("premiumDetails")
          .doc(firebaseAuth.currentUser!.uid)
          .get()
          .then((value) {
        // final Timestamp endDate = value.get("endDate");
        // settings.proStateSave(endDate);
      }).onError((error, stackTrace) {
        // settings.proStateSave(
        //   Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
        // );
      });
      try {
        final response = await get(
          Uri.parse(
            firebaseAuth.currentUser!.photoURL!,
          ),
        );
        if (response.statusCode == 200) {
          final file = File("${downloadPath!.path}/avatar.png");
          await file.writeAsBytes(response.bodyBytes);
        } else {
          log('Failed to download image');
        }
      } catch (e) {
        log('Error: $e');
      }
      Fluttertoast.showToast(msg: 'SignIn Successful');
    } catch (e) {
      await firebaseAuth.signOut();
      await GoogleSignIn().signOut();
      Fluttertoast.showToast(msg: "SignIn Failed");
    }
  }

  static Future<void> signOut(BuildContext context) async {
    bool? confirmSignOut = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const CircleAvatar(
            radius: 40,
            child: Icon(
              Icons.logout_rounded,
              size: 40,
            ),
          ),
          content: const Text(
            'Are you sure you want to Log Out?',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            SizedBox(
              height: 40,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // User pressed cancel
                },
                child: const Text('Cancel'),
              ),
            ),
            SizedBox(
              height: 40,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // User pressed confirm
                },
                child: const Text('Log Out'),
              ),
            ),
          ],
        );
      },
    );

    if (confirmSignOut == true) {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      Fluttertoast.showToast(msg: 'Log Out Successful');
    }
  }
}