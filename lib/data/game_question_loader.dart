// data/game_question_loader.dart
// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/game_question.dart';

class GameQuestionLoader {
  static List<GameQuestion>? _cachedQuestions;
  
  static Future<List<GameQuestion>> loadQuestions() async {
    // Return cached questions if available
    if (_cachedQuestions != null) {
      print('📚 Using cached questions from JSON');
      return _cachedQuestions!;
    }
    
    print('📚 Loading questions from game_questions.json...');
    
    try {
      // Load from JSON file
      final String jsonString = await rootBundle.loadString('assets/game_questions.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      
      // Parse JSON into GameQuestion objects
      _cachedQuestions = jsonList.map((json) {
        return GameQuestion(
          id: json['id']?.toString() ?? 'unknown_${jsonList.indexOf(json)}',
          question: json['question']?.toString() ?? 'No question text',
          options: (json['options'] as List?)?.map((opt) {
            return QuestionOption(
              text: opt['text']?.toString() ?? 'No option text',
              isCorrect: opt['isCorrect'] ?? false,
            );
          }).toList() ?? [QuestionOption(text: 'No options', isCorrect: true)],
          explanation: json['explanation']?.toString() ?? 'No explanation available',
          lawReference: json['lawReference']?.toString() ?? 'No law reference',
          category: json['category']?.toString() ?? 'General',
          difficulty: json['difficulty']?.toString() ?? 'beginner',
          points: (json['points'] as num?)?.toInt() ?? 10,
        );
      }).toList();
      
      print('✅ Successfully loaded ${_cachedQuestions!.length} questions from JSON');
      return _cachedQuestions!;
      
    } catch (e, stackTrace) {
      print('❌ Error loading questions from JSON: $e');
      print('❌ Stack trace: $stackTrace');
      
      // Return fallback questions
      return _getFallbackQuestions();
    }
  }
  
  static List<GameQuestion> _getFallbackQuestions() {
    print('⚠️ Using fallback questions');
    
    return [
      GameQuestion(
        id: 'fallback_1',
        question: 'What is the minimum voting age in Ghana?',
        options: [
          QuestionOption(text: '16 years', isCorrect: false),
          QuestionOption(text: '18 years', isCorrect: true),
          QuestionOption(text: '21 years', isCorrect: false),
          QuestionOption(text: '25 years', isCorrect: false),
        ],
        explanation: 'Article 42 of the 1992 Constitution states that every citizen of Ghana of eighteen years or above has the right to vote.',
        lawReference: '1992 Constitution, Article 42',
        category: 'Rights & Freedoms',
        difficulty: 'beginner',
        points: 5,
      ),
      GameQuestion(
        id: 'fallback_2',
        question: 'Which law establishes the Right to Information in Ghana?',
        options: [
          QuestionOption(text: 'Right to Information Act, 2019 (Act 989)', isCorrect: true),
          QuestionOption(text: 'Data Protection Act, 2012 (Act 843)', isCorrect: false),
          QuestionOption(text: 'Whistleblower Act, 2006 (Act 720)', isCorrect: false),
          QuestionOption(text: 'Electronic Transactions Act, 2008 (Act 772)', isCorrect: false),
        ],
        explanation: 'The Right to Information Act, 2019 (Act 989) gives citizens the right to access information held by public institutions.',
        lawReference: 'Right to Information Act, 2019 (Act 989)',
        category: 'Rights & Freedoms',
        difficulty: 'intermediate',
        points: 10,
      ),
    ];
  }
  
  static void clearCache() {
    _cachedQuestions = null;
    print('🗑️ Cleared question loader cache');
  }
  
  static bool get isLoaded => _cachedQuestions != null;
  static int get questionCount => _cachedQuestions?.length ?? 0;
}