import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../auth/auth_controller.dart';

final authController = AuthController();

class SettingsController extends ChangeNotifier {
  Future<bool> deleteAccount() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user == null) {
        debugPrint("No user is logged in.");
        return false;
      }

      // 1. Hapus data user di Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      // 2. Hapus akun dari FirebaseAuth
      await user.delete();

      // 3. Logout Google Sign In (kalau pakai Google)
      try {
        await GoogleSignIn().signOut();
      } catch (_) {}

      return true;
    } on FirebaseAuthException catch (e) {
      // Error paling umum: butuh login ulang
      if (e.code == 'requires-recent-login') {
        debugPrint('User needs to reauthenticate before deleting the account.');
      } else {
        debugPrint('Failed to delete account: ${e.message}');
      }
      return false;
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return false;
    }
  }
}
