// models/game_question.dart
class GameQuestion {
  final String id;
  final String question;
  final List<QuestionOption> options;
  final String explanation;
  final String lawReference;
  final String category;
  final String difficulty; // beginner, intermediate, expert
  final String? imageUrl;
  final int points;
  
  GameQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.explanation,
    required this.lawReference,
    required this.category,
    required this.difficulty,
    this.imageUrl,
    this.points = 10,
  });
}

class QuestionOption {
  final String text;
  final bool isCorrect;
  
  QuestionOption({required this.text, required this.isCorrect});
}

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
    return totalGamesPlayed > 0 ? correctAnswers / (totalGamesPlayed * 10) * 100 : 0;
  }
  
  int get experienceToNextLevel {
    return level * 100;
  }
}