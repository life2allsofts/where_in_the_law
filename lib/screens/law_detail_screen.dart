// screens/law_detail_screen.dart
// ignore_for_file: avoid_print, deprecated_member_use, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import '../models/law_model.dart';
import '../services/ad_service.dart';

class LawDetailScreen extends StatefulWidget {
  final Law law;

  const LawDetailScreen({super.key, required this.law});

  @override
  _LawDetailScreenState createState() => _LawDetailScreenState();
}

class _LawDetailScreenState extends State<LawDetailScreen> {
  @override
  void initState() {
    super.initState();
    AdService().addListener(_onAdChanged);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLawDetailAd();
    });
  }

  void _loadLawDetailAd() {
    print('🔄 LawDetailScreen: Loading LAW DETAIL banner ad');
    AdService.loadLawDetailBannerAd(
      Platform.isAndroid 
        ? 'ca-app-pub-4334052584109954/4511342998'
        : 'ca-app-pub-4334052584109954/7924792638'
    );
  }

  void _onAdChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    AdService().removeListener(_onAdChanged);
    super.dispose();
  }

  Color _getCategoryColor(String category) {
    final colors = {
      'Housing': Color(0xFF8E44AD),
      'Rights & Freedoms': Color(0xFF3498DB),
      'Business': Color(0xFF2ECC71),
      'Employment': Color(0xFFE67E22),
      'Environment': Color(0xFF1ABC9C),
      'Consumer Rights': Color(0xFFE74C3C),
    };
    return colors[category] ?? Color(0xFF7F8C8D);
  }

  Widget _buildInfoCard(String title, String content, {Color? color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color ?? Color(0xFF2C3E50),
              ),
            ),
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

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(widget.law.category);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(widget.law.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: categoryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        shape: Border(
          bottom: BorderSide(
            color: Color(0xFFD4AF37),
            width: 2,
          ),
        ),
      ),
      body: Column(
        children: [
          // LAW DETAIL Banner Ad at TOP
          Container(
            color: Colors.transparent,
            width: double.infinity,
            height: 50,
            child: AdService.getLawDetailBannerAd(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category and Reference Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
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
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Chip with Gold Border
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: categoryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Color(0xFFD4AF37),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              widget.law.category,
                              style: TextStyle(
                                color: categoryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Law Reference
                          Text(
                            '${widget.law.lawName} (${widget.law.lawCode})',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.law.section,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF7F8C8D),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Legal Text Card
                  _buildInfoCard(
                    'Legal Text',
                    widget.law.legalText,
                    color: Color(0xFF8E44AD),
                  ),
                  // Plain Explanation Card
                  _buildInfoCard(
                    'Plain Explanation',
                    widget.law.plainExplanation,
                    color: Color(0xFF3498DB),
                  ),
                  // Back Button with Gold Border
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10),
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
                        'Back to Laws',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}