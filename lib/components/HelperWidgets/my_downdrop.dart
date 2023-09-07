import 'package:flutter/material.dart';

class MyDropdown extends StatelessWidget {
  final List<String> items;
  final String selectedItem;
  final void Function(String?) onChanged;
  final Map<String, TextStyle>? itemStyles; // Add this line

  const MyDropdown({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    this.itemStyles, // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: DropdownButton<String>(
        value: selectedItem,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: itemStyles != null ? itemStyles![item] : null, // Apply custom style if available
            ),
          );
        }).toList(),
        onChanged: onChanged,
        isExpanded: true,
        underline: Container(
          height: 1,
          color: Colors.grey,
        ),
      ),
    );
  }
}
