import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fittrack/features/workout/workout_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fittrack/models/user_model.dart';
import 'package:fittrack/features/report/report_controller.dart';
// import 'package:fittrack/features/auth/auth_controller.dart';
// import 'package:flutter/material.dart';

ValueNotifier<AuthController> authController = ValueNotifier(AuthController());

class AuthController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Stream<User?> get authStateChanges => auth.authStateChanges();
  final ReportController report = ReportController();

  Future<UserModel?> signInWithGoogle() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final AuthCredential googleProvider = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final UserCredential credential = await auth.signInWithCredential(
      googleProvider,
    );

    final User? user = credential.user;

    if (user != null) {
      // BUAT UserModel dengan data lengkap
      UserModel userModel = UserModel(
        uid: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        photoBase64: null,
      );

      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);
      final userDoc = await userRef.get();

      if (!userDoc.exists) {
        await report.initializeUserProgress(user.uid, userRef);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap(), SetOptions(merge: true));
      }
      // Simpan ke Firestore dengan data lengkap
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(user.uid)
      //     .set(userModel.toMap(), SetOptions(merge: true));

      return userModel;
    }
    return null;
  }

  Future<UserModel?> register(
    String email,
    String password,
    String username,
  ) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;

    if (user != null) {
      await user.updateDisplayName(username);

      // Buat UserModel untuk email/password user
      UserModel userModel = UserModel(
        uid: user.uid,
        name: username,
        email: email,
        provider: 'email', // TANDAI sebagai email login
      );

      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);
      final userDoc = await userRef.get();

      if (!userDoc.exists) {
        await report.initializeUserProgress(user.uid, userRef);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap(), SetOptions(merge: true));
      }

      // Simpan ke Firestore

      return userModel;
    }
    return null;
  }

  Future<UserModel?> login(String email, String password) async {
    UserCredential credential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User? user = credential.user;

    if (user != null) {
      // Ambil data dari Firestore untuk mendapatkan photoBase64
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      UserModel userModel;
      if (userDoc.exists) {
        // Gunakan data dari Firestore
        userModel = UserModel.fromDocument(userDoc);
      } else {
        // Buat baru jika tidak ada
        userModel = UserModel(
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          provider: 'email',
        );

        // Simpan ke Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap(), SetOptions(merge: true));
      }

      return userModel;
    }
    return null;
  }

  Future<bool> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true; // success
    } on FirebaseAuthException catch (e) {
      debugPrint('Failed to send reset email: ${e.message}');
      return false; // failed
    }
  }

  Future<void> logout() async {
    await auth.signOut();
    await GoogleSignIn().signOut();
  }

  User? get currentUser => auth.currentUser;
}
