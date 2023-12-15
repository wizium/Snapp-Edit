import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '/main.dart';
import '/service/purchase.dart';
import '/service/signin.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => HomeDrawerState();
}

class HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(.8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (auth.currentUser != null)
                (UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    gradient: SweepGradient(
                      colors: [Colors.blue, Colors.purple, Colors.pink],
                      center: Alignment.topRight,
                      tileMode: TileMode.decal,
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                  otherAccountsPictures: [
                    Obx(
                      () {
                        return Icon(
                          isPro.isPro.value
                              ? Icons.workspace_premium_rounded
                              : null,
                          size: 40,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        );
                      },
                    ),
                  ],
                  currentAccountPicture: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: auth.currentUser!.photoURL.toString(),
                    ),
                  ),
                  accountName: Text(
                    auth.currentUser!.displayName.toString(),
                  ),
                  accountEmail: Text(
                    auth.currentUser!.email.toString(),
                  ),
                ))
              else
                Card(
                  child: ListTile(
                    onTap: () {
                      signInCheck();
                    },
                    leading: const Icon(
                      Icons.account_circle_rounded,
                      size: 40,
                    ),
                    title: const Center(
                      child: Text(
                        "Login",
                      ),
                    ),
                  ),
                ),
              Obx(() {
                return isPro.isPro.value != true
                    ? Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.workspace_premium_rounded,
                            size: 40,
                          ),
                          title: const Text("Remove ads"),
                          onTap: () async {
                            buy(product: products[0]);
                          },
                        ),
                      )
                    : const SizedBox();
              }),
              const Divider(),
              auth.currentUser != null
                  ? Card(
                      child: ListTile(
                        onTap: () async {
                          await auth.signOut();
                          await GoogleSignIn().signOut();
                          preferences.remove("endDate");
                          preferences.setBool("isPro", false);
                          isPro.init();
                          await signInCheck();
                        },
                        title: const Center(
                          child: Text(
                            "Logout",
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
