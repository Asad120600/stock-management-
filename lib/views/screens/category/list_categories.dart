import 'package:flutter/material.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/widgets/card.dart';
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
            // Category cards
            Expanded(
              child: ListView.builder(
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  return CommonListItem(
                    title: "Category Name: ${filteredCategories[index]['name']}",
                    subtitle1: "Description: ${filteredCategories[index]['description']}",
                    onEdit: () {
                      print('Edit tapped for ${filteredCategories[index]['name']}');
                      // Add your edit logic here
                    },
                    onDelete: () {
                      setState(() {
                        // Add delete logic here if needed
                      });
                      print('Delete tapped for ${filteredCategories[index]['name']}');
                    },
                    index: index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
