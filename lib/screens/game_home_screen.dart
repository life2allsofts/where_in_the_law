// screens/game_home_screen.dart
// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import '../models/user_game_profile.dart';
import '../services/game_service.dart';
import '../services/ad_service.dart';
import 'quiz_screen.dart';

class GameHomeScreen extends StatefulWidget {
  const GameHomeScreen({super.key});

  @override
  State<GameHomeScreen> createState() => _GameHomeScreenState();
}

class _GameHomeScreenState extends State<GameHomeScreen> {
  late Future<UserGameProfile> _profileFuture;
  bool _dailyAvailable = false;
  bool _isGameBannerLoaded = false;
  
  @override
  void initState() {
    super.initState();
    _profileFuture = GameService.getUserProfile();
    _checkDailyChallenge();
    
    // Load game banner ad after screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGameBannerAd();
    });
  }
  
  void _loadGameBannerAd() {
    print('🔄 GameHomeScreen: Loading GAME banner ad');
    AdService.loadGameBannerAd(
      Platform.isAndroid 
        ? 'ca-app-pub-4334052584109954/4511342998' // Android banner
        : 'ca-app-pub-4334052584109954/7924792638' // iOS banner (same as home for now)
    );
    
    // Listen for banner ad changes
    AdService().addListener(_onAdChanged);
  }
  
  void _onAdChanged() {
    if (mounted) {
      setState(() {
        _isGameBannerLoaded = AdService.isGameBannerReady;
      });
    }
  }
  
  @override
  void dispose() {
    AdService().removeListener(_onAdChanged);
    super.dispose();
  }
  
  Future<void> _checkDailyChallenge() async {
    final available = await GameService.canPlayDailyChallenge();
    setState(() {
      _dailyAvailable = available;
    });
  }
  
  void _startQuiz(String difficulty) {
    AdService.showInterstitialAd(
      screenName: 'GameHome',
      action: 'start_${difficulty}_quiz',
    );
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          difficulty: difficulty,
          isDailyChallenge: false,
        ),
      ),
    );
  }
  
  void _startDailyChallenge() async {
    if (!_dailyAvailable) {
      _showSnackBar('Daily challenge already completed today! Try again tomorrow.');
      return;
    }
    
    AdService.showInterstitialAd(
      screenName: 'GameHome',
      action: 'start_daily_challenge',
    );
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuizScreen(
          difficulty: 'daily',
          isDailyChallenge: true,
        ),
      ),
    );
  }
  
  void _showShop() {
    AdService.showInterstitialAd(
      screenName: 'GameHome',
      action: 'open_shop',
    );
    
    _showSnackBar('Shop feature coming soon!');
  }
  
  void _showLeaderboard() {
    AdService.showInterstitialAd(
      screenName: 'GameHome',
      action: 'open_leaderboard',
    );
    
    _showSnackBar('Leaderboard feature coming soon!');
  }
  
  void _showAchievements() {
    AdService.showInterstitialAd(
      screenName: 'GameHome',
      action: 'open_achievements',
    );
    
    _showSnackBar('Achievements feature coming soon!');
  }
  
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  Widget _buildGameModeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: enabled 
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color.withOpacity(0.1), color.withOpacity(0.3)],
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: enabled ? color : Colors.grey,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: enabled ? color : Colors.grey,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  color: enabled ? Colors.grey[600] : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              if (!enabled)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Completed',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.gamepad),
            SizedBox(width: 8),
            Text('🇬🇭 Law Master Ghana'),
          ],
        ),
        backgroundColor: const Color(0xFF3498DB),
        elevation: 2,
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
            // GAME Banner Ad at TOP
            AdService.getGameBannerAd(),
            
            // User Stats Card
            FutureBuilder<UserGameProfile>(
              future: _profileFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  );
                }
                
                if (snapshot.hasError) {
                  return Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('Error loading profile: ${snapshot.error}'),
                    ),
                  );
                }
                
                final profile = snapshot.data!;
                
                return Card(
                  margin: const EdgeInsets.all(16),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.emoji_events,
                              color: Theme.of(context).primaryColor,
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Level ${profile.level}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  LinearProgressIndicator(
                                    value: profile.experience / profile.experienceToNextLevel,
                                    backgroundColor: Colors.grey[200],
                                    color: const Color(0xFF2ECC71),
                                  ),
                                  Text(
                                    '${profile.experience}/${profile.experienceToNextLevel} XP',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                const Text(
                                  'Cedi Coins',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  '₵${profile.cediCoins}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE67E22),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              icon: Icons.local_fire_department,
                              value: '${profile.streakDays}',
                              label: 'Day Streak',
                            ),
                            _buildStatItem(
                              icon: Icons.check_circle,
                              value: '${profile.accuracy.toStringAsFixed(1)}%',
                              label: 'Accuracy',
                            ),
                            _buildStatItem(
                              icon: Icons.people,
                              value: '#${profile.level * 23}',
                              label: 'Rank',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            // Game Modes Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                  children: [
                    _buildGameModeCard(
                      title: '🇬🇭 Beginner',
                      subtitle: 'Basic Laws & Constitution',
                      icon: Icons.school,
                      color: const Color(0xFF3498DB),
                      onTap: () => _startQuiz('beginner'),
                    ),
                    _buildGameModeCard(
                      title: '⚖️ Intermediate',
                      subtitle: 'Specific Laws & Regulations',
                      icon: Icons.gavel,
                      color: const Color(0xFF2ECC71),
                      onTap: () => _startQuiz('intermediate'),
                    ),
                    _buildGameModeCard(
                      title: '👑 Expert',
                      subtitle: 'Complex Legal Scenarios',
                      icon: Icons.psychology,
                      color: const Color(0xFF8E44AD),
                      onTap: () => _startQuiz('expert'),
                    ),
                    _buildGameModeCard(
                      title: '🏆 Daily Challenge',
                      subtitle: 'Special Rewards!',
                      icon: Icons.whatshot,
                      color: const Color(0xFFE67E22),
                      onTap: _startDailyChallenge,
                      enabled: _dailyAvailable,
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom Navigation
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBottomButton(
                    icon: Icons.leaderboard,
                    label: 'Leaderboard',
                    onTap: _showLeaderboard,
                  ),
                  _buildBottomButton(
                    icon: Icons.emoji_events,
                    label: 'Achievements',
                    onTap: _showAchievements,
                  ),
                  _buildBottomButton(
                    icon: Icons.shopping_cart,
                    label: 'Shop',
                    onTap: _showShop,
                  ),
                ],
              ),
            ),
            
            // Banner Ad Load Status Indicator (for debugging)
            if (kDebugMode)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isGameBannerLoaded ? Icons.check_circle : Icons.timer,
                      color: _isGameBannerLoaded ? Colors.green : Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isGameBannerLoaded ? 'Banner Ad Ready' : 'Loading Banner...',
                      style: TextStyle(
                        fontSize: 12,
                        color: _isGameBannerLoaded ? Colors.green : Colors.orange,
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
  
  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF7F8C8D)),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
  
  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, size: 30),
          onPressed: onTap,
          color: const Color(0xFF3498DB),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}