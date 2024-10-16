import 'package:flutter/material.dart';

class PopupMenuWidget extends StatelessWidget {
  final Function() onEdit;
  final Function() onDelete;

  const PopupMenuWidget({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert, color: Colors.black),
      onSelected: (value) {
        if (value == 1) {
          onEdit();
        } else if (value == 2) {
          onDelete();
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Circular shape
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.black54), // Edit icon
              SizedBox(width: 8),
              Text("Edit"),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red), // Delete icon with red color
              SizedBox(width: 8),
              Text("Delete"),
            ],
          ),
        ),
      ],
    );
  }
}
