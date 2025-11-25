import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import '../models/law_model.dart';
import 'package:where_in_the_law/models/widgets/law_card.dart';
import 'search_screen.dart'; 
import 'categories_screen.dart';
import 'favorites_screen.dart';
import '../services/ad_service.dart'; // ADD THIS IMPORT


class HomeScreen extends StatefulWidget {
  final List<Law> laws;

  const HomeScreen({super.key, required this.laws});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedView = 'all'; // 'all' or 'categories'
  String? _selectedCategory; // Track selected category

  @override
  void initState() {
    super.initState();
    // Load banner ad after the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AdService.loadBannerAd(
        Platform.isAndroid 
          ? 'ca-app-pub-4334052584109954/4511342998' // Android test ID
          : 'ca-app-pub-4334052584109954/7924792638' // iOS test ID
      );
    });
  }

  @override
  void dispose() {
    AdService.dispose();
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(allLaws: widget.laws),
                ),
              );
            },
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
                      onPressed: _showCategoriesScreen,
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
                        return LawCard(law: _filteredLaws[index]);
                      },
                    ),
            ),
            // AdMob Banner Ad - ADD THIS SECTION
            Container(
              color: Colors.transparent,
              width: double.infinity,
              height: 50, // Standard banner height
              child: AdService.getBannerAd(),
            ),
          ],
        ),
      ),
    );
  }
}