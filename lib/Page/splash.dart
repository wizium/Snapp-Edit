import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '/Functions/subscriptioncheck.dart';
import '/main.dart';
import '/service/adservice.dart';
import '/service/signin.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () async {
      try {
        final Timestamp endDate = Timestamp.fromDate(
          DateTime.parse(
            preferences.getString("endDate")!,
          ),
        );
        debugPrint(endDate.toDate().toString());
        subscriptionCheck(endDate);
      } catch (e) {
        debugPrint(e.toString());
        preferences.setBool("isPro", false);
      }
      final isFirstTime = preferences.getBool("isFirstTime");
      if (isFirstTime == null) {
        await preferences.setBool("isFirstTime", false);
        signInCheck();
      } else {
        Get.offAll(
          () => const Home(),
        );
      }
    });
    AdServices().interstitialAdLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * .05,
        ),
        child: OrientationBuilder(builder: (context, orientation) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Get.height * .15,
                ),
                child: Center(
                  child: Image.asset(
                    "assets/appIcon.jpg",
                    height: orientation == Orientation.portrait
                        ? Get.height * .35
                        : Get.height * .7,
                  ),
                ),
              ),
              orientation == Orientation.portrait
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Get.height * .1,
                      ),
                      child: Text(
                        "Welcome To SnapAway",
                        style: Theme.of(context).textTheme.titleLarge!.merge(
                              const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                      ),
                    )
                  : const SizedBox(),
            ],
          );
        }),
      ),
    );
  }
}
