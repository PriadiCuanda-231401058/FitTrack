import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/setting_menu_button.dart';
import 'package:fittrack/features/settings/screens/edit_profile_screen.dart';
import '../widgets/custom_popup.dart';
import 'package:fittrack/features/settings/screens/account_settings_screen.dart';
import 'package:fittrack/features/settings/screens/delete_account_screen.dart';
import 'package:fittrack/features/settings/screens/premium_features_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fittrack/shared/widgets/navigation_bar_widget.dart';
import 'package:fittrack/features/settings/settings_controller.dart';
import 'package:fittrack/models/user_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsController _settingsController = SettingsController();
  UserModel? _userData;
  // bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final data = await _settingsController.getUserData();
      if (data != null) {
        setState(() {
          _userData = UserModel.fromMap(data);
          // _isLoading = false;
        });
      } else {
        setState(() {
          // _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Load user data error: $e');
      setState(() {
        // _isLoading = false;
      });
    }
  }

  ImageProvider getProfileImage() {
    final user = FirebaseAuth.instance.currentUser;

    // Priority 1: Base64 dari Firestore
    if (_userData?.photoBase64 != null && _userData!.photoBase64!.isNotEmpty) {
      try {
        final bytes = base64.decode(_userData!.photoBase64!);
        return MemoryImage(bytes);
      } catch (e) {
        print('Error decoding Base64: $e');
      }
    }

    // Priority 2: Photo dari Firebase Auth (untuk social login)
    if (user?.photoURL != null && user!.photoURL!.isNotEmpty) {
      return NetworkImage(user.photoURL!);
    }

    // Fallback: Default asset image
    return const AssetImage('assets/images/profile_icon.png');
  }

  String _getDisplayName() {
    final user = FirebaseAuth.instance.currentUser;
    return _userData?.name ?? user?.displayName ?? 'User';
  }

  Future<void> _refreshProfile() async {
    await _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: screenWidth * 0.05,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenHeight * 0.03,
          vertical: screenWidth * 0.06,
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: screenWidth * 0.18,
              backgroundImage: getProfileImage(),
            ),

            SizedBox(height: screenHeight * 0.02),

            Text(
              "Hello ${_getDisplayName()},",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: screenHeight * 0.001),
            Text(
              "Welcome back",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F6).withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  SettingsMenuButton(
                    text: 'Edit Profile',
                    icon: Image.asset(
                      'assets/images/edit_profile.png',
                      width: screenWidth * 0.05,
                      height: screenHeight * 0.05,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierColor: Colors.black.withOpacity(0.7),
                        builder: (context) {
                          return CustomPopup(
                            child: EditProfileScreen(
                              currentName: _getDisplayName(),
                              onProfileUpdated: _refreshProfile,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SettingsMenuButton(
                    text: 'Account Settings',
                    icon: Image.asset(
                      'assets/images/account_settings.png',
                      width: screenWidth * 0.05,
                      height: screenHeight * 0.05,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierColor: Colors.black.withOpacity(0.7),
                        barrierDismissible: true,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            insetPadding: EdgeInsets.zero,
                            child: CustomPopup(child: AccountSettingsScreen()),
                          );
                        },
                      );
                    },
                  ),
                  SettingsMenuButton(
                    text: 'Premium Features',
                    icon: Image.asset(
                      'assets/images/premium_features.png',
                      width: screenWidth * 0.05,
                      height: screenHeight * 0.05,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) =>
                            CustomPopup(child: PremiumFeaturesScreen()),
                      );
                    },
                  ),
                  SettingsMenuButton(
                    text: 'Delete Account',
                    icon: Image.asset(
                      'assets/images/delete_account.png',
                      width: screenWidth * 0.05,
                      height: screenHeight * 0.05,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierColor: Colors.black.withOpacity(0.7),
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            insetPadding: EdgeInsets.zero,
                            child: CustomPopup(child: DeleteAccountScreen()),
                          );
                        },
                      );
                    },
                  ),
                  SettingsMenuButton(
                    text: 'Log Out',
                    icon: Image.asset(
                      'assets/images/log_out.png',
                      width: screenWidth * 0.05,
                      height: screenHeight * 0.05,
                    ),
                    onTap: () async {
                      await GoogleSignIn().signOut();
                      await FirebaseAuth.instance.signOut();

                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/loginScreen',
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBarWidget(location: '/settingsScreen'),
    );
  }
}
