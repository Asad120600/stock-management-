import 'package:flutter/material.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/widgets/button.dart';
import 'package:stock_managment/widgets/drawer.dart';

class AddIngredientScreen extends StatefulWidget {
  const AddIngredientScreen({super.key});

  @override
  _AddIngredientScreenState createState() => _AddIngredientScreenState();
}

class _AddIngredientScreenState extends State<AddIngredientScreen> {
  // Dropdown selected values
  String? selectedCategory;
  String? selectedPurchaseUnit;
  String? selectedConsumeUnit;

  // Dropdown options
  final List<String> categories = ['Fish', 'Fruit', 'Meat', 'Oil'];
  final List<String> units = ['L', 'ml', 'g', 'Kg'];

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Ingredients",
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
                child: Column(
                  children: [
                    _buildTextField(label: "Name * "),
                    SizedBox(height: ScreenUtil.setHeight(16)),
                    _buildTextField(label: "Code"),
                    SizedBox(height: ScreenUtil.setHeight(16)),

                    // Category Dropdown
                    _buildCategoryDropdown(label: "Category *"),

                    SizedBox(height: ScreenUtil.setHeight(16)),

                    // Row for Purchase Unit and Consume Unit Dropdowns
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildUnitDropdown(
                            label: "Purchase Unit *",
                            selectedValue: selectedPurchaseUnit,
                            onChanged: (value) {
                              setState(() {
                                selectedPurchaseUnit = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: ScreenUtil.setWidth(8)), // Space between dropdowns
                        Expanded(
                          child: _buildUnitDropdown(
                            label: "Consume Unit *",
                            selectedValue: selectedConsumeUnit,
                            onChanged: (value) {
                              setState(() {
                                selectedConsumeUnit = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: ScreenUtil.setHeight(16)),
                    _buildTextField(label: "Conversion Rate *"),
                    SizedBox(height: ScreenUtil.setHeight(16)),

                    // Row for Purchased Price and Cost/Unit
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildTextField(label: "Purchased Price *"),
                        ),
                        SizedBox(width: ScreenUtil.setWidth(8)), // Space between text fields
                        Expanded(
                          child: _buildTextField(label: "Cost/Unit *"),
                        ),
                      ],
                    ),

                    SizedBox(height: ScreenUtil.setHeight(16)),
                    _buildTextField(label: "Low Qty *"),
                    SizedBox(height: ScreenUtil.setHeight(30)),

                    // Add Button
                    SizedBox(
                      width: double.infinity,
                      child: Button(
                        onPressed: () {
                          // Handle Add button press
                        },
                        text: "Add",
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil.setHeight(20)), // Added space at the bottom
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields with labels above
  Widget _buildTextField({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ScreenUtil.setSp(16),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF54357E), // Label color set to #54357E
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0), // Added border radius
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to build Category dropdown field
  Widget _buildCategoryDropdown({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ScreenUtil.setSp(16),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF54357E), // Label color set to #54357E
          ),
        ),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0), // Added border radius
            ),
          ),
          value: selectedCategory,
          items: categories.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedCategory = newValue;
            });
          },
        ),
      ],
    );
  }

  // Helper method to build Unit dropdown fields for Purchase Unit and Consume Unit
  Widget _buildUnitDropdown({
    required String label,
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ScreenUtil.setSp(16),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF54357E), // Label color set to #54357E
          ),
        ),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0), // Added border radius
            ),
          ),
          value: selectedValue,
          items: units.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
