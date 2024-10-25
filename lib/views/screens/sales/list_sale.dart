import 'dart:convert'; // For decoding JSON responses
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:stock_managment/services/token_service.dart'; // To get the token
import 'package:stock_managment/widgets/drawer.dart';
import 'package:stock_managment/widgets/sales_card.dart';

class ListSalesScreen extends StatefulWidget {
  const ListSalesScreen({super.key});

  @override
  _ListSalesScreenState createState() => _ListSalesScreenState();
}

class _ListSalesScreenState extends State<ListSalesScreen> {
  final TokenService _tokenService = TokenService(); // For token management
  List<Map<String, dynamic>> sales = []; // Sales data from the API
  bool _isLoading = true; // Loading state
  String? _error; // Error message if any

  @override
  void initState() {
    super.initState();
    fetchSales(); // Fetch sales data when the screen loads
  }

  // Method to fetch sales data from the API
// Method to fetch sales data from the API
  Future<void> fetchSales() async {
    setState(() {
      _isLoading = true; // Set loading to true
      _error = null; // Clear any previous errors
    });

    final token = await _tokenService.getToken(); // Get the token

    final response = await http.get(
      Uri.parse('https://stock.cslancer.com/api/sales'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      // Update the sales list
      setState(() {
        sales = data.map<Map<String, dynamic>>((item) => {
          "id": item['id'] ?? 0, // Default to 0 if id is null
          "food_item": item['food_item'] ?? "Unknown", // Handle null safely
          "qty": item['quantity']?.toString() ?? "0", // Convert quantity to string
          "category": item['category'] ?? "Unknown", // Handle category
          "total_amount_of_sale": item['total_amount_of_sale']?.toString() ?? "0.00", // Handle total_amount_of_sale
        }).toList();
        _isLoading = false; // Data is loaded
      });
    } else {
      // Handle error
      setState(() {
        _error = 'Failed to load sales: ${response.statusCode}';
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Sales'),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: fetchSales, // Fetch sales again on refresh
          child: _isLoading
              ? const Center(
              child: SpinKitFadingCircle(
                color: Colors.purple,
                size: 50.0,
              )) // Show a loading spinner while fetching data
              : _error != null
              ? Center(child: Text(_error!)) // Display error message if any
              : Column(
            children: [
              // List of Sales
              Expanded(
                child: ListView.builder(
                  itemCount: sales.length,
                  itemBuilder: (context, index) {
                    final sale = sales[index];

                    // Ensure sale['id'] is not null
                    final saleId = sale["id"] != null ? sale["id"] : 0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SalesCard(
                        foodItem: sale["food_item"] ?? "Unknown",
                        qty: sale["qty"] ?? "0",
                        category: sale["category"] ?? "Unknown",
                        isSelected: index % 2 == 1,
                        saleId: saleId,
                        total_amount_of_sale: sale["total_amount_of_sale"].toString(),
                        // Pass the saleId here
                        onDeleteSuccess: () {
                          // Refresh the list after deletion
                          fetchSales();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
