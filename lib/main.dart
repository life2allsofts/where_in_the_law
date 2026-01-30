// main.dart - UPDATED with AppState
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:where_in_the_law/services/ad_service.dart';
import 'package:where_in_the_law/services/shared_prefs_service.dart';
import 'package:where_in_the_law/services/app_state.dart'; // NEW
import 'screens/home_screen.dart';
import 'screens/law_detail_screen.dart';
import 'screens/terms_screen.dart';
import 'screens/tutorial_screen.dart';
import 'screens/game_home_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/quiz_result_screen.dart';
import 'models/law_model.dart';
import 'screens/categories_screen.dart';
import 'screens/faq_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await _initializeFirebase();
  
  // Initialize AdMob
  await AdService.initializeAdMob();
  
  // Preload laws into AppState
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  await appState.getLaws(); // Preload in background
  
  runApp(const MyApp());
}

Future<void> _initializeFirebase() async {
  try {
    if (Platform.isIOS) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyC6LL23LLSvtPSZ7X5IFBwZ_mboQ2megTg",
          appId: "1:120410408525:ios:5c400c24766aa5d4f33e04",
          messagingSenderId: "120410408525",
          projectId: "where-in-the-law-bf730",
          iosBundleId: "com.life2allsofts.where-in-the-law",
          iosClientId: "120410408525-91k5ecrblh5t51iq0k1i04cdcq1t2dv4.apps.googleusercontent.com",
          storageBucket: "where-in-the-law-bf730.appspot.com",
        ),
      );
    } else if (Platform.isAndroid) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyC6LL23LLSvtPSZ7X5IFBwZ_mboQ2megTg",
          appId: "1:120410408525:android:7df39ee70ee7b77cf33e04",
          messagingSenderId: "120410408525",
          projectId: "where-in-the-law-bf730",
          androidClientId: "120410408525-91k5ecrblh5t51iq0k1i04cdcq1t2dv4.apps.googleusercontent.com",
          storageBucket: "where-in-the-law-bf730.appspot.com",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    final errorMessage = e.toString();
    
    if (errorMessage.contains('duplicate-app') || 
        errorMessage.contains('already exists')) {
      // Firebase already initialized
    } else if (errorMessage.contains('MissingPluginException')) {
      // Firebase not available on this platform
    } else {
      // Real initialization error
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Where in the Law?',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3498DB),
          primary: const Color(0xFF3498DB),
          secondary: const Color(0xFF8E44AD),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3498DB),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: FutureBuilder<List<Law>>(
        future: AppState().getLaws(), // Use AppState instead of LawData.loadLaws()
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return ErrorScreen(error: snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const HomeScreen(laws: []);
          } else {
            return FirstLaunchFlow(laws: snapshot.data!);
          }
        },
      ),
      routes: {
        '/home': (context) {
          // Get laws from AppState
          return FutureBuilder<List<Law>>(
            future: AppState().getLaws(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
              } else if (snapshot.hasData) {
                return HomeScreen(laws: snapshot.data!);
              } else {
                return const HomeScreen(laws: []);
              }
            },
          );
        },
        '/law_detail': (context) {
          final law = ModalRoute.of(context)!.settings.arguments as Law;
          return LawDetailScreen(law: law);
        },
        '/categories': (context) {
          final laws = ModalRoute.of(context)!.settings.arguments as List<Law>;
          return CategoriesScreen(laws: laws);
        },
        '/tutorial': (context) => const TutorialScreen(),
        '/faq': (context) => const FAQScreen(),
        '/privacy': (context) => const PrivacyPolicyScreen(),
        '/terms': (context) => const TermsScreen(),
        '/game': (context) => const GameHomeScreen(),
        '/quiz': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return QuizScreen(
            difficulty: args['difficulty'],
            isDailyChallenge: args['isDailyChallenge'],
          );
        },
        '/quiz_results': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return QuizResultScreen(
            score: args['score'],
            totalQuestions: args['totalQuestions'],
            difficulty: args['difficulty'],
            isDailyChallenge: args['isDailyChallenge'],
            coinsEarned: args['coinsEarned'],
            xpEarned: args['xpEarned'],
          );
        },
      },
    );
  }
}

class FirstLaunchFlow extends StatefulWidget {
  final List<Law> laws;

  const FirstLaunchFlow({super.key, required this.laws});

  @override
  State<FirstLaunchFlow> createState() => _FirstLaunchFlowState();
}

class _FirstLaunchFlowState extends State<FirstLaunchFlow> {
  bool _isChecking = true;
  bool _needsTerms = false;
  bool _needsTutorial = false;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final hasAgreedToTerms = await SharedPrefsService.hasAgreedToTerms;
    final hasSeenTutorial = await SharedPrefsService.hasSeenTutorial;
    
    setState(() {
      _needsTerms = !hasAgreedToTerms;
      _needsTutorial = !hasSeenTutorial;
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const LoadingScreen();
    }
    
    // Show Terms first if needed
    if (_needsTerms) {
      return TermsScreen(
        onAgree: () async {
          await SharedPrefsService.setHasAgreedToTerms(true);
          setState(() {
            _needsTerms = false;
          });
        },
      );
    }
    
    // Show Tutorial if needed (after terms)
    if (_needsTutorial) {
      return TutorialScreen(
        onComplete: () async {
          await SharedPrefsService.setHasSeenTutorial(true);
          // Go directly to HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(laws: widget.laws),
            ),
          );
        },
      );
    }
    
    // Otherwise, go to HomeScreen
    return HomeScreen(laws: widget.laws);
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF3498DB)),
            ),
            const SizedBox(height: 20),
            Text(
              'Loading Ghana Law Library...',
              style: TextStyle(
                fontSize: 16,
                color: const Color(0xFF7F8C8D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Error'),
        backgroundColor: const Color(0xFF3498DB),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: const Color(0xFFE74C3C),
              ),
              const SizedBox(height: 20),
              Text(
                'Failed to load laws',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF7F8C8D),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyApp(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3498DB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}