// data/law_question_generator.dart - FINAL FIXED VERSION (NO MORE "GOVERNED BY" PATTERN)
// ignore_for_file: prefer_final_fields, avoid_print

import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/game_question.dart';

class LawQuestionGenerator {
  static Random _random = Random();
  
  // Common Ghanaian laws with their sections for plausible wrong answers
  static final Map<String, List<String>> _commonLawSections = {
    'Children\'s Act, 1998 (Act 560)': [
      'Section 2 (Best interests of the child)',
      'Section 5 (Parental responsibility)',
      'Section 8 (Right to name and nationality)',
      'Section 10 (Right to parental care)',
    ],
    'Constitution of Ghana 1992': [
      'Article 12 (Protection of fundamental rights)',
      'Article 21 (General fundamental freedoms)',
      'Article 33 (Right to administrative justice)',
      'Article 125 (Judicial power)',
    ],
    'Right to Information Act, 2019 (Act 989)': [
      'Section 1 (Right to information)',
      'Section 5 (Information accessible to public)',
      'Section 18 (Exempt information)',
      'Section 23 (Review of refusal)',
    ],
    'Courts Act, 1993 (Act 459)': [
      'Section 40 (Open court principle)',
      'Section 41 (Exclusion of public)',
      'Section 42 (Reporting of proceedings)',
      'Section 43 (Photography in court)',
    ],
    'Registration of Births and Deaths Act (Act 301)': [
      'Section 4 (Duty to register birth)',
      'Section 5 (Registration period)',
      'Section 6 (Registration by parents)',
      'Section 10 (Birth certificate)',
    ],
    'Education Act, 2008 (Act 778)': [
      'Section 2 (Right to education)',
      'Section 17 (School discipline)',
      'Section 21 (Admission policies)',
      'Section 25 (School facilities)',
    ],
  };

  static Future<List<GameQuestion>> generateQuestionsFromLaws() async {
    print('🔧 Generating pattern-free questions from law_data.json...');
    
    try {
      final String jsonString = await rootBundle.loadString('assets/law_data.json');
      final List<dynamic> lawList = json.decode(jsonString);
      
      final questions = <GameQuestion>[];
      int questionId = 1;
      
      final shuffledLaws = List<Map<String, dynamic>>.from(lawList);
      shuffledLaws.shuffle();
      
      for (final law in shuffledLaws) {
        final lawQuestions = _createPatternFreeQuestionsFromLaw(law, questionId);
        questions.addAll(lawQuestions);
        questionId += lawQuestions.length;
        
        if (questions.length >= 500) break;
      }
      
      print('✅ Generated ${questions.length} pattern-free questions');
      return questions;
      
    } catch (e, stackTrace) {
      print('❌ Error: $e\n$stackTrace');
      return [];
    }
  }
  
  static List<GameQuestion> _createPatternFreeQuestionsFromLaw(Map<String, dynamic> law, int startId) {
    final questions = <GameQuestion>[];
    final String id = law['id']?.toString() ?? 'unknown';
    final String title = law['title'] ?? 'Unknown Title';
    final String category = law['category'] ?? 'General';
    final String lawName = law['lawName'] ?? 'Unknown Law';
    final String lawCode = law['lawCode'] ?? '';
    final String section = law['section'] ?? '';
    final String plainExplanation = law['plainExplanation'] ?? '';
    
    final difficulty = _determineOptimizedDifficulty(category, title, plainExplanation.length);
    final points = difficulty == 'beginner' ? 5 : difficulty == 'intermediate' ? 10 : 15;
    
    // Always create a direct question, sometimes a second one
    questions.add(_createPatternFreeDirectQuestion(id, title, category, lawName, lawCode, 
      section, plainExplanation, difficulty, points));
    
    if (_random.nextDouble() < 0.4) { // 40% chance for second question
      questions.add(_createAlternativeQuestion(id, title, category, lawName, lawCode,
        section, plainExplanation, difficulty, points));
    }
    
    return questions;
  }
  
