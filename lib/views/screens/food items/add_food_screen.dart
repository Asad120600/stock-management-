import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stock_managment/utils/screen_util.dart';
import 'package:stock_managment/services/token_service.dart';
import 'package:stock_managment/views/screens/dashboard/dashboard_screen.dart';
import 'package:stock_managment/widgets/button.dart';
import 'package:stock_managment/widgets/dots.dart';
import 'package:stock_managment/widgets/drawer.dart';

class AddFoodMenuScreen extends StatefulWidget {
  const AddFoodMenuScreen({Key? key}) : super(key: key);

  @override
  _AddFoodMenuScreenState createState() => _AddFoodMenuScreenState();
}

class _AddFoodMenuScreenState extends State<AddFoodMenuScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  List<dynamic> _categories = [];
  List<dynamic> _ingredients = [];
  int? _selectedCategory;
  int? _selectedIngredient;
  List<Map<String, dynamic>> _selectedIngredients = [];
  bool _isCategoriesLoading = true;
  bool _isIngredientsLoading = true;
  bool _isLoading = false;

  final TokenService _tokenService = TokenService();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchIngredients();
  }

  Future<void> _fetchCategories() async {
    try {
      final token = await _tokenService.getToken();
      final response = await http.get(
        Uri.parse('https://stock.cslancer.com/api/food-categories'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _categories = json.decode(response.body);
        });
      } else {
        log('Failed to load categories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching categories: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load categories: $e')),
      );
    } finally {
      setState(() {
        _isCategoriesLoading = false;
      });
    }
  }

  Future<void> _fetchIngredients() async {
    try {
      final token = await _tokenService.getToken();
      final response = await http.get(
        Uri.parse('https://stock.cslancer.com/api/ingredients'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _ingredients = json.decode(response.body);
        });
      } else {
        log('Failed to load ingredients. Status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching ingredients: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load ingredients: $e')),
      );
    } finally {
      setState(() {
        _isIngredientsLoading = false;
      });
    }
  }

  Future<void> _createFoodItem() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String ingredientsJson = json.encode(_selectedIngredients);

      final body = json.encode({
        "name": _nameController.text,
        "code": _codeController.text,
        "category_id": _selectedCategory,
        "sale_price": double.parse(_salePriceController.text),
        "ingredients": ingredientsJson,
      });

      try {
        final token = await _tokenService.getToken();
        final response = await http.post(
          Uri.parse('https://stock.cslancer.com/api/food-items'),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token',
          },
          body: body,
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Food item created successfully')),
          );
          _clearForm();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create food item')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating food item: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _codeController.clear();
    _salePriceController.clear();
    _quantityController.clear();
    setState(() {
      _selectedCategory = null;
      _selectedIngredient = null;
      _selectedIngredients.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Food Menu",
          style: TextStyle(
            fontSize: ScreenUtil.setSp(18),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? Center(child: LoadingDots()) // Show loading indicator
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil.setWidth(16)),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ScreenUtil.setHeight(10)),
                Text(
                  "Add Food Category Menu Of Your Food Here!",
                  style: TextStyle(
                    fontSize: ScreenUtil.setSp(18),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF54357E),
                  ),
                ),
                SizedBox(height: ScreenUtil.setHeight(10)),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(controller: _nameController, label: "Name *"),
                    ),
                    SizedBox(width: ScreenUtil.setWidth(8)),
                    Expanded(
                      child: _buildTextField(controller: _codeController, label: "Code"),
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil.setHeight(12)),
                _isCategoriesLoading
                    ? Center(child: LoadingDots())
                    : _buildDropdownField(
                  label: "Category *",
                  items: _categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category['id'],
                      child: Text(category['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value as int?;
                    });
                  },
                  value: _selectedCategory,
                ),
                SizedBox(height: ScreenUtil.setHeight(12)),
                _isIngredientsLoading
                    ? Center(child: LoadingDots())
                    : _buildDropdownField(
                  label: "Select Ingredient *",
                  items: _ingredients.map((ingredient) {
                    return DropdownMenuItem<int>(
                      value: ingredient['id'],
                      child: Text(ingredient['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedIngredient = value as int?;
                    });
                  },
                  value: _selectedIngredient,
                ),
                SizedBox(height: ScreenUtil.setHeight(12)),
                _buildTextField(controller: _quantityController, label: "Quantity (e.g., 200g)"),
                SizedBox(height: ScreenUtil.setHeight(12)),
                Button(
                  onPressed: (_selectedIngredient == null) ? () {} : _addIngredient,
                  text: "Add Ingredient",
                  width: double.infinity,
                  leadingIcon: const Icon(Icons.add, size: 20, color: Colors.white),
                ),
                SizedBox(height: ScreenUtil.setHeight(20)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildTextField(controller: _salePriceController, label: "Sale Price *"),
                    ),
                    SizedBox(width: ScreenUtil.setWidth(12)),
                    Expanded(
                      flex: 2,
                      child: Button(
                        onPressed: _createFoodItem,
                        text: "Add Food Item",
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil.setHeight(20)),
                const Text(
                  "Selected Ingredients:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: ScreenUtil.setHeight(8)),
                ..._selectedIngredients.map((ingredient) {
                  return Container(
                    margin: EdgeInsets.only(bottom: ScreenUtil.setHeight(12)),
                    padding: EdgeInsets.all(ScreenUtil.setHeight(12)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xFFF0F0F0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ingredient['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text("Quantity: ${ingredient['quantity']}"),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _removeIngredient(ingredient['id']),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                SizedBox(height: ScreenUtil.setHeight(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),

    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<DropdownMenuItem<int>> items,
    required void Function(int?) onChanged,
    required int? value,
  }) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items,
      onChanged: onChanged,
      value: value,
    );
  }

  void _addIngredient() {
    if (_quantityController.text.isNotEmpty && _selectedIngredient != null) {
      setState(() {
        final selected = _ingredients.firstWhere(
              (ingredient) => ingredient['id'] == _selectedIngredient,
        );

        _selectedIngredients.add({
          "id": selected['id'],
          "name": selected['name'],
          "quantity": _quantityController.text,
        });

        _quantityController.clear();
        _selectedIngredient = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select ingredient and quantity')),
      );
    }
  }

  void _removeIngredient(int id) {
    setState(() {
      _selectedIngredients.removeWhere((ingredient) => ingredient['id'] == id);
    });
  }
}
