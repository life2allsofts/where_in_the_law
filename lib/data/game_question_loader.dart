// data/game_question_loader.dart - OPTIMIZED VERSION
// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/game_question.dart';
import 'law_question_generator.dart';

class GameQuestionLoader {
  static List<GameQuestion>? _cachedQuestions;
  
  static Future<List<GameQuestion>> loadQuestions({bool forceRegenerate = false}) async {
  if (_cachedQuestions != null && !forceRegenerate) {
    print('📚 Using cached questions (${_cachedQuestions!.length} total)');
    return _cachedQuestions!;
  }
  
  print('📚 Loading and generating optimized questions...');
  
  try {
    final allQuestions = <GameQuestion>[];
    final Map<String, int> difficultyCount = {
      'beginner': 0,
      'intermediate': 0,
      'expert': 0,
    };
    
    // 1. Load from game_questions.json (your curated questions)
    try {
      final String jsonString = await rootBundle.loadString('assets/game_questions.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      
      for (final json in jsonList) {
        final question = GameQuestion(
          id: json['id']?.toString() ?? 'json_${jsonList.indexOf(json)}',
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
        
        allQuestions.add(question);
        difficultyCount[question.difficulty] = (difficultyCount[question.difficulty] ?? 0) + 1;
      }
      
      print('✅ Loaded ${jsonList.length} curated questions from game_questions.json');
      
    } catch (e) {
      print('⚠️ Could not load game_questions.json: $e');
    }
    
    // 2. Generate optimized questions from law_data.json
    try {
      final generatedQuestions = await LawQuestionGenerator.generateQuestionsFromLaws();
      
      // Target distribution: 40% beginner, 30% intermediate, 30% expert
      final totalTarget = 450; // Total questions target
      final beginnerTarget = (totalTarget * 0.4).round(); // ~180
      final intermediateTarget = (totalTarget * 0.3).round(); // ~135
      final expertTarget = (totalTarget * 0.3).round(); // ~135
      
      print('🎯 Target distribution: Beginner: $beginnerTarget, Intermediate: $intermediateTarget, Expert: $expertTarget');
      
      // Separate generated questions by difficulty
      final beginnerQuestions = <GameQuestion>[];
      final intermediateQuestions = <GameQuestion>[];
      final expertQuestions = <GameQuestion>[];
      
      for (final question in generatedQuestions) {
        switch (question.difficulty) {
          case 'beginner':
            beginnerQuestions.add(question);
            break;
          case 'intermediate':
            intermediateQuestions.add(question);
            break;
          case 'expert':
            expertQuestions.add(question);
            break;
        }
      }
      
      // Shuffle each list
      beginnerQuestions.shuffle();
      intermediateQuestions.shuffle();
      expertQuestions.shuffle();
      
      // Add questions up to target counts
      final questionsToAdd = <GameQuestion>[];
      
      // Add beginner questions
      final beginnerNeeded = beginnerTarget - (difficultyCount['beginner'] ?? 0);
      if (beginnerNeeded > 0) {
        final count = beginnerNeeded.clamp(0, beginnerQuestions.length);
        questionsToAdd.addAll(beginnerQuestions.take(count));
        difficultyCount['beginner'] = (difficultyCount['beginner'] ?? 0) + count;
      }
      
      // Add intermediate questions
      final intermediateNeeded = intermediateTarget - (difficultyCount['intermediate'] ?? 0);
      if (intermediateNeeded > 0) {
        final count = intermediateNeeded.clamp(0, intermediateQuestions.length);
        questionsToAdd.addAll(intermediateQuestions.take(count));
        difficultyCount['intermediate'] = (difficultyCount['intermediate'] ?? 0) + count;
      }
      
      // Add expert questions
      final expertNeeded = expertTarget - (difficultyCount['expert'] ?? 0);
      if (expertNeeded > 0) {
        final count = expertNeeded.clamp(0, expertQuestions.length);
        questionsToAdd.addAll(expertQuestions.take(count));
        difficultyCount['expert'] = (difficultyCount['expert'] ?? 0) + count;
      }
      
      // Add the selected questions
      allQuestions.addAll(questionsToAdd);
      
      print('✅ Added ${questionsToAdd.length} generated questions (balanced selection)');
      print('   Beginner added: ${beginnerQuestions.take(beginnerNeeded.clamp(0, beginnerQuestions.length)).length}');
      print('   Intermediate added: ${intermediateQuestions.take(intermediateNeeded.clamp(0, intermediateQuestions.length)).length}');
      print('   Expert added: ${expertQuestions.take(expertNeeded.clamp(0, expertQuestions.length)).length}');
      
    } catch (e, stackTrace) {
      print('⚠️ Could not generate questions from laws: $e');
      print('❌ Stack trace: $stackTrace');
    }
    
    // 3. Ensure we have a minimum number of questions
    if (allQuestions.length < 100) {
      print('⚠️ Too few questions, adding fallback');
      final fallback = _getFallbackQuestions();
      allQuestions.addAll(fallback);
      
      for (final question in fallback) {
        difficultyCount[question.difficulty] = (difficultyCount[question.difficulty] ?? 0) + 1;
      }
    }
    
    // 4. Assign unique IDs and shuffle
    for (int i = 0; i < allQuestions.length; i++) {
      allQuestions[i] = GameQuestion(
        id: 'q_${i + 1}',
        question: allQuestions[i].question,
        options: allQuestions[i].options,
        explanation: allQuestions[i].explanation,
        lawReference: allQuestions[i].lawReference,
        category: allQuestions[i].category,
        difficulty: allQuestions[i].difficulty,
        points: allQuestions[i].points,
      );
    }
    
    // Shuffle all questions
    allQuestions.shuffle();
    
    _cachedQuestions = allQuestions;
    
    // Print final statistics
    print('🎉 Total optimized questions: ${_cachedQuestions!.length}');
    print('📊 Final difficulty distribution:');
    print('   Beginner: ${difficultyCount['beginner'] ?? 0}');
    print('   Intermediate: ${difficultyCount['intermediate'] ?? 0}');
    print('   Expert: ${difficultyCount['expert'] ?? 0}');
    
    return _cachedQuestions!;
    
  } catch (e, stackTrace) {
    print('❌ Error in loadQuestions: $e');
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
  
  static Map<String, int> getDifficultyStats() {
    if (_cachedQuestions == null) return {'beginner': 0, 'intermediate': 0, 'expert': 0};
    
    final stats = {'beginner': 0, 'intermediate': 0, 'expert': 0};
    for (final question in _cachedQuestions!) {
      stats[question.difficulty] = (stats[question.difficulty] ?? 0) + 1;
    }
    return stats;
  }
}