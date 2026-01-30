// data/law_question_generator.dart - OPTIMIZED VERSION
// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/game_question.dart';

class LawQuestionGenerator {
  static Future<List<GameQuestion>> generateQuestionsFromLaws() async {
    print('🔧 Generating optimized questions from law_data.json...');
    
    try {
      // Load law data
      final String jsonString = await rootBundle.loadString('assets/law_data.json');
      final List<dynamic> lawList = json.decode(jsonString);
      
      final questions = <GameQuestion>[];
      int questionId = 1;
      
      // Shuffle laws to ensure variety
      final shuffledLaws = List<Map<String, dynamic>>.from(lawList);
      shuffledLaws.shuffle();
      
      for (final law in shuffledLaws) {
        // Create 1-2 unique question types per law (not all 3)
        final lawQuestions = _createOptimizedQuestionsFromLaw(law, questionId);
        questions.addAll(lawQuestions);
        questionId += lawQuestions.length;
        
        // Limit to ~500 questions total for better performance
        if (questions.length >= 500) {
          break;
        }
      }
      
      print('✅ Generated ${questions.length} optimized questions from ${shuffledLaws.length} laws');
      return questions;
      
    } catch (e, stackTrace) {
      print('❌ Error generating questions from laws: $e');
      print('❌ Stack trace: $stackTrace');
      return [];
    }
  }
  
  static List<GameQuestion> _createOptimizedQuestionsFromLaw(Map<String, dynamic> law, int startId) {
  final questions = <GameQuestion>[];
  final String id = law['id']?.toString() ?? 'unknown';
  final String title = law['title'] ?? 'Unknown Title';
  final String category = law['category'] ?? 'General';
  final String lawName = law['lawName'] ?? 'Unknown Law';
  final String lawCode = law['lawCode'] ?? '';
  final String section = law['section'] ?? '';
  final String plainExplanation = law['plainExplanation'] ?? '';
  
  // Get assigned difficulty
  String difficulty = _determineOptimizedDifficulty(category, title, plainExplanation.length);
  
  // Points based on difficulty
  final points = difficulty == 'beginner' ? 5 : difficulty == 'intermediate' ? 10 : 15;
  
  // Select question types with weighted distribution based on difficulty
  final questionTypes = _selectQuestionTypesForDifficulty(title, plainExplanation, difficulty);
  
  for (var type in questionTypes) {
    switch (type) {
      case 'direct':
        questions.add(_createDirectQuestion(id, title, category, lawName, lawCode, 
          section, plainExplanation, difficulty, points));
        break;
      case 'law_reference':
        questions.add(_createLawReferenceQuestion(id, title, category, lawName, lawCode,
          section, plainExplanation, difficulty, points));
        break;
      case 'scenario':
        if (plainExplanation.length > 60) {
          questions.add(_createScenarioQuestion(id, title, category, lawName, lawCode,
            section, plainExplanation, difficulty, points));
        }
        break;
      case 'true_false':
        questions.add(_createTrueFalseQuestion(id, title, category, lawName, lawCode,
          section, plainExplanation, difficulty, points));
        break;
    }
  }
  
  return questions;
}

static List<String> _selectQuestionTypesForDifficulty(String title, String explanation, String difficulty) {
  final types = <String>[];
  
  // Always include a direct question
  types.add('direct');
  
  // Add more questions based on difficulty
  if (difficulty == 'beginner') {
    // Beginners get simpler questions
    final random = DateTime.now().millisecondsSinceEpoch % 3;
    if (random == 0) types.add('true_false');
  } else if (difficulty == 'intermediate') {
    // Intermediate get mix
    final random = DateTime.now().millisecondsSinceEpoch % 2;
    if (random == 0) {
      types.add('law_reference');
    } else if (explanation.length > 100) {
      types.add('scenario');
    }
  } else { // expert
    // Experts get challenging questions
    final random = DateTime.now().millisecondsSinceEpoch % 3;
    if (random == 0) {
      types.add('scenario');
    } else if (random == 1) {
      types.add('law_reference');
    } else {
      types.add('true_false');
    }
  }
  
  // Limit to max 2 questions
  return types.take(2).toList();
}
  
  static GameQuestion _createDirectQuestion(String id, String title, String category, String lawName, String lawCode, 
      String section, String explanation, String difficulty, int points) {
    
    final questionTexts = [
      'What is the legal position on "$title" in Ghana?',
      'How does Ghanaian law address "$title"?',
      'What does "$title" involve under Ghanaian law?',
      'Which legal principle applies to "$title"?',
    ];
    
    final questionText = questionTexts[DateTime.now().millisecondsSinceEpoch % questionTexts.length];
    
    return GameQuestion(
      id: 'law_${id}_direct',
      question: questionText,
      options: _createVariedOptions(lawName, lawCode, category, true),
      explanation: explanation,
      lawReference: '$lawName $lawCode, $section',
      category: category,
      difficulty: difficulty,
      points: points,
    );
  }
  
