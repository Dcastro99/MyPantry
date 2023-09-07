import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final Function(String, String) onSearch;
  final TextEditingController searchController;
  final String selectedCategory;
  final Function(String) onCategoryChange;

  const Header(
      {super.key,
      required this.onSearch,
      required this.searchController,
      required this.selectedCategory,
      required this.onCategoryChange});

  void _handleSearch(String query) {
    onSearch(query, selectedCategory);
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search for a Product'),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Enter product name...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _handleSearch('');
                searchController.clear();
              },
              child: const Text('Clear',
                  style: TextStyle(color: Color.fromARGB(255, 232, 111, 111))),
            ),
            ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(3),
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 232, 231, 231)),
              ),
              onPressed: () {
                Navigator.pop(context);
                _handleSearch(searchController.text);
              },
              child: const Text(
                'Search',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            _showSearchDialog(context);
          },
        ),
        const Spacer(),
        const Text(
          'Welcom to My Pantry',
          style: TextStyle(
            fontFamily: 'DancingScript',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ],
    );
  }
}
