import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:lottie/lottie.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({super.key});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(
              12,
            ),
          ),
        ),
        child: Center(
          child: GlassContainer(
            blur: 2,
            height: orientation == Orientation.portrait
                ? Get.height * 0.35
                : Get.height * 0.7,
            width: orientation == Orientation.portrait
                ? Get.width * 0.6
                : Get.width * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  "assets/Animation - 1701860113537.json",
                  height: 200,
                  repeat: true,
                  frameRate: FrameRate(90),
                ),
                Text(
                  "Processing...",
                  style: Theme.of(context).textTheme.headlineSmall!.merge(
                        const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
