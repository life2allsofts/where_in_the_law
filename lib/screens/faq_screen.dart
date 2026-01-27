// screens/faq_screen.dart
// ignore_for_file: library_private_types_in_public_api, sized_box_for_whitespace

import 'package:flutter/material.dart';
import '../services/ad_service.dart';
import 'dart:io' show Platform;

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
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
        title: const Text('Frequently Asked Questions'),
        backgroundColor: Color(0xFF3498DB),
        iconTheme: IconThemeData(color: Colors.white),
        shape: Border(
          bottom: BorderSide(
            color: Color(0xFFD4AF37),
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
                  children: [
                    _buildFAQItem(
                      question: 'Is this app official?',
                      answer: 'No, this app is not an official government application. It provides simplified explanations of Ghanaian laws for educational purposes.',
                    ),
                    const SizedBox(height: 16),
                    _buildFAQItem(
                      question: 'Is the legal information accurate?',
                      answer: 'We strive to provide accurate information based on publicly available legal texts. However, for official legal advice, always consult a qualified lawyer.',
                    ),
                    const SizedBox(height: 16),
                    _buildFAQItem(
                      question: 'How often is the law database updated?',
                      answer: 'We update the database regularly when new laws are enacted or existing laws are amended. Check the app version for update information.',
                    ),
                    const SizedBox(height: 16),
                    _buildFAQItem(
                      question: 'Is the app free to use?',
                      answer: 'Yes, the app is completely free. It is supported by non-intrusive ads to help maintain and improve the service.',
                    ),
                    const SizedBox(height: 16),
                    _buildFAQItem(
                      question: 'How do I report an error in the content?',
                      answer: 'Use the "Contact Support" option in the menu to report any errors or suggest corrections.',
                    ),
                    const SizedBox(height: 16),
                    _buildFAQItem(
                      question: 'Can I use this app offline?',
                      answer: 'Yes, once downloaded, all law content is available offline. You need internet only for ads and updates.',
                    ),
                    const SizedBox(height: 16),
                    _buildFAQItem(
                      question: 'Why do I see ads?',
                      answer: 'Ads help support the development and maintenance of this free app. We show ads respectfully and at appropriate intervals.',
                    ),
                    const SizedBox(height: 16),
                    _buildFAQItem(
                      question: 'How do I save laws for later?',
                      answer: 'Tap the heart icon on any law card to add it to your favorites. Access favorites from the heart icon in the app bar.',
                    ),
                    const SizedBox(height: 16),
                    _buildFAQItem(
                      question: 'Are my favorites saved?',
                      answer: 'Yes, your favorite laws are saved locally on your device and will persist between app sessions.',
                    ),
                    const SizedBox(height: 30),
                    
                    // Back Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF2C3E50),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Color(0xFFD4AF37),
                              width: 1.5,
                            ),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Back to Home',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

  Widget _buildFAQItem({required String question, required String answer}) {
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
          color: Color(0xFFD4AF37),
          width: 1.5,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF34495E),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}