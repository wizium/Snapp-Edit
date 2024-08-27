import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'screen/splash.dart';
import '../firebase_options.dart';
import 'services/purchase.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'state/state_control.dart';

StateController stateController = Get.put(StateController());
List<ProductDetails> products = [];
const Set<String> kProductIds = {"1year_pro"};
IsPro isPro = Get.put(IsPro());
bool isLoaded = false;
late SharedPreferences preferences;
Directory? downloadPath;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  downloadPath = await getApplicationDocumentsDirectory();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  preferences = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    initStore(() {
      setState(() {});
    });
    return GetMaterialApp(
      home: const SplashScreen(),
      theme: ThemeData(
        fontFamily: "Agbalumo",
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0XFFFF8473),
          brightness: Brightness.light,
          primary: const Color(0XFFFF8473),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
