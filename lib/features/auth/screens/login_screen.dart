import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fittrack/features/auth/auth_controller.dart';
import 'package:fittrack/features/auth/widgets/error_message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fittrack/models/user_model.dart';
// import 'package:fittrack/features/auth/screens/register_screen.dart';
// import 'package:fittrack/features/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool('remember_me') ?? false;
      if (rememberMe) {
        emailController.text = prefs.getString('email') ?? '';
        passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // String email = "", password = "";

  // bool rememberMe = false;
  bool showError = false;
  String errorMessage = "";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> handleGoogleSignIn() async {
    // setState(() => _isLoading = true);

    try {
      // 🔹 Panggil fungsi dari AuthController
      UserModel? userModel = await authController.value.signInWithGoogle();

      if (userModel != null && mounted) {
        // 🔹 Jika berhasil, pindah ke HomeScreen
        Navigator.pushNamed(context, '/homeScreen');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal login dengan Google')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void login() async {
    try {
      await authController.value.login(
        emailController.text,
        passwordController.text,
      );

      final prefs = await SharedPreferences.getInstance();

      if (rememberMe) {
        await prefs.setBool('remember_me', true);
        await prefs.setString('email', emailController.text);
        await prefs.setString('password', passwordController.text);
      } else {
        await prefs.clear(); // hapus semua data login
      }

      if (!mounted) return; // untuk memastikan context masih aktif

      Navigator.pushNamed(context, '/homeScreen');
    } on FirebaseAuthException catch (e) {
      setState(() {
        showError = true;
        errorMessage = e.message ?? 'Something went wrong.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.black,
          constraints: BoxConstraints(
            minWidth: screenWidth,
            minHeight: screenHeight,
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
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
                          handleGoogleSignIn();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>((states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return Colors.white;
                                }
                                return Colors.transparent;
                              }),
                          foregroundColor:
                              WidgetStateProperty.resolveWith<Color>((states) {
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
                            return BorderSide(
                              width: 1,
                              color: Color(0xFF9999A1),
                            );
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
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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

                            SizedBox(height: screenHeight * 0.02),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Transform.translate(
                                      offset: Offset(-screenWidth * 0.03, 0),
                                      child: Transform.scale(
                                        scale: 1.2,
                                        child: Checkbox(
                                          value: rememberMe,
                                          checkColor: Color(0xFF1E90FF),
                                          fillColor:
                                              WidgetStateProperty.resolveWith<
                                                Color
                                              >((states) {
                                                return Colors.white;
                                              }),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          side: BorderSide(
                                            width: screenWidth * 0.0035,
                                            color: Color(0xFFA1999F),
                                          ),
                                          onChanged: (bool? value) {
                                            setState(() {
                                              rememberMe = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),

                                    Transform.translate(
                                      offset: Offset(-screenWidth * 0.05, 0),
                                      child: Text(
                                        'Remember me',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenWidth * 0.035,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                TextButton(
                                  onPressed: () {
                                    // pindah ke halaman verifikasi kode
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size(0, 0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth * 0.035,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    login();
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
                                  'Login',
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
                                  'Don\'t Have an Account?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.035,
                                  ),
                                ),

                                SizedBox(width: screenWidth * 0.015),

                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/registerScreen',
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size(0, 0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Register',
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

              if (showError)
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: ErrorMessage(
                    message: errorMessage,
                    onDismiss: () => setState(() => showError = false),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
