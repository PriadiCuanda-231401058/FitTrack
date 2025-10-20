import 'package:firebase_auth/firebase_auth.dart';
import 'package:fittrack/features/auth/auth_controller.dart';
import 'package:flutter/material.dart';
// import 'package:fittrack/features/auth/screens/login_screen.dart';

// import 'package:fittrack/features/auth/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  // String username = "", password = "", email = "";
  // final _formKey = GlobalKey<FormState>();
  String errorMessage = "";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }


  void register() async{
    try { 
      await authController.value.register(
        emailController.text,
        passwordController.text,
        usernameController.text,
      );
      Navigator.pushNamed(context, '/loginScreen');
    } on FirebaseAuthException catch (e) {
      showAlert(context, e.message ?? 'An error occurred');
    }
  }

  void pop(){
    Navigator.pop(context);
  }

  void showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Notifikasi"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("Tutup"),
              onPressed: () {
                Navigator.pop(context); // menutup dialog
              },
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.03),

                  Image.asset(
                    'assets/images/fittrack_logo.png',
                    width: screenWidth * 0.2,
                  ),

                  SizedBox(height: screenHeight * 0.01),

                  Text(
                    'FitTrack',
                    style: TextStyle(
                      fontFamily: 'LeagueSpartan',
                      fontSize: screenWidth * 0.09,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  ElevatedButton(
                    onPressed: () {
                      // Implement Google Sign-In
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
                        states,
                      ) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.white;
                        }
                        return Colors.transparent;
                      }),
                      foregroundColor: WidgetStateProperty.resolveWith<Color>((
                        states,
                      ) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.black;
                        }
                        return Color(0xFF9999A1);
                      }),
                      side: WidgetStateProperty.resolveWith<BorderSide>((
                        states,
                      ) {
                        if (states.contains(WidgetState.pressed)) {
                          return BorderSide(
                            width: 0,
                            color: Colors.transparent,
                          );
                        }
                        return BorderSide(width: 1, color: Color(0xFF9999A1));
                      }),
                      padding: WidgetStateProperty.all(
                        EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.02,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/images/google_icon.png'),

                        SizedBox(width: screenWidth * 0.125),

                        Text(
                          'Continue with Google',
                          style: TextStyle(fontSize: screenWidth * 0.035),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Username',
                                style: TextStyle(
                                  fontFamily: 'LeagueSpartan',
                                  fontSize: screenWidth * 0.07,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.01),

                            TextFormField(
                              cursorColor: Colors.white,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Username';
                                }
                                return null;
                              },
                              controller: usernameController,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.035,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter Your Username',
                                hintStyle: TextStyle(
                                  color: Color(0xFF9999A1),
                                  fontSize: screenWidth * 0.035,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: screenWidth * 0.0027,
                                    color: Color(0xFF9999A1),
                                    // color: Colors.blue,
                                  ),
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: screenWidth * 0.0027,
                                    color: Colors.white,
                                    // color: Colors.blue,
                                  ),
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: screenWidth * 0.0027,
                                    color: Colors.red,
                                  ),
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: screenWidth * 0.0027,
                                    color: Colors.white,
                                    // color: Colors.blue,
                                  ),
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04,
                                  vertical: screenHeight * 0.022,
                                ),
                              ),
                              // onChanged: (value) {
                              //   setState(() {
                              //     username = value;
                              //   });
                              // },
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Email',
                                style: TextStyle(
                                  fontFamily: 'LeagueSpartan',
                                  fontSize: screenWidth * 0.07,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.01),

                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: Colors.white,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Email';
                                }
                                return null;
                              },
                              controller: emailController,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.035,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter Your Email',
                                hintStyle: TextStyle(
                                  color: Color(0xFF9999A1),
                                  fontSize: screenWidth * 0.035,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: screenWidth * 0.0027,
                                    color: Color(0xFF9999A1),
                                    // color: Colors.blue,
                                  ),
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: screenWidth * 0.0027,
                                    color: Colors.white,
                                    // color: Colors.blue,
                                  ),
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: screenWidth * 0.0027,
                                    color: Colors.red,
                                  ),
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: screenWidth * 0.0027,
                                    color: Colors.white,
                                    // color: Colors.blue,
                                  ),
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04,
                                  vertical: screenHeight * 0.022,
                                ),
                              ),
                              // onChanged: (value) {
                              //   setState(() {
                              //     email = value;
                              //   });
                              // },
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Password',
                                style: TextStyle(
                                  fontFamily: 'LeagueSpartan',
                                  fontSize: screenWidth * 0.07,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.01),

                            TextFormField(
                              cursorColor: Colors.white,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Password';
                                }
                                return null;
                              },
                              controller: passwordController,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.035,
                              ),
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Enter Your Password',
                                hintStyle: TextStyle(
                                  color: Color(0xFF9999A1),
                                  fontSize: screenWidth * 0.035,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: screenWidth * 0.0027,
                                    color: Color(0xFF9999A1),
                                    // color: Colors.blue,
                                  ),
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: screenWidth * 0.0027,
                                    color: Colors.white,
                                    // color: Colors.blue,
                                  ),
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: screenWidth * 0.0027,
                                    color: Colors.red,
                                  ),
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: screenWidth * 0.0027,
                                    color: Colors.white,
                                    // color: Colors.blue,
                                  ),
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04,
                                  vertical: screenHeight * 0.022,
                                ),
                              ),
                              // onChanged: (value) {
                              //   setState(() {
                              //     password = value;
                              //   });
                              // },
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.04),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                register();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,

                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1000),
                              ),
                            ),
                            child: Text(
                              'Register',
                              style: TextStyle(
                                fontFamily: 'LeagueSpartan',
                                fontSize: screenWidth * 0.07,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.035),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already Have an Account?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),

                            SizedBox(width: screenWidth * 0.015),

                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/loginScreen');
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w700,
                                
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.03),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
