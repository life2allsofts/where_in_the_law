import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/law_model.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_laws';

  static Future<void> toggleFavorite(Law law) async {
    final favorites = await getFavorites();
    
    if (law.isFavorite) {
      favorites.removeWhere((l) => l.id == law.id);
    } else {
      favorites.add(law);
    }
    
    await _saveFavorites(favorites);
  }

  static Future<List<Law>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_favoritesKey);
    
    if (jsonString == null) return [];
    
    try {
      final jsonList = json.decode(jsonString) as List;
      return jsonList.map((json) => Law.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> _saveFavorites(List<Law> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = favorites.map((law) => law.toJson()).toList();
    await prefs.setString(_favoritesKey, json.encode(jsonList));
  }

  static Future<bool> isFavorite(String lawId) async {
    final favorites = await getFavorites();
    return favorites.any((law) => law.id == lawId);
  }
}