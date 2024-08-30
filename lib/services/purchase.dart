import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../screen/login.dart';
import '/main.dart';
import 'signin.dart';
import 'subscriptioncheck.dart';

InAppPurchase inAppPurchase = InAppPurchase.instance;
late PurchaseParam purchaseParam;
FirebaseFirestore firestore = FirebaseFirestore.instance;
listenToPurchase(List<PurchaseDetails> purchaseDetails) async {
  for (PurchaseDetails element in purchaseDetails) {
    if (element.status == PurchaseStatus.pending) {
      debugPrint("Purchase pending");
    } else if (element.status == PurchaseStatus.error) {
      debugPrint("Error Buying");
    } else if (element.status == PurchaseStatus.purchased) {
      Timestamp? endDate;
      if (purchaseParam.productDetails.id == products[1].id) {
        endDate = Timestamp.fromDate(
          DateTime.now().add(
            const Duration(days: 365),
          ),
        );
      } else if (purchaseParam.productDetails.id == products[0].id) {
        endDate = Timestamp.fromDate(
          DateTime.now().add(
            const Duration(days: 365 * 100),
          ),
        );
      }
      await firestore
          .collection("subscription_details")
          .doc(firebaseAuth.currentUser!.uid)
          .set(
        {"endDate": endDate},
      );
      preferences.setString(
        "endDate",
        endDate!.toDate().toString(),
      );
      subscriptionCheck(
        Timestamp.fromDate(
          DateTime.now().add(
            const Duration(days: 365),
          ),
        ),
      );
      debugPrint("purchased");
    }
  }
}

initStore(VoidCallback callback) async {
  ProductDetailsResponse productDetailsResponse =
      await inAppPurchase.queryProductDetails(kProductIds);
  if (productDetailsResponse.error == null) {
    products = productDetailsResponse.productDetails;
  } else {
    debugPrint(productDetailsResponse.error.toString());
  }
  callback();
}

buy({required ProductDetails product}) async {
  if (firebaseAuth.currentUser == null) {
    Get.snackbar(
      "Error",
      "Please login first",
      mainButton: TextButton(
        onPressed: () {
          Get.to(
            const LoginScreen(),
          );
        },
        child: const Text("Login"),
      ),
    );
  } else {
    purchaseParam = PurchaseParam(productDetails: product);
    await inAppPurchase.buyConsumable(
      purchaseParam: purchaseParam,
    );
  }
}
