// data/game_questions.dart - UPDATED VERSION
// ignore_for_file: avoid_print

import '../models/game_question.dart';
import 'game_question_loader.dart';
import 'dart:math';

class GameQuestions {
  // Cached questions organized by difficulty
  static final Map<String, List<GameQuestion>> _questionsByDifficulty = {};
  static bool _isInitialized = false;
  
  // Initialize and load questions from JSON
  static Future<void> _initialize() async {
    if (_isInitialized) return;
    
    print('🎮 Initializing GameQuestions...');
    
    try {
      // Load all questions from JSON using GameQuestionLoader
      final allQuestions = await GameQuestionLoader.loadQuestions();
      
      if (allQuestions.isEmpty) {
        print('⚠️ No questions loaded from JSON, using generated questions');
        _generateQuestions(); // Fallback to generated questions
      } else {
        print('✅ Organizing ${allQuestions.length} questions by difficulty');
        _organizeQuestions(allQuestions);
      }
      
      _isInitialized = true;
      _printStatistics();
      
    } catch (e, stackTrace) {
      print('❌ Error initializing GameQuestions: $e');
      print('❌ Stack trace: $stackTrace');
      _generateQuestions(); // Fallback to generated questions
      _isInitialized = true;
    }
  }
  
  // Organize loaded questions by difficulty
  static void _organizeQuestions(List<GameQuestion> allQuestions) {
    // Clear existing questions
    _questionsByDifficulty.clear();
    
    // Initialize all difficulty levels
    _questionsByDifficulty['beginner'] = [];
    _questionsByDifficulty['intermediate'] = [];
    _questionsByDifficulty['expert'] = [];
    
    // Organize questions by difficulty
    for (final question in allQuestions) {
      final difficulty = question.difficulty.toLowerCase();
      if (_questionsByDifficulty.containsKey(difficulty)) {
        _questionsByDifficulty[difficulty]!.add(question);
      } else {
        // If difficulty not recognized, add to beginner
        _questionsByDifficulty['beginner']!.add(question);
      }
    }
    
    print('📊 Organized questions:');
    print('   Beginner: ${_questionsByDifficulty['beginner']!.length}');
    print('   Intermediate: ${_questionsByDifficulty['intermediate']!.length}');
    print('   Expert: ${_questionsByDifficulty['expert']!.length}');
  }
  
  // Get questions by difficulty
  static Future<List<GameQuestion>> getQuestionsByDifficulty(String difficulty, [int limit = 10]) async {
    await _initialize();
    
    final questions = _questionsByDifficulty[difficulty] ?? [];
    
    if (questions.isEmpty) {
      print('⚠️ No questions found for difficulty: $difficulty');
      return _getFallbackQuestions(difficulty, limit);
    }
    
    // Shuffle and limit
    final shuffled = List<GameQuestion>.from(questions);
    shuffled.shuffle(Random());
    
    final result = shuffled.take(limit).toList();
    print('📚 Returning ${result.length} questions for $difficulty difficulty');
    return result;
  }
  
  // Get daily challenge questions
  static Future<List<GameQuestion>> getDailyChallenge() async {
    await _initialize();
    
    // Create a seed based on today's date
    final today = DateTime.now();
    final dailySeed = today.year * 10000 + today.month * 100 + today.day;
    final random = Random(dailySeed);
    
    print('📅 Daily challenge for ${today.toIso8601String().split('T')[0]}');
    
    final questions = <GameQuestion>[];
    
    // Get 2 beginner, 3 intermediate, 2 expert questions
    final beginnerQuestions = _questionsByDifficulty['beginner'] ?? [];
    final intermediateQuestions = _questionsByDifficulty['intermediate'] ?? [];
    final expertQuestions = _questionsByDifficulty['expert'] ?? [];
    
    // Select questions based on daily seed
    if (beginnerQuestions.isNotEmpty) {
      for (int i = 0; i < 2 && i < beginnerQuestions.length; i++) {
        questions.add(beginnerQuestions[random.nextInt(beginnerQuestions.length)]);
      }
    }
    
    if (intermediateQuestions.isNotEmpty) {
      for (int i = 0; i < 3 && i < intermediateQuestions.length; i++) {
        questions.add(intermediateQuestions[random.nextInt(intermediateQuestions.length)]);
      }
    }
    
    if (expertQuestions.isNotEmpty) {
      for (int i = 0; i < 2 && i < expertQuestions.length; i++) {
        questions.add(expertQuestions[random.nextInt(expertQuestions.length)]);
      }
    }
    
    // Remove duplicates and ensure unique questions
    final uniqueQuestions = <String, GameQuestion>{};
    for (final question in questions) {
      uniqueQuestions[question.id] = question;
    }
    
    final result = uniqueQuestions.values.toList();
    
    // If not enough questions, add more from any difficulty
    if (result.length < 7) {
      final allQuestions = [...beginnerQuestions, ...intermediateQuestions, ...expertQuestions];
      while (result.length < 7 && allQuestions.isNotEmpty) {
        final question = allQuestions[random.nextInt(allQuestions.length)];
        if (!result.any((q) => q.id == question.id)) {
          result.add(question);
        }
      }
    }
    
    print('✅ Daily challenge: ${result.length} unique questions');
    return result;
  }
  
