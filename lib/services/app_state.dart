// lib/services/app_state.dart
// ignore_for_file: avoid_print

import '../models/law_model.dart';
import '../data/law_data.dart';

class AppState {
  // Singleton instance
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  // Cached laws
  List<Law>? _cachedLaws;
  
  // Game state (optional, for future expansion)
  bool _isGameInitialized = false;

  // Get laws (cached or fresh)
  Future<List<Law>> getLaws() async {
    if (_cachedLaws == null) {
      print('📚 AppState: Loading laws fresh');
      _cachedLaws = await LawData.loadLaws();
      print('📚 AppState: Loaded ${_cachedLaws?.length ?? 0} laws');
    } else {
      print('📚 AppState: Using cached laws (${_cachedLaws!.length} laws)');
    }
    return _cachedLaws!;
  }

  // Clear cache (if needed)
  void clearLawCache() {
    print('🗑️ AppState: Clearing law cache');
    _cachedLaws = null;
  }

  // Check if game is initialized
  bool get isGameInitialized => _isGameInitialized;
  
  // Mark game as initialized
  void markGameInitialized() {
    _isGameInitialized = true;
    print('🎮 AppState: Game marked as initialized');
  }

  // Get app state summary (for debugging)
  Map<String, dynamic> getStateSummary() {
    return {
      'lawsCached': _cachedLaws != null,
      'lawCount': _cachedLaws?.length ?? 0,
      'gameInitialized': _isGameInitialized,
    };
  }
}