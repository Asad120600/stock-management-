import 'package:flutter/material.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/widgets/drawer.dart';

class ListCategoriesScreen extends StatefulWidget {
  const ListCategoriesScreen({super.key});

  @override
  _ListCategoriesScreenState createState() => _ListCategoriesScreenState();
}

class _ListCategoriesScreenState extends State<ListCategoriesScreen> {
  final List<Map<String, String>> _categories = [
    {"name": "Pizza", "description": "Pizza Ingredients"},
    {"name": "Burger", "description": "Burger Ingredients"},
    {"name": "Pasta", "description": "Pasta Ingredients"},
    {"name": "Salad", "description": "Salad Ingredients"},
  ];

  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(context);

    // Filtered list of categories based on search query
    List<Map<String, String>> filteredCategories = _categories
        .where((category) => category['name']!
        .toLowerCase()
        .contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List Categories",
          style: TextStyle(
            fontSize: ScreenUtil.setSp(18),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon press
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil.setWidth(16)),
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(vertical: ScreenUtil.setHeight(16)),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            // Category cards with alternating background colors
            Expanded(
              child: ListView.builder(
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryCard(index, filteredCategories);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each category card with alternating color styling
  Widget _buildCategoryCard(int index, List<Map<String, String>> categories) {
    Color cardColor = (index % 2 == 0) ? const Color(0xFFEDECEC) : const Color(0xFFDFC8FF);
    Map<String, String> category = categories[index];

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(bottom: ScreenUtil.setHeight(16)),
      child: ListTile(
        contentPadding: EdgeInsets.all(ScreenUtil.setWidth(16)),
        title: Text(
          "Category Name: ${category['name']}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil.setSp(16),
            color: const Color(0xFF54357E),
          ),
        ),
        subtitle: Text(
          "Description: ${category['description']}",
          style: TextStyle(fontSize: ScreenUtil.setSp(14)),
        ),
        trailing: Icon(
          Icons.more_vert,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
