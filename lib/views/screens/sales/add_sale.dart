import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  final TokenService _tokenService = TokenService();

  int? _categoryId;
  int? _menuItemId;
  int? _quantityOfSale;
  double? _totalAmount; // New field for total amount spent
  double? _itemPrice; // Field to store the price of the selected menu item

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
        'Authorization': 'Bearer ${await _tokenService.getToken()}',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        menuItems = jsonDecode(response.body);
      });
    } else {
      print('Failed to load food items: ${response.statusCode} ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load food items: ${response.body}')),
      );
    }
  }

  void _calculateTotalAmount() {
    if (_quantityOfSale != null && _quantityOfSale! > 0 && _itemPrice != null && _itemPrice! > 0.0) {
      setState(() {
        _totalAmount = _quantityOfSale! * _itemPrice!;
        print(_totalAmount);
      });
    } else {
      setState(() {
        _totalAmount = 0.0; // Set default to 0.0 if values are invalid
      });
    }
  }


  Future<void> addItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    // Prepare the data for the API, including total_amount_of_sale
    final data = {
      "category_id": _categoryId.toString(),
      "food_item_id": _menuItemId.toString(),
      "quantity": _quantityOfSale.toString(),
      "total_amount_of_sale": _totalAmount?.toStringAsFixed(2) ?? '0.00', // total_amount as string
    };

    // Debugging: Print the data to be sent to the API
    print('Data to be sent: $data');

    // Use TokenService to get the token
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

    // Debugging: Log the response status code and body
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added successfully.')),
      );
      Navigator.pop(context);
    } else {
      print('Failed to add sale: ${response.statusCode} ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add sale: ${response.body}')),
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
          'Add Sale ',
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

                    // Safely access the price and handle potential null or missing values
                    var selectedItem = menuItems.firstWhere((item) => item['id'] == value, orElse: () => null);

                    if (selectedItem != null) {
                      // Parse sale_price as double, if it fails, default to 0.0
                      _itemPrice = double.tryParse(selectedItem['sale_price']) ?? 0.0;
                      // Debugging: Log the selected item and its parsed price
                      print('Selected Menu Item: ${selectedItem['name']}');
                      print('Parsed Price: $_itemPrice');
                    } else {
                      print('No item found with id $value');
                      _itemPrice = 0.0;
                    }

                    // Calculate total if both price and quantity are set
                    _calculateTotalAmount();
                  });
                },
                validator: (value) => value == null ? 'Please select a menu item' : null,
                onSaved: (value) => _menuItemId = value,
              ),
              SizedBox(height: ScreenUtil.setHeight(16)),
              _buildLabel('Quantity of Sale:'),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Please enter a quantity' : null,
                onChanged: (value) {
                  setState(() {
                    _quantityOfSale = int.tryParse(value) ?? 0;
                    _calculateTotalAmount(); // Recalculate total when the quantity changes
                  });
                },
              ),
              SizedBox(height: ScreenUtil.setHeight(16)),
              _buildLabel('Total Amount:'),
              Text(
                _totalAmount != null && _totalAmount! > 0 ? '${_totalAmount!.toStringAsFixed(2)}' : 'N/A',
                style: TextStyle(
                  fontSize: ScreenUtil.setSp(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ScreenUtil.setHeight(32)),
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
