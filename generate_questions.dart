// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';
import 'dart:io';

void main() async {
  print('🚀 Generating questions from law_data.json...');
  
  try {
    // Read law_data.json
    final lawFile = File('assets/law_data.json');
    final lawString = await lawFile.readAsString();
    final lawList = json.decode(lawString) as List;
    
    final questions = [];
    int questionId = 1;
    
    for (final law in lawList) {
      final String id = law['id']?.toString() ?? 'unknown';
      final String title = law['title'] ?? 'Unknown Title';
      final String category = law['category'] ?? 'General';
      final String lawName = law['lawName'] ?? 'Unknown Law';
      final String lawCode = law['lawCode'] ?? '';
      final String section = law['section'] ?? '';
      final String plainExplanation = law['plainExplanation'] ?? '';
      final String legalText = law['legalText'] ?? '';
      
      // Determine difficulty
      String difficulty;
      if (category.contains('Rights') || category.contains('Consumer')) {
        difficulty = 'beginner';
      } else if (category.contains('Employment') || category.contains('Business')) {
        difficulty = 'intermediate';
      } else {
        difficulty = 'expert';
      }
      
      // Determine points
      int points;
      switch (difficulty) {
        case 'beginner': points = 5; break;
        case 'intermediate': points = 10; break;
        case 'expert': points = 15; break;
        default: points = 10;
      }
      
      // Create question 1: Multiple Choice
      questions.add({
        'id': '${questionId++}',
        'question': 'What does "$title" involve in Ghanaian law?',
        'options': [
          {'text': 'It is governed by $lawName $lawCode', 'isCorrect': true},
          {'text': 'There is no specific law addressing this', 'isCorrect': false},
          {'text': 'It is only covered by customary law', 'isCorrect': false},
          {'text': 'It falls under international law only', 'isCorrect': false},
        ],
        'explanation': plainExplanation,
        'lawReference': '$lawName $lawCode, $section',
        'category': category,
        'difficulty': difficulty,
        'points': points,
      });
      
      // Create question 2: Law Reference
      questions.add({
        'id': '${questionId++}',
        'question': 'Which law covers "$title"?',
        'options': [
          {'text': '$lawName $lawCode', 'isCorrect': true},
          {'text': 'Labour Act, 2003 (Act 651)', 'isCorrect': false},
          {'text': '1992 Constitution', 'isCorrect': false},
          {'text': 'Companies Act, 2019 (Act 992)', 'isCorrect': false},
        ],
        'explanation': 'This matter is covered under $lawName $lawCode, $section. $plainExplanation',
        'lawReference': '$lawName $lawCode, $section',
        'category': category,
        'difficulty': difficulty == 'beginner' ? 'intermediate' : difficulty,
        'points': points + 5,
      });
      
      // Create question 3: True/False
      questions.add({
        'id': '${questionId++}',
        'question': 'TRUE or FALSE: $title is clearly regulated under Ghanaian law.',
        'options': [
          {'text': 'TRUE', 'isCorrect': true},
          {'text': 'FALSE', 'isCorrect': false},
        ],
        'explanation': plainExplanation,
        'lawReference': '$lawName $lawCode, $section',
        'category': category,
        'difficulty': difficulty == 'beginner' ? 'intermediate' : 'expert',
        'points': points + 10,
      });
    }
    
    // Write to game_questions.json
    final questionFile = File('assets/game_questions_generated.json');
    await questionFile.writeAsString(const JsonEncoder.withIndent('  ').convert(questions));
    
    print('✅ Generated ${questions.length} questions');
    print('📁 Saved to: assets/game_questions_generated.json');
    
    // Statistics
    final beginnerCount = questions.where((q) => q['difficulty'] == 'beginner').length;
    final intermediateCount = questions.where((q) => q['difficulty'] == 'intermediate').length;
    final expertCount = questions.where((q) => q['difficulty'] == 'expert').length;
    
    print('\n📊 Statistics:');
    print('   Beginner: $beginnerCount');
    print('   Intermediate: $intermediateCount');
    print('   Expert: $expertCount');
    print('   Total: ${questions.length}');
    
  } catch (e, stackTrace) {
    print('❌ Error: $e');
    print('❌ Stack trace: $stackTrace');
  }
}
