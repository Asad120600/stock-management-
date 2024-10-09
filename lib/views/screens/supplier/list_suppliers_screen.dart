import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For jsonDecode
import 'package:stock_managment/utils/screen_util.dart';
import 'package:stock_managment/widgets/drawer.dart';
import 'package:stock_managment/widgets/popup_menu.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Import flutter_spinkit

class ListSupplierScreen extends StatefulWidget {
  const ListSupplierScreen({super.key});

  @override
  _ListSupplierScreenState createState() => _ListSupplierScreenState();
}

class _ListSupplierScreenState extends State<ListSupplierScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> suppliers = []; // Store fetched suppliers
  List<Map<String, dynamic>> filteredSuppliers = []; // Store filtered suppliers
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchSuppliers(); // Fetch suppliers when the screen is initialized

    // Add listener to the search controller for real-time filtering
    searchController.addListener(() {
      filterSuppliers();
    });
  }

  Future<void> fetchSuppliers() async {
    final url = Uri.parse('https://stock.cslancer.com/api/suppliers');

    // Retrieve the token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("No token found. Please log in first.");
      return; // Exit if no token is found
    }

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Add the token to the headers
      },
    );

    if (response.statusCode == 200) {
      // Parse the response body and update the suppliers list
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        suppliers = List<Map<String, dynamic>>.from(data); // Update suppliers
        filteredSuppliers = suppliers; // Initialize filtered suppliers
        isLoading = false; // Set loading state to false
      });
    } else {
      print("Failed to load suppliers: ${response.body}");
      // Handle the error appropriately
      setState(() {
        isLoading = false; // Set loading state to false in case of error
      });
    }
  }

  void filterSuppliers() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredSuppliers = suppliers.where((supplier) {
        return supplier['name'].toLowerCase().contains(query) ||
            supplier['email']?.toLowerCase().contains(query) == true;
      }).toList();
    });
  }

  Future<void> deleteSupplier(int id) async {
    final url = Uri.parse('https://stock.cslancer.com/api/suppliers/$id');

    // Retrieve the token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("No token found. Please log in first.");
      return; // Exit if no token is found
    }

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Add the token to the headers
      },
    );

    if (response.statusCode == 200) {
      // Successfully deleted supplier
      setState(() {
        suppliers.removeWhere((supplier) => supplier['id'] == id); // Remove supplier from the list
        filteredSuppliers.removeWhere((supplier) => supplier['id'] == id); // Remove from filtered list
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Supplier deleted successfully!')),
      );
    } else {
      // Handle the error appropriately
      print("Failed to delete supplier: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete supplier!')),
      );
    }
  }

  Future<void> _refreshSuppliers() async {
    setState(() {
      isLoading = true; // Set loading state to true while refreshing
    });
    await fetchSuppliers(); // Refresh suppliers
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'List Supplier',
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
            // Search Bar
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ScreenUtil.setWidth(20)),
                ),
              ),
            ),
            SizedBox(height: ScreenUtil.setHeight(16)),

            // List of suppliers with pull-to-refresh
            Expanded(
              child: isLoading // Check if loading
                  ? Center(
                child: SpinKitFadingCircle(
                  color: Colors.purple,
                  size: 50.0,
                ),
              ) // Display loading indicator
                  : RefreshIndicator(
                onRefresh: _refreshSuppliers,
                child: ListView.builder(
                  itemCount: filteredSuppliers.length,
                  itemBuilder: (context, index) {
                    final supplier = filteredSuppliers[index];

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
                              // Name Text
                              Row(
                                children: [
                                  Text(
                                    'Name: ',
                                    style: TextStyle(
                                      fontSize: ScreenUtil.setSp(14),
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF54357E),
                                    ),
                                  ),
                                  Text(
                                    supplier['name'], // Accessing 'name' from the response
                                    style: TextStyle(
                                      fontSize: ScreenUtil.setSp(14),
                                      color: const Color(0xFF54357E),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: ScreenUtil.setHeight(4)),
                              // Email Text
                              Row(
                                children: [
                                  Text(
                                    'Email: ',
                                    style: TextStyle(
                                      fontSize: ScreenUtil.setSp(14),
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF54357E),
                                    ),
                                  ),
                                  Text(
                                    supplier['email'], // Accessing 'email' from the response
                                    style: TextStyle(
                                      fontSize: ScreenUtil.setSp(14),
                                      color: const Color(0xFF54357E),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: ScreenUtil.setHeight(4)),
                            ],
                          ),
                          trailing: PopupMenuWidget(
                            onEdit: () {
                              print('Edit tapped for ${supplier['name']}');
                              // Add your edit logic here
                            },
                            onDelete: () {
                              deleteSupplier(supplier['id']); // Call delete function with supplier ID
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
