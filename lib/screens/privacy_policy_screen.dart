// screens/privacy_policy_screen.dart
// ignore_for_file: library_private_types_in_public_api, sized_box_for_whitespace

import 'package:flutter/material.dart';
import '../services/ad_service.dart';
import 'dart:io' show Platform;

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
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
        title: const Text('Privacy Policy'),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPolicySection(
                      title: 'Privacy Policy',
                      subtitle: 'Last updated: ${DateTime.now().toString().split(' ')[0]}',
                      content: 'This Privacy Policy describes how "Where in the Law?" collects, uses, and shares information when you use our mobile application.',
                    ),
                    const SizedBox(height: 20),
                    
                    _buildPolicySection(
                      title: 'Information We Collect',
                      content: '''
1. **Usage Data**: We collect anonymous usage statistics to improve the app, including:
   - Screen views and navigation patterns
   - Feature usage frequency
   - App performance metrics
   - Crash reports

2. **Ad-related Data**: Our ad provider (Google AdMob) may collect:
   - Device information (model, OS version)
   - IP address (for ad targeting)
   - Advertising ID (for personalized ads)
   ''',
                    ),
                    const SizedBox(height: 20),
                    
                    _buildPolicySection(
                      title: 'How We Use Information',
                      content: '''
• To improve app functionality and user experience
• To display relevant advertisements
• To fix bugs and optimize performance
• To analyze usage patterns for future development
• To comply with legal obligations
                      ''',
                    ),
                    const SizedBox(height: 20),
                    
                    _buildPolicySection(
                      title: 'Third-Party Services',
                      content: '''
We use the following third-party services:

1. **Google AdMob**: For displaying advertisements
   - Privacy Policy: https://policies.google.com/privacy

2. **Firebase Analytics**: For app analytics
   - Privacy Policy: https://firebase.google.com/support/privacy

3. **Google Play Services**: For app distribution
   - Privacy Policy: https://policies.google.com/privacy
                      ''',
                    ),
                    const SizedBox(height: 20),
                    
                    _buildPolicySection(
                      title: 'Data Security',
                      content: 'We implement reasonable security measures to protect your information. However, no method of transmission over the Internet or electronic storage is 100% secure.',
                    ),
                    const SizedBox(height: 20),
                    
                    _buildPolicySection(
                      title: 'Children\'s Privacy',
                      content: 'Our app is not directed to children under 13. We do not knowingly collect personal information from children under 13.',
                    ),
                    const SizedBox(height: 20),
                    
                    _buildPolicySection(
                      title: 'Your Rights',
                      content: '''
You have the right to:
• Access information we hold about you
• Correct inaccurate information
• Request deletion of your information
• Opt-out of personalized advertising (through device settings)
                      ''',
                    ),
                    const SizedBox(height: 20),
                    
                    _buildPolicySection(
                      title: 'Changes to This Policy',
                      content: 'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date.',
                    ),
                    const SizedBox(height: 20),
                    
                    _buildPolicySection(
                      title: 'Contact Us',
                      content: 'If you have questions about this Privacy Policy, please contact us through the "Contact Support" option in the app.',
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

  Widget _buildPolicySection({required String title, String? subtitle, required String content}) {
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
                style: TextStyle(
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
      ),
    );
  }
}