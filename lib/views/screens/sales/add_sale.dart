import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Required for SharedPreferences
import 'package:stock_managment/services/token_service.dart';
import 'package:stock_managment/utils/screen_util.dart';
import 'package:stock_managment/widgets/button.dart';
import 'package:stock_managment/widgets/drawer.dart';


class AddSales extends StatefulWidget {
  const AddSales({super.key});

  @override
  _AddSalesState createState() => _AddSalesState();
}

class _AddSalesState extends State<AddSales> {
  final _formKey = GlobalKey<FormState>();
  final TokenService _tokenService = TokenService(); // Create an instance of TokenService

  int? _categoryId;
  int? _menuItemId;
  int? _quantityOfSale;

  List<dynamic> categories = [];
  List<dynamic> menuItems = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchFoodItems();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(
      Uri.parse('https://stock.cslancer.com/api/food-categories'),
      headers: {
        'Authorization': 'Bearer ${await _tokenService.getToken()}', // Use TokenService to get token
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        categories = jsonDecode(response.body);
      });
    } else {
      // Print error details for debugging
      print('Failed to load categories: ${response.statusCode} ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load categories: ${response.body}')),
      );
    }
  }

  Future<void> fetchFoodItems() async {
    final response = await http.get(
      Uri.parse('https://stock.cslancer.com/api/food-items'),
      headers: {
        'Authorization': 'Bearer ${await _tokenService.getToken()}', // Use TokenService to get token
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        menuItems = jsonDecode(response.body);
      });
    } else {
      // Print error details for debugging
      print('Failed to load food items: ${response.statusCode} ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load food items: ${response.body}')),
      );
    }
  }

  Future<void> addItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    // Prepare the data for the API
    final data = {
      "category_id": _categoryId.toString(),
      "food_item_id": _menuItemId.toString(),
      "quantity": _quantityOfSale.toString(),
    };

    // Use TokenService to get the token for the request
    String token = await _tokenService.getToken() ?? '';

    // Send a POST request to the API
    final response = await http.post(
      Uri.parse('https://stock.cslancer.com/api/sales'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      // Successfully added the item
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added successfully.')),
      );
      Navigator.pop(context);
    } else {
      // Print error details for debugging
      print('Failed to add item: ${response.statusCode} ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add item: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add Item',
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
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil.setWidth(16)),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Add Your Sale Item Details Here!',
                style: TextStyle(
                  fontSize: ScreenUtil.setSp(20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF54357E),
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: ScreenUtil.setHeight(16)),

              // Category dropdown
              _buildLabel('Category:'),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: categories.map<DropdownMenuItem<int>>((category) {
                  return DropdownMenuItem<int>(
                    value: category['id'],
                    child: Text(category['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _categoryId = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a category' : null,
                onSaved: (value) => _categoryId = value,
              ),
              SizedBox(height: ScreenUtil.setHeight(16)),

              // Menu Item dropdown
              _buildLabel('Menu Item:'),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: menuItems.map<DropdownMenuItem<int>>((menuItem) {
                  return DropdownMenuItem<int>(
                    value: menuItem['id'],
                    child: Text(menuItem['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _menuItemId = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a menu item' : null,
                onSaved: (value) => _menuItemId = value,
              ),
              SizedBox(height: ScreenUtil.setHeight(16)),

              // Quantity of sale field
              _buildLabel('Quantity of Sale:'),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Please enter a quantity' : null,
                onSaved: (value) => _quantityOfSale = int.tryParse(value!),
              ),
              SizedBox(height: ScreenUtil.setHeight(32)),

              // Save Item Button
              Button(onPressed: addItem, text: 'Save'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Nunito Sans',
        fontSize: ScreenUtil.setSp(22),
        fontWeight: FontWeight.w700,
        color: const Color(0xFF54357E),
        height: 1.36,
      ),
    );
  }
}
