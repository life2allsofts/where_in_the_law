// data/game_questions.dart
import 'dart:math';

import '../models/game_question.dart';

class GameQuestions {
  static final List<GameQuestion> allQuestions = [
    GameQuestion(
      id: '1',
      question: 'According to the 1992 Constitution, what is the minimum voting age in Ghana?',
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
    ),
    GameQuestion(
      id: '2',
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
    ),
    GameQuestion(
      id: '3',
      question: 'What is the maximum duration for maternity leave under Ghanaian law?',
      options: [
        QuestionOption(text: '12 weeks', isCorrect: false),
        QuestionOption(text: '14 weeks', isCorrect: false),
        QuestionOption(text: '3 months', isCorrect: true),
        QuestionOption(text: '6 months', isCorrect: false),
      ],
      explanation: 'Section 57(1) of the Labour Act, 2003 (Act 651) provides for 12 weeks of maternity leave, but collective agreements may extend this to 3 months.',
      lawReference: 'Labour Act, 2003 (Act 651), Section 57(1)',
      category: 'Employment',
      difficulty: 'intermediate',
    ),
    GameQuestion(
      id: '4',
      question: 'TRUE or FALSE: A landlord can evict a tenant without a court order in Ghana.',
      options: [
        QuestionOption(text: 'TRUE', isCorrect: false),
        QuestionOption(text: 'FALSE', isCorrect: true),
      ],
      explanation: 'Under the Rent Act, 1963 (Act 220), a landlord must obtain a court order for eviction. Self-help evictions are illegal.',
      lawReference: 'Rent Act, 1963 (Act 220)',
      category: 'Housing',
      difficulty: 'expert',
    ),
    // Add more questions based on your existing law data
  ];

  static List<GameQuestion> getQuestionsByDifficulty(String difficulty, [int limit = 10]) {
    final filtered = allQuestions.where((q) => q.difficulty == difficulty).toList();
    filtered.shuffle();
    return filtered.take(limit).toList();
  }

  static List<GameQuestion> getQuestionsByCategory(String category, [int limit = 10]) {
    final filtered = allQuestions.where((q) => q.category == category).toList();
    filtered.shuffle();
    return filtered.take(limit).toList();
  }

  static List<GameQuestion> getDailyChallenge([DateTime? date]) {
    // Use date as seed for consistent daily challenge
    final today = date ?? DateTime.now();
    final seed = today.day + today.month * 100;
    final random = Random(seed);
    
    final questions = List<GameQuestion>.from(allQuestions);
    questions.shuffle(random);
    
    return questions.take(5).toList(); // 5 questions daily
  }
}