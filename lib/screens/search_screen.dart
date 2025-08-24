import 'package:flutter/material.dart';
import '../models/law_model.dart';
import 'package:where_in_the_law/models/widgets/law_card.dart';
import 'package:where_in_the_law/models/widgets/filter_dialog.dart';

class SearchScreen extends StatefulWidget {
  final List<Law> allLaws;

  const SearchScreen({super.key, required this.allLaws});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<Law> _filteredLaws;
  final TextEditingController _searchController = TextEditingController();
  List<String> _selectedCategories = [];

  List<String> get _allCategories {
    return widget.allLaws.map((law) => law.category).toSet().toList()..sort();
  }

  void _filterLaws(String query) {
    setState(() {
      if (query.isEmpty && _selectedCategories.isEmpty) {
        _filteredLaws = [];
      } else {
        _filteredLaws = widget.allLaws.where((law) {
          final matchesText = query.isEmpty || 
              law.title.toLowerCase().contains(query.toLowerCase()) ||
              law.searchKeywords.any((keyword) => 
                  keyword.toLowerCase().contains(query.toLowerCase())) ||
              law.plainExplanation.toLowerCase().contains(query.toLowerCase());

          final matchesCategory = _selectedCategories.isEmpty || 
              _selectedCategories.contains(law.category);

          return matchesText && matchesCategory;
        }).toList();
      }
    });
  }

  Future<void> _showFilterDialog() async {
    final selectedCategories = await showDialog<List<String>>(
      context: context,
      builder: (context) => FilterDialog(
        allCategories: _allCategories,
        selectedCategories: _selectedCategories,
      ),
    );

    if (selectedCategories != null) {
      setState(() {
        _selectedCategories = selectedCategories;
        _filterLaws(_searchController.text);
      });
    }
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
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search laws...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
            prefixIcon: Icon(Icons.search, color: Colors.white),
          ),
          style: TextStyle(color: Colors.white),
          autofocus: true,
          onChanged: _filterLaws,
        ),
        backgroundColor: Color(0xFF3498DB),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
          if (_searchController.text.isNotEmpty || _selectedCategories.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _selectedCategories = [];
                  _filteredLaws = [];
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips for selected categories
          if (_selectedCategories.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[100],
              child: Wrap(
                spacing: 8,
                children: _selectedCategories.map((category) {
                  return Chip(
                    label: Text(category),
                    onDeleted: () {
                      setState(() {
                        _selectedCategories.remove(category);
                        _filterLaws(_searchController.text);
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          // Results
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
                        SizedBox(height: 16),
                        Text(
                          _searchController.text.isEmpty && _selectedCategories.isEmpty
                              ? 'Start typing to search laws'
                              : 'No laws found matching your criteria',
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
        ],
      ),
    );
  }
}