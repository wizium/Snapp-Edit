import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config.dart';
import 'package:lottie/lottie.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({super.key});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      "assets/loadingGradient.json",
      height: 70,
      width: 70,
      repeat: true,
      fit: BoxFit.contain,
      frameRate: FrameRate(90),
      frameBuilder: (context, child, composition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(childBorderRadius),
          child: Container(
            height: 100,
            width: Get.width * .7,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 40,
                sigmaY: 40,
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
