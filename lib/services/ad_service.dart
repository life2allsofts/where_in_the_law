// services/ad_service.dart
// ignore_for_file: avoid_print

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class AdService with ChangeNotifier {
  // Banner Ads for each screen
  static BannerAd? _homeBannerAd;
  static BannerAd? _categoriesBannerAd;
  static BannerAd? _favoritesBannerAd;
  static BannerAd? _lawDetailBannerAd;
  static BannerAd? _searchBannerAd;
  
  // Interstitial Ad
  static InterstitialAd? _interstitialAd;
  static bool isInterstitialReady = false;
  static bool _isInterstitialLoading = false;
  
  // Counter for interstitial frequency (show every 3-5 actions)
  static int _actionCounter = 0;
  static const int _interstitialFrequency = 3; // Show every 3 actions
  
  // Loading states for each screen
  static bool isHomeBannerReady = false;
  static bool isCategoriesBannerReady = false;
  static bool isFavoritesBannerReady = false;
  static bool isLawDetailBannerReady = false;
  static bool isSearchBannerReady = false;
  
  static bool _isAdMobInitialized = false;
  
  // Singleton instance
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  static Future<void> initializeAdMob() async {
    try {
      await MobileAds.instance.initialize();
      _isAdMobInitialized = true;
      print('✅ AdMob initialized successfully');
      
      // Preload interstitial ad
      _loadInterstitialAd();
      
      if (kDebugMode) {
        // Add test device IDs for debugging
        List<String> testDeviceIds = [];
        
        // You can add your test device IDs here
        // For Android: Use the device ID shown in logcat
        // For iOS: Use the device ID from settings
        
        final configuration = RequestConfiguration(
          testDeviceIds: testDeviceIds,
        );
        MobileAds.instance.updateRequestConfiguration(configuration);
      }
    } catch (e) {
      print('❌ AdMob initialization failed: $e');
      _isAdMobInitialized = false;
    }
  }

  // ========== INTERSTITIAL ADS ==========
  static void _loadInterstitialAd() {
    if (!_isAdMobInitialized) {
      print('⚠️ AdMob not initialized yet');
      return;
    }
    
    if (_isInterstitialLoading) {
      print('⚠️ Interstitial ad is already loading');
      return;
    }
    
    print('🔄 Loading INTERSTITIAL ad');
    _isInterstitialLoading = true;
    
    InterstitialAd.load(
      adUnitId: Platform.isAndroid 
        ? 'ca-app-pub-4334052584109954/4716944863' // Android interstitial
        : 'ca-app-pub-4334052584109954/4716944863', // iOS interstitial
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          isInterstitialReady = true;
          _isInterstitialLoading = false;
          print('✅ Interstitial ad loaded successfully');
          print('📱 Platform: ${Platform.isAndroid ? 'Android' : 'iOS'}');
          
          // Set up full screen content callback
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              print('🔄 Interstitial ad showing');
            },
            onAdDismissedFullScreenContent: (ad) {
              print('✅ Interstitial ad dismissed');
              ad.dispose();
              isInterstitialReady = false;
              _interstitialAd = null;
              // Load next interstitial after a delay
              Future.delayed(const Duration(seconds: 1), () {
                _loadInterstitialAd();
              });
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('❌ Interstitial ad failed to show: $error');
              ad.dispose();
              isInterstitialReady = false;
              _interstitialAd = null;
              // Retry after delay
              Future.delayed(const Duration(seconds: 5), () {
                _loadInterstitialAd();
              });
            },
            onAdClicked: (ad) {
              print('👆 Interstitial ad clicked');
            },
            onAdImpression: (ad) {
              print('👁️ Interstitial ad impression recorded');
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('❌ Interstitial ad failed to load: $error');
          print('📱 Platform: ${Platform.isAndroid ? 'Android' : 'iOS'}');
          print('🔧 Error details: ${error.message}');
          print('🔧 Error code: ${error.code}');
          print('🔧 Error domain: ${error.domain}');
          
          isInterstitialReady = false;
          _isInterstitialLoading = false;
          _interstitialAd = null;
          
          // Retry after delay with exponential backoff
          Future.delayed(const Duration(seconds: 30), () {
            _loadInterstitialAd();
          });
        },
      ),
    );
  }

  static void showInterstitialAd({required String screenName, required String action}) {
    print('🔍 Checking interstitial ad...');
    print('   Screen: $screenName');
    print('   Action: $action');
    print('   isInterstitialReady: $isInterstitialReady');
    print('   _interstitialAd is null: ${_interstitialAd == null}');
    print('   _actionCounter: $_actionCounter');
    print('   _interstitialFrequency: $_interstitialFrequency');
    
    if (!isInterstitialReady || _interstitialAd == null) {
      print('⚠️ Interstitial ad not ready yet');
      print('   Current state:');
      print('   - isInterstitialReady: $isInterstitialReady');
      print('   - _interstitialAd: ${_interstitialAd == null ? 'null' : 'loaded'}');
      print('   - _isInterstitialLoading: $_isInterstitialLoading');
      return;
    }
    
    // Increment action counter
    _actionCounter++;
    
    print('📊 Action counter incremented: $_actionCounter/$_interstitialFrequency');
    
    // Show interstitial every N actions
    if (_actionCounter >= _interstitialFrequency) {
      print('🎯 Showing interstitial ad!');
      print('   Screen: $screenName');
      print('   Action: $action');
      print('   Counter: $_actionCounter/$_interstitialFrequency');
      
      try {
        _interstitialAd?.show();
        _actionCounter = 0; // Reset counter
        print('✅ Interstitial ad show() called successfully');
      } catch (e) {
        print('❌ Error showing interstitial ad: $e');
        // Reset and reload if there's an error
        _actionCounter = 0;
        isInterstitialReady = false;
        _interstitialAd?.dispose();
        _interstitialAd = null;
        _loadInterstitialAd();
      }
    } else {
      print('📊 Action count: $_actionCounter/$_interstitialFrequency');
      print('   (Not showing ad yet, need ${_interstitialFrequency - _actionCounter} more actions)');
    }
  }

  // ========== FORCE SHOW INTERSTITIAL (For Testing) ==========
  static void forceShowInterstitial() {
    if (isInterstitialReady && _interstitialAd != null) {
      print('🎯 FORCE showing interstitial ad (testing)');
      _interstitialAd?.show();
      _actionCounter = 0;
    } else {
      print('⚠️ Cannot force show: interstitial not ready');
    }
  }

  // ========== RESET ACTION COUNTER (For Testing) ==========
  static void resetActionCounter() {
    print('🔄 Resetting action counter from $_actionCounter to 0');
    _actionCounter = 0;
  }

  // ========== GET CURRENT INTERSTITIAL STATUS ==========
  static Map<String, dynamic> getInterstitialStatus() {
    return {
      'isReady': isInterstitialReady,
      'isLoading': _isInterstitialLoading,
      'actionCounter': _actionCounter,
      'frequency': _interstitialFrequency,
      'adLoaded': _interstitialAd != null,
      'actionsNeeded': _interstitialFrequency - _actionCounter,
    };
  }

  // ========== HOME SCREEN ==========
  static void loadHomeBannerAd(String adUnitId) {
    if (!_isAdMobInitialized) {
      print('⚠️ AdMob not initialized yet');
      return;
    }
    
    if (isHomeBannerReady && _homeBannerAd != null) {
      print('✅ Home banner ad already loaded');
      return;
    }
    
    _homeBannerAd?.dispose();
    
    print('🔄 Loading HOME banner ad: $adUnitId');
    
    _homeBannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isHomeBannerReady = true;
          print('✅ Home banner ad loaded successfully');
          _instance.notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          isHomeBannerReady = false;
          _homeBannerAd = null;
          print('❌ Home banner ad failed to load: $error');
          _instance.notifyListeners();
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  static Widget getHomeBannerAd() {
    if (isHomeBannerReady && _homeBannerAd != null) {
      return SizedBox(
        width: _homeBannerAd!.size.width.toDouble(),
        height: _homeBannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _homeBannerAd!),
      );
    }
    return Container(height: 50, color: Colors.transparent);
  }

  // ========== CATEGORIES SCREEN ==========
  static void loadCategoriesBannerAd(String adUnitId) {
    if (!_isAdMobInitialized) {
      print('⚠️ AdMob not initialized yet');
      return;
    }
    
    if (isCategoriesBannerReady && _categoriesBannerAd != null) {
      print('✅ Categories banner ad already loaded');
      return;
    }
    
    _categoriesBannerAd?.dispose();
    
    print('🔄 Loading CATEGORIES banner ad: $adUnitId');
    
    _categoriesBannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isCategoriesBannerReady = true;
          print('✅ Categories banner ad loaded successfully');
          _instance.notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          isCategoriesBannerReady = false;
          _categoriesBannerAd = null;
          print('❌ Categories banner ad failed to load: $error');
          _instance.notifyListeners();
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  static Widget getCategoriesBannerAd() {
    if (isCategoriesBannerReady && _categoriesBannerAd != null) {
      return SizedBox(
        width: _categoriesBannerAd!.size.width.toDouble(),
        height: _categoriesBannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _categoriesBannerAd!),
      );
    }
    return Container(height: 50, color: Colors.transparent);
  }

  // ========== FAVORITES SCREEN ==========
  static void loadFavoritesBannerAd(String adUnitId) {
    if (!_isAdMobInitialized) {
      print('⚠️ AdMob not initialized yet');
      return;
    }
    
    if (isFavoritesBannerReady && _favoritesBannerAd != null) {
      print('✅ Favorites banner ad already loaded');
      return;
    }
    
    _favoritesBannerAd?.dispose();
    
    print('🔄 Loading FAVORITES banner ad: $adUnitId');
    
    _favoritesBannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isFavoritesBannerReady = true;
          print('✅ Favorites banner ad loaded successfully');
          _instance.notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          isFavoritesBannerReady = false;
          _favoritesBannerAd = null;
          print('❌ Favorites banner ad failed to load: $error');
          _instance.notifyListeners();
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  static Widget getFavoritesBannerAd() {
    if (isFavoritesBannerReady && _favoritesBannerAd != null) {
      return SizedBox(
        width: _favoritesBannerAd!.size.width.toDouble(),
        height: _favoritesBannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _favoritesBannerAd!),
      );
    }
    return Container(height: 50, color: Colors.transparent);
  }

  // ========== LAW DETAIL SCREEN ==========
  static void loadLawDetailBannerAd(String adUnitId) {
    if (!_isAdMobInitialized) {
      print('⚠️ AdMob not initialized yet');
      return;
    }
    
    if (isLawDetailBannerReady && _lawDetailBannerAd != null) {
      print('✅ Law Detail banner ad already loaded');
      return;
    }
    
    _lawDetailBannerAd?.dispose();
    
    print('🔄 Loading LAW DETAIL banner ad: $adUnitId');
    
    _lawDetailBannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isLawDetailBannerReady = true;
          print('✅ Law Detail banner ad loaded successfully');
          _instance.notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          isLawDetailBannerReady = false;
          _lawDetailBannerAd = null;
          print('❌ Law Detail banner ad failed to load: $error');
          _instance.notifyListeners();
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  static Widget getLawDetailBannerAd() {
    if (isLawDetailBannerReady && _lawDetailBannerAd != null) {
      return SizedBox(
        width: _lawDetailBannerAd!.size.width.toDouble(),
        height: _lawDetailBannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _lawDetailBannerAd!),
      );
    }
    return Container(height: 50, color: Colors.transparent);
  }

  // ========== SEARCH SCREEN ==========
  static void loadSearchBannerAd(String adUnitId) {
    if (!_isAdMobInitialized) {
      print('⚠️ AdMob not initialized yet');
      return;
    }
    
    if (isSearchBannerReady && _searchBannerAd != null) {
      print('✅ Search banner ad already loaded');
      return;
    }
    
    _searchBannerAd?.dispose();
    
    print('🔄 Loading SEARCH banner ad: $adUnitId');
    
    _searchBannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isSearchBannerReady = true;
          print('✅ Search banner ad loaded successfully');
          _instance.notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          isSearchBannerReady = false;
          _searchBannerAd = null;
          print('❌ Search banner ad failed to load: $error');
          _instance.notifyListeners();
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  static Widget getSearchBannerAd() {
    if (isSearchBannerReady && _searchBannerAd != null) {
      return SizedBox(
        width: _searchBannerAd!.size.width.toDouble(),
        height: _searchBannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _searchBannerAd!),
      );
    }
    return Container(height: 50, color: Colors.transparent);
  }

  // ========== DISPOSE ALL ==========
  static void disposeAll() {
    print('🗑️ Disposing all ads...');
    
    _homeBannerAd?.dispose();
    _categoriesBannerAd?.dispose();
    _favoritesBannerAd?.dispose();
    _lawDetailBannerAd?.dispose();
    _searchBannerAd?.dispose();
    _interstitialAd?.dispose();
    
    _homeBannerAd = null;
    _categoriesBannerAd = null;
    _favoritesBannerAd = null;
    _lawDetailBannerAd = null;
    _searchBannerAd = null;
    _interstitialAd = null;
    
    isHomeBannerReady = false;
    isCategoriesBannerReady = false;
    isFavoritesBannerReady = false;
    isLawDetailBannerReady = false;
    isSearchBannerReady = false;
    isInterstitialReady = false;
    _isInterstitialLoading = false;
    
    _actionCounter = 0;
    
    print('✅ All ads disposed');
    _instance.notifyListeners();
  }
}