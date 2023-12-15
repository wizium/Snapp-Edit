import '/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

subscriptionCheck(Timestamp endDate) async {
  if (endDate.toDate().isAfter(DateTime.now())) {
    preferences.setBool("isPro", true);
  } else {
    preferences.setBool("isPro", false);
  }
  isPro.init();
}
