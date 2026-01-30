// screens/quiz_screen.dart
// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/game_question.dart';
import '../services/game_service.dart';
import '../services/ad_service.dart';
import 'quiz_result_screen.dart';
import '../data/game_questions.dart';

class QuizScreen extends StatefulWidget {
  final String difficulty;
  final bool isDailyChallenge;

  const QuizScreen({
    super.key,
    required this.difficulty,
    required this.isDailyChallenge,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  List<GameQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  late AnimationController _timerController;
  int _timeLeft = 30;
  bool _usedHint = false;
  List<bool> _hintsUsed = [];

  @override
  void initState() {
    super.initState();

    // Initialize timer
    _timerController =
        AnimationController(
          vsync: this,
          duration: Duration(seconds: _timeLeft),
        )..addListener(() {
          setState(() {
            // FIX: Convert to int properly
            _timeLeft =
                (_timerController.duration!.inSeconds -
                        (_timerController.value *
                            _timerController.duration!.inSeconds))
                    .toInt();
          });
        });

    // Load questions asynchronously
    _loadQuestions();
  }

 Future<void> _loadQuestions() async {
  try {
    print('🎮 Loading questions for ${widget.difficulty} mode...');

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    List<GameQuestion> questions;

    if (widget.isDailyChallenge) {
      // Use await since getDailyChallenge is now async
      questions = await GameQuestions.getDailyChallenge();
    } else {
      // Use await since getQuestionsByDifficulty is now async
      questions = await GameQuestions.getQuestionsByDifficulty(widget.difficulty, 10);
    }

    if (questions.isEmpty) {
      throw Exception('No questions available for ${widget.difficulty}');
    }

    setState(() {
      _questions = questions;
      _isLoading = false;
      // Initialize hints array
      _hintsUsed = List<bool>.filled(_questions.length, false);
    });

    print('✅ Loaded ${_questions.length} questions');

    // Start timer after questions are loaded
    if (mounted) {
      _timerController.forward().whenComplete(() {
        if (!_isAnswered && mounted) {
          _handleTimeOut();
        }
      });
    }
  } catch (e) {
    print('❌ Error loading questions: $e');

    // Fallback to sample questions - also need await here
    try {
      final fallbackQuestions = await GameQuestions.getQuestionsByDifficulty(
        widget.difficulty,
        10,
      );

      setState(() {
        _questions = fallbackQuestions; // No need for .cast() anymore
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Using fallback questions: ${e.toString()}';
        // Initialize hints array
        _hintsUsed = List<bool>.filled(_questions.length, false);
      });

      // Start timer with fallback questions
      if (mounted) {
        _timerController.forward().whenComplete(() {
          if (!_isAnswered && mounted) {
            _handleTimeOut();
          }
        });
      }
    } catch (fallbackError) {
      print('❌ Even fallback failed: $fallbackError');
      
      // Ultimate fallback - create empty questions
      setState(() {
        _questions = [];
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Unable to load questions. Please check your connection and try again.';
      });
    }
  }
}

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  void _handleTimeOut() {
    if (!mounted) return;

    setState(() {
      _isAnswered = true;
    });

    // REMOVED automatic navigation - user must click Next
  }

  void _handleAnswer(bool isCorrect) {
    if (!mounted) return;

    setState(() {
      _isAnswered = true;
      if (isCorrect) {
        // Bonus points for quick answers
        int timeBonus = (_timeLeft ~/ 5) * 2;
        _score += _questions[_currentQuestionIndex].points + timeBonus;
      }
    });

    _timerController.stop();

    // REMOVED automatic navigation - user must click Next
  }

  void _useHint() async {
    if (_hintsUsed[_currentQuestionIndex]) {
      return;
    }

    final userProfile = await GameService.getUserProfile();
    if (userProfile.cediCoins >= 50) {
      userProfile.cediCoins -= 50;
      await GameService.saveUserProfile(userProfile);

      if (mounted) {
        setState(() {
          _usedHint = true;
          _hintsUsed[_currentQuestionIndex] = true;
        });
      }

      _showSnackBar('Hint used! 50 Cedi Coins deducted.');
    } else {
      // Show rewarded ad for free hint
      AdService.showRewardedAd(
        screenName: 'QuizScreen',
        action: 'free_hint',
        onReward: () {
          if (mounted) {
            setState(() {
              _usedHint = true;
              _hintsUsed[_currentQuestionIndex] = true;
            });
          }
        },
        rewardType: '',
      );
    }
  }

  void _nextQuestion() {
    if (!mounted) return;

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _isAnswered = false;
        _usedHint = false;
        _timeLeft = 30;
        _timerController.reset();
        _timerController.duration = Duration(seconds: _timeLeft);
        _timerController.forward();
      });
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    if (!mounted) return;

    // Update user profile
    final userProfile = await GameService.getUserProfile();
    userProfile.totalGamesPlayed++;
    userProfile.correctAnswers += _score ~/ 10; // 10 points per correct answer

    // Add experience
    int xpEarned =
        _score *
        (widget.difficulty == 'beginner'
            ? 1
            : widget.difficulty == 'intermediate'
            ? 2
            : 3);
    if (widget.isDailyChallenge) xpEarned *= 2;

    userProfile.experience += xpEarned;

    // Check level up
    while (userProfile.experience >= (userProfile.level * 100).toDouble()) {
      userProfile.experience -= ((userProfile.level * 100).toDouble()).toInt();
      userProfile.level++;
    }

    // Add coins
    int coinsEarned = _score * 2;
    if (widget.isDailyChallenge) {
      coinsEarned *= 3;
      await GameService.updateStreak();
      userProfile.streakDays = await GameService.getCurrentStreak();
    }

    userProfile.cediCoins += coinsEarned;

    // Update category scores
    for (var question in _questions) {
      final currentScore = userProfile.categoryScores[question.category] ?? 0;
      userProfile.categoryScores[question.category] =
          currentScore +
          (_questions.indexOf(question) <= _currentQuestionIndex &&
                  _score > (_questions.indexOf(question) * 10)
              ? 10
              : 0);
    }

    await GameService.saveUserProfile(userProfile);

    // Show interstitial ad
    AdService.showInterstitialAd(
      screenName: 'QuizScreen',
      action: 'quiz_completed',
    );

    // Navigate to results
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultScreen(
            score: _score,
            totalQuestions: _questions.length,
            difficulty: widget.difficulty,
            isDailyChallenge: widget.isDailyChallenge,
            coinsEarned: coinsEarned,
            xpEarned: xpEarned,
          ),
        ),
      );
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _retryLoading() {
    _loadQuestions();
  }

  Color _getOptionColor(
    int optionIndex,
    bool isCorrect,
    dynamic currentQuestion,
  ) {
    if (!_isAnswered) return Colors.white;

    if (isCorrect) {
      return Colors.green.shade100;
    } else if (currentQuestion.options[optionIndex].isCorrect) {
      return Colors.green.shade100;
    } else {
      return Colors.red.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isDailyChallenge
                ? 'Daily Challenge'
                : '${widget.difficulty.toUpperCase()} Mode',
          ),
          backgroundColor: const Color(0xFF3498DB),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF5F7FA), Color(0xFFC3CFE2)],
            ),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Loading questions...', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      );
    }

    if (_hasError || _questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isDailyChallenge
                ? 'Daily Challenge'
                : '${widget.difficulty.toUpperCase()} Mode',
          ),
          backgroundColor: const Color(0xFF3498DB),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF5F7FA), Color(0xFFC3CFE2)],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    _hasError
                        ? 'Error loading questions'
                        : 'No questions available',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _errorMessage.isNotEmpty
                        ? _errorMessage
                        : 'Please try again',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    onPressed: _retryLoading,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3498DB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isDailyChallenge
              ? 'Daily Challenge'
              : '${widget.difficulty.toUpperCase()} Mode',
        ),
        backgroundColor: const Color(0xFF3498DB),
        actions: [
          IconButton(
            icon: Icon(
              _hintsUsed[_currentQuestionIndex]
                  ? Icons.lightbulb
                  : Icons.lightbulb_outline,
              color: Colors.white,
            ),
            onPressed: _useHint,
            tooltip: 'Use Hint (50 coins)',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 16),
            child: Text(
              '$_score',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F7FA), Color(0xFFC3CFE2)],
          ),
        ),
        child: Column(
          children: [
            // Progress and Timer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _timeLeft < 10
                              ? Colors.red
                              : const Color(0xFF3498DB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.timer,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$_timeLeft',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_currentQuestionIndex + 1) / _questions.length,
                    backgroundColor: Colors.grey[200],
                    color: const Color(0xFF2ECC71),
                  ),
                ],
              ),
            ),

            // Question Card
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor(
                                        currentQuestion.category,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      currentQuestion.category,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${currentQuestion.points} pts',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFE67E22),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                currentQuestion.question,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (currentQuestion.imageUrl != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Image.network(
                                    currentQuestion.imageUrl!,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Options
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: currentQuestion.options.length,
                        itemBuilder: (context, index) {
                          final option = currentQuestion.options[index];
                          return Card(
                            color: _getOptionColor(
                              index,
                              option.isCorrect,
                              currentQuestion,
                            ),
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(
                                option.text,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: _isAnswered && option.isCorrect
                                      ? Colors.green[900]
                                      : Colors.black,
                                ),
                              ),
                              onTap: _isAnswered
                                  ? null
                                  : () => _handleAnswer(option.isCorrect),
                              trailing: _isAnswered && option.isCorrect
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),

                      // Hint (if used)
                      if (_usedHint && currentQuestion.explanation.length > 100)
                        Card(
                          color: Colors.amber[50],
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              '💡 Hint: ${currentQuestion.explanation.substring(0, 100)}...',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Explanation (after answer) with Next Button
            if (_isAnswered)
              Card(
                margin: const EdgeInsets.all(16),
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '📚 Explanation:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(currentQuestion.explanation),
                      const SizedBox(height: 8),
                      Text(
                        '⚖️ Reference: ${currentQuestion.lawReference}',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Next Question Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.navigate_next),
                          label: Text(
                            _currentQuestionIndex < _questions.length - 1
                                ? 'Next Question'
                                : 'Finish Quiz',
                            style: const TextStyle(fontSize: 16),
                          ),
                          onPressed: _nextQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2ECC71),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Learn More Button (Optional - stays as before)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.book),
                        label: const Text('Learn More About This Law'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Want to learn more about this law?',
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Search for "${currentQuestion.lawReference}" in the main app.',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              duration: const Duration(seconds: 4),
                              action: SnackBarAction(
                                label: 'Go to App',
                                onPressed: () {
                                  // Navigate back to main app
                                  Navigator.popUntil(
                                    context,
                                    (route) => route.isFirst,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3498DB),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    final colors = {
      'Housing': const Color(0xFF8E44AD),
      'Rights & Freedoms': const Color(0xFF3498DB),
      'Business': const Color(0xFF2ECC71),
      'Employment': const Color(0xFFE67E22),
      'Environment': const Color(0xFF1ABC9C),
      'Consumer Rights': const Color(0xFFE74C3C),
      'Education': const Color(0xFF9B59B6),
      'Health': const Color(0xFFE91E63),
      'Family & Personal': const Color(0xFF795548),
      'Justice & Legal Aid': const Color(0xFF607D8B),
      'Property & Housing': const Color(0xFF8E44AD),
      'Transport': const Color(0xFF009688),
      'Technology & Communication': const Color(0xFF3F51B5),
    };
    return colors[category] ?? const Color(0xFF7F8C8D);
  }
}
