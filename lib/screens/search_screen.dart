import 'package:flutter/material.dart';
import '../models/law_model.dart';
import 'package:where_in_the_law/models/widgets/law_card.dart';


class SearchScreen extends StatefulWidget {
  final List<Law> allLaws;

  const SearchScreen({super.key, required this.allLaws});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Law> _filteredLaws = [];

  void _filterLaws(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredLaws = [];
      } else {
        _filteredLaws = widget.allLaws.where((law) {
          return law.title.toLowerCase().contains(query.toLowerCase()) ||
              law.searchKeywords.any((keyword) => 
                  keyword.toLowerCase().contains(query.toLowerCase())) ||
              law.category.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _filteredLaws = widget.allLaws;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 appBar: AppBar(
  title: Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(8),
    ),
    child: TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search laws...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(Icons.search, color: Colors.white),
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
      style: TextStyle(color: Colors.white), // White text for visibility
      autofocus: true,
      onChanged: _filterLaws,
    ),
  ),
  backgroundColor: Color(0xFF3498DB), // Blue
  iconTheme: IconThemeData(color: Colors.white),
  actions: [
    IconButton(
      icon: Icon(Icons.clear, color: Colors.white),
      onPressed: () {
        _searchController.clear();
        _filterLaws('');
      },
    ),
  ],
),
      body: _filteredLaws.isEmpty
          ? const Center(
              child: Text(
                'No laws found. Try different keywords.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _filteredLaws.length,
              itemBuilder: (context, index) {
                return LawCard(law: _filteredLaws[index]);
              },
            ),
    );
  }
}