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
import 'package:google_sign_in/google_sign_in.dart';


final authController = AuthController();

class SettingsController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  Future<File?> _compressImage(File file, {int maxSize = 100}) async {
    try {
      final originalBytes = await file.readAsBytes();
      final originalImage = img.decodeImage(originalBytes);

      if (originalImage == null) return null;

      final resizedImage = img.copyResize(
        originalImage,
        width: maxSize,
        height: maxSize,
      );

      final compressedBytes = img.encodeJpg(resizedImage, quality: 70);

      final tempFile = File('${file.path}_compressed.jpg');
      await tempFile.writeAsBytes(compressedBytes);

      return tempFile;
    } catch (e) {
      return null;
    }
  }

  Future<String?> _imageToBase64(File imageFile) async {
    try {
      final compressedFile = await _compressImage(imageFile, maxSize: 150);
      if (compressedFile == null) return null;

      final bytes = await compressedFile.readAsBytes();
      final base64String = base64Encode(bytes);

      await compressedFile.delete();

      return base64String;
    } catch (e) {
      // print('❌ Base64 conversion error: $e');
      return null;
    }
  }

  Future<bool> updateUsername(String newUsername) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await user.updateDisplayName(newUsername);

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

  Future<bool> uploadProfilePhotoBase64(String base64Image) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

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

  Future<String?> pickProfilePhotoFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
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
      print('❌ Pick photo error: $e');
      return null;
    }
  }

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

  Future<bool> deleteProfilePhoto() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

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

  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final email = user.email;
      if (email == null) return false;

      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);

      return true;
    } catch (e) {
      print('❌ Change password error: $e');
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final email = user.email;
      if (email == null) return false;

      // final password = user.password;

      // final credential = EmailAuthProvider.credential(
      //   email: email,
      //   password: password,
      // );

      // await user.reauthenticateWithCredential(credential);

      await _firestore.collection('users').doc(user.uid).delete();

      await user.delete();
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();

      return true;
    } catch (e) {
      print('❌ Delete account error: $e');
      return false;
    }
  }

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

  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .delete();

  //     await user.delete();

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