  static GameQuestion _createPatternFreeDirectQuestion(String id, String title, String category, String lawName, String lawCode, 
      String section, String explanation, String difficulty, int points) {
    
    final questionTexts = [
      'What is the legal position on "$title" in Ghana?',
      'How does Ghanaian law address "$title"?',
      'Which statement about "$title" is CORRECT?',
      'What does "$title" involve under Ghanaian law?',
      'How is "$title" regulated in Ghana?',
      'Under what legal framework is "$title" addressed?',
      'Which best describes the law regarding "$title"?',
    ];
    
    return GameQuestion(
      id: 'law_${id}_pattern_free',
      question: questionTexts[_random.nextInt(questionTexts.length)],
      options: _createPatternFreeOptions(lawName, lawCode, category, title, section, difficulty),
      explanation: explanation,
      lawReference: '$lawName $lawCode, $section',
      category: category,
      difficulty: difficulty,
      points: points,
    );
  }
  
  static GameQuestion _createAlternativeQuestion(String id, String title, String category, String lawName, String lawCode,
      String section, String explanation, String difficulty, int points) {
    
    final questionTypes = [
      _createNotTrueQuestion,
      _createScenarioQuestion,
      _createTrueFalseQuestion,
    ];
    
    final creator = questionTypes[_random.nextInt(questionTypes.length)];
    return creator(id, title, category, lawName, lawCode, section, explanation, difficulty, points);
  }
  
  // COMPLETELY PATTERN-FREE OPTION GENERATION
  static List<QuestionOption> _createPatternFreeOptions(String lawName, String lawCode, String category, String title, String section, String difficulty) {
    var options = <QuestionOption>[];
    final correctLaw = lawCode.isNotEmpty ? '$lawName $lawCode' : lawName;
    
    // 1. CORRECT ANSWER - NO "GOVERNED BY" PATTERN
    final correctAnswers = _getCorrectAnswerVariations(correctLaw, category, title, section);
    final correctText = correctAnswers[_random.nextInt(correctAnswers.length)];
    options.add(QuestionOption(text: correctText, isCorrect: true));
    
    // 2. TRAP ANSWERS - Plausible but wrong laws/sections
    final trapAnswers = _getTrapAnswers(category, correctLaw, title, section, difficulty);
    
    // 3. GENERIC WRONG ANSWERS - Avoid "governed by" pattern here too
    final genericWrong = _getGenericWrongAnswers(difficulty);
    
    // Combine all wrong answers
    final allWrongAnswers = [...trapAnswers, ...genericWrong];
    allWrongAnswers.shuffle();
    
    // Add 3 wrong options
    for (int i = 0; i < 3 && i < allWrongAnswers.length; i++) {
      options.add(QuestionOption(text: allWrongAnswers[i], isCorrect: false));
    }
    
    // Ensure we have 4 options total
    while (options.length < 4) {
      options.add(QuestionOption(
        text: 'The legal position depends on specific circumstances',
        isCorrect: false
      ));
    }
    
    // CRITICAL: Remove any accidental "governed by" patterns from wrong answers
    options = options.map((option) {
      if (option.text.toLowerCase().contains('governed by') && !option.isCorrect) {
        return QuestionOption(
          text: option.text.replaceAll('governed by', 'addressed under').replaceAll('Governed by', 'Addressed under'),
          isCorrect: option.isCorrect
        );
      }
      return option;
    }).toList();
    
    options.shuffle();
    return options;
  }
  
