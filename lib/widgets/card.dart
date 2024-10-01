import 'package:flutter/material.dart';
import 'package:stock_managment/widgets/popup_menu.dart';
import 'package:stock_managment/screen_util.dart';

class CommonListItem extends StatefulWidget {
  final String title;
  final String? subtitle1; // Code or Description
  final String? subtitle2; // Category or another detail (optional)
  final String? subtitle3; // Purchased Unit or another detail (optional)
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final int index;

  const CommonListItem({
    super.key,
    required this.title,
    this.subtitle1,
    this.subtitle2,
    this.subtitle3,
    required this.onEdit,
    required this.onDelete,
    required this.index,
  });

  @override
  State<CommonListItem> createState() => _CommonListItemState();
}

class _CommonListItemState extends State<CommonListItem> {
  @override
  Widget build(BuildContext context) {
    Color cardColor = (widget.index % 2 == 0) ? const Color(0xFFEDECEC) : const Color(0xFFDFC8FF);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.only(bottom: ScreenUtil.setHeight(16)),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(ScreenUtil.setWidth(16)),
            title: Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil.setSp(16),
                color: const Color(0xFF54357E),
              ),
            ),
            subtitle: widget.subtitle1 != null ||
                widget.subtitle2 != null ||
                widget.subtitle3 != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Ensure height is based on content
              children: [
                if (widget.subtitle1 != null) ...[
                  SizedBox(height: ScreenUtil.setHeight(8)),
                  Text(widget.subtitle1!, style: TextStyle(fontSize: ScreenUtil.setSp(14))),
                ],
                if (widget.subtitle2 != null) ...[
                  Text(widget.subtitle2!, style: TextStyle(fontSize: ScreenUtil.setSp(14))),
                ],
                if (widget.subtitle3 != null) ...[
                  Text(widget.subtitle3!, style: TextStyle(fontSize: ScreenUtil.setSp(14))),
                ],
              ],
            )
                : null,
            trailing: PopupMenuWidget(
              onEdit: widget.onEdit,
              onDelete: widget.onDelete,
            ),
          ),
        ],
      ),
    );
  }
}
