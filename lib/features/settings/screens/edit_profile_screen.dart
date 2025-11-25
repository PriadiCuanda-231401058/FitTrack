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
                "Edit Profile",
                style: TextStyle(
                  fontSize: screenWidth * 0.07,
                  color: const Color(0xff1E90FF),
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

        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "New Username",
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        SizedBox(height: screenHeight * 0.01),

        Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.7),
              width: screenWidth * 0.001,
            ),
          ),
          child: TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter New Username",
              hintStyle: TextStyle(color: Colors.white54),
              contentPadding:
                EdgeInsets.symmetric(horizontal: screenWidth * 0.045, vertical: screenHeight * 0.017),
              border: InputBorder.none,
            ),
          ),
        ),

        SizedBox(height: screenHeight * 0.02),

        SizedBox(
          width: double.infinity, 
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.045, vertical: screenHeight * 0.013),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.7),
                  width: screenWidth * 0.01,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Upload New Profile",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.025),
                  Image.asset(
                    'assets/images/upload_icon.png',
                      width: screenWidth * 0.04,
                      height: screenHeight * 0.04, 
                  ),
                ],
              ),
            ),
          ),
        ),


        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }
}
