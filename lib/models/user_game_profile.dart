// models/user_game_profile.dart

class UserGameProfile {
  String userId;
  int level;
  int experience;
  int cediCoins;
  int streakDays;
  DateTime lastPlayDate;
  Map<String, bool> unlockedBadges;
  Map<String, int> categoryScores;
  int totalGamesPlayed;
  int correctAnswers;
  
  UserGameProfile({
    required this.userId,
    this.level = 1,
    this.experience = 0,
    this.cediCoins = 0,
    this.streakDays = 0,
    required this.lastPlayDate,
    this.unlockedBadges = const {},
    this.categoryScores = const {},
    this.totalGamesPlayed = 0,
    this.correctAnswers = 0,
  });
  
  double get accuracy {
    return totalGamesPlayed > 0 ? (correctAnswers / (totalGamesPlayed * 10)) * 100 : 0;
  }
  
  int get experienceToNextLevel {
    return level * 100;
  }
  
  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'level': level,
      'experience': experience,
      'cediCoins': cediCoins,
      'streakDays': streakDays,
      'lastPlayDate': lastPlayDate.toIso8601String(),
      'unlockedBadges': unlockedBadges,
      'categoryScores': categoryScores,
      'totalGamesPlayed': totalGamesPlayed,
      'correctAnswers': correctAnswers,
    };
  }
  
  // Create from JSON
  factory UserGameProfile.fromJson(Map<String, dynamic> json) {
    return UserGameProfile(
      userId: json['userId'] ?? '',
      level: json['level'] ?? 1,
      experience: json['experience'] ?? 0,
      cediCoins: json['cediCoins'] ?? 0,
      streakDays: json['streakDays'] ?? 0,
      lastPlayDate: DateTime.parse(json['lastPlayDate'] ?? DateTime.now().toIso8601String()),
      unlockedBadges: Map<String, bool>.from(json['unlockedBadges'] ?? {}),
      categoryScores: Map<String, int>.from(json['categoryScores'] ?? {}),
      totalGamesPlayed: json['totalGamesPlayed'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
    );
  }
}