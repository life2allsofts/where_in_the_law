// screens/categories_screen.dart
// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import '../models/law_model.dart';
import '../services/ad_service.dart';

class CategoriesScreen extends StatefulWidget {
  final List<Law> laws;

  const CategoriesScreen({super.key, required this.laws});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // Get unique categories from laws
  List<String> get _categories {
    final categories = widget.laws.map((law) => law.category).toSet().toList();
    categories.sort();
    return categories;
  }

  // Count laws in each category
  int _getCategoryCount(String category) {
    return widget.laws.where((law) => law.category == category).length;
  }

  // Helper function to get category color
  Color _getCategoryColor(String category) {
    final colors = {
      'Housing': Color(0xFF8E44AD), // Purple
      'Rights & Freedoms': Color(0xFF3498DB), // Blue
      'Business': Color(0xFF2ECC71), // Green
      'Employment': Color(0xFFE67E22), // Orange
      'Environment': Color(0xFF1ABC9C), // Teal
      'Consumer Rights': Color(0xFFE74C3C), // Red
      'Education': Color(0xFF9B59B6), // Deep Purple
      'Health': Color(0xFFE91E63), // Pink
      'Family & Personal': Color(0xFF795548), // Brown
      'Justice & Legal Aid': Color(0xFF607D8B), // Blue Grey
      'Property & Housing': Color(0xFF8E44AD), // Purple (same as Housing)
      'Transport': Color(0xFF009688), // Teal
      'Technology & Communication': Color(0xFF3F51B5), // Indigo
    };
    return colors[category] ?? Color(0xFF7F8C8D); // Default gray
  }

  // Helper function to get category icon
  IconData _getCategoryIcon(String category) {
    final icons = {
      'Housing': Icons.home,
      'Rights & Freedoms': Icons.gavel,
      'Business': Icons.business,
      'Employment': Icons.work,
      'Environment': Icons.eco,
      'Consumer Rights': Icons.shopping_cart,
      'Education': Icons.school,
      'Health': Icons.local_hospital,
      'Family & Personal': Icons.family_restroom,
      'Justice & Legal Aid': Icons.balance,
      'Property & Housing': Icons.home_work,
      'Transport': Icons.directions_car,
      'Technology & Communication': Icons.phone_iphone,
    };
    return icons[category] ?? Icons.category;
  }

  void _handleCategoryTap(String category) {
    // Call this when category is tapped
    AdService.showInterstitialAd(
      screenName: 'CategoriesScreen',
      action: 'category_selection',
    );
    Navigator.pop(context, category);
  }

  @override
  void initState() {
    super.initState();
    AdService().addListener(_onAdChanged);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategoriesAd();
    });
  }

  void _loadCategoriesAd() {
    print('🔄 CategoriesScreen: Loading CATEGORIES banner ad');
    AdService.loadCategoriesBannerAd(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Color(0xFF3498DB),
        iconTheme: const IconThemeData(color: Colors.white),
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
            // CATEGORIES Banner Ad at TOP
            Container(
              color: Colors.transparent,
              width: double.infinity,
              height: 50,
              child: AdService.getCategoriesBannerAd(),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Browse Laws by Category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select a category to view related laws',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7F8C8D),
                    ),
                  ),
                ],
              ),
            ),
            // Category Grid - FIXED: Using Expanded to prevent overflow
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5, // Adjusted for better fit
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final count = _getCategoryCount(category);
                    final categoryColor = _getCategoryColor(category);

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Color(0xFFD4AF37),
                          width: 1.5,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _handleCategoryTap(category),
                        child: Container(
                          padding: const EdgeInsets.all(12), // Reduced padding
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min, // FIX: Use min size
                            children: [
                              // Category Icon - smaller
                              Icon(
                                _getCategoryIcon(category),
                                size: 28, // Reduced size
                                color: categoryColor,
                              ),
                              const SizedBox(height: 6), // Reduced spacing
                              // Category Name - with flexible text
                              Flexible(
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 13, // Smaller font
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C3E50),
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Law Count - smaller text
                              Text(
                                '$count law${count != 1 ? 's' : ''}',
                                style: TextStyle(
                                  fontSize: 11, // Smaller font
                                  color: Color(0xFF7F8C8D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}