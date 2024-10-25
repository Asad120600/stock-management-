import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:stock_managment/widgets/popup_menu.dart';
import 'package:stock_managment/services/token_service.dart'; // Assuming you have a TokenService

class SalesCard extends StatelessWidget {
  final String qty;
  final String foodItem;
  final String category;
  final String total_amount_of_sale;
  final bool isSelected;
  final int saleId;
  final Function onDeleteSuccess;

  const SalesCard({
    super.key,
    required this.category,
    this.isSelected = false,
    required this.foodItem,
    required this.total_amount_of_sale,
    required this.qty,
    required this.saleId,
    required this.onDeleteSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? const Color(0xFFE6DFFB) : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Category', category),
                  _buildInfoRow('Food Item', foodItem),
                  _buildInfoRow('Quantity', qty),
                  _buildInfoRow('Total Amount', total_amount_of_sale),
                ],
              ),
            ),
            PopupMenuWidget(
              onEdit: () {
                print('Edit action selected for $foodItem');
              },
              onDelete: () {
                _showDeleteConfirmation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF54357E),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this sale?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteSale();
                onDeleteSuccess();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteSale() async {
    final tokenService = TokenService();
    final token = await tokenService.getToken();

    final response = await http.delete(
      Uri.parse('https://stock.cslancer.com/api/sales/$saleId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 204) {
      print('Sale deleted successfully.');
    } else {
      print('Failed to delete sale: ${response.statusCode} - ${response.body}');
    }
  }
}
