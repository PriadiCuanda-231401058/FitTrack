import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../auth/auth_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'dart:convert';
import 'dart:async';


final authController = AuthController();

class SettingsController extends ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  // 1. Compress Image ke ukuran kecil (untuk Base64)
  Future<File?> _compressImage(File file, {int maxSize = 100}) async {
    try {
      // Baca file asli
      final originalBytes = await file.readAsBytes();
      final originalImage = img.decodeImage(originalBytes);
      
      if (originalImage == null) return null;
      
      // Resize ke ukuran maksimum
      final resizedImage = img.copyResize(
        originalImage,
        width: maxSize,
        height: maxSize,
      );
      
      // Encode ke JPEG dengan kualitas 70%
      final compressedBytes = img.encodeJpg(resizedImage, quality: 70);
      
      // Buat file temporary
      final tempFile = File('${file.path}_compressed.jpg');
      await tempFile.writeAsBytes(compressedBytes);
      
      return tempFile;
    } catch (e) {
      // print('Image compression error: $e');
      return null;
    }
  }

  // 2. Convert Image to Base64
  Future<String?> _imageToBase64(File imageFile) async {
    try {
      // Compress dulu
      final compressedFile = await _compressImage(imageFile, maxSize: 150);
      if (compressedFile == null) return null;
      
      // Convert ke Base64
      final bytes = await compressedFile.readAsBytes();
      final base64String = base64Encode(bytes);
      
      // Hapus file temporary
      await compressedFile.delete();
      
      return base64String;
    } catch (e) {
      // print('❌ Base64 conversion error: $e');
      return null;
    }
  }

  // 3. Update Username
  Future<bool> updateUsername(String newUsername) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Update di Firebase Auth
      await user.updateDisplayName(newUsername);
      
      // Update di Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'name': newUsername,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      print('❌ Update username error: $e');
      return false;
    }
  }

  // 4. Upload Profile Photo sebagai Base64
  Future<bool> uploadProfilePhotoBase64(String base64Image) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Simpan Base64 ke Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'photoBase64': base64Image,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('❌ Upload profile photo error: $e');
      return false;
    }
  }

  // 5. Pilih Foto dari Gallery dan Convert ke Base64
  Future<String?> pickProfilePhotoFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70, // Kurangi quality untuk size lebih kecil
      );

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        return await _imageToBase64(imageFile);
      }
      return null;
    } catch (e) {
      print('❌ Pick photo error: $e');
      return null;
    }
  }

  // 6. Ambil Foto dari Kamera
  Future<String?> takeProfilePhotoWithCamera() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        return await _imageToBase64(imageFile);
      }
      return null;
    } catch (e) {
      print('❌ Take photo error: $e');
      return null;
    }
  }

  // 7. Hapus Foto Profil
  Future<bool> deleteProfilePhoto() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Hapus photoBase64 dari Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'photoBase64': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update Firebase Auth
      await user.updatePhotoURL(null);
      
      return true;
    } catch (e) {
      print('Delete profile photo error: $e');
      return false;
    }
  }

  // 8. Change Password
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final email = user.email;
      if (email == null) return false;

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      
      // Update password
      await user.updatePassword(newPassword);
      
      return true;
    } catch (e) {
      print('❌ Change password error: $e');
      return false;
    }
  }

  // 9. Delete Account
  Future<bool> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final email = user.email;
      if (email == null) return false;

      // final password = user.password;

      // Re-authenticate user
      // final credential = EmailAuthProvider.credential(
      //   email: email,
      //   password: password,
      // );

      // await user.reauthenticateWithCredential(credential);
      
      // Delete user data dari Firestore
      await _firestore.collection('users').doc(user.uid).delete();
      
      // Delete user dari Firebase Auth
      await user.delete();
      
      return true;
    } catch (e) {
      print('❌ Delete account error: $e');
      return false;
    }
  }

  // 10. Get Current User Data
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('❌ Get user data error: $e');
      return null;
    }
  }
}
  // Future<bool> deleteAccount() async {
  //   try {
  //     final FirebaseAuth auth = FirebaseAuth.instance;
  //     User? user = auth.currentUser;

  //     if (user == null) {
  //       debugPrint("No user is logged in.");
  //       return false;
  //     }

  //     // 1. Hapus data user di Firestore
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .delete();

  //     // 2. Hapus akun dari FirebaseAuth
  //     await user.delete();

  //     // 3. Logout Google Sign In (kalau pakai Google)
  //     try {
  //       await GoogleSignIn().signOut();
  //     } catch (_) {}

  //     return true;
  //   } on FirebaseAuthException catch (e) {
  //     // Error paling umum: butuh login ulang
  //     if (e.code == 'requires-recent-login') {
  //       debugPrint('User needs to reauthenticate before deleting the account.');
  //     } else {
  //       debugPrint('Failed to delete account: ${e.message}');
  //     }
  //     return false;
  //   } catch (e) {
  //     debugPrint('Unexpected error: $e');
  //     return false;
  //   }
  // }
