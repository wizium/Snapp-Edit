import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '/service/signin.dart';
import '/widget/home_drawer.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in to Continue'),
        actions: [
          TextButton(
            onPressed: () {
              auth.signOut();
              GoogleSignIn().signOut();
              Get.offAll(
                const Home(),
              );
            },
            child: Text(
              "Skip",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: Get.height * .03),
              child: Text(
                "Welcome to SnapAway",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: Get.height * .15,
                ),
                child: Container(
                  height: Get.height * .3,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    image: const DecorationImage(
                      image: AssetImage('assets/appIcon.jpg'),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Get.width * .35,
              ),
              child: InkWell(
                onTap: () async {
                  await SignIn().googleSignIn();
                },
                child: Container(
                  height: Get.height * .08,
                  width: Get.width * .9,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "Continue with Google",
                      style: Theme.of(context).textTheme.labelLarge!.merge(
                            const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                    ),
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
