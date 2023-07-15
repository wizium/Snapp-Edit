import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import '/Functions/get_doc_directory.dart';
import '/Functions/bg_remove.dart';
import 'package:photo_view/photo_view.dart';
import '/Functions/pick_image.dart';
import 'package:fluttertoast/fluttertoast.dart';

File? image;
bool isEdited = false;
Directory? appDocDir;
bool isDone = true;

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    getDocDirectory().then(
      (value) => {
        appDocDir = value,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          image != null
              ? ElevatedButton.icon(
                  onPressed: () {
                    image = null;
                    setState(() {});
                  },
                  icon: const Icon(Icons.add_a_photo_rounded),
                  label: const Text('Add Photo'),
                )
              : const SizedBox(),
        ],
      ),
      floatingActionButton: image != null
          ? FloatingActionButton(
              onPressed: isEdited == false
                  ? () async {
                      isDone = false;
                      setState(() {});
                      await backGroundRemove(
                        startImagePath: image!.path,
                        targetImagePath: "${appDocDir!.path}newImage.jpg",
                      ).then(
                        (value) => {
                          if (value != null)
                            {
                              isEdited = true,
                              isDone = true,
                              image = File(value),
                            }
                          else
                            {
                              Fluttertoast.showToast(msg: "Error"),
                            }
                        },
                      );
                      setState(() {});
                    }
                  : () async {
                      await GallerySaver.saveImage(image!.path).then(
                        (value) => {
                          Fluttertoast.showToast(msg: "Saved"),
                        },
                      );
                    },
              child: isEdited == false
                  ? const Icon(
                      Icons.cut_rounded,
                    )
                  : const Icon(
                      Icons.download_for_offline_rounded,
                    ),
            )
          : null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: image == null
                ? Container(
                    height: height * .59,
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await pickImage().then((value) {
                            image = File(value!);
                            isEdited = false;
                          });
                          setState(() {});
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add"),
                      ),
                    ),
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: height * .89,
                        width: width,
                        child: PhotoView(
                          customSize: MediaQuery.of(context).size,
                          tightMode: true,
                          imageProvider: FileImage(
                            image!,
                          ),
                          initialScale: PhotoViewComputedScale.contained,
                          maxScale: PhotoViewComputedScale.contained * 2.5,
                          minScale: PhotoViewComputedScale.contained * 1,
                        ),
                      ),
                      isDone == false
                          ? Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    12,
                                  ),
                                ),
                                color: Colors.black87,
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Processing",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
