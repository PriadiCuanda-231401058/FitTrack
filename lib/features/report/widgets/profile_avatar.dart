import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String imagePath;
  final double size;

  const ProfileAvatar({super.key, required this.imagePath, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.2),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: size * 0.15,
            spreadRadius: size * 0.03,
            offset: Offset(0, size * 0.06),
          ),
        ],
      ),
    );
  }
}
