// main.dart - FINAL PRODUCTION VERSION
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:where_in_the_law/services/ad_service.dart';
import 'screens/home_screen.dart';
import 'screens/law_detail_screen.dart';
import 'data/law_data.dart';
import 'models/law_model.dart';
import 'screens/categories_screen.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (handles duplicates gracefully)
  await _initializeFirebase();
  
  // Initialize AdMob
  await AdService.initializeAdMob();
  
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
      print('✅ Firebase initialized for iOS');
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
      print('✅ Firebase initialized for Android');
    } else {
      await Firebase.initializeApp();
      print('✅ Firebase initialized');
    }
  } catch (e) {
    // If it's a duplicate app error, Firebase is already working
    // This is common on Android hot restarts
    final errorMessage = e.toString();
    
    if (errorMessage.contains('duplicate-app') || 
        errorMessage.contains('already exists')) {
      print('✅ Firebase already initialized');
    } else if (errorMessage.contains('MissingPluginException')) {
      // Firebase not available on this platform (e.g., web without config)
      print('⚠️ Firebase not configured for this platform');
    } else {
      // Real initialization error
      print('❌ Firebase initialization error: $e');
      // App can still run without Firebase
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
        future: LawData.loadLaws(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Color(0xFFF5F7FA),
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3498DB)),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              backgroundColor: Color(0xFFF5F7FA),
              appBar: AppBar(
                title: const Text('Error'),
                backgroundColor: Color(0xFF3498DB),
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
                        color: Color(0xFFE74C3C),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Failed to load laws',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Please check your connection and try again',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF7F8C8D),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyApp(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF3498DB),
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
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return HomeScreen(laws: []);
          } else {
            return HomeScreen(laws: snapshot.data!);
          }
        },
      ),
      routes: {
        '/law_detail': (context) {
          final law = ModalRoute.of(context)!.settings.arguments as Law;
          return LawDetailScreen(law: law);
        },
        '/categories': (context) {
          final laws = ModalRoute.of(context)!.settings.arguments as List<Law>;
          return CategoriesScreen(laws: laws);
        },
      },
    );
  }
}