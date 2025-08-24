import 'package:flutter/material.dart';
import '../models/law_model.dart';

class CategoriesScreen extends StatelessWidget {
  final List<Law> laws;

  const CategoriesScreen({super.key, required this.laws});

  // Get unique categories from laws
  List<String> get _categories {
    final categories = laws.map((law) => law.category).toSet().toList();
    categories.sort();
    return categories;
  }

  // Count laws in each category
  int _getCategoryCount(String category) {
    return laws.where((law) => law.category == category).length;
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
        child: ListView(
          padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 24),
            // Category Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
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
                    onTap: () {
                      Navigator.pop(context, category);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Category Icon
                          Icon(
                            _getCategoryIcon(category),
                            size: 32,
                            color: categoryColor,
                          ),
                          const SizedBox(height: 8),
                          // Category Name
                          Text(
                            category,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Law Count
                          Text(
                            '$count law${count != 1 ? 's' : ''}',
                            style: TextStyle(
                              fontSize: 12,
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
          ],
        ),
      ),
    );
  }
}