  // Generate fallback questions for a difficulty
  static List<GameQuestion> _getFallbackQuestions(String difficulty, int limit) {
    print('⚠️ Using fallback questions for $difficulty');
    
    final questions = _generateQuestionsForDifficulty(difficulty, limit * 2);
    questions.shuffle(Random());
    return questions.take(limit).toList();
  }
  
  // Fallback: Generate questions if JSON loading fails
  static void _generateQuestions() {
    print('⚙️ Generating fallback questions...');
    
    // Clear existing questions
    _questionsByDifficulty.clear();
    
    // Generate questions for each difficulty
    _questionsByDifficulty['beginner'] = _generateQuestionsForDifficulty('beginner', 20);
    _questionsByDifficulty['intermediate'] = _generateQuestionsForDifficulty('intermediate', 20);
    _questionsByDifficulty['expert'] = _generateQuestionsForDifficulty('expert', 20);
    
    print('✅ Generated fallback questions');
  }
  
  // Generate questions for a difficulty level (fallback)
  static List<GameQuestion> _generateQuestionsForDifficulty(String difficulty, int count) {
    final questions = <GameQuestion>[];
    final random = Random();
    
    for (int i = 0; i < count; i++) {
      questions.add(_createGeneratedQuestion(i, difficulty, random));
    }
    
    return questions;
  }
  
  // Create a generated question (fallback)
  static GameQuestion _createGeneratedQuestion(int id, String difficulty, Random random) {
    // Simplified fallback question generation
    final categories = ['Rights & Freedoms', 'Business', 'Employment', 'Housing', 'Education'];
    final category = categories[random.nextInt(categories.length)];
    
    return GameQuestion(
      id: 'gen_${difficulty}_$id',
      question: 'Generated question about $category in Ghanaian law',
      options: [
        QuestionOption(text: 'Correct answer', isCorrect: true),
        QuestionOption(text: 'Wrong answer 1', isCorrect: false),
        QuestionOption(text: 'Wrong answer 2', isCorrect: false),
        QuestionOption(text: 'Wrong answer 3', isCorrect: false),
      ],
      explanation: 'This is a generated explanation for a question about $category.',
      lawReference: 'Generated Law Reference',
      category: category,
      difficulty: difficulty,
      points: difficulty == 'beginner' ? 5 : difficulty == 'intermediate' ? 10 : 15,
    );
  }
  
  // Print statistics
  static void _printStatistics() {
    print('📊 Game Questions Statistics:');
    print('   Beginner: ${_questionsByDifficulty['beginner']?.length ?? 0}');
    print('   Intermediate: ${_questionsByDifficulty['intermediate']?.length ?? 0}');
    print('   Expert: ${_questionsByDifficulty['expert']?.length ?? 0}');
    print('   Total: ${_questionsByDifficulty.values.fold(0, (sum, list) => sum + list.length)}');
    print('   Loaded from JSON: ${GameQuestionLoader.isLoaded}');
  }
  
  // Clear cache
  static void clearCache() {
    _questionsByDifficulty.clear();
    _isInitialized = false;
    GameQuestionLoader.clearCache();
    print('🗑️ Cleared all game questions cache');
  }
  
  // Get statistics
  static Future<Map<String, dynamic>> getStatistics() async {
    await _initialize();
    
    return {
      'beginner': _questionsByDifficulty['beginner']?.length ?? 0,
      'intermediate': _questionsByDifficulty['intermediate']?.length ?? 0,
      'expert': _questionsByDifficulty['expert']?.length ?? 0,
      'total': _questionsByDifficulty.values.fold(0, (sum, list) => sum + list.length),
      'initialized': _isInitialized,
      'loadedFromJson': GameQuestionLoader.isLoaded,
    };
  }
  
  // Check if daily challenge is available for today
  static bool canPlayDailyChallengeToday(String lastPlayedDate) {
    try {
      final lastDate = DateTime.parse(lastPlayedDate);
      final today = DateTime.now();
      return !(lastDate.year == today.year &&
          lastDate.month == today.month &&
          lastDate.day == today.day);
    } catch (e) {
      return true; // If error, allow playing
    }
  }
}