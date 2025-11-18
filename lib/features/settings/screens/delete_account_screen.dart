import 'package:flutter/material.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        Row(
          children: [
            const Spacer(),
            const Text(
              "Delete Account",
              style: TextStyle(
                color: Color(0xffD10F0F),
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close, color: Colors.white, size: 30),
            ),
          ],
        ),

        const SizedBox(height: 24),

        Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: 22,
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

        const SizedBox(height: 35),

        GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xffD9D9D9),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Center(
              child: Text(
                "Yes, I’m Sure",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
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