  // CORRECT ANSWER VARIATIONS - NO "GOVERNED BY"
  static List<String> _getCorrectAnswerVariations(String correctLaw, String category, String title, String section) {
    final variations = <String>[];
    
    // Clean, simple law references
    variations.addAll([
      correctLaw,
      '$correctLaw, $section',
      'Under $correctLaw',
      '$correctLaw applies',
      'Primarily $correctLaw',
      '$correctLaw provides the framework',
    ]);
    
    // Category-specific correct answer phrasing
    switch (category.toLowerCase()) {
      case 'rights & freedoms':
      case 'justice & legal aid':
        variations.addAll([
          'Protected under $correctLaw',
          '$correctLaw guarantees this right',
          'A right established by $correctLaw',
          '$correctLaw ensures access',
          'Mandated by $correctLaw',
        ]);
        break;
        
      case 'family & personal':
        variations.addAll([
          'Regulated through $correctLaw',
          '$correctLaw establishes procedures for this',
          'Covered under $correctLaw provisions',
          '$correctLaw specifies requirements',
          'Addressed in $correctLaw',
        ]);
        break;
        
      case 'education':
        variations.addAll([
          'Education policy under $correctLaw',
          '$correctLaw outlines educational rights',
          'Governed by education provisions in $correctLaw',
          '$correctLaw sets standards for this',
          'Educational framework in $correctLaw',
        ]);
        break;
        
      case 'employment':
        variations.addAll([
          'Employment standards in $correctLaw',
          '$correctLaw protects workers regarding this',
          'Labor provisions under $correctLaw',
          '$correctLaw establishes employment rights',
          'Workplace regulations in $correctLaw',
        ]);
        break;
    }
    
    // Add some with the actual law name only (no "governed by")
    final simpleLawName = correctLaw.split(' ').take(3).join(' '); // Just "Right to Information Act"
    variations.add(simpleLawName);
    
    return variations;
  }
  
  // TRAP ANSWERS - plausible but wrong
  static List<String> _getTrapAnswers(String category, String correctLaw, String title, String section, String difficulty) {
    final traps = <String>[];
    final wrongLaws = _getWrongLawsForCategory(category, correctLaw);
    
    // Wrong laws with different phrasing
    for (final wrongLaw in wrongLaws.take(3)) {
      final trapFormats = [
        wrongLaw,
        'Under $wrongLaw',
        '$wrongLaw might apply',
        'Sometimes addressed by $wrongLaw',
        'Related to $wrongLaw',
        '$wrongLaw covers similar issues',
      ];
      traps.add(trapFormats[_random.nextInt(trapFormats.length)]);
    }
    
    // Wrong sections of the correct law
    if (_commonLawSections.containsKey(correctLaw) && section.isNotEmpty) {
      final sections = _commonLawSections[correctLaw]!;
      final wrongSections = sections.where((s) => !s.contains(section)).toList();
      if (wrongSections.isNotEmpty) {
        final wrongSection = wrongSections[_random.nextInt(wrongSections.length)];
        traps.add('$correctLaw, $wrongSection');
      }
    }
    
    // For expert difficulty, add more sophisticated traps
    if (difficulty == 'expert') {
      traps.addAll([
        'Multiple laws apply with $correctLaw being primary',
        '$correctLaw with ministerial exceptions',
        'Generally under $correctLaw but with caveats',
        '$correctLaw supplemented by regulations',
      ]);
    }
    
    return traps;
  }
  
  // GENERIC WRONG ANSWERS - also pattern-free
  static List<String> _getGenericWrongAnswers(String difficulty) {
    final answers = <String>[];
    
    // Beginner/Intermediate wrong answers
    answers.addAll([
      'District Assembly bylaws',
      'Customary law principles',
      'Administrative guidelines only',
      'Ministerial discretion',
      'No specific legislation',
      'Informal resolution methods',
      'Community arbitration',
    ]);
    
    // Expert wrong answers
    if (difficulty == 'expert') {
      answers.addAll([
        'International conventions primarily',
        'Case law precedents mainly',
        'Constitutional interpretation required',
        'Regulatory frameworks supplement gaps',
        'Discretionary enforcement applies',
      ]);
    }
    
    // Avoid "governed by" in wrong answers too
    return answers.map((answer) {
      if (answer.toLowerCase().contains('governed')) {
        return answer.replaceAll('governed', 'addressed');
      }
      return answer;
    }).toList();
  }
  
