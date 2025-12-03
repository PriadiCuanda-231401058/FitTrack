import 'package:fittrack/features/achievement/screens/achievement_screen.dart';
import 'package:fittrack/features/report/screens/bmi_screen.dart';
import 'package:fittrack/features/report/screens/report_screen.dart';
import 'package:fittrack/features/settings/screens/settings_screen.dart';
import 'package:fittrack/features/workout/screens/search_screen.dart';
import 'package:fittrack/features/workout/screens/workout_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:fittrack/features/splash/splash_screen.dart';
import 'package:fittrack/features/auth/screens/login_screen.dart';
import 'package:fittrack/features/auth/screens/register_screen.dart';
import 'package:fittrack/features/auth/screens/reset_password_screen.dart';
import 'package:fittrack/features/home/home_screen.dart';
import 'package:fittrack/features/workout/screens/workout_screen.dart';
import 'package:fittrack/features/workout/screens/exercise_list_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  '/loginScreen': (context) => const LoginScreen(),
  '/registerScreen': (context) => const RegisterScreen(),
  '/resetPasswordScreen': (context) => const ResetPasswordScreen(),
  '/homeScreen': (context) => const HomeScreen(),
  '/settingsScreen': (context) => const SettingsScreen(),
  '/achievementScreen': (context) => const AchievementScreen(),
  '/workoutScreen': (context) => const WorkoutScreen(),
  '/exerciseListScreen': (context) => const ExerciseListScreen(),
  '/workoutDetailScreen': (context) => const WorkoutDetailScreen(),
  '/reportScreen': (context) => const ReportScreen(),
  '/bmiScreen': (context) => const BmiScreen(),
  '/searchScreen' : (context) => const SearchScreen(),
};
