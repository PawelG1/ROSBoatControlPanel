import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? horizontalPadding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, //make buttons full width
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12), //reduced vertical margin
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[850],
          foregroundColor: Colors.white,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[700]!, width: 1),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 20,
            vertical: 14, //reduced vertical padding
          ),
          elevation: 6,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}