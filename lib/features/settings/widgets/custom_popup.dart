import 'package:flutter/material.dart';

class CustomPopup extends StatelessWidget {
  final Widget child;

  const CustomPopup({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
      child: Container(
        width: width * 0.85,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.73),
              blurRadius: 10,
              spreadRadius: 5,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
