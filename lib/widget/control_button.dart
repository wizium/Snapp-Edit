import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config.dart';

Widget controlButton(String childText, Function onPressed) {
  return SizedBox(
    height: 100,
    width: Get.width * .7,
    child: InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).colorScheme.surface,
          borderRadius: BorderRadius.circular(childBorderRadius),
        ),
        child: Center(
          child: Text(
            childText,
            style: Theme.of(Get.context!).textTheme.bodyLarge,
          ),
        ),
      ),
    ),
  );
}
