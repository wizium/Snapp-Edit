import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../screen/home.dart';
import '../services/signIn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FilledButton(
              onPressed: () {
                firebaseAuth.signOut();
                GoogleSignIn().signOut();
                Get.offAll(() => const HomeScreen());
              },
              child: const Text("Skip"),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/appIcon.png'),
                  radius: 100,
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(height: 30),
                Text(
                  "Snapp Edit",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  "Let's get started",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w400,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Positioned(
              bottom: 40,
              child: SizedBox(
                width: Get.width * 0.9,
                height: 60,
                child: FilledButton(
                  onPressed: () {
                    SignIn.googleSignIn();
                  },
                  // style: FilledButton.styleFrom(
                  //   backgroundColor: Colors.white,
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 20, vertical: 15),
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/google.png",
                        height: 25,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Sign in with Google",
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
