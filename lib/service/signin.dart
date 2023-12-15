import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Functions/subscriptioncheck.dart';
import '../main.dart';
import '/Page/home.dart';
import '/Page/signin.dart';
import '/widget/home_drawer.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
Future<void> signInCheck() async {
  if (_auth.currentUser == null) {
    Get.offAll(
      () => const LoginScreen(),
    );
  } else {
    Get.offAll(
      () => const Home(),
    );
  }
}

class SignIn {
  Future<void> googleSignIn() async {
    try {
      final googleSignIn = await GoogleSignIn().signIn();
      final auth = await googleSignIn!.authentication;
      await _auth.signInWithCredential(
        GoogleAuthProvider.credential(
          idToken: auth.idToken,
          accessToken: auth.accessToken,
        ),
      );
      await firestore
          .collection("subscription_details")
          .doc(
            FirebaseAuth.instance.currentUser!.uid,
          )
          .get()
          .then((value) {
        final Timestamp endDate = value.get("endDate");
        preferences.setString(
          "endDate",
          endDate.toDate().toString(),
        );
        if (kDebugMode) {
          print("\nendDate: ${endDate.toDate().toString()}\n");
        }
        subscriptionCheck(endDate);
      }).onError((error, stackTrace) {
        debugPrint(error.toString());
        preferences.setBool("isPro", false);
        isPro.init();
      });
      await signInCheck();
      Get.snackbar('Done', 'Sign in successful');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message!);
      auth.signOut();
      GoogleSignIn().signOut();
    } catch (e) {
      auth.signOut();
      GoogleSignIn().signOut();
      debugPrint(e.toString());
      Get.snackbar('Error', '$e');
    }
  }
}
