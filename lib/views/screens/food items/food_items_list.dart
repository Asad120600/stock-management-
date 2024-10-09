import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:stock_managment/model/food_item_model.dart';
import 'package:stock_managment/utils/screen_util.dart';
import 'package:stock_managment/services/token_service.dart';
import 'package:stock_managment/widgets/drawer.dart';
import 'package:stock_managment/widgets/product_item.dart';

class MenuList extends StatefulWidget {
  const MenuList({super.key});

  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  List<FoodItem> foodItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFoodItems();
  }

  Future<void> _fetchFoodItems() async {
    final token = await TokenService().getToken(); // Fetch token dynamically
    final response = await http.get(
      Uri.parse('https://stock.cslancer.com/api/food-items'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        foodItems = data.map((item) => FoodItem.fromJson(item)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      log('Failed to load food items');
    }
  }

  Future<void> _deleteFoodItem(String id) async {
    final token = await TokenService().getToken(); // Fetch token dynamically
    final response = await http.delete(
      Uri.parse('https://stock.cslancer.com/api/food-items/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 204) {
      setState(() {
        foodItems.removeWhere((item) => item.id == id); // Update the list after deletion
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Food item deleted successfully')),
      );
      await _fetchFoodItems();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete food item')),
      );
      log('Failed to delete food item: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Menu Item List",
          style: TextStyle(
            fontSize: ScreenUtil.setSp(18),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        toolbarHeight: ScreenUtil.setHeight(60),
      ),
      drawer: const AppDrawer(),
      body: isLoading
          ? const Center(
        child: SpinKitFadingCircle(
          color: Colors.blue,
          size: 50.0,
        ), // Show spinner while loading
      ): RefreshIndicator(
        onRefresh: _fetchFoodItems,
        child: Column(
          children: [
            // Table header with background color
            Container(
              color: const Color(0xFF54357E), // Set header background color
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil.setWidth(16.0),
                  vertical: ScreenUtil.setHeight(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Sr#",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil.setSp(14),
                          color: Colors.white, // Change text color to white for visibility
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        "Products",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil.setSp(14),
                          color: Colors.white, // Change text color to white for visibility
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Action",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil.setSp(14),
                          color: Colors.white, // Change text color to white for visibility
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1),
            // List of products
            Expanded(
              child: ListView.builder(
                itemCount: foodItems.length,
                itemBuilder: (context, index) {
                  return ProductItem(
                    srNo: (index + 1).toString(),
                    name: foodItems[index].name,
                    details: foodItems[index].code,
                    onEdit: () {
                      log("Edit tapped for ${foodItems[index].name}");
                    },
                    onDelete: () {
                      _deleteFoodItem(foodItems[index].id.toString());
                    },
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

