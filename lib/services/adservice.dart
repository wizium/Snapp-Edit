import 'package:flutter/material.dart';
import '../main.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class AdServices {
  static String appId = "5500181";
  static String bannerAdUnitId = "Banner_Android";
  static String interstitialAdUnitId = "Interstitial_Android";

  void interstitialAdLoad() async {
    if (!isPro.isPro.value) {
      await UnityAds.load(
        placementId: interstitialAdUnitId,
        onComplete: (placementId) {
          debugPrint(
            "$placementId is loaded",
          );
          isLoaded = true;
        },
        onFailed: (placementId, error, errorMessage) {
          debugPrint(
            "$placementId id failed to load for $errorMessage",
          );
        },
      );
    }
  }

  Future<void> showInterstitialAd(Function onComplete) async {
    if (!isPro.isPro.value) {
      await UnityAds.showVideoAd(
        placementId: AdServices.interstitialAdUnitId,
        onComplete: (placementId) {
          onComplete();
        },
        onSkipped: (placementId) {
          onComplete();
        },
        onFailed: (placementId, error, errorMessage) {
          onComplete();
        },
      );
      isLoaded = false;
    }
  }
}
