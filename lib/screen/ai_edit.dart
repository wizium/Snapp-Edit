import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import '../config.dart';
import '../models/feature_model.dart';
import '../widget/loading.dart';
import '../services/network_check.dart';
import '../main.dart';
import 'package:image_compare_slider/image_compare_slider.dart';
import 'package:lottie/lottie.dart';
import '../widget/control_button.dart';
import '../services/cutout.dart';
import '/services/pick_image.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class AiEditScreen extends StatefulWidget {
  final Feature feature;
  const AiEditScreen({Key? key, required this.feature}) : super(key: key);

  @override
  State<AiEditScreen> createState() => AiEditScreenState();
}

class AiEditScreenState extends State<AiEditScreen> {
  late Directory appDocDir;
  File? image;
  File? image2;
  bool isDone = true;
  Completer<void>? _cancelCompleter;

  @override
  void initState() {
    super.initState();
    stateController.isEdited!.value = 0;
    getTemporaryDirectory().then((value) {
      setState(() {
        appDocDir = value;
        image2 = File("${appDocDir.path}/newImage.png");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.8),
        gradient: const LinearGradient(
          colors: [
            Color(0XFFFFF9D2),
            Color(0XFFFF8473),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 40,
          sigmaY: 40,
        ),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(.3),
            title: Text(
              widget.feature.title,
            ),
            leading: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.all(gPadding),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surface.withOpacity(.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    CupertinoIcons.chevron_back,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: image == null
                ? Center(
                    child: SizedBox(
                      height: Get.height,
                      width: Get.width,
                      child: Lottie.asset(
                        'assets/addImage.json',
                        animate: true,
                        height: 200,
                        frameRate: FrameRate(90),
                      ),
                    ),
                  )
                : Center(
                    child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: stateController.isEdited!.value == 1
                          ? Image.file(image!)
                          : Center(
                              child: ImageCompareSlider(
                                hideHandle: true,
                                dividerWidth: 1,
                                dividerColor: Colors.white.withOpacity(.5),
                                itemOne: Image.file(image!),
                                itemTwo: Image.file(image2!),
                              ),
                            ),
                    ),
                  ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * .025),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(parentBorderRadius),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(.4),
                  borderRadius: BorderRadius.circular(childBorderRadius),
                ),
                height: 50,
                margin: const EdgeInsets.all(5),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      image != null
                          ? InkWell(
                              onTap: () async {
                                _cancelEditing();
                              },
                              child: Container(
                                height: 50,
                                width: Get.width * .2,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius:
                                      BorderRadius.circular(childBorderRadius),
                                ),
                                child: const Icon(Icons.clear),
                              ),
                            )
                          : InkWell(
                              onTap: () async {
                                _cancelEditing();
                                await pickImage().then((value) {
                                  image = File(value!);
                                  stateController.isEdited!.value = 1;
                                });
                                setState(() {});
                              },
                              child: Container(
                                height: 50,
                                width: Get.width * .2,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius:
                                      BorderRadius.circular(childBorderRadius),
                                ),
                                child: const Icon(Icons.add_a_photo_rounded),
                              ),
                            ),
                      SizedBox(width: Get.width * .015),
                      Obx(() {
                        if (!isDone) {
                          return const LoadingIndicator();
                        } else if (stateController.isEdited!.value == 1) {
                          return controlButton("Process image", () {
                            checkNetworkConnectivity().then((value) {
                              if (value) {
                                _startEditing();
                              }
                            });
                          });
                        } else if (stateController.isEdited!.value == 2) {
                          return controlButton("Download", () {
                            saveImage();
                          });
                        } else {
                          return const SizedBox();
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _startEditing() async {
    if (image2 != null && image2!.existsSync()) {
      image2!.deleteSync();
    }
    final newImage2Path =
        "${appDocDir.path}/${DateTime.now().millisecondsSinceEpoch}.png";
    image2 = File(newImage2Path);

    _cancelCompleter = Completer<void>();
    isDone = false;
    setState(() {});

    try {
      String? value;
      switch (widget.feature.title) {
        case "Image Background Remover":
          {
            value = await CutoutPro.backGroundRemover(
              startImagePath: image!.path,
              targetImagePath: newImage2Path,
              cancelCompleter: _cancelCompleter!,
            );
            break;
          }
        case "AI Image Enhancer":
          {
            value = await CutoutPro.photoEnhancer(
              startImagePath: image!.path,
              targetImagePath: newImage2Path,
              cancelCompleter: _cancelCompleter!,
            );
            break;
          }
        case "Colorize B&W Photos":
          {
            value = await CutoutPro.bAndWToColor(
              startImagePath: image!.path,
              targetImagePath: newImage2Path,
              cancelCompleter: _cancelCompleter!,
            );
            break;
          }
        case "Ai Natural Color Blend":
          {
            value = await CutoutPro.colorEnhancer(
              startImagePath: image!.path,
              targetImagePath: newImage2Path,
              cancelCompleter: _cancelCompleter!,
            );
            break;
          }
        // default:
      }
      if (value != null) {
        stateController.isEdited!.value = 2;
        isDone = true;
        image2 = File(value);
        setState(() {});
      } else {
        isDone = true;
        Fluttertoast.showToast(msg: "Error");
      }
    } catch (e) {
      isDone = true;
      Fluttertoast.showToast(msg: "Error");
    } finally {
      setState(() {});
    }
  }

  void _cancelEditing() {
    if (_cancelCompleter != null && !_cancelCompleter!.isCompleted) {
      _cancelCompleter!.complete();
    }
    image = null;
    isDone = true;
    stateController.isEdited!.value = 0;
    setState(() {});
  }

  void saveImage() async {
    await GallerySaver.saveImage(image2!.path).then((value) {
      Fluttertoast.showToast(msg: "Downloaded");
    });
  }
}
