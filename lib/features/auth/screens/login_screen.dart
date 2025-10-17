import 'package:fittrack/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fittrack/features/auth/auth_controller.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // String email = "", password = "";

  final _formKey = GlobalKey<FormState>();
  String errorMessage = "";

  void login() async {
    try { 
      await authController.value.login(
        emailController.text,
        passwordController.text,
      );
      errorMessage = "";
      // Navigator.push(
      //                 context,
      //                 MaterialPageRoute(builder: (context) => const HomeScreen()),
      //               );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'An error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        // padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                // onChanged: (value) {
                //   setState(() {
                //     email = value;
                //   });
                // },
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Password';
                  }
                  return null;
                },
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                // onChanged: (value) {
                //   setState(() {
                //     password = value;
                //   });
                // },
              ),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    login();
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}