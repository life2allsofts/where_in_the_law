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