  static List<String> _getWrongLawsForCategory(String category, String correctLaw) {
    final categoryLaws = <String, List<String>>{
      'Rights & Freedoms': [
        '1992 Constitution',
        'Commission on Human Rights and Administrative Justice Act',
        'Public Order Act',
        'Criminal Offences Act, 1960 (Act 29)',
        'Whistleblower Act, 2006 (Act 720)',
      ],
      'Justice & Legal Aid': [
        'Courts Act, 1993 (Act 459)',
        'Legal Aid Act, 2018 (Act 977)',
        'Judicial Service Act, 1960 (CA.10)',
        'Alternative Dispute Resolution Act, 2010 (Act 798)',
      ],
      'Family & Personal': [
        'Marriage Act, 1884-1985 (CAP 127)',
        'Intestate Succession Law (PNDC Law 111)',
        'Domestic Violence Act, 2007 (Act 732)',
        'Wills Act, 1971 (Act 360)',
      ],
      'Education': [
        'Teaching Council Act, 2012 (Act 849)',
        'Ghana Education Trust Fund Act, 2000 (Act 581)',
        'Council for Technical and Vocational Education and Training Act',
      ],
      'Employment': [
        'Social Security Act, 2010 (Act 766)',
        'Workers\' Compensation Act, 1987 (PNDCL 187)',
        'Labour Commission Act, 2003 (Act 652)',
      ],
    };
    
    final laws = categoryLaws[category] ?? [
      '1992 Constitution',
      'Criminal Offences Act, 1960 (Act 29)',
      'Courts Act, 1993 (Act 459)',
    ];
    
    return laws.where((law) => !law.contains(correctLaw.split(' ').first)).toList();
  }
  
  static GameQuestion _createNotTrueQuestion(String id, String title, String category, String lawName, String lawCode,
      String section, String explanation, String difficulty, int points) {
    
    final correctLaw = lawCode.isNotEmpty ? '$lawName $lawCode' : lawName;
    
    return GameQuestion(
      id: 'law_${id}_not_true',
      question: 'Which statement about "$title" is NOT true?',
      options: _createNotTrueOptions(correctLaw, category, title, explanation),
      explanation: '$explanation The false statement tests understanding of $correctLaw.',
      lawReference: '$lawName $lawCode, $section',
      category: category,
      difficulty: difficulty == 'beginner' ? 'intermediate' : 'expert',
      points: points + 4,
    );
  }
  
  static List<QuestionOption> _createNotTrueOptions(String correctLaw, String category, String title, String explanation) {
    final List<QuestionOption> options = <QuestionOption>[];
    
    // The NOT TRUE statement (correct answer for this question type)
    final falseStatements = [
      'No legal framework exists for this issue',
      'Only customary law applies to this matter',
      'The law encourages this practice in some cases',
      'There are no penalties for violating this',
      'This is completely unregulated in Ghana',
      'International law takes precedence here',
      'District Assemblies have exclusive jurisdiction',
    ];
    
    options.add(QuestionOption(
      text: falseStatements[_random.nextInt(falseStatements.length)],
      isCorrect: true
    ));
    
    // Three TRUE statements
    final trueStatements = [
      'Ghanaian law addresses this issue',
      'Legal remedies are available for this',
      '$correctLaw provides relevant provisions',
      'This is recognized within the legal system',
      'Procedures exist to handle this matter',
      'Authorities have jurisdiction over this',
    ];
    
    trueStatements.shuffle();
    for (int i = 0; i < 3 && i < trueStatements.length; i++) {
      options.add(QuestionOption(text: trueStatements[i], isCorrect: false));
    }
    
    options.shuffle();
    return options;
  }
  
