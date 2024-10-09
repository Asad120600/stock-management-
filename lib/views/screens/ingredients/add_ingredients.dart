import 'package:flutter/material.dart';
import 'package:stock_managment/utils/screen_util.dart';
import 'package:stock_managment/views/screens/dashboard/dashboard_screen.dart';
import 'package:stock_managment/widgets/button.dart';
import 'package:stock_managment/widgets/dots.dart';
import 'package:stock_managment/widgets/drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AddIngredientScreen extends StatefulWidget {
  const AddIngredientScreen({super.key});

  @override
  _AddIngredientScreenState createState() => _AddIngredientScreenState();
}

class _AddIngredientScreenState extends State<AddIngredientScreen> {
  String? selectedCategory;
  int? selectedPurchaseUnitId;
  int? selectedConsumeUnitId;

  List<String> categories = [];
  List<Map<String, dynamic>> purchaseUnits = [];
  List<Map<String, dynamic>> consumptionUnits = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _conversionRateController = TextEditingController();
  final TextEditingController _purchasePriceController = TextEditingController();
  final TextEditingController _costPerUnitController = TextEditingController();
  final TextEditingController _lowQtyController = TextEditingController();

  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchUnits();
  }

  Future<void> _fetchCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print('No token found. Please log in again.');
      return;
    }

    try {
      final url = Uri.parse('https://stock.cslancer.com/api/food-categories');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          categories = data.map((category) => category['name'].toString()).toList().cast<String>();
        });
      } else {
        print('Error fetching categories: ${response.body}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> _fetchUnits() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print('No token found. Please log in again.');
      return;
    }

    try {
      final url = Uri.parse('https://stock.cslancer.com/api/units');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          purchaseUnits = List<Map<String, dynamic>>.from(data);
          consumptionUnits = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print('Error fetching units: ${response.body}');
      }
    } catch (e) {
      print('Error fetching units: $e');
    }
  }

  Future<void> _addIngredient() async {
    if (_formKey.currentState?.validate() ?? false) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication required. Please log in again.')),
        );
        return;
      }

      final url = Uri.parse('https://stock.cslancer.com/api/ingredients');

      try {
        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "name": _nameController.text,
            "code": _codeController.text,
            "purchase_unit_id": selectedPurchaseUnitId,
            "consumption_unit_id": selectedConsumeUnitId,
            "conversion_rate": int.tryParse(_conversionRateController.text) ?? 0,
            "purchase_price": double.tryParse(_purchasePriceController.text) ?? 0.0,
            "cost_per_unit": double.tryParse(_costPerUnitController.text) ?? 0.0,
            "low_qty": int.tryParse(_lowQtyController.text) ?? 0,
          }),
        );

        if (response.statusCode == 201) {
          _clearFields();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ingredient added successfully!')),
          );

          // Use pushAndRemoveUntil to navigate to DashboardScreen
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
                (route) => false,
          );
        } else {
          print('Error adding ingredient: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add ingredient: ${response.body}')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    }
  }

  void _clearFields() {
    _nameController.clear();
    _codeController.clear();
    _conversionRateController.clear();
    _purchasePriceController.clear();
    _costPerUnitController.clear();
    _lowQtyController.clear();
    setState(() {
      selectedCategory = null;
      selectedPurchaseUnitId = null;
      selectedConsumeUnitId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Ingredients",
          style: TextStyle(
            fontSize: ScreenUtil.setSp(18),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil.setWidth(16)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ScreenUtil.setHeight(20)),
              Text(
                "Add Ingredients Of Your Food Here!",
                style: TextStyle(
                  fontSize: ScreenUtil.setSp(18),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF54357E),
                ),
              ),
              SizedBox(height: ScreenUtil.setHeight(20)),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(controller: _nameController, label: "Name * ", validator: _validateRequired),
                    SizedBox(height: ScreenUtil.setHeight(16)),
                    _buildTextField(controller: _codeController, label: "Code"),
                    SizedBox(height: ScreenUtil.setHeight(16)),
                    _buildCategoryDropdown(label: "Category *"),
                    SizedBox(height: ScreenUtil.setHeight(16)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildUnitDropdown(
                            label: "Purchase Unit *",
                            selectedValue: selectedPurchaseUnitId != null
                                ? purchaseUnits.firstWhere((unit) => unit['id'] == selectedPurchaseUnitId)['name']
                                : null,
                            onChanged: (value) {
                              setState(() {
                                if (value != null) {
                                  selectedPurchaseUnitId = purchaseUnits.firstWhere((unit) => unit['name'] == value)['id'];
                                }
                              });
                            },
                            units: purchaseUnits.map((unit) => unit['name'] as String).toList(),
                          ),
                        ),
                        SizedBox(width: ScreenUtil.setWidth(8)),
                        Expanded(
                          child: _buildUnitDropdown(
                            label: "Consume Unit *",
                            selectedValue: selectedConsumeUnitId != null
                                ? consumptionUnits.firstWhere((unit) => unit['id'] == selectedConsumeUnitId)['name']
                                : null,
                            onChanged: (value) {
                              setState(() {
                                if (value != null) {
                                  selectedConsumeUnitId = consumptionUnits.firstWhere((unit) => unit['name'] == value)['id'];
                                }
                              });
                            },
                            units: consumptionUnits.map((unit) => unit['name'] as String).toList(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil.setHeight(16)),
                    _buildTextField(controller: _conversionRateController, label: "Conversion Rate"),
                    SizedBox(height: ScreenUtil.setHeight(16)),
                    _buildTextField(controller: _purchasePriceController, label: "Purchase Price"),
                    SizedBox(height: ScreenUtil.setHeight(16)),
                    _buildTextField(controller: _costPerUnitController, label: "Cost Per Unit"),
                    SizedBox(height: ScreenUtil.setHeight(16)),
                    _buildTextField(controller: _lowQtyController, label: "Low Quantity"),
                    SizedBox(height: ScreenUtil.setHeight(16)),
                    isLoading
                        ? LoadingDots() // Show LoadingDots when loading
                        : Button(
                      onPressed: _addIngredient,
                      text: "Add Ingredient",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Widget _buildCategoryDropdown({required String label}) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: categories.map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCategory = value;
        });
      },
      validator: (value) => value == null ? 'Please select a category' : null,
    );
  }

  Widget _buildUnitDropdown({
    required String label,
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
    required List<String> units,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      value: selectedValue,
      items: units.map((String unit) {
        return DropdownMenuItem<String>(
          value: unit,
          child: Text(unit),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select a unit' : null,
    );
  }

  String? _validateRequired(String? value) {
    return (value == null || value.isEmpty) ? 'This field is required' : null;
  }
}
