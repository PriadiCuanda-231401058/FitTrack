import 'package:flutter/material.dart';

import 'package:fittrack/features/settings/settings_controller.dart';

class EditProfileScreen extends StatefulWidget {
final String currentName;
  final VoidCallback? onProfileUpdated;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    this.onProfileUpdated,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final SettingsController _controller = SettingsController();
  final TextEditingController nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.currentName;
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.white),
              title: Text('Choose from Gallery', style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.pop(context);
                setState(() => _isLoading = true);
                
                try {
                  final base64Image = await _controller.pickProfilePhotoFromGallery();
                  if (base64Image != null) {
                    final success = await _controller.uploadProfilePhotoBase64(base64Image);
                    if (success && mounted) {
                      widget.onProfileUpdated?.call();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Profile photo updated')),
                      );
                    }
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                } finally {
                  if (mounted) setState(() => _isLoading = false);
                }
              },
            ),
            
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.white),
              title: Text('Take Photo', style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.pop(context);
                setState(() => _isLoading = true);
                
                try {
                  final base64Image = await _controller.takeProfilePhotoWithCamera();
                  if (base64Image != null) {
                    final success = await _controller.uploadProfilePhotoBase64(base64Image);
                    if (success && mounted) {
                      widget.onProfileUpdated?.call();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Profile photo updated')),
                      );
                    }
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                } finally {
                  if (mounted) setState(() => _isLoading = false);
                }
              },
            ),
            
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Remove Photo', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                setState(() => _isLoading = true);
                
                try {
                  final success = await _controller.deleteProfilePhoto();
                  if (success && mounted) {
                    widget.onProfileUpdated?.call();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Profile photo removed')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                } finally {
                  if (mounted) setState(() => _isLoading = false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a username')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await _controller.updateUsername(nameController.text);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        widget.onProfileUpdated?.call();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final nameController = TextEditingController(text: currentName ?? "");
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
              contentPadding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.045,
                vertical: screenHeight * 0.017,
              ),
              border: InputBorder.none,
            ),
          ),
        ),

        SizedBox(height: screenHeight * 0.02),

        SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.045,
                vertical: screenHeight * 0.013,
              ),
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

        GestureDetector(
          onTap: _isLoading ? null : _saveProfile,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
            decoration: BoxDecoration(
              color: Color(0xFF1E90FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: _isLoading
                  ? SizedBox(
                      width: screenWidth * 0.05,
                      height: screenWidth * 0.05,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      "Save Changes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),

        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }
}
