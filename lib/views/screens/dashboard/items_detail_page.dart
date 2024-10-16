import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:stock_managment/services/token_service.dart';
import 'package:stock_managment/utils/screen_util.dart';
import 'package:stock_managment/widgets/button.dart';

class ItemDetailsPage extends StatefulWidget {
  final int ingredientId;

  const ItemDetailsPage({super.key, required this.ingredientId});

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  List<Map<String,
      dynamic>>? ingredientDetails; // List to hold multiple ingredients
  String unitName = 'Loading...';
  bool _isLoading = true;
  String? _errorMessage;
  final TokenService tokenService = TokenService(); // Initialize your TokenService

  @override
  void initState() {
    super.initState();
    _fetchIngredientDetails();
  }

  Future<void> _fetchIngredientDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final accessToken = await tokenService.getToken();

      final response = await http.get(
        Uri.parse('https://stock.cslancer.com/api/purchases/ingredient/${widget
            .ingredientId}'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isNotEmpty) {
          setState(() {
            ingredientDetails = List<Map<String, dynamic>>.from(jsonResponse);
            _errorMessage = null;
          });
          // Fetch the unit name for each ingredient
          for (var item in ingredientDetails!) {
            await _fetchUnitName(
                item['unit_id']); // Call the method to fetch unit name
          }
        } else {
          _handleError('No data found for this ingredient.');
        }
      } else {
        _handleError(
            'Failed to fetch ingredient details. Status Code: ${response
                .statusCode}. Response: ${response.body}');
      }
    } catch (e) {
      _handleError('Error fetching ingredient details: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchUnitName(dynamic unitId) async {
    if (unitId == null) {
      setState(() {
        unitName = 'No unit ID available';
      });
      return; // Exit if unit ID is null
    }

    try {
      final String? token = await tokenService.getToken();

      final unitResponse = await http.get(
        Uri.parse('https://stock.cslancer.com/api/units/$unitId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (unitResponse.statusCode == 200) {
        final unitData = json.decode(unitResponse.body);
        setState(() {
          unitName = unitData['name'] ?? 'Unknown Unit';
        });
      } else {
        setState(() {
          unitName = 'Unknown Unit';
        });
        debugPrint(
            'Failed to fetch unit: ${unitResponse.statusCode} - ${unitResponse
                .body}');
      }
    } catch (e) {
      debugPrint('Error fetching unit name: $e');
    }
  }

  Future<void> _downloadReportAsPdf() async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load("assets/fonts/OpenSans-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);

    if (ingredientDetails != null) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Stock Report', style: pw.TextStyle(
                    fontSize: 24, fontWeight: pw.FontWeight.bold, font: ttf)),
                pw.SizedBox(height: 20),
                ...ingredientDetails!.map((item) {
                  final ingredient = item['ingredient'] ?? 'Unknown Ingredient';
                  final price = item['price'] ?? 'N/A';
                  final quantity = item['quantity'] ?? 'N/A';
                  final expirationDate = item['expiration_date'] != null
                      ? DateFormat('dd/MM/yyyy').format(
                      DateTime.parse(item['expiration_date']))
                      : 'Unknown Date';

                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Ingredient: $ingredient', style: pw.TextStyle(
                          font: ttf)),
                      pw.Text('Quantity: $quantity', style: pw.TextStyle(
                          font: ttf)),
                      pw.Text('Price: $price', style: pw.TextStyle(font: ttf)),
                      pw.Text('Expiration Date: $expirationDate', style: pw
                          .TextStyle(font: ttf)),
                      pw.SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save());
    }
  }

  void _handleError(String message) {
    setState(() {
      _errorMessage = message;
      ingredientDetails = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredient Details'),
      ),
      body: _isLoading
          ? const Center(child: SpinKitFadingCircle(
        color: Colors.purple,
        size: 50,
      ))
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : ingredientDetails != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: ingredientDetails!.length,
          itemBuilder: (context, index) {
            final item = ingredientDetails![index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ingredient: ${item['ingredient']}',
                        style: const TextStyle(fontSize: 18)),
                    Text('Supplier: ${item['supplier']}',
                        style: const TextStyle(fontSize: 18)),
                    Text('Unit: $unitName',
                        style: const TextStyle(fontSize: 18)),
                    // Display the fetched unit name
                    Text('Quantity: ${item['quantity']}',
                        style: const TextStyle(fontSize: 18)),
                    Text('Price: ${item['price']}',
                        style: const TextStyle(fontSize: 18)),
                    Text('Expiration Date: ${item['expiration_date']}',
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            );
          },
        ),
      )
          : const Center(child: Text('No ingredient details available.')),
      bottomNavigationBar: BottomAppBar(
        child: Center( // Center the button horizontally
          child: ElevatedButton(
            onPressed: _downloadReportAsPdf,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    10), // Use a fixed value for border radius
              ),
              minimumSize: Size(ScreenUtil.setWidth(150), ScreenUtil.setHeight(40)), // Set a smaller width and height
            ),
            child: const Text('Download Report',style: TextStyle(color: Colors.white),),
          ),
        ),
      ),
    );
  }
}