import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'screens/law_detail_screen.dart';
import 'data/law_data.dart';
import 'models/law_model.dart';
import 'screens/categories_screen.dart';
import 'services/ad_service.dart'; // ADD THIS IMPORT

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize AdMob with error handling
  try {
    await AdService.initialize();
  } catch (e) {
    print('AdMob initialization error: $e');
    // Continue running the app even if ads fail
  }
  
  runApp(const MyApp());
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
      ),
      home: FutureBuilder<List<Law>>(
        future: LawData.loadLaws(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const HomeScreen(laws: []);
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