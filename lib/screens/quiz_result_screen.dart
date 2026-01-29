// screens/quiz_result_screen.dart
import 'package:flutter/material.dart';
import 'package:where_in_the_law/screens/quiz_screen.dart';
import '../services/ad_service.dart';
import 'game_home_screen.dart';
import 'home_screen.dart';

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final String difficulty;
  final bool isDailyChallenge;
  final int coinsEarned;
  final int xpEarned;
  
  const QuizResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.difficulty,
    required this.isDailyChallenge,
    required this.coinsEarned,
    required this.xpEarned,
  });

  double get percentage => (score / (totalQuestions * 10)) * 100;
  
  String get performanceText {
    if (percentage >= 90) return 'Outstanding! 🎉';
    if (percentage >= 70) return 'Great Job! 👍';
    if (percentage >= 50) return 'Good Effort! 💪';
    return 'Keep Practicing! 📚';
  }
  
  Color get performanceColor {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 70) return const Color(0xFF2ECC71);
    if (percentage >= 50) return const Color(0xFFE67E22);
    return const Color(0xFFE74C3C);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        backgroundColor: const Color(0xFF3498DB),
        automaticallyImplyLeading: false,
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
            // Performance Card
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      performanceText,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: performanceColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: CircularProgressIndicator(
                            value: percentage / 100,
                            strokeWidth: 10,
                            backgroundColor: Colors.grey[200],
                            color: performanceColor,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$score/${totalQuestions * 10}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      isDailyChallenge 
                          ? 'Daily Challenge Completed!' 
                          : '${difficulty.toUpperCase()} Mode',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Rewards Card
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🎁 Rewards Earned',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRewardItem(
                      icon: Icons.star,
                      iconColor: Colors.amber,
                      title: 'Experience Points',
                      value: '+$xpEarned XP',
                      subtitle: 'Level up your profile',
                    ),
                    _buildRewardItem(
                      icon: Icons.currency_exchange,
                      iconColor: const Color(0xFFE67E22),
                      title: 'Cedi Coins',
                      value: '+₵$coinsEarned',
                      subtitle: 'Use in shop for power-ups',
                    ),
                    if (isDailyChallenge)
                      _buildRewardItem(
                        icon: Icons.local_fire_department,
                        iconColor: Colors.red,
                        title: 'Streak Bonus',
                        value: '3x Multiplier',
                        subtitle: 'Daily challenge special',
                      ),
                  ],
                ),
              ),
            ),
            
            const Spacer(),
            
            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (percentage < 70)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.replay),
                      label: const Text('Try Again'),
                      onPressed: () {
                        AdService.showInterstitialAd(
                          screenName: 'QuizResult',
                          action: 'try_again',
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(
                              difficulty: difficulty,
                              isDailyChallenge: isDailyChallenge,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3498DB),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.gamepad),
                    label: const Text('Play Another Quiz'),
                    onPressed: () {
                      AdService.showInterstitialAd(
                        screenName: 'QuizResult',
                        action: 'play_another',
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GameHomeScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2ECC71),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.home),
                    label: const Text('Back to Law Library'),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(laws: []), // Pass your actual laws
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8E44AD),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRewardItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}