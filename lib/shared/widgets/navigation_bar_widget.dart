import 'package:flutter/material.dart';

class NavigationBarWidget extends StatefulWidget {
  final String? location;

  const NavigationBarWidget({super.key, required this.location});

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.black,
      height: screenHeight * 0.05,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'assets/images/workout_icon.png',
            color: widget.location == '/workoutScreen'
                ? Colors.blue
                : Colors.white,
          ),
          Image.asset(
            'assets/images/achievement_icon.png',
            color: widget.location == '/achievementScreen'
                ? Colors.blue
                : Colors.white,
          ),
          Image.asset(
            'assets/images/leaderboard_icon.png',
            color: widget.location == '/leaderboardScreen'
                ? Colors.blue
                : Colors.white,
          ),
          Image.asset(
            'assets/images/report_icon.png',
            color: widget.location == '/reportScreen'
                ? Colors.blue
                : Colors.white,
          ),
          Image.asset(
            'assets/images/setting_icon.png',
            color: widget.location == '/settingsScreen'
                ? Colors.blue
                : Colors.white,
          ),
        ],
      ),
    );
  }
}
