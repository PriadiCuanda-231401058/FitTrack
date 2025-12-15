import 'package:flutter/material.dart';
import 'package:fittrack/features/settings/settings_controller.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final SettingsController _controller = SettingsController();
  final TextEditingController oldPass = TextEditingController();
  final TextEditingController newPass = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();
  // bool _isLoading = false;

  Future<void> _changePassword() async {
    if (newPass.text != confirmPass.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('New passwords do not match')));
      return;
    }

    // if (newPass.text.length < 6) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Password must be at least 6 characters')),
    //   );
    //   return;
    // }

    setState(() {
      // _isLoading = true;
    });

    try {
      final success = await _controller.changePassword(
        oldPass.text,
        newPass.text,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to change password. Your current password is incorrect or Login with Google.',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() {
          // _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  "Account Settings",
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
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

          SizedBox(height: screenHeight * 0.02),

          _label("Current Password", context),
          _textfield(oldPass, context),

          SizedBox(height: screenHeight * 0.02),

          _label("New Password", context),
          _textfield(newPass, context),

          SizedBox(height: screenHeight * 0.02),

          _label("Confirm New Password", context),
          _textfield(confirmPass, context),

          SizedBox(height: screenHeight * 0.04),

          GestureDetector(
            onTap: _changePassword,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  "Confirm",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text, context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.04,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _textfield(TextEditingController controller, context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(top: screenHeight * 0.006),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white54, width: screenWidth * 0.001),
        borderRadius: BorderRadius.circular(18),
        color: Colors.black,
      ),
      child: TextField(
        controller: controller,
        obscureText: true,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.045,
            vertical: screenHeight * 0.009,
          ),
          border: InputBorder.none,
          hintText: "Enter Password",
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
        ),
      ),
    );
  }
}
