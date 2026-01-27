// lib/screens/terms_screen.dart
// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import '../services/ad_service.dart';
import 'dart:io' show Platform;

class TermsScreen extends StatefulWidget {
  final VoidCallback? onAgree;
  
  const TermsScreen({super.key, this.onAgree});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
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
        title: const Text('Terms of Service'),
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
                    _buildTermSection(
                      title: 'Terms of Service',
                      subtitle: 'Effective Date: ${DateTime.now().toString().split(' ')[0]}',
                      content: 'By downloading or using "Where in the Law?" mobile application, you agree to be bound by these Terms of Service.',
                    ),
                    const SizedBox(height: 20),
                    
                    _buildTermSection(
                      title: 'Acceptance of Terms',
                      content: 'By accessing and using this app, you accept and agree to be bound by the terms and provision of this agreement.',
                    ),
                    const SizedBox(height: 20),
                    
                    _buildTermSection(
                      title: 'Description of Service',
                      content: '''
"Where in the Law?" provides simplified explanations of Ghanaian laws for educational and informational purposes only.

**Disclaimer**: This app does not provide legal advice. Always consult a qualified lawyer for legal matters.
                      ''',
                    ),
                    const SizedBox(height: 20),
                    
                    _buildTermSection(
                      title: 'User Responsibilities',
                      content: '''
You agree to:
• Use the app for lawful purposes only
• Not misuse or abuse the app
• Not attempt to reverse engineer the app
• Not use the app to provide legal advice
• Comply with all applicable laws and regulations
                      ''',
                    ),
                    const SizedBox(height: 20),
                    
                    _buildTermSection(
                      title: 'Intellectual Property',
                      content: '''
All content in this app, including but not limited to text, graphics, logos, and software, is the property of the app developers and is protected by copyright laws.

You may:
• Use the app for personal, non-commercial purposes
• Share information from the app with proper attribution

You may not:
• Reproduce, distribute, or sell app content
• Use app content for commercial purposes without permission
                      ''',
                    ),
                    const SizedBox(height: 20),
                    
                    _buildTermSection(
                      title: 'Advertising',
                      content: '''
The app displays advertisements to support free access. By using the app, you acknowledge that:

• Ads may be displayed within the app
• Ad content is provided by third-party networks
• We are not responsible for ad content or accuracy
• You can manage ad preferences through your device settings
                      ''',
                    ),
                    const SizedBox(height: 20),
                    
                    _buildTermSection(
                      title: 'Limitation of Liability',
                      content: '''
The app developers shall not be liable for:
• Any indirect, incidental, or consequential damages
• Loss of data or profits
• Errors or inaccuracies in content
• Actions taken based on app content
• Any damages resulting from app use or inability to use
                      ''',
                    ),
                    const SizedBox(height: 20),
                    
                    _buildTermSection(
                      title: 'Termination',
                      content: 'We may terminate or suspend access to our app immediately, without prior notice, for any breach of these Terms.',
                    ),
                    const SizedBox(height: 20),
                    
                    _buildTermSection(
                      title: 'Changes to Terms',
                      content: 'We reserve the right to modify these terms at any time. We will notify users of any changes by updating the "Effective Date" at the top of this page.',
                    ),
                    const SizedBox(height: 20),
                    
                    _buildTermSection(
                      title: 'Governing Law',
                      content: 'These Terms shall be governed by and construed in accordance with the laws of Ghana, without regard to its conflict of law provisions.',
                    ),
                    const SizedBox(height: 20),
                    
                    _buildTermSection(
                      title: 'Contact Information',
                      content: 'For questions about these Terms, please contact us through the "Contact Support" option in the app.',
                    ),
                    const SizedBox(height: 30),
                    
                    // Accept Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.onAgree ?? () {
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
                          widget.onAgree != null ? 'I Understand & Accept' : 'Back',
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

  Widget _buildTermSection({required String title, String? subtitle, required String content}) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF7F8C8D),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF34495E),
                height: 1.6,
              ),
            ),
          ],
        ),
      )
    );
  }
}