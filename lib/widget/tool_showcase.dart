import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config.dart';
import '../models/feature_model.dart';
import '../screen/ai_edit.dart';

class ToolShowCase extends StatefulWidget {
  final Feature feature;
  const ToolShowCase({super.key, required this.feature});

  @override
  State<ToolShowCase> createState() => _ToolShowCaseState();
}

class _ToolShowCaseState extends State<ToolShowCase> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(parentBorderRadius),
      onTap: () {
        Get.to(() => AiEditScreen(
              feature: widget.feature,
            ));
      },
      child: Container(
        height: 150,
        margin: const EdgeInsets.symmetric(
          horizontal: 2.5,
          vertical: 2.5,
        ),
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.2),
          borderRadius: BorderRadius.circular(parentBorderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(gPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: Get.width * .5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.feature.title,
                      style: Theme.of(context).textTheme.titleMedium!,
                    ),
                    Flexible(
                      child: Text(
                        widget.feature.description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.1),
                  borderRadius: BorderRadius.circular(childBorderRadius),
                  image: DecorationImage(
                    image: AssetImage("assets/${widget.feature.image}.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
