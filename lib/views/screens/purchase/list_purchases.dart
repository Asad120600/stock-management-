import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/widgets/drawer.dart';
import 'package:stock_managment/widgets/popup_menu.dart';
import 'package:http/http.dart' as http; // Import HTTP package
import 'dart:convert';
import 'package:stock_managment/token_service.dart';

class ListPurchaseScreen extends StatefulWidget {
  const ListPurchaseScreen({super.key});

  @override
  _ListPurchaseScreenState createState() => _ListPurchaseScreenState();
}

class _ListPurchaseScreenState extends State<ListPurchaseScreen> {
  TextEditingController searchController = TextEditingController();
  final TokenService _tokenService = TokenService(); // Create an instance of TokenService

  List<Map<String, dynamic>> purchases = []; // List to hold purchase data
  bool isLoadingPurchases = true; // Loading state for purchases

  @override
  void initState() {
    super.initState();
    fetchPurchases(); // Fetch purchases on init
  }

  Future<void> fetchPurchases() async {
    final token = await _tokenService.getToken(); // Get the token for authorization
    final response = await http.get(
      Uri.parse('http://stock.cslancer.com/api/purchases'), // Purchase API endpoint
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Decode the response into a list
      final List<dynamic> data = json.decode(response.body); // Directly decode into a list

      // Fetch unit and ingredient data
      final units = await fetchUnits(token!);
      final ingredients = await fetchIngredients(token);

      setState(() {
        purchases = data.map((purchase) {
          return {
            'id': purchase['id'],
            'Supplier': purchase['supplier'], // Supplier name from API
            'Unit': units[purchase['unit_id']] ?? 'Unknown Unit', // Map unit_id to name
            'Ingredient': ingredients[purchase['ingredient']] ?? 'Unknown Ingredient', // Map ingredient to name
            'Quantity': purchase['quantity'], // Quantity from API
            'Price': purchase['price'], // Price from API if needed
            'Expiration Date': purchase['expiration_date'], // Add expiration date
            // Add any additional fields you want to include
          };
        }).toList();
        isLoadingPurchases = false; // Set loading state to false
      });
    } else {
      setState(() {
        isLoadingPurchases = false; // Set loading state to false even on error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load purchases')),
      );
    }
  }

  // Function to fetch unit names
  Future<Map<int, String>> fetchUnits(String token) async {
    final response = await http.get(
      Uri.parse('http://stock.cslancer.com/api/units'), // API endpoint for units
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return {for (var unit in data) unit['id']: unit['name']};
    } else {
      return {}; // Return an empty map in case of an error
    }
  }

  // Function to fetch ingredient names
  Future<Map<String, String>> fetchIngredients(String token) async {
    final response = await http.get(
      Uri.parse('http://stock.cslancer.com/api/ingredients'), // API endpoint for ingredients
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return {for (var ingredient in data) ingredient['name']: ingredient['name']};
    } else {
      return {}; // Return an empty map in case of an error
    }
  }

  Future<void> deletePurchase(int purchaseId) async {
    try {
      final token = await _tokenService.getToken(); // Get the token for authorization
      final response = await http.delete(
        Uri.parse('http://stock.cslancer.com/api/purchases/$purchaseId'), // DELETE endpoint with purchase ID
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 204) {
        // If the deletion was successful, remove the purchase from the list
        setState(() {
          purchases.removeWhere((purchase) => purchase['id'] == purchaseId); // Remove deleted item
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase deleted successfully')),
        );
      } else {
        // log error details to console
        log('Failed to delete purchase. Status code: ${response.statusCode}');
        log('Response body: ${response.body}');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete purchase')),
        );
      }
    } catch (e) {
      // Catch and log any unexpected errors
      log('Error during deletion: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void _confirmDelete(int purchaseId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this purchase?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                deletePurchase(purchaseId); // Call delete function
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'List Purchase',
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
            Expanded(
              child: isLoadingPurchases
                  ? const Center(child: CircularProgressIndicator()) // Show a loading indicator
                  : ListView.builder(
                itemCount: purchases.length,
                itemBuilder: (context, index) {
                  final purchase = purchases[index];

                  // Alternate between light grey and light purple
                  final backgroundColor = index % 2 == 0
                      ? Colors.grey[200] // Light grey
                      : Colors.purple[100]; // Light purple

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: ScreenUtil.setHeight(8)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(ScreenUtil.setWidth(12)),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(ScreenUtil.setWidth(16)),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Supplier Text
                            Text(
                              'Supplier: ${purchase['Supplier']}', // Use supplier name
                              style: TextStyle(
                                fontSize: ScreenUtil.setSp(16),
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF54357E), // Set color here
                              ),
                            ),
                            SizedBox(height: ScreenUtil.setHeight(4)),
                            // Ingredient Text
                            Text(
                              'Ingredient: ${purchase['Ingredient']}', // Use ingredient name
                              style: TextStyle(
                                fontSize: ScreenUtil.setSp(14),
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF54357E), // Set color here
                              ),
                            ),
                            SizedBox(height: ScreenUtil.setHeight(4)),
                            // Unit Text
                            Text(
                              'Unit: ${purchase['Unit']}', // Use unit name
                              style: TextStyle(
                                fontSize: ScreenUtil.setSp(14),
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF54357E), // Set color here
                              ),
                            ),
                            SizedBox(height: ScreenUtil.setHeight(4)),
                            // Quantity Text
                            Text(
                              'Quantity: ${purchase['Quantity']}',
                              style: TextStyle(
                                fontSize: ScreenUtil.setSp(14),
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF54357E), // Set color here
                              ),
                            ),
                            SizedBox(height: ScreenUtil.setHeight(4)),
                            // Expiration Date
                            Text(
                              'Expiration Date: ${purchase['Expiration Date']}',
                              style: TextStyle(
                                fontSize: ScreenUtil.setSp(14),
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF54357E), // Set color here
                              ),
                            ),
                          ],
                        ),
                        trailing: PopupMenuWidget(
                          onDelete: () {
                            if (purchase['id'] != null) { // Check if the ID is valid
                              _confirmDelete(purchase['id']);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Invalid purchase ID')),
                              );
                            }
                          },
                          onEdit: () {  },
                        ),
                      ),
                    ),
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