  static GameQuestion _createLawReferenceQuestion(String id, String title, String category, String lawName, String lawCode,
      String section, String explanation, String difficulty, int points) {
    
    return GameQuestion(
      id: 'law_${id}_ref',
      question: 'Which law or regulation covers "$title"?',
      options: _createLawOptions(lawName, lawCode),
      explanation: 'This is covered under $lawName $lawCode, $section. $explanation',
      lawReference: '$lawName $lawCode, $section',
      category: category,
      difficulty: difficulty == 'beginner' ? 'intermediate' : difficulty,
      points: points + 2,
    );
  }
  
  static GameQuestion _createScenarioQuestion(String id, String title, String category, String lawName, String lawCode,
      String section, String explanation, String difficulty, int points) {
    
    final scenarios = {
      'Rights & Freedoms': 'If someone experiences $title, what legal recourse do they have?',
      'Employment': 'An employee encounters $title at work. What are their rights?',
      'Housing': 'A tenant faces $title from their landlord. What can they do?',
      'Consumer Rights': 'A consumer experiences $title. How are they protected?',
      'Business': 'A business deals with $title. What legal requirements apply?',
    };
    
    final questionText = scenarios[category] ?? 'How would you handle a situation involving $title under Ghanaian law?';
    
    return GameQuestion(
      id: 'law_${id}_scenario',
      question: questionText,
      options: _createScenarioOptions(lawName, category),
      explanation: '$explanation This is governed by $lawName $lawCode, $section.',
      lawReference: '$lawName $lawCode, $section',
      category: category,
      difficulty: difficulty == 'beginner' ? 'intermediate' : 'expert',
      points: points + 5,
    );
  }
  
  static GameQuestion _createTrueFalseQuestion(String id, String title, String category, String lawName, String lawCode,
      String section, String explanation, String difficulty, int points) {
    
    final statements = [
      '$title is not regulated under any Ghanaian law.',
      'The law provides clear protection against $title.',
      '$title is exclusively a matter for customary law.',
      'There are no legal consequences for $title.',
      '$title is protected under constitutional provisions.',
    ];
    
    final isTrue = explanation.toLowerCase().contains('protected') || 
                   explanation.toLowerCase().contains('right') ||
                   explanation.toLowerCase().contains('must') ||
                   explanation.toLowerCase().contains('cannot');
    
    final statement = statements[DateTime.now().millisecondsSinceEpoch % statements.length];
    
    return GameQuestion(
      id: 'law_${id}_tf',
      question: 'TRUE or FALSE: $statement',
      options: [
        QuestionOption(text: 'TRUE', isCorrect: isTrue),
        QuestionOption(text: 'FALSE', isCorrect: !isTrue),
      ],
      explanation: '$explanation The correct answer is ${isTrue ? 'TRUE' : 'FALSE'} because $lawName $lawCode, $section addresses this.',
      lawReference: '$lawName $lawCode, $section',
      category: category,
      difficulty: difficulty == 'beginner' ? 'intermediate' : 'expert',
      points: points + 3,
    );
  }
  
  static List<QuestionOption> _createVariedOptions(String lawName, String lawCode, String category, bool isCorrect) {
    final options = <QuestionOption>[];
    
    if (isCorrect) {
      options.add(QuestionOption(
        text: 'It is governed by $lawName $lawCode under $category law',
        isCorrect: true,
      ));
    }
    
    // Wrong options
    final wrongOptions = [
      'There is no specific legislation addressing this',
      'It falls under customary law only',
      'It is regulated by international treaties',
      'The law was repealed and is no longer in force',
      'It is covered by a different ministry/agency',
      'Only administrative guidelines apply, not law',
    ];
    
    // Add wrong options
    wrongOptions.shuffle();
    for (int i = 0; i < 3 && i < wrongOptions.length; i++) {
      options.add(QuestionOption(text: wrongOptions[i], isCorrect: false));
    }
    
    // Add the correct option if not already added
    if (!isCorrect) {
      options.add(QuestionOption(
        text: 'It is governed by $lawName $lawCode under $category law',
        isCorrect: true,
      ));
    }
    
    options.shuffle();
    return options;
  }
  
