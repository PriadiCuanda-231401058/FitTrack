import 'package:flutter/material.dart';

class NavigationBarWidget extends StatefulWidget {
  final String? location;

  const NavigationBarWidget({super.key, required this.location});

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  Widget buildNavItem(String route, String iconPath) {
    return GestureDetector(
      onTap: () {
        if (widget.location != route) {
          Navigator.pushNamed(context, route);
        }
      },
      child: Image.asset(
        iconPath,
        color: widget.location == route ? Colors.blue : Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Color(0xFF1F1F1F),
      padding: EdgeInsets.symmetric(vertical: 15),
      // height: screenHeight * 0.05,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildNavItem('/workoutScreen', 'assets/images/workout_icon.png'),
          buildNavItem(
            '/achievementScreen',
            'assets/images/achievement_icon.png',
          ),
          buildNavItem(
            '/leaderboardScreen',
            'assets/images/leaderboard_icon.png',
          ),
          buildNavItem('/reportScreen', 'assets/images/report_icon.png'),
          buildNavItem('/settingsScreen', 'assets/images/setting_icon.png'),
        ],
      ),
    );
  }
}
