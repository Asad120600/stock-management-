import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/token_service.dart';
import 'package:stock_managment/widgets/drawer.dart';
import 'package:stock_managment/widgets/popup_menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListIngredientsScreen extends StatefulWidget {
  const ListIngredientsScreen({super.key});

  @override
  State<ListIngredientsScreen> createState() => _ListIngredientsScreenState();
}

class _ListIngredientsScreenState extends State<ListIngredientsScreen> {
  final TokenService _tokenService = TokenService();
  List<dynamic> ingredients = [];
  Map<int, String> units = {}; // Map to store unit names
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUnits(); // Fetch units at initialization
    fetchIngredients(); // Fetch ingredients
  }

  Future<void> fetchUnits() async {
    try {
      final token = await _tokenService.getToken();
      final response = await http.get(
        Uri.parse('http://stock.cslancer.com/api/units'), // Your units API endpoint
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> unitList = json.decode(response.body);
        units = {
          for (var unit in unitList) unit['id']: unit['name'], // Create a map from unit id to unit name
        };
      } else {
        throw Exception('Failed to load units');
      }
    } catch (e) {
      print("Error fetching units: $e");
    }
  }

  Future<void> fetchIngredients() async {
    final token = await _tokenService.getToken(); // Retrieve your token from the token service
    final response = await http.get(
      Uri.parse('http://stock.cslancer.com/api/ingredients'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Decode the JSON response
      setState(() {
        ingredients = json.decode(response.body);
        isLoading = false; // Update loading status
      });
    } else {
      // Handle error response
      setState(() {
        isLoading = false; // Update loading status
      });
      throw Exception('Failed to load ingredients');
    }
  }

  Future<void> deleteIngredient(int ingredientId) async {
    final token = await _tokenService.getToken(); // Retrieve your token from the token service
    final response = await http.delete(
      Uri.parse('http://stock.cslancer.com/api/ingredients/$ingredientId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 204) {
      // If the server returns a 200 OK response, remove the ingredient from the list
      setState(() {
        ingredients.removeWhere((ingredient) => ingredient['id'] == ingredientId);
      });
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ingredient deleted successfully.'),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      throw Exception('Failed to delete ingredient');
    }
  }

  Future<void> _refreshIngredients() async {
    setState(() {
      isLoading = true; // Set loading status while refreshing
    });
    await fetchIngredients();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List Ingredients",
          style: TextStyle(
            fontSize: ScreenUtil.setSp(18), // Responsive text size
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil.setWidth(16),
        ),
        child: isLoading
            ? Center(
          child: SpinKitFadingCircle(
            color: Colors.purple,
            size: 50.0,
          ),
        ): RefreshIndicator(
          onRefresh: _refreshIngredients,
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: EdgeInsets.symmetric(vertical: ScreenUtil.setHeight(16)),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              // Ingredient cards
              Expanded(
                child: ListView.builder(
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    return _buildIngredientCard(context, ingredients[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build each ingredient card
  Widget _buildIngredientCard(BuildContext context, dynamic ingredient) {
    Color cardColor = (ingredient['id'] % 2 == 0) ? const Color(0xFFEDECEC) : const Color(0xFFDFC8FF);

    return Container(
      decoration: BoxDecoration(
        color: cardColor, // Alternating background colors
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      margin: EdgeInsets.only(bottom: ScreenUtil.setHeight(16)),
      child: ListTile(
        contentPadding: EdgeInsets.all(ScreenUtil.setWidth(16)), // Adjust padding inside the tile
        title: Text(
          ingredient['name'] ?? "Unnamed",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil.setSp(16), // Adjust text size
            color: const Color(0xFF54357E), // Primary color similar to your theme
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ScreenUtil.setHeight(8)), // Space between title and subtitle
            Text(
              "Code: ${ingredient['code'] ?? "N/A"}",
              style: TextStyle(fontSize: ScreenUtil.setSp(14)),
            ),
            Text(
              "Purchased Unit: ${units[ingredient['purchase_unit_id']] ?? "N/A"}", // Accessing unit name using the map
              style: TextStyle(fontSize: ScreenUtil.setSp(14)),
            ),
            Text(
              "Consumption Unit: ${units[ingredient['consumption_unit_id']] ?? "N/A"}", // Accessing unit name using the map
              style: TextStyle(fontSize: ScreenUtil.setSp(14)),
            ),
          ],
        ),
        trailing: PopupMenuWidget(
          onEdit: () {
            print('Edit tapped for ${ingredient['name']}');
            // Add your edit logic here
          },
          onDelete: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Delete Ingredient'),
                  content: Text('Are you sure you want to delete ${ingredient['name']}?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                    TextButton(
                      child: const Text('Delete'),
                      onPressed: () async {
                        await deleteIngredient(ingredient['id']); // Call the delete method
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
