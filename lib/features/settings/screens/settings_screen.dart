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
// import 'package:fittrack/features/settings/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          children: [
            CircleAvatar(
              radius: width * 0.18,
              backgroundImage:
                  user?.photoURL != null && user!.photoURL!.isNotEmpty
                  ? NetworkImage(user.photoURL!)
                  : const AssetImage('assets/images/default_pp.png')
                        as ImageProvider,
            ),
            const SizedBox(height: 24),

            Text(
              "Hello ${user?.displayName ?? 'User'},",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Welcome back",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 32),

            // Menu
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
                      width: 20,
                      height: 20,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierColor: Colors.black.withOpacity(0.7),
                        builder: (context) {
                          return CustomPopup(
                            child: EditProfileScreen(
                              currentName: "",
                              currentPhotoUrl: null,
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
                      width: 20,
                      height: 20,
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
                      width: 20,
                      height: 20,
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
                      width: 20,
                      height: 20,
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
                            child: CustomPopup(
                              child:
                                  DeleteAccountScreen(), // << INI YANG KAMU MAKSUD
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SettingsMenuButton(
                    text: 'Log Out',
                    icon: Image.asset(
                      'assets/images/log_out.png',
                      width: 20,
                      height: 20,
                    ),
                    onTap: () async {
                      await GoogleSignIn().signOut();
                      await FirebaseAuth.instance.signOut();

                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, '/loginScreen');
                      }
                    },
                  ),
                  NavigationBarWidget(location: '/settingsScreen'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
