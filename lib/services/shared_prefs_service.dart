// lib/services/shared_prefs_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String _hasAgreedToTermsKey = 'has_agreed_to_terms';
  static const String _hasSeenTutorialKey = 'has_seen_tutorial';
  static const String _isFirstLaunchKey = 'is_first_launch';

  static Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  // Check if user has agreed to terms
  static Future<bool> get hasAgreedToTerms async {
    final prefs = await _prefs;
    return prefs.getBool(_hasAgreedToTermsKey) ?? false;
  }

  // Set that user has agreed to terms
  static Future<void> setHasAgreedToTerms(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_hasAgreedToTermsKey, value);
  }

  // Check if user has seen tutorial
  static Future<bool> get hasSeenTutorial async {
    final prefs = await _prefs;
    return prefs.getBool(_hasSeenTutorialKey) ?? false;
  }

  // Set that user has seen tutorial
  static Future<void> setHasSeenTutorial(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_hasSeenTutorialKey, value);
  }

  // Check if this is first app launch
  static Future<bool> get isFirstLaunch async {
    final prefs = await _prefs;
    final isFirst = prefs.getBool(_isFirstLaunchKey) ?? true;
    if (isFirst) {
      await prefs.setBool(_isFirstLaunchKey, false);
    }
    return isFirst;
  }
}