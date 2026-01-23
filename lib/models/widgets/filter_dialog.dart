// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final List<String> allCategories;
  final List<String> selectedCategories;

  const FilterDialog({
    super.key,
    required this.allCategories,
    required this.selectedCategories,
  });

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late List<String> _selectedCategories;

  @override
  void initState() {
    super.initState();
    _selectedCategories = List.from(widget.selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter by Categories'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.allCategories.length,
          itemBuilder: (context, index) {
            final category = widget.allCategories[index];
            return CheckboxListTile(
              title: Text(category),
              value: _selectedCategories.contains(category),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, _selectedCategories);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}