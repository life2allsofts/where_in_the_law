import 'package:flutter/material.dart';
import 'package:where_in_the_law/models/law_model.dart';

class LawCard extends StatelessWidget {
  final Law law;

  const LawCard({super.key, required this.law});

  // Helper function to get category color
  Color _getCategoryColor(String category) {
    final colors = {
      'Housing': Color(0xFF8E44AD), // Purple
      'Rights & Freedoms': Color(0xFF3498DB), // Blue
      'Business': Color(0xFF2ECC71), // Green
      'Employment': Color(0xFFE67E22), // Orange
      'Environment': Color(0xFF1ABC9C), // Teal
      'Consumer Rights': Color(0xFFE74C3C), // Red
    };
    return colors[category] ?? Color(0xFF7F8C8D); // Default gray
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(law.category);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        // GOLD BORDER EFFECT
        border: Border.all(
          color: Color(0xFFD4AF37), // Gold color
          width: 1.5,
        ),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pushNamed(context, '/law_detail', arguments: law);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: categoryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    law.category,
                    style: TextStyle(
                      color: categoryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Title
                Text(
                  law.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8),
                // Law Reference
                Text(
                  '${law.lawName} (${law.lawCode}) - ${law.section}',
                  style: const TextStyle(
                    color: Color(0xFF7F8C8D),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                // Preview of explanation
                Text(
                  law.plainExplanation.length > 100
                      ? '${law.plainExplanation.substring(0, 100)}...'
                      : law.plainExplanation,
                  style: const TextStyle(
                    color: Color(0xFF34495E),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}