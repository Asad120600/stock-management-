import 'package:flutter/material.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/widgets/button.dart';
import 'package:stock_managment/widgets/drawer.dart';

class AddIngredientScreen extends StatelessWidget {
  const AddIngredientScreen({super.key});

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
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon press
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
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
                    _buildDropdownField(label: "Category *"),
                    SizedBox(height: ScreenUtil.setHeight(16)),

                    // Row for Purchase Unit and Consume Unit
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildDropdownField(label: "Purchase Unit *"),
                        ),
                        SizedBox(width: ScreenUtil.setWidth(8)), // Space between dropdowns
                        Expanded(
                          child: _buildDropdownField(label: "Consume Unit *"),
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

  // Helper method to build dropdown fields
  Widget _buildDropdownField({required String label}) {
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
          items: <String>['Option 1', 'Option 2', 'Option 3'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            // Handle dropdown changes
          },
        ),
      ],
    );
  }
}
