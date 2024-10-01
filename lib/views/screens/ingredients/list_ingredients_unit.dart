import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/widgets/card.dart';
import 'package:stock_managment/widgets/drawer.dart';
import 'package:stock_managment/token_service.dart'; // Import your TokenService

class ListIngredientsUnitScreen extends StatefulWidget {
  const ListIngredientsUnitScreen({super.key});

  @override
  _ListIngredientsUnitScreenState createState() => _ListIngredientsUnitScreenState();
}

class _ListIngredientsUnitScreenState extends State<ListIngredientsUnitScreen> {
  TextEditingController searchController = TextEditingController();
  final TokenService _tokenService = TokenService(); // Initialize TokenService
  List<dynamic> units = []; // This will hold the fetched units
  bool isLoading = true; // For loading state

  @override
  void initState() {
    super.initState();
    _fetchUnits(); // Call the fetch method on initialization
  }

  Future<void> _fetchUnits() async {
    final String apiUrl = 'https://stock.cslancer.com/api/units';

    // Retrieve the token
    final token = await _tokenService.getToken();

    // Check if the token is null
    if (token == null) {
      log('Token is null. Please log in to continue.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to log in again.')),
      );
      setState(() {
        isLoading = false; // Stop loading if token is null
      });
      return; // Exit early if token is null
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': 'Bearer $token', // Include token in headers
        },
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body ?? 'No response'}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          units = responseData; // Update the units with the fetched data
          isLoading = false; // Stop loading
        });
      } else {
        log('Failed to fetch units: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch units: ${response.body}')),
        );
        setState(() {
          isLoading = false; // Stop loading on failure
        });
      }
    } catch (e) {
      log('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }

  Future<void> _deleteUnit(int unitId) async {
    final String apiUrl = 'https://stock.cslancer.com/api/units/$unitId';

    // Retrieve the token
    final token = await _tokenService.getToken();

    // Check if the token is null
    if (token == null) {
      log('Token is null. Please log in to continue.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to log in again.')),
      );
      return; // Exit early if token is null
    }

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': 'Bearer $token', // Include token in headers
        },
      );

      log('Delete response status: ${response.statusCode}');
      log('Delete response body: ${response.body ?? 'No response'}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Successfully deleted, remove the unit from the list
        setState(() {
          units.removeWhere((unit) => unit['id'] == unitId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unit deleted successfully')),
        );
        _fetchUnits(); // Refresh the list after deletion
      } else {
        log('Failed to delete unit: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete unit: ${response.body}')),
        );
      }
    } catch (e) {
      log('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'List Ingredients Unit',
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
      body: RefreshIndicator(
        onRefresh: _fetchUnits,
        child: Padding(
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

              // Loading Indicator
              if (isLoading)
                Center(child: CircularProgressIndicator())
              else
              // List of units
                Expanded(
                  child: ListView.builder(
                    itemCount: units.length,
                    itemBuilder: (context, index) {
                      final unit = units[index];

                      // Log the unit to check its structure
                      log('Unit data: ${unit.toString()}');

                      return CommonListItem(
                        title: unit['name'] ?? 'Unnamed', // Use null-aware operator
                        onEdit: () {
                          print('Edit tapped for ${unit['name']}');
                          // Add your edit logic here
                        },
                        onDelete: () {
                          _deleteUnit(unit['id']);
                        },
                        index: index,
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
