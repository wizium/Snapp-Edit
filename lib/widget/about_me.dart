import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config.dart';
import 'package:url_launcher/url_launcher.dart';

aboutMeDialog() async {
  await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(childBorderRadius),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(childBorderRadius),
                      child: Image.asset(
                        "assets/abubakar.png",
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Hi, I'm Abubakar",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "A full stack Flutter developer based in Faisalabad, Pakistan. I specialize in Flutter, Dart, Node.js, Express, MongoDB, MySQL, TypeScript, JavaScript, and Python. With years of experience in mobile development and AI, I deliver high-quality, user-focused applications.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "For freelance work hire me on:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF99D18),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              launchUrl(
                                Uri.parse("https://www.fiverr.com/wizium"),
                              );
                            },
                            child: const Text("Fiverr"),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF99D18),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              launchUrl(
                                Uri.parse(
                                  "https://www.upwork.com/freelancers/~010068a01c10ad13de",
                                ),
                              );
                            },
                            child: const Text("Upwork"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF99D18),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          launchUrl(
                            Uri.parse(
                              "https://www.linkedin.com/in/abubakarl/",
                            ),
                          );
                        },
                        child: const Text("LinkedIn"),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0.0,
                right: 0.0,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      });
}
