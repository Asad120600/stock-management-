import 'package:flutter/material.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/widgets/drawer.dart';

class ListCategoriesScreen extends StatelessWidget {
  const ListCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List Categories",
          style: TextStyle(
            fontSize: ScreenUtil.setSp(18), // Responsive text size
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon press
            },
          ),
        ],
      ),
      drawer:AppDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil.setWidth(16),
        ),
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(vertical: ScreenUtil.setHeight(16)),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), // Added border radius for the search bar
                  ),
                ),
              ),
            ),
            // Category cards with alternating background colors
            Expanded(
              child: ListView.builder(
                itemCount: 4, // Simulating four items
                itemBuilder: (context, index) {
                  return _buildCategoryCard(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each category card with alternating color styling
  Widget _buildCategoryCard(int index) {
    // Interchanging colors: even index - one color, odd index - another color
    Color cardColor = (index % 2 == 0) ? const Color(0xFFEDECEC) : const Color(0xFFDFC8FF);

    return Container(
      decoration: BoxDecoration(
        color: cardColor, // Alternating background colors
        borderRadius: BorderRadius.circular(8), // Rounded corners for category card
      ),
      margin: EdgeInsets.only(bottom: ScreenUtil.setHeight(16)),
      child: ListTile(
        contentPadding: EdgeInsets.all(ScreenUtil.setWidth(16)), // Adjust padding inside the tile
        title: Text(
          "Category Name: Pizza",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil.setSp(16), // Adjust text size
            color: const Color(0xFF54357E), // Primary color similar to your theme
          ),
        ),
        subtitle: Text(
          "Description: Pizza Ingredients",
          style: TextStyle(fontSize: ScreenUtil.setSp(14)),
        ),
        trailing: Icon(
          Icons.more_vert,
          color: Colors.grey[600], // Trailing icon color to match the theme
        ),
      ),
    );
  }
}
