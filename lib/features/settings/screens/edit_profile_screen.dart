import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  final String? currentName;
  final String? currentPhotoUrl;

  const EditProfileScreen({
    super.key,
    this.currentName,
    this.currentPhotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: currentName ?? "");

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // TITLE + CLOSE BUTTON
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              "Edit Profile",
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

        // LABEL
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "New Username",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // TEXTFIELD
        Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.7),
              width: 1.2,
            ),
          ),
          child: TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter New Username",
              hintStyle: TextStyle(color: Colors.white54),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              border: InputBorder.none,
            ),
          ),
        ),

        const SizedBox(height: 25),

        // UPLOAD BUTTON
        SizedBox(
          width: double.infinity, // sama seperti TextField
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.7),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // text + icon center
                children: [
                  const Text(
                    "Upload New Profile",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/images/upload_icon.png',
                    width: 20,
                    height: 20, 
                  ),
                ],
              ),
            ),
          ),
        ),


        const SizedBox(height: 20),
      ],
    );
  }
}
