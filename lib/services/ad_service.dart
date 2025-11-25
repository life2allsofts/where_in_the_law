// services/ad_service.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart'; // Import for Widget
import 'package:flutter/foundation.dart';

class AdService {
  static BannerAd? _bannerAd;
  static bool isBannerAdReady = false;

  static Future<void> initialize() async {
    try {
      await MobileAds.instance.initialize();
      
      if (kDebugMode) {
        // Request test ads in debug mode
        final configuration = RequestConfiguration(
          testDeviceIds: ['YOUR_TEST_DEVICE_ID'], // Get from console logs when running
        );
        MobileAds.instance.updateRequestConfiguration(configuration);
      }
    } catch (e) {
      print('AdMob initialization failed: $e');
    }
  }

  static void loadBannerAd(String adUnitId) {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isBannerAdReady = true;
          print('Banner ad loaded successfully');
        },
        onAdFailedToLoad: (ad, error) {
          isBannerAdReady = false;
          _bannerAd = null;
          print('Banner ad failed to load: $error');
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  static Widget getBannerAd() {
    if (isBannerAdReady && _bannerAd != null) {
      return SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }
    return const SizedBox.shrink();
  }

  static void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    isBannerAdReady = false;
  }
}