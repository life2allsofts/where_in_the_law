// screens/home_screen.dart - WITH SIMPLIFIED CONTACT SUPPORT
// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';
import 'package:where_in_the_law/screens/game_home_screen.dart';
import '../models/law_model.dart';
import 'package:where_in_the_law/models/widgets/law_card.dart';
import 'search_screen.dart'; 
import 'categories_screen.dart';
import 'favorites_screen.dart';
import 'law_detail_screen.dart';
import 'tutorial_screen.dart';
import 'faq_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_screen.dart';
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
    AdService.showInterstitialAd(
      screenName: 'HomeScreen',
      action: 'categories_button',
    );
    _showCategoriesScreen();
  }

  void _handleFavoriteTap() {
    AdService.showInterstitialAd(
      screenName: 'HomeScreen',
      action: 'favorites_button',
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FavoritesScreen(),
      ),
    );
  }

  void _handleSearchTap() {
    try {
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
    } catch (e) {
      print('Search button error: $e');
      _showSnackBar('Could not open search. Please try again.');
    }
  }

  void _handleLawCardTap(Law law) {
    try {
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
    } catch (e) {
      print('Law card tap error: $e');
      _showSnackBar('Could not open law details. Please try again.');
    }
  }

  // Menu item handlers
  void _handleTutorialTap() {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TutorialScreen(),
        ),
      );
    } catch (e) {
      print('Tutorial error: $e');
      _showSnackBar('Could not open tutorial. Please try again.');
    }
  }

  void _handleFaqTap() {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FAQScreen(),
        ),
      );
    } catch (e) {
      print('FAQ error: $e');
      _showSnackBar('Could not open FAQ. Please try again.');
    }
  }

  void _handlePrivacyPolicyTap() {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PrivacyPolicyScreen(),
        ),
      );
    } catch (e) {
      print('Privacy policy error: $e');
      _showSnackBar('Could not open privacy policy. Please try again.');
    }
  }

  void _handleTermsTap() {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TermsScreen(),
        ),
      );
    } catch (e) {
      print('Terms error: $e');
      _showSnackBar('Could not open terms. Please try again.');
    }
  }

  // SIMPLIFIED CONTACT SUPPORT - JUST LIKE YOUR WORKING APP
  Future<void> _launchEmail(String email) async {
    try {
      // Simple mailto URL - this is what works in your other app
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          'subject': 'Where in the Law App - Support Request',
        },
      );
      
      print('Launching email: $emailLaunchUri');
      
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        // Fallback: Show email in dialog for manual copy
        _showEmailFallbackDialog(email);
      }
    } catch (e) {
      print('Email launch error: $e');
      _showEmailFallbackDialog(email);
    }
  }

  void _showEmailFallbackDialog(String email) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please email us at:'),
            const SizedBox(height: 10),
            SelectableText(
              email,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3498DB),
              ),
            ),
            const SizedBox(height: 10),
            const Text('You can copy this email to your clipboard.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _copyToClipboard(email);
              Navigator.pop(context);
              _showSnackBar('Email address copied to clipboard');
            },
            child: const Text('Copy Email'),
          ),
        ],
      ),
    );
  }

  Future<void> _copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
    } catch (e) {
      print('Copy to clipboard error: $e');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    final colors = {
      'Housing': const Color(0xFF8E44AD),
      'Rights & Freedoms': const Color(0xFF3498DB),
      'Business': const Color(0xFF2ECC71),
      'Employment': const Color(0xFFE67E22),
      'Environment': const Color(0xFF1ABC9C),
      'Consumer Rights': const Color(0xFFE74C3C),
      'Education': const Color(0xFF9B59B6),
      'Health': const Color(0xFFE91E63),
      'Family & Personal': const Color(0xFF795548),
      'Justice & Legal Aid': const Color(0xFF607D8B),
      'Property & Housing': const Color(0xFF8E44AD),
      'Transport': const Color(0xFF009688),
      'Technology & Communication': const Color(0xFF3F51B5),
    };
    return colors[category] ?? const Color(0xFF7F8C8D);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghana Law Library'),
        centerTitle: true,
        backgroundColor: const Color(0xFF3498DB),
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const Border(
          bottom: BorderSide(
            color: Color(0xFFD4AF37),
            width: 2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: _handleFavoriteTap,
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: _handleSearchTap,
          ),
//Game Button
          IconButton(
  icon: const Icon(Icons.sports_esports, color: Colors.white),
  onPressed: () {
    AdService.showInterstitialAd(
      screenName: 'HomeScreen',
      action: 'game_button',
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GameHomeScreen(),
      ),
    );
  },
  tooltip: 'Play Law Master Game',
),


        
          // 3-dot menu button - USING SIMPLE APPROACH LIKE YOUR WORKING APP
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'tutorial':
                  _handleTutorialTap();
                  break;
                case 'faq':
                  _handleFaqTap();
                  break;
                case 'privacy':
                  _handlePrivacyPolicyTap();
                  break;
                case 'terms':
                  _handleTermsTap();
                  break;
                case 'contact':
                  _launchEmail('life2allsofts@gmail.com');
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'tutorial',
                  child: ListTile(
                    leading: Icon(Icons.school, color: Colors.purple),
                    title: Text('Tutorial & Guide'),
                    subtitle: Text('Step-by-step guide'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'faq',
                  child: ListTile(
                    leading: Icon(Icons.help_outline, color: Colors.blue),
                    title: Text('FAQ'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'privacy',
                  child: ListTile(
                    leading: Icon(Icons.privacy_tip, color: Colors.green),
                    title: Text('Privacy Policy'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'terms',
                  child: ListTile(
                    leading: Icon(Icons.description, color: Colors.orange),
                    title: Text('Terms of Service'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'contact',
                  child: ListTile(
                    leading: Icon(Icons.mail, color: Colors.red),
                    title: Text('Contact Support'),
                  ),
                ),
              ];
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
                            ? const Color(0xFF3498DB) 
                            : Colors.white,
                        foregroundColor: _selectedView == 'all' 
                            ? Colors.white 
                            : const Color(0xFF3498DB),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
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
                            ? const Color(0xFF8E44AD) 
                            : Colors.white,
                        foregroundColor: _selectedView == 'categories' 
                            ? Colors.white 
                            : const Color(0xFF8E44AD),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
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
                        color: const Color(0xFF7F8C8D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Chip(
                      label: Text(
                        _selectedCategory!,
                        style: const TextStyle(color: Colors.white),
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
                          color: const Color(0xFFE74C3C),
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
                            color: const Color(0xFF7F8C8D),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _selectedView == 'categories' && _selectedCategory == null
                                ? 'Select a category to view laws'
                                : 'No laws found',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color(0xFF7F8C8D),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: _filteredLaws.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: GestureDetector(
                            onTap: () => _handleLawCardTap(_filteredLaws[index]),
                            child: LawCard(law: _filteredLaws[index]),
                          ),
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