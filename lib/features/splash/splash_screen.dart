import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/loginScreen',
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Material(
      child: Container(
        width: screenWidth,
        height: screenHeight,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/fittrack_logo.png',
              width: screenWidth * 0.2,
            ),

            SizedBox(width: screenWidth * 0.01),

            Text(
              'FitTrack',
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontSize: screenWidth * 0.09,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