  static List<QuestionOption> _createLawOptions(String correctLawName, String correctLawCode) {
    final correctOption = '$correctLawName $correctLawCode';
    final options = <QuestionOption>[];
    
    // Common Ghanaian laws for wrong options
    final wrongLaws = [
      'Labour Act, 2003 (Act 651)',
      'Companies Act, 2019 (Act 992)',
      '1992 Constitution',
      'Criminal Offences Act, 1960 (Act 29)',
      'Rent Act, 1963 (Act 220)',
      'Children\'s Act, 1998 (Act 560)',
      'Data Protection Act, 2012 (Act 843)',
      'Right to Information Act, 2019 (Act 989)',
      'Consumer Protection Act, 2008 (Act 870)',
      'Environmental Protection Agency Act, 1994 (Act 490)',
      'Electronic Transactions Act, 2008 (Act 772)',
      'National Health Insurance Act, 2012 (Act 852)',
    ];
    
    // Remove correct law if present
    final filteredLaws = wrongLaws.where((law) => law != correctOption).toList();
    
    // Add correct option
    options.add(QuestionOption(text: correctOption, isCorrect: true));
    
    // Add 3 wrong options
    filteredLaws.shuffle();
    for (int i = 0; i < 3 && i < filteredLaws.length; i++) {
      options.add(QuestionOption(text: filteredLaws[i], isCorrect: false));
    }
    
    options.shuffle();
    return options;
  }
  
  static List<QuestionOption> _createScenarioOptions(String lawName, String category) {
    final options = <QuestionOption>[];
    
    // Correct options based on category
    final correctOptions = {
      'Rights & Freedoms': 'Seek legal protection under $lawName',
      'Employment': 'File a complaint with the Labour Commission under $lawName',
      'Housing': 'Apply to the Rent Control Department under $lawName',
      'Consumer Rights': 'Report to the Consumer Protection Commission under $lawName',
      'Business': 'Comply with requirements under $lawName and seek legal advice',
      'Health': 'Report to the relevant health authority under $lawName',
      'Education': 'Follow procedures outlined in $lawName',
    };
    
    final correctText = correctOptions[category] ?? 'Take appropriate action under $lawName';
    options.add(QuestionOption(text: correctText, isCorrect: true));
    
    // Wrong options
    final wrongOptions = [
      'Ignore the issue as there is no legal remedy',
      'Take immediate unilateral action without legal advice',
      'Assume the matter is too minor for legal attention',
      'Wait indefinitely without documentation',
      'Rely solely on informal community resolution',
      'Assume the law does not apply in this case',
      'Take matters into your own hands outside the legal system',
    ];
    
    wrongOptions.shuffle();
    for (int i = 0; i < 3 && i < wrongOptions.length; i++) {
      options.add(QuestionOption(text: wrongOptions[i], isCorrect: false));
    }
    
    options.shuffle();
    return options;
  }
  
  static String _determineOptimizedDifficulty(String category, String title, int explanationLength) {
  // Convert to lowercase for easier matching
  final lowerTitle = title.toLowerCase();
  final lowerCategory = category.toLowerCase();
  
  // BEGINNER: Basic rights, simple concepts, common issues
  final beginnerCategories = ['rights & freedoms', 'consumer rights', 'education', 'family & personal', 'health'];
  final beginnerKeywords = [
    'right to', 'access to', 'free', 'basic', 'simple', 'minimum', 
    'protection', 'against', 'without', 'refusal to', 'allow', 'admit',
    'permit', 'license', 'register', 'issue', 'provide', 'compensation'
  ];
  
  // Check if category is beginner
  if (beginnerCategories.contains(lowerCategory)) {
    // Double-check title doesn't contain expert keywords
    final expertKeywords = ['fraud', 'crime', 'laundering', 'mining', 'customs', 'cyber', 'terrorism'];
    if (!expertKeywords.any((word) => lowerTitle.contains(word))) {
      return 'beginner';
    }
  }
  
  // Check if title contains beginner keywords
  if (beginnerKeywords.any((word) => lowerTitle.contains(word))) {
    return 'beginner';
  }
  
  // EXPERT: Complex, technical, serious crimes
  final expertCategories = ['financial crime', 'customs', 'natural resources', 'technology & communication'];
  final expertKeywords = [
    'money laundering', 'fraud', 'cybercrime', 'terrorism financing', 'drug trafficking',
    'illegal mining', 'galamsey', 'customs fraud', 'import violation', 'export violation',
    'intellectual property infringement', 'patent', 'trademark', 'hacking', 'data breach'
  ];
  
  // Check if category is expert
  if (expertCategories.contains(lowerCategory)) {
    return 'expert';
  }
  
  // Check if title contains expert keywords
  if (expertKeywords.any((word) => lowerTitle.contains(word))) {
    return 'expert';
  }
  
  // Check explanation length (long explanations often more complex)
  if (explanationLength > 400) {
    return 'expert';
  }
  
  // INTERMEDIATE: Employment, business, housing, environment
  final intermediateCategories = ['employment', 'business', 'housing', 'environment', 'property & housing', 'transport'];
  
  if (intermediateCategories.contains(lowerCategory)) {
    return 'intermediate';
  }
  
  // DEFAULT: If nothing matches, use weighted random distribution
  // 40% beginner, 30% intermediate, 30% expert for better balance
  final random = DateTime.now().millisecondsSinceEpoch % 10;
  if (random < 4) return 'beginner';
  if (random < 7) return 'intermediate';
  return 'expert';
}
}