import 'package:flutter/material.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/widgets/button.dart';
import 'package:stock_managment/widgets/drawer.dart';

class AddFoodMenuScreen extends StatelessWidget {
  const AddFoodMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Food Menu",
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
      drawer:const AppDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil.setWidth(16),
        ),
        child: SingleChildScrollView(
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
              Form(
                child: Column(
                  children: [
                    // Row for Name and Code
                    Row(
                      children: [
                        Expanded(child: _buildTextField(label: "Name *")),
                        SizedBox(width: ScreenUtil.setWidth(8)),
                        Expanded(child: _buildTextField(label: "Code")),
                      ],
                    ),
                    SizedBox(height: ScreenUtil.setHeight(12)),

                    // Dropdown for Category
                    _buildDropdownField(label: "Category *"),
                    SizedBox(height: ScreenUtil.setHeight(12)),

                    // Dropdown for Ingredients Consumption
                    _buildDropdownField(label: "Ingredients Consumption *"),
                    SizedBox(height: ScreenUtil.setHeight(12)),

                    // Row for Sale Price and Add Button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildTextField(label: "Sale Price *"),
                        ),
                        SizedBox(width: ScreenUtil.setWidth(12)),
                        Expanded(
                          flex: 2,
                          child: Button(
                            onPressed: () {
                              // Handle Add button press
                            },
                            text: "Add",
                            width: double.infinity,
                            leadingIcon: const Icon(Icons.add, size: 20, color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: ScreenUtil.setHeight(20)),

                    // Ingredients List
                    _buildIngredientList(),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil.setHeight(10)),
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
            color: const Color(0xFF54357E),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12), // Adjusted padding
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
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
            color: const Color(0xFF54357E),
          ),
        ),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12), // Adjusted padding
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
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

  // Example ingredients list (simulating a few entries)
  Widget _buildIngredientList() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text("1"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // Handle delete
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Ingredients: Pizza"),
                _buildInlineTextField("Consumption", "4g"),
                SizedBox(height: ScreenUtil.setHeight(8)),
                _buildInlineTextField("Cost", "0.05"),
                SizedBox(height: ScreenUtil.setHeight(8)),
                _buildInlineTextField("Total", "0.20"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build inline text fields for cost details
  Widget _buildInlineTextField(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$label:",
          style: TextStyle(fontSize: ScreenUtil.setSp(14)),
        ),
        SizedBox(
          width: ScreenUtil.setWidth(100), // Increased the width to make the field wider
          child: TextFormField(
            initialValue: value,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 8), // Reduced padding
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
