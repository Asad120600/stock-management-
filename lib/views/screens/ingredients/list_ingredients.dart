import 'package:flutter/material.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/widgets/drawer.dart';

class ListIngredientsScreen extends StatefulWidget {
  const ListIngredientsScreen({super.key});

  @override
  State<ListIngredientsScreen> createState() => _ListIngredientsScreenState();
}

class _ListIngredientsScreenState extends State<ListIngredientsScreen> {
  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List Ingredients",
          style: TextStyle(
            fontSize: ScreenUtil.setSp(18), // Responsive text size
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
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil.setWidth(16),
        ),
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(vertical: ScreenUtil.setHeight(16)),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // Ingredient cards with alternating background colors
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Simulating three items
                itemBuilder: (context, index) {
                  return _buildIngredientCard(context, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each ingredient card with alternating color styling
  Widget _buildIngredientCard(BuildContext context, int index) {
    // Interchanging colors: even index - one color, odd index - another color
    Color cardColor = (index % 2 == 0) ? const Color(0xFFEDECEC) : const Color(0xFFDFC8FF);

    return Container(
      decoration: BoxDecoration(
        color: cardColor, // Alternating background colors
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      margin: EdgeInsets.only(bottom: ScreenUtil.setHeight(16)),
      child: ListTile(
        contentPadding: EdgeInsets.all(ScreenUtil.setWidth(16)), // Adjust padding inside the tile
        title: Text(
          "Pizza",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil.setSp(16), // Adjust text size
            color: const Color(0xFF54357E), // Primary color similar to your theme
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ScreenUtil.setHeight(8)), // Space between title and subtitle
            Text(
              "Code: IG-005",
              style: TextStyle(fontSize: ScreenUtil.setSp(14)),
            ),
            Text(
              "Category: Food",
              style: TextStyle(fontSize: ScreenUtil.setSp(14)),
            ),
            Text(
              "Purchased Unit: Box",
              style: TextStyle(fontSize: ScreenUtil.setSp(14)),
            ),
          ],
        ),
        trailing: PopupMenuButton<int>(
          icon: Icon(
            Icons.more_vert,
            color: Colors.grey[600], // Trailing icon color to match the theme
          ),
          onSelected: (value) {
            if (value == 1) {
              // Handle edit action
              print('Edit tapped');
            } else if (value == 2) {
              // Handle delete action
              print('Delete tapped');
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Row(
                children: const [
                  Icon(Icons.edit, color: Colors.black54),
                  SizedBox(width: 8),
                  Text("Edit"),
                ],
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: Row(
                children: const [
                  Icon(Icons.delete, color: Colors.black54),
                  SizedBox(width: 8),
                  Text("Delete"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
