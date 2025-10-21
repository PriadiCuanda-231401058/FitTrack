import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const ErrorMessage({
    super.key,
    required this.message,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/error_icon.png',
                width: screenWidth * 0.07,
              ),

              SizedBox(width: screenWidth * 0.02),

              SizedBox(
                width: screenWidth * 0.6,

                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Color(0xFFF87171),
                  ),
                ),
              ),
            ],
          ),

          GestureDetector(
            onTap: onDismiss,
            child: Image.asset(
              'assets/images/close_icon.png',
              width: screenWidth * 0.07,
            ),
          ),
        ],
      ),
    );
  }
}
