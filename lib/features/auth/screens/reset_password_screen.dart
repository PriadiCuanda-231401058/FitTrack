import 'package:flutter/material.dart';
import 'package:fittrack/shared/widgets/error_message.dart';
import 'package:fittrack/shared/widgets/success_message.dart';
import 'package:fittrack/features/auth/auth_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool? successSendEmail;
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  Future<void> handleResetPassword(BuildContext context, String email) async {
    // Tampilkan loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Jalankan fungsi utama dari controller
    successSendEmail = await authController.value.resetPassword(email);

    // Tutup loading
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          color: Colors.black,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/fittrack_logo.png',
                          width: screenWidth * 0.14,
                        ),

                        SizedBox(width: screenWidth * 0.02),

                        Text(
                          'FitTrack',
                          style: TextStyle(
                            fontFamily: 'LeagueSpartan',
                            fontSize: screenWidth * 0.065,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    Text(
                      'Reset Password',
                      style: TextStyle(
                        fontFamily: 'LeagueSpartan',
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    Text(
                      'Reset your password quickly and securely to regain access.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        children: [
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
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final email = emailController.text.trim();
                                  if (email.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please enter your email',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  await handleResetPassword(context, email);
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
                                'Continue',
                                style: TextStyle(
                                  fontFamily: 'LeagueSpartan',
                                  fontSize: screenWidth * 0.07,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/loginScreen',
                          (route) => false,
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Back To Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              successSendEmail != null
                  ? successSendEmail == true
                        ? Padding(
                            padding: EdgeInsets.all(screenWidth * 0.05),
                            child: SuccessMessage(
                              message: "Success",
                              onDismiss: () =>
                                  setState(() => successSendEmail = null),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.all(screenWidth * 0.05),
                            child: ErrorMessage(
                              message: "Error",
                              onDismiss: () =>
                                  setState(() => successSendEmail = null),
                            ),
                          )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
