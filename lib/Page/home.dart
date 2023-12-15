import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:image_bg_remover/Functions/network_check.dart';
import 'package:image_bg_remover/main.dart';
import 'package:image_bg_remover/widget/fab.dart';
import 'package:image_compare_slider/image_compare_slider.dart';
import 'package:lottie/lottie.dart';
import '../service/adservice.dart';
import '/widget/home_drawer.dart';
import '/widget/loading.dart';
import '/Functions/get_doc_directory.dart';
import '/Functions/bg_remove.dart';
import '/Functions/pick_image.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Directory appDocDir;
  File? image;
  File? image2;
  bool isDone = true;
  Completer<void>? _cancelCompleter;

  @override
  void initState() {
    super.initState();
    getDocDirectory().then((value) {
      setState(() {
        appDocDir = value;
        image2 = File("${appDocDir.path}/newImage.png");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isLoaded) {
          await AdServices().showInterstitialAd(() {
            SystemNavigator.pop();
          });
        } else {
          SystemNavigator.pop();
        }
        return false;
      },
      child: Scaffold(
        drawer: const HomeDrawer(),
        key: scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            "SnapAway",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.menu_rounded,
            ),
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
          ),
          backgroundColor: Colors.white.withOpacity(.2),
          actions: [
            if (image != null)
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(.1),
                    foregroundColor: Theme.of(context).colorScheme.surface,
                  ),
                  onPressed: () {
                    _cancelEditing();
                  },
                  icon: const Icon(Icons.clear_all_rounded),
                  label: const Text('Clear'),
                ),
              ),
          ],
        ),
        floatingActionButton: Obx(() {
          if (!isDone) {
            return const SizedBox();
          } else if (stateController.isEdited!.value == 1) {
            return fab("Remove Background", () {
              checkNetworkConnectivity().then((value) {
                if (value) {
                  _startEditing();
                }
              });
            }, Icons.cut_rounded);
          } else if (stateController.isEdited!.value == 2) {
            return fab("Save Image", () {
              saveImage();
            }, Icons.save_rounded);
          } else {
            return const SizedBox();
          }
        }),
        body: OrientationBuilder(builder: (context, orientation) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple, Colors.pink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: image == null
                          ? GlassContainer(
                              height: Get.height * 0.7,
                              width: Get.width * 0.9,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                    'assets/Animation - 1701857493293.json',
                                    animate: true,
                                    height: Get.height * 0.5,
                                    frameRate: FrameRate(90),
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.black.withOpacity(.1),
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .surface),
                                    onPressed: () async {
                                      await pickImage().then((value) {
                                        image = File(value!);
                                        stateController.isEdited!.value = 1;
                                      });
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.add_a_photo_rounded),
                                    label: const Text("Add Image"),
                                  ),
                                ],
                              ),
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                GlassContainer(
                                  height: double.infinity,
                                  width: double.infinity,
                                  opacity: .3,
                                  child: stateController.isEdited!.value == 1
                                      ? Image.file(image!)
                                      : Center(
                                          child: ImageCompareSlider(
                                            itemOne: Image.file(image!),
                                            itemTwo: Image.file(image2!),
                                          ),
                                        ),
                                ),
                                if (!isDone) const LoadingIndicator(),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void _startEditing() async {
    _cancelCompleter = Completer<void>();
    isDone = false;
    setState(() {});
    try {
      final value = await backGroundRemove(
        startImagePath: image!.path,
        targetImagePath: image2!.path,
        cancelCompleter: _cancelCompleter!,
      );
      if (value != null) {
        stateController.isEdited!.value = 2;
        isDone = true;
        image2 = File(value);
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
      _cancelCompleter!.completeError("Editing canceled");
    }
    image = null;
    isDone = true;
    stateController.isEdited!.value = 0;
    setState(() {});
  }

  void saveImage() async {
    await GallerySaver.saveImage(image2!.path).then((value) {
      Fluttertoast.showToast(msg: "Saved");
    });
  }
}
