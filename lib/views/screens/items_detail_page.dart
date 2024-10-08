import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stock_managment/token_service.dart';

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
      setState(() {
        units = {for (var unit in data) unit['id']: unit['name']};
      });
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
          Text(value),
        ],
      ),
    );
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
              _buildDetailRow('Quantity:', widget.item['quantity']),
              _buildDetailRow('Price:', widget.item['price']),
              _buildDetailRow('Expiration Date:', widget.item['expiration_date']),
              _buildDetailRow('Created At:', widget.item['created_at']),
              _buildDetailRow('Updated At:', widget.item['updated_at']),
            ],
          ),
        ),
      ),
    );
  }
}
