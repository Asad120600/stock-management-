import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:stock_managment/services/token_service.dart';

class ItemDetailsPage extends StatefulWidget {
  final Map<String, dynamic> item;

  const ItemDetailsPage({Key? key, required this.item}) : super(key: key);

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  Map<int, String> units = {};
  final TokenService tokenService = TokenService();

  @override
  void initState() {
    super.initState();
    _fetchUnits();
  }

  Future<void> _fetchUnits() async {
    final token = await tokenService.getToken();
    if (token == null) {
      print('Failed to load units: No token found');
      return;
    }

    final response = await http.get(
      Uri.parse('https://stock.cslancer.com/api/units'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Check if the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          units = {for (var unit in data) unit['id']: unit['name']};
        });
      }
    } else {
      print('Failed to load units: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(child: Text(value, textAlign: TextAlign.end)),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    final DateTime date = DateTime.parse(dateString);
    return DateFormat('yyyy-MM-dd – HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details for ${widget.item['ingredient']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card( // Adding a Card for better UI
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('ID:', widget.item['id'].toString()),
                  _buildDetailRow('Ingredient:', widget.item['ingredient']),
                  _buildDetailRow('Supplier:', widget.item['supplier']),
                  _buildDetailRow(
                    'Unit:',
                    units[widget.item['unit_id']] ?? 'Loading...', // Show unit name
                  ),
                  _buildDetailRow('Quantity:', widget.item['quantity'].toString()),
                  _buildDetailRow('Price:', widget.item['price'].toString()),
                  _buildDetailRow(
                    'Expiration Date:',
                    _formatDate(widget.item['expiration_date']),
                  ),
                  _buildDetailRow(
                    'Created At:',
                    _formatDate(widget.item['created_at']),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
