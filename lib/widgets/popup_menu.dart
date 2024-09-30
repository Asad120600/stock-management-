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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8), // Adding border radius
      ),
      child: PopupMenuButton<int>(
        icon: const Icon(Icons.more_vert),
        onSelected: (value) {
          if (value == 1) {
            onEdit();
          } else if (value == 2) {
            onDelete();
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Adding border radius to the popup itself
        ),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 1,
            child: Row(
              children: [
                Icon(Icons.edit, color: Colors.black54),
                SizedBox(width: 8),
                Text("Edit"),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 2,
            child: Row(
              children: [
                Icon(Icons.delete, color: Colors.black54),
                SizedBox(width: 8),
                Text("Delete"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
