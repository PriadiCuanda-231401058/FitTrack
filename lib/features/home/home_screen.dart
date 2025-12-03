import 'package:flutter/material.dart';
import 'package:fittrack/features/home/home_controller.dart';
import 'package:fittrack/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:fittrack/features/auth/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _homeController = HomeController();
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _homeController.getCurrentUserData();
    setState(() {
      userModel = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: userModel == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '👋 Halo, ${userModel!.name}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text('Email: ${userModel!.email}'),
                  Text('UID: ${userModel!.uid}'),

                  const SizedBox(height: 24),

                  // Tombol Ganti Akun
                  TextButton(
                    onPressed: () async {
                      await GoogleSignIn().signOut();
                      await FirebaseAuth.instance.signOut();

                      // Kembali ke halaman login
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, '/loginScreen');
                      }
                    },
                    child: const Text(
                      "Ganti akun",
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(
                          context,
                          '/settingsScreen',
                        );
                      }
                    },
                    child: const Text(
                      "settings",
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(
                          context,
                          '/workoutScreen',
                        );
                      }
                    },
                    child: const Text(
                      "workouts",
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                  // TextButton(
                  //   onPressed:,
                  //   child: const Text(
                  //     "s",
                  //     style: TextStyle(fontSize: 16, color: Colors.red),
                  //   ),
                  // ),
                ],
              ),
            ),
    );
  }
}
