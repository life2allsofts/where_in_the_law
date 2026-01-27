// lib/screens/tutorial_screen.dart
// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import '../services/ad_service.dart';
import 'dart:io' show Platform;

class TutorialScreen extends StatefulWidget {
  final VoidCallback? onComplete;
  
  const TutorialScreen({super.key, this.onComplete});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AdService.loadLawDetailBannerAd(
        Platform.isAndroid 
          ? 'ca-app-pub-4334052584109954/4511342998'
          : 'ca-app-pub-4334052584109954/7924792638'
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial & Guide'),
        backgroundColor: const Color(0xFF3498DB),
        iconTheme: const IconThemeData(color: Colors.white),
        shape: Border(
          bottom: BorderSide(
            color: const Color(0xFFD4AF37),
            width: 2,
          ),
        ),
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
            // Banner Ad at TOP
            Container(
              height: 50,
              child: AdService.getLawDetailBannerAd(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    _buildSectionCard(
                      title: '📚 Welcome to Ghana Law Library',
                      content: 'Your comprehensive guide to understanding Ghanaian laws in simple language.',
                      icon: Icons.waving_hand,
                      color: const Color(0xFF3498DB),
                    ),
                    const SizedBox(height: 20),
                    
                    // Step 1
                    _buildStepCard(
                      stepNumber: 1,
                      title: 'Browse All Laws',
                      content: 'Tap "All Laws" button to see all available laws. Scroll through the list to explore different laws.',
                      icon: Icons.list,
                    ),
                    const SizedBox(height: 16),
                    
                    // Step 2
                    _buildStepCard(
                      stepNumber: 2,
                      title: 'Explore by Categories',
                      content: 'Tap "Categories" button to view laws organized by topics like Housing, Business, Employment, etc.',
                      icon: Icons.category,
                    ),
                    const SizedBox(height: 16),
                    
                    // Step 3
                    _buildStepCard(
                      stepNumber: 3,
                      title: 'Search for Specific Laws',
                      content: 'Use the search icon (🔍) to find laws by keywords, titles, or specific terms.',
                      icon: Icons.search,
                    ),
                    const SizedBox(height: 16),
                    
                    // Step 4
                    _buildStepCard(
                      stepNumber: 4,
                      title: 'Save Favorite Laws',
                      content: 'Tap the heart icon (❤️) on any law card to save it to your favorites for quick access later.',
                      icon: Icons.favorite,
                    ),
                    const SizedBox(height: 16),
                    
                    // Step 5
                    _buildStepCard(
                      stepNumber: 5,
                      title: 'Understand Law Details',
                      content: 'Tap any law card to see:\n• Legal text\n• Plain English explanation\n• Law reference\n• Category',
                      icon: Icons.info,
                    ),
                    const SizedBox(height: 20),
                    
                    // Tips Section
                    _buildSectionCard(
                      title: '💡 Quick Tips',
                      content: '• Use search for specific legal terms\n• Save frequently referenced laws\n• Check categories for related laws\n• Contact support if you need clarification',
                      icon: Icons.lightbulb,
                      color: const Color(0xFFF39C12),
                    ),
                    const SizedBox(height: 20),
                    
                    // Back/Get Started Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.onComplete ?? () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF2C3E50),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: const Color(0xFFD4AF37),
                              width: 1.5,
                            ),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          widget.onComplete != null ? 'Get Started' : 'Back to Home',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required String content, required IconData icon, required Color color}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFD4AF37),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF34495E),
                      height: 1.5,
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

  Widget _buildStepCard({required int stepNumber, required String title, required String content, required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFD4AF37),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFF3498DB),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  '$stepNumber',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: const Color(0xFF3498DB), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF34495E),
                      height: 1.5,
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
}