import 'package:flutter/material.dart';
import 'package:fittrack/features/auth/screens/login_screen.dart';
import 'package:fittrack/features/auth/screens/register_screen.dart';
import 'package:fittrack/features/home/home_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const RegisterScreen(),
  '/loginScreen': (context) => const LoginScreen(),
  '/homeScreen': (context) => const HomeScreen(),
};
