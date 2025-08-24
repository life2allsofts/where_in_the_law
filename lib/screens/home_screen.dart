import 'package:flutter/material.dart';
import '../models/law_model.dart';
import 'package:where_in_the_law/models/widgets/law_card.dart';
import 'search_screen.dart'; 

class HomeScreen extends StatefulWidget {
  final List<Law> laws;

  const HomeScreen({super.key, required this.laws});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Housing',
    'Rights & Freedoms',
    'Business',
    'Employment',
    'Environment',
    'Consumer Rights'
  ];

  List<Law> get _filteredLaws {
    if (_selectedCategory == 'All') {
      return widget.laws;
    }
    return widget.laws.where((law) => law.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghana Law Library'),
        centerTitle: true,
        actions: [
          // SEARCH BUTTON
          IconButton(
            icon: const Icon(Icons.search),
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
      body: Column(
        children: [
          // CATEGORY FILTER CHIP BAR
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : 'All';
                      });
                    },
                  ),
                );
              },
            ),
          ),
          // LAWS LIST
          Expanded(
            child: _filteredLaws.isEmpty
                ? const Center(
                    child: Text(
                      'No laws available in this category.',
                      style: TextStyle(fontSize: 16),
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