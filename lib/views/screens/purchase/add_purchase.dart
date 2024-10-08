import 'package:flutter/material.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/token_service.dart';
import 'package:stock_managment/widgets/button.dart';
import 'package:stock_managment/widgets/dots.dart';
import 'package:stock_managment/widgets/drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPurchaseScreen extends StatefulWidget {
  const AddPurchaseScreen({super.key});

  @override
  _AddPurchaseScreenState createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends State<AddPurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TokenService _tokenService = TokenService();

  String? _name;
  int? _supplierId;
  int? _unitId;
  int? _ingredientId; // Added ingredient ID
  double? _quantity;
  double? _price;
  DateTime selectedDate = DateTime.now();

  List<dynamic> suppliers = [];
  List<dynamic> units = [];
  List<dynamic> ingredients = []; // List to hold ingredients
  bool isLoadingSuppliers = true;
  bool isLoadingUnits = true;
  bool isLoadingIngredients = true; // Loading state for ingredients

  @override
  void initState() {
    super.initState();
    fetchSuppliers();
    fetchUnits();
    fetchIngredients(); // Fetch ingredients on init
  }

  Future<void> fetchSuppliers() async {
    final token = await _tokenService.getToken();
    final response = await http.get(
      Uri.parse('http://stock.cslancer.com/api/suppliers'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        suppliers = json.decode(response.body);
        isLoadingSuppliers = false;
      });
    } else {
      setState(() {
        isLoadingSuppliers = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load suppliers')),
      );
    }
  }

  Future<void> fetchUnits() async {
    final token = await _tokenService.getToken();
    final response = await http.get(
      Uri.parse('http://stock.cslancer.com/api/units'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        units = json.decode(response.body);
        isLoadingUnits = false;
      });
    } else {
      setState(() {
        isLoadingUnits = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load units')),
      );
    }
  }

  Future<void> fetchIngredients() async { // New method to fetch ingredients
    final token = await _tokenService.getToken();
    final response = await http.get(
      Uri.parse('http://stock.cslancer.com/api/ingredients'), // Ensure this endpoint exists
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        ingredients = json.decode(response.body);
        isLoadingIngredients = false;
      });
    } else {
      setState(() {
        isLoadingIngredients = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load ingredients')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> addPurchase() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final token = await _tokenService.getToken();
    final response = await http.post(
      Uri.parse('http://stock.cslancer.com/api/purchases'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "ingredient_id": _ingredientId, // Include ingredient_id
        "supplier_id": _supplierId,
        "unit_id": _unitId,
        "quantity": _quantity,
        "price": _price,
        "expiration_date": selectedDate.toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Purchase added successfully.')),
      );
      Navigator.pop(context);
    } else {
      final responseBody = json.decode(response.body);
      print('Failed to add purchase: ${response.statusCode} - ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add purchase: ${responseBody['message']}')),
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
          'Add Purchase',
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
                'Add Your Purchase With Details Here!',
                style: TextStyle(
                  fontSize: ScreenUtil.setSp(20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF54357E),
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: ScreenUtil.setHeight(16)),

              // Name field
              _buildLabel('Name:'),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
                onSaved: (value) => _name = value,
              ),
              SizedBox(height: ScreenUtil.setHeight(16)),

              // Supplier dropdown
              _buildLabel('Supplier:'),
              isLoadingSuppliers
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: LoadingDots(),
              )
                  : DropdownButtonFormField<int>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: suppliers.map<DropdownMenuItem<int>>((supplier) {
                  return DropdownMenuItem<int>(
                    value: supplier['id'],
                    child: Text(supplier['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _supplierId = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a supplier' : null,
                onSaved: (value) => _supplierId = value,
              ),
              SizedBox(height: ScreenUtil.setHeight(16)),

              // Unit dropdown
              _buildLabel('Unit of Measurement:'),
              isLoadingUnits
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: LoadingDots(),
              )
                  : DropdownButtonFormField<int>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: units.map<DropdownMenuItem<int>>((unit) {
                  return DropdownMenuItem<int>(
                    value: unit['id'],
                    child: Text(unit['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _unitId = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a unit' : null,
                onSaved: (value) => _unitId = value,
              ),
              SizedBox(height: ScreenUtil.setHeight(16)),

              // Ingredient dropdown
              _buildLabel('Ingredient:'),
              isLoadingIngredients
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: LoadingDots(),
              )
                  : DropdownButtonFormField<int>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: ingredients.map<DropdownMenuItem<int>>((ingredient) {
                  return DropdownMenuItem<int>(
                    value: ingredient['id'],
                    child: Text(ingredient['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _ingredientId = value; // Save selected ingredient ID
                  });
                },
                validator: (value) => value == null ? 'Please select an ingredient' : null,
                onSaved: (value) => _ingredientId = value,
              ),
              SizedBox(height: ScreenUtil.setHeight(16)),

              // Quantity field
              _buildLabel('Quantity:'),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Please enter a quantity' : null,
                onSaved: (value) => _quantity = double.tryParse(value!),
              ),
              SizedBox(height: ScreenUtil.setHeight(16)),

              // Purchase Price field
              _buildLabel('Purchase Price:'),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Please enter a price' : null,
                onSaved: (value) => _price = double.tryParse(value!),
              ),
              SizedBox(height: ScreenUtil.setHeight(16)),

              // Expiration Date picker
              _buildLabel('Expiration Date:'),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text: "${selectedDate.toLocal()}".split(' ')[0],
                    ),
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil.setHeight(32)),

              // Add Purchase Button
              Button(onPressed: addPurchase, text: 'Add Purchase'),
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
