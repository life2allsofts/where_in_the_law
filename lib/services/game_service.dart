// services/game_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:where_in_the_law/models/user_game_profile.dart';


class GameService {
  static const String _profileKey = 'user_game_profile';
  static const String _lastDailyKey = 'last_daily_challenge';
  static const String _streakKey = 'game_streak_days';
  
  static Future<UserGameProfile> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_profileKey);
    
    if (json == null) {
      // Create new profile
      final newProfile = UserGameProfile(
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        lastPlayDate: DateTime.now(),
      );
      await saveUserProfile(newProfile);
      return newProfile;
    }
    
    try {
      final data = Map<String, dynamic>.from(jsonDecode(json));
      return UserGameProfile(
        userId: data['userId'] ?? '',
        level: data['level'] ?? 1,
        experience: data['experience'] ?? 0,
        cediCoins: data['cediCoins'] ?? 0,
        streakDays: data['streakDays'] ?? 0,
        lastPlayDate: DateTime.parse(data['lastPlayDate'] ?? DateTime.now().toString()),
        unlockedBadges: Map<String, bool>.from(data['unlockedBadges'] ?? {}),
        categoryScores: Map<String, int>.from(data['categoryScores'] ?? {}),
        totalGamesPlayed: data['totalGamesPlayed'] ?? 0,
        correctAnswers: data['correctAnswers'] ?? 0,
      );
    } catch (e) {
      // If corrupted, create new
      final newProfile = UserGameProfile(
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        lastPlayDate: DateTime.now(),
      );
      await saveUserProfile(newProfile);
      return newProfile;
    }
  }
  
  static Future<void> saveUserProfile(UserGameProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'userId': profile.userId,
      'level': profile.level,
      'experience': profile.experience,
      'cediCoins': profile.cediCoins,
      'streakDays': profile.streakDays,
      'lastPlayDate': profile.lastPlayDate.toIso8601String(),
      'unlockedBadges': profile.unlockedBadges,
      'categoryScores': profile.categoryScores,
      'totalGamesPlayed': profile.totalGamesPlayed,
      'correctAnswers': profile.correctAnswers,
    };
    await prefs.setString(_profileKey, jsonEncode(data));
  }
  
  static Future<bool> canPlayDailyChallenge() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDateStr = prefs.getString(_lastDailyKey);
    
    if (lastDateStr == null) {
      return true; // First time playing
    }
    
    final lastDate = DateTime.parse(lastDateStr);
    final today = DateTime.now();
    
    return !(lastDate.year == today.year && 
             lastDate.month == today.month && 
             lastDate.day == today.day);
  }
  
  static Future<void> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDateStr = prefs.getString(_lastDailyKey);
    final today = DateTime.now();
    
    if (lastDateStr == null) {
      // First day
      await prefs.setInt(_streakKey, 1);
      await prefs.setString(_lastDailyKey, today.toIso8601String());
      return;
    }
    
    final lastDate = DateTime.parse(lastDateStr);
    final yesterday = DateTime(today.year, today.month, today.day - 1);
    
    if (lastDate.year == yesterday.year && 
        lastDate.month == yesterday.month && 
        lastDate.day == yesterday.day) {
      // Consecutive day
      final currentStreak = prefs.getInt(_streakKey) ?? 0;
      await prefs.setInt(_streakKey, currentStreak + 1);
    } else if (lastDate.year != today.year || 
               lastDate.month != today.month || 
               lastDate.day != today.day) {
      // Not yesterday, break streak
      await prefs.setInt(_streakKey, 1);
    }
    
    await prefs.setString(_lastDailyKey, today.toIso8601String());
  }
  
  static Future<int> getCurrentStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }
}