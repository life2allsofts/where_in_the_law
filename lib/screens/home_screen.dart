// screens/home_screen.dart
// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import '../models/law_model.dart';
import 'package:where_in_the_law/models/widgets/law_card.dart';
import 'search_screen.dart'; 
import 'categories_screen.dart';
import 'favorites_screen.dart';
import 'law_detail_screen.dart';
import '../services/ad_service.dart';

class HomeScreen extends StatefulWidget {
  final List<Law> laws;

  const HomeScreen({super.key, required this.laws});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedView = 'all';
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Listen to ad service changes
    AdService().addListener(_onAdChanged);
    
    // Load ad after screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHomeAd();
    });
  }

  void _loadHomeAd() {
    print('🔄 HomeScreen: Loading HOME banner ad');
    AdService.loadHomeBannerAd(
      Platform.isAndroid 
        ? 'ca-app-pub-4334052584109954/4511342998'
        : 'ca-app-pub-4334052584109954/7924792638'
    );
  }

  void _onAdChanged() {
    print('🔄 HomeScreen: Ad state changed, updating UI');
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    AdService().removeListener(_onAdChanged);
    super.dispose();
  }

  List<Law> get _filteredLaws {
    if (_selectedView == 'all' || _selectedCategory == null) {
      return widget.laws;
    }
    return widget.laws.where((law) => law.category == _selectedCategory).toList();
  }

  void _showCategoriesScreen() async {
    final selectedCategory = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoriesScreen(laws: widget.laws),
      ),
    );
    
    if (selectedCategory != null) {
      setState(() {
        _selectedView = 'categories';
        _selectedCategory = selectedCategory;
      });
    }
  }

  void _handleCategorySelection() {
    // Call this when "Categories" button is pressed
    AdService.showInterstitialAd(
      screenName: 'HomeScreen',
      action: 'categories_button',
    );
    _showCategoriesScreen();
  }

  void _handleFavoriteTap() {
    // Call this when favorite icon is pressed
    AdService.showInterstitialAd(
      screenName: 'HomeScreen',
      action: 'favorites_button',
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesScreen(),
      ),
    );
  }

  void _handleSearchTap() {
    // Call this when search icon is pressed
    AdService.showInterstitialAd(
      screenName: 'HomeScreen',
      action: 'search_button',
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(allLaws: widget.laws),
      ),
    );
  }

  void _handleLawCardTap(Law law) {
    // Call this when a law card is tapped
    AdService.showInterstitialAd(
      screenName: 'HomeScreen',
      action: 'law_card_tap',
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LawDetailScreen(law: law),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    final colors = {
      'Housing': Color(0xFF8E44AD),
      'Rights & Freedoms': Color(0xFF3498DB),
      'Business': Color(0xFF2ECC71),
      'Employment': Color(0xFFE67E22),
      'Environment': Color(0xFF1ABC9C),
      'Consumer Rights': Color(0xFFE74C3C),
      'Education': Color(0xFF9B59B6),
      'Health': Color(0xFFE91E63),
      'Family & Personal': Color(0xFF795548),
      'Justice & Legal Aid': Color(0xFF607D8B),
      'Property & Housing': Color(0xFF8E44AD),
      'Transport': Color(0xFF009688),
      'Technology & Communication': Color(0xFF3F51B5),
    };
    return colors[category] ?? Color(0xFF7F8C8D);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghana Law Library'),
        centerTitle: true,
        backgroundColor: Color(0xFF3498DB),
        iconTheme: IconThemeData(color: Colors.white),
        shape: Border(
          bottom: BorderSide(
            color: Color(0xFFD4AF37),
            width: 2,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.white),
            onPressed: _handleFavoriteTap,
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: _handleSearchTap,
          ),
        ],
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
            // HOME Banner Ad at TOP
            AdService.getHomeBannerAd(),
            
            // Two Main Buttons - All & Categories
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // All Laws Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedView = 'all';
                          _selectedCategory = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedView == 'all' 
                            ? Color(0xFF3498DB) 
                            : Colors.white,
                        foregroundColor: _selectedView == 'all' 
                            ? Colors.white 
                            : Color(0xFF3498DB),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Color(0xFFD4AF37),
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: const Text(
                        'All Laws',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Categories Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleCategorySelection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedView == 'categories' 
                            ? Color(0xFF8E44AD) 
                            : Colors.white,
                        foregroundColor: _selectedView == 'categories' 
                            ? Colors.white 
                            : Color(0xFF8E44AD),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Color(0xFFD4AF37),
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Categories',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Selected Category Indicator (if any)
            if (_selectedCategory != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      'Showing: ',
                      style: TextStyle(
                        color: Color(0xFF7F8C8D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Chip(
                      label: Text(
                        _selectedCategory!,
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: _getCategoryColor(_selectedCategory!),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedView = 'all';
                          _selectedCategory = null;
                        });
                      },
                      child: Text(
                        'Clear',
                        style: TextStyle(
                          color: Color(0xFFE74C3C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // Laws List
            Expanded(
              child: _filteredLaws.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Color(0xFF7F8C8D),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _selectedView == 'categories' && _selectedCategory == null
                                ? 'Select a category to view laws'
                                : 'No laws found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF7F8C8D),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredLaws.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _handleLawCardTap(_filteredLaws[index]),
                          child: LawCard(law: _filteredLaws[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}