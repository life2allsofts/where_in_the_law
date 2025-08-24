import 'package:flutter/material.dart';
import 'package:where_in_the_law/models/law_model.dart';
import 'package:where_in_the_law/services/favorites_service.dart';

class LawCard extends StatefulWidget {
  final Law law;

  const LawCard({super.key, required this.law});

  @override
  _LawCardState createState() => _LawCardState();
}

class _LawCardState extends State<LawCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.law.isFavorite;
    _loadFavoriteStatus();
  }

  void _loadFavoriteStatus() async {
    final isFav = await FavoritesService.isFavorite(widget.law.id);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  void _toggleFavorite() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    await FavoritesService.toggleFavorite(widget.law);
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(widget.law.category);

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
        border: Border.all(
          color: Color(0xFFD4AF37),
          width: 1.5,
        ),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pushNamed(context, '/law_detail', arguments: widget.law);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                        widget.law.category,
                        style: TextStyle(
                          color: categoryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Spacer(),
                    // Favorite Button
                    IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Title
                Text(
                  widget.law.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8),
                // Law Reference
                Text(
                  '${widget.law.lawName} (${widget.law.lawCode}) - ${widget.law.section}',
                  style: const TextStyle(
                    color: Color(0xFF7F8C8D),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                // Preview of explanation
                Text(
                  widget.law.plainExplanation.length > 100
                      ? '${widget.law.plainExplanation.substring(0, 100)}...'
                      : widget.law.plainExplanation,
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
}