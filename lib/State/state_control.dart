import 'package:get/state_manager.dart';
import '../main.dart';

class StateController extends GetxController {
  RxInt? isEdited = 0.obs;
  updateIsEdited(int newValue) {
    isEdited!.value = newValue;
  }
}

class IsPro extends GetxController {
  RxBool isPro = false.obs;
  init() {
    isPro.value = preferences.getBool("isPro") ?? false;
  }
}
