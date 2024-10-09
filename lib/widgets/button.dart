import 'package:flutter/material.dart';
import 'package:stock_managment/utils/screen_util.dart';

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double? width; // Add a width parameter
  final Widget? leadingIcon; // Add an optional leading icon

  const Button({
    super.key,
    required this.onPressed,
    this.text = 'Log in', // Default text value
    this.width, // Allow width to be passed in
    this.leadingIcon, // Optional leading icon
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity, // Use custom width if provided, otherwise full width
      height: ScreenUtil.setHeight(50), // Set height responsive
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenUtil.setWidth(10)), // Scale border radius
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content
          mainAxisSize: MainAxisSize.min, // Adapt to content size
          children: [
            if (leadingIcon != null) ...[
              leadingIcon!, // Display icon if it's provided
              SizedBox(width: ScreenUtil.setWidth(5)), // Add space between icon and text
            ],
            Text(
              text, // Use the customizable text
              style: TextStyle(
                fontSize: ScreenUtil.setSp(15), // Scale text size
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
