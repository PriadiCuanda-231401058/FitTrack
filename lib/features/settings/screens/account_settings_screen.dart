import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController oldPass = TextEditingController();
    final TextEditingController newPass = TextEditingController();
    final TextEditingController confirmPass = TextEditingController();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Spacer(),
            const Text(
              "Account Settings",
              style: TextStyle(
                color: Color(0xFF1E90FF),
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close, color: Colors.white, size: 28),
            ),
          ],
        ),

        const SizedBox(height: 25),

        _label("Current Password"),
        _textfield(oldPass),

        const SizedBox(height: 18),

        _label("New Password"),
        _textfield(newPass),

        const SizedBox(height: 18),

        _label("Confirm New Password"),
        _textfield(confirmPass),

        const SizedBox(height: 28),

        GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Center(
              child: Text(
                "Confirm",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _textfield(TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white54, width: 1.2),
        borderRadius: BorderRadius.circular(18),
        color: Colors.black,
      ),
      child: TextField(
        controller: controller,
        obscureText: true,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          border: InputBorder.none,
          hintText: "Enter Password",
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
        ),
      ),
    );
  }
}
