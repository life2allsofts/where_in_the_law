// screens/favorites_screen.dart
// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import '../services/favorites_service.dart';
import '../models/law_model.dart';
import 'package:where_in_the_law/models/widgets/law_card.dart';
import 'law_detail_screen.dart';
import '../services/ad_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Law>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    
    // Listen to ad service changes
    AdService().addListener(_onAdChanged);
    
    // Load ad after screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFavoritesAd();
    });
  }

  void _loadFavorites() {
    _favoritesFuture = FavoritesService.getFavorites();
  }

  void _loadFavoritesAd() {
    print('🔄 FavoritesScreen: Loading FAVORITES banner ad');
    AdService.loadFavoritesBannerAd(
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

  void _refreshFavorites() {
    AdService.showInterstitialAd(
      screenName: 'FavoritesScreen',
      action: 'refresh_button',
    );
    setState(() {
      _loadFavorites();
    });
  }

  void _handleFavoriteLawTap(Law law) {
    AdService.showInterstitialAd(
      screenName: 'FavoritesScreen',
      action: 'favorite_law_tap',
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LawDetailScreen(law: law),
      ),
    );
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
        title: const Text('Favorite Laws'),
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
            icon: Icon(Icons.refresh),
            onPressed: _refreshFavorites,
          ),
        ],
      ),
      body: Column(
        children: [
          // FAVORITES Banner Ad at TOP
          Container(
            color: Colors.transparent,
            width: double.infinity,
            height: 50,
            child: AdService.getFavoritesBannerAd(),
          ),
          Expanded(
            child: FutureBuilder<List<Law>>(
              future: _favoritesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading favorites'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 64,
                          color: Color(0xFF7F8C8D),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No favorite laws yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF7F8C8D),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap the heart icon on any law to add it here',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7F8C8D),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  final favorites = snapshot.data!;
                  return ListView.builder(
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _handleFavoriteLawTap(favorites[index]),
                        child: LawCard(law: favorites[index]),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}