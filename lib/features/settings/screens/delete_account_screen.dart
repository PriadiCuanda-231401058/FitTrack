import 'package:flutter/material.dart';
import 'package:fittrack/features/settings/settings_controller.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                "Delete Account",
                style: TextStyle(
                  fontSize: screenWidth * 0.07,
                  color: const Color(0xffC50000),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),

            Positioned(
              right: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: screenWidth * 0.07,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: screenHeight * 0.025),

        Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              height: 1.4,
              fontFamily: "LeagueSpartan",
            ),
            children: [
              TextSpan(
                text: "Are you sure you want to delete your account? ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                text: "This action is ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500
                  ),
              ),
              TextSpan(
                text: "permanent ",
                style: TextStyle(color: Color(0xFFC50000), fontWeight: FontWeight.w500),
              ),
              TextSpan(
                text: "and ",
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),
              ),
              TextSpan(
                text: "all your progress will be lost.",
                style: TextStyle(color: Color(0xFFC50000),fontWeight: FontWeight.w500),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: screenHeight * 0.03),

        GestureDetector(
          onTap: () => SettingsController().deleteAccount().then((success) {
            if (success) {
              Navigator.pushReplacementNamed(context, '/loginScreen');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to delete account. Please try again.'),
                ),
              );
            }
          }),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
            decoration: BoxDecoration(
              color: const Color(0xffD9D9D9),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Center(
              child: Text(
                "Yes, I’m Sure",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
