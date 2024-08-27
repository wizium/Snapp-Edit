import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/cache_service.dart';
import '../services/signin.dart';
import '../widget/about_me.dart';
import '../widget/donations.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config.dart';
import '../main.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => HomeDrawerState();
}

class HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: Theme.of(context).colorScheme.onSecondary,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: SafeArea(
                  child: Column(
                    children: [
                      if (firebaseAuth.currentUser != null) ...[
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(
                            File("${downloadPath!.path}/avatar.png"),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Welcome, ${firebaseAuth.currentUser!.displayName}!',
                          style: Theme.of(context).textTheme.titleLarge!.merge(
                                TextStyle(
                                  color:
                                      Theme.of(context).listTileTheme.iconColor,
                                ),
                              ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "You are using Snapp Edit ${isPro.isPro.value ? "Pro" : "Free"}",
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          width: Get.width,
                          child: FilledButton(
                            child: Text(
                              'Log Out',
                              style:
                                  Theme.of(context).textTheme.bodyLarge!.merge(
                                        TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                            ),
                            onPressed: () async {
                              await SignIn.signOut(context);
                              setState(() {});
                            },
                          ),
                        ),
                      ] else ...[
                        const CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person, size: 50),
                        ),
                        const SizedBox(height: 20),
                        const Text("Sign in below to get started"),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 60,
                          width: Get.width,
                          child: FilledButton.icon(
                            icon: Image.asset(
                              "assets/google.png",
                              height: 30,
                            ),
                            label: Text(
                              'Continue with Google',
                              style:
                                  Theme.of(context).textTheme.bodyLarge!.merge(
                                        TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                            ),
                            onPressed: () async {
                              await SignIn.googleSignIn();
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: gPadding),
            Card(
              color: Theme.of(context).colorScheme.primary,
              child: ListTile(
                leading: const Icon(
                  Icons.workspace_premium_rounded,
                  color: Colors.white,
                ),
                title: const Text(
                  'Donate Us!',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: const Text(
                  'Support in keeping app free.',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () async {
                  Get.to(
                    () => const PaymentsBottomSheet(),
                  );
                },
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.star_rounded,
              ),
              title: const Text('Rate Snapp Edit'),
              subtitle: const Text(
                'Rate us on the Play Store.',
              ),
              onTap: () async {
                final InAppReview inAppReview = InAppReview.instance;

                if (await inAppReview.isAvailable()) {
                  inAppReview.requestReview();
                }
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.mail_rounded,
              ),
              title: const Text('Help and Feedback'),
              subtitle: const Text('Got questions? Email Us.'),
              onTap: () {
                launchUrl(
                  Uri.parse(
                    "mailto:wizium123@gmail.com?subject=Feedback for Snapp Edit",
                  ),
                  mode: LaunchMode.externalNonBrowserApplication,
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete,
              ),
              title: const Text('Clear Cache'),
              subtitle: const Text(
                'Clear locally cached images.',
              ),
              onTap: () {
                CacheManager().clearCacheAndShowSize();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.privacy_tip_rounded,
              ),
              title: const Text('Privacy Policy'),
              subtitle: const Text('Read our Privacy Policy.'),
              onTap: () {
                launchUrl(
                  Uri.parse(
                    "https://sites.google.com/view/snapawaypolicy/home",
                  ),
                  mode: LaunchMode.inAppBrowserView,
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.info_rounded,
              ),
              title: const Text('About'),
              subtitle: const Text('Licenses and credits'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: appName,
                  applicationVersion: version,
                  applicationIcon: ClipRRect(
                    borderRadius: BorderRadius.circular(childBorderRadius),
                    child: Image.asset(
                      "assets/appIcon.png",
                      height: 70,
                      width: 70,
                    ),
                  ),
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "This is a fermium ai powered image editing app.",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        aboutMeDialog();
                      },
                      child: const Text("About Developer"),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