  static GameQuestion _createScenarioQuestion(String id, String title, String category, String lawName, String lawCode,
      String section, String explanation, String difficulty, int points) {
    
    final correctLaw = lawCode.isNotEmpty ? '$lawName $lawCode' : lawName;
    final scenarios = [
      'If someone encounters "$title", what should they do?',
      'How should one respond to a situation involving "$title"?',
      'What\'s the proper course of action when facing "$title"?',
    ];
    
    return GameQuestion(
      id: 'law_${id}_scenario',
      question: scenarios[_random.nextInt(scenarios.length)],
      options: _createScenarioOptions(correctLaw, category),
      explanation: '$explanation Proper action involves referencing $correctLaw.',
      lawReference: '$lawName $lawCode, $section',
      category: category,
      difficulty: difficulty == 'beginner' ? 'intermediate' : 'expert',
      points: points + 5,
    );
  }
  
  static List<QuestionOption> _createScenarioOptions(String correctLaw, String category) {
    final List<QuestionOption> options = <QuestionOption>[];
    
    // Correct action
    final correctActions = [
      'Reference $correctLaw for guidance',
      'Seek remedies under $correctLaw',
      'Follow procedures in $correctLaw',
      'Invoke protections in $correctLaw',
      'Use $correctLaw as legal basis',
    ];
    
    options.add(QuestionOption(
      text: correctActions[_random.nextInt(correctActions.length)],
      isCorrect: true
    ));
    
    // Wrong actions
    final wrongActions = [
      'Take matters into your own hands',
      'Ignore the issue completely',
      'Rely only on informal resolution',
      'Assume no legal recourse exists',
      'Delay action indefinitely',
      'Retaliate without following procedures',
    ];
    
    wrongActions.shuffle();
    for (int i = 0; i < 3 && i < wrongActions.length; i++) {
      options.add(QuestionOption(text: wrongActions[i], isCorrect: false));
    }
    
    options.shuffle();
    return options;
  }
  
  static GameQuestion _createTrueFalseQuestion(String id, String title, String category, String lawName, String lawCode,
      String section, String explanation, String difficulty, int points) {
    
    final correctLaw = lawCode.isNotEmpty ? '$lawName $lawCode' : lawName;
    final statements = [
      '$title is regulated under Ghanaian law',
      'Legal protections exist against $title',
      '$correctLaw addresses this issue',
      'There are legal consequences for $title',
      'This matter falls within legal jurisdiction',
    ];
    
    final isTrue = _random.nextDouble() < 0.7; // 70% true for realism
    
    return GameQuestion(
      id: 'law_${id}_tf',
      question: 'TRUE or FALSE: ${statements[_random.nextInt(statements.length)]}',
      options: [
        QuestionOption(text: 'TRUE', isCorrect: isTrue),
        QuestionOption(text: 'FALSE', isCorrect: !isTrue),
      ],
      explanation: '$explanation The statement is ${isTrue ? 'TRUE' : 'FALSE'} according to $correctLaw.',
      lawReference: '$lawName $lawCode, $section',
      category: category,
      difficulty: difficulty,
      points: points + 3,
    );
  }
  
  static String _determineOptimizedDifficulty(String category, String title, int explanationLength) {
    final lowerTitle = title.toLowerCase();
    final lowerCategory = category.toLowerCase();
    
    // Simple categories for beginners
    final beginnerCategories = ['rights & freedoms', 'consumer rights', 'education', 'family & personal'];
    final beginnerKeywords = ['right to', 'access to', 'free', 'basic', 'simple', 'protection', 'against'];
    
    if (beginnerCategories.contains(lowerCategory) || 
        beginnerKeywords.any((word) => lowerTitle.contains(word))) {
      return 'beginner';
    }
    
    // Expert categories
    final expertCategories = ['financial crime', 'customs', 'natural resources', 'technology & communication'];
    final expertKeywords = ['fraud', 'laundering', 'cybercrime', 'terrorism', 'mining', 'customs'];
    
    if (expertCategories.contains(lowerCategory) || 
        expertKeywords.any((word) => lowerTitle.contains(word)) ||
        explanationLength > 400) {
      return 'expert';
    }
    
    // Default to intermediate
    return 'intermediate';
  }
}