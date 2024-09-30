import 'package:flutter/material.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/widgets/card.dart';
import 'package:stock_managment/widgets/drawer.dart';

class ListIngredientsUnitScreen extends StatefulWidget {
  const ListIngredientsUnitScreen({super.key});

  @override
  _ListIngredientsUnitScreenState createState() => _ListIngredientsUnitScreenState();
}

class _ListIngredientsUnitScreenState extends State<ListIngredientsUnitScreen> {
  TextEditingController searchController = TextEditingController();

  // Sample data for ingredients
  List<Map<String, dynamic>> ingredients = [
    {'Unit Name': 'Psc', 'Description': 'Pieces'},
    {'Unit Name': 'g', 'Description': 'gram'},
    {'Unit Name': 'kg', 'Description': 'kilo gram'},
    {'Unit Name': 'Box', 'Description': 'Boxes'},
    {'Unit Name': 'ml', 'Description': 'milli liter'},
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'List Ingredients Unit',
          style: TextStyle(
            fontSize: ScreenUtil.setSp(22),
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil.setWidth(16)),
        child: Column(
          children: [
            // Search Bar
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ScreenUtil.setWidth(20)),
                ),
              ),
            ),
            SizedBox(height: ScreenUtil.setHeight(16)),

            // List of ingredients
            Expanded(
              child: ListView.builder(
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  final ingredient = ingredients[index];

                  return CommonListItem(

                    title: ingredient['Unit Name'],
                    subtitle1: "Description: ${ingredient['Description']}",
                     // You can leave this empty or add more details if needed
                    onEdit: () {
                      print('Edit tapped for ${ingredient['Unit Name']}');
                      // Add your edit logic here
                    },
                    onDelete: () {
                      setState(() {
                        // Logic for deleting the ingredient
                        ingredients.removeAt(index); // Example deletion
                      });
                      print('Delete tapped for ${ingredient['Unit Name']}');
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
