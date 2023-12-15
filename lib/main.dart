import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_bg_remover/Page/splash.dart';
import 'package:image_bg_remover/firebase_options.dart';
import 'package:image_bg_remover/service/adservice.dart';
import 'package:image_bg_remover/service/purchase.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'State/state_control.dart';

StateController stateController = Get.put(StateController());
List<ProductDetails> products = [];
const Set<String> kProductIds = {"1year_pro"};
IsPro isPro = Get.put(IsPro());
bool isLoaded = false;

late SharedPreferences preferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  UnityAds.init(
    gameId: AdServices.appId,
  );
  preferences = await SharedPreferences.getInstance();
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
      theme: ThemeData(useMaterial3: true),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
