import 'dart:math';
import 'package:fittrack/features/leaderboard/leaderboard_controller.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool isWeekly = false;
  bool isLoading = false;
  // contoh data dummy, tinggal diganti dengan data dari database
  // final List<Map<String, dynamic>> weeklyLeaderboard = [
  //   {'name': 'Alice', 'point': 120},
  //   {'name': 'Bob', 'point': 90},
  //   {'name': 'James', 'point': 80},
  //   {'name': 'Charlie', 'point': 70},
  //   {'name': 'Charlie', 'point': 70},
  //   {'name': 'Charlie', 'point': 70},
  //   {'name': 'Charlie', 'point': 70},
  //   {'name': 'Charlie', 'point': 70},
  //   {'name': 'Charlie', 'point': 65},
  //   {'name': 'Charlie', 'point': 70},
  //   {'name': 'Charlie', 'point': 70},
  //   {'name': 'Charlie', 'point': 65},
  // ];

  // final List<Map<String, dynamic>> monthlyLeaderboard = [
  //   {'name': 'Alice', 'point': 450},
  //   {'name': 'Bob', 'point': 410},
  //   {'name': 'Charlie', 'point': 380},
  //   {'name': 'James', 'point': 280},
  //   {'name': 'James', 'point': 280},
  //   {'name': 'James', 'point': 280},
  //   {'name': 'James', 'point': 280},
  //   {'name': 'James', 'point': 280},
  //   {'name': 'James', 'point': 280},
  //   {'name': 'James', 'point': 280},
  //   {'name': 'James', 'point': 280},
  //   {'name': 'James', 'point': 280},
  // ];

  final LeaderboardController _leaderboardController = LeaderboardController();
  
  // Data dari controller akan menggantikan data dummy
  List<Map<String, dynamic>> weeklyLeaderboard = [];
  List<Map<String, dynamic>> monthlyLeaderboard = [];

  @override
  void initState() {
    super.initState();
    _loadWeeklyLeaderboard();
  }

  Future<void> _loadWeeklyLeaderboard() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    
    try {
      final data = await _leaderboardController.getWeeklyLeaderboard();
      if (mounted) {
        setState(() {
          weeklyLeaderboard = data;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading weekly leaderboard: $e');
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _loadMonthlyLeaderboard() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    
    try {
      final data = await _leaderboardController.getMonthlyLeaderboard();
      if (mounted) {
        setState(() {
          monthlyLeaderboard = data;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading monthly leaderboard: $e');
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final leaderboardData = isWeekly ? weeklyLeaderboard : monthlyLeaderboard;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.05),
          child: ElevatedButton(
            onPressed: () {
              // tambahi fungsi untuk back ke halaman sebelumnya
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
            ),
            child: Image.asset('assets/images/arrow_back.png'),
          ),
        ),
        title: Text(
          'Leaderboard',
          style: TextStyle(
            fontFamily: 'LeagueSpartan',
            fontSize: screenWidth * 0.07,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        width: screenWidth,
        height: screenHeight,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.01,
                bottom: screenHeight * 0.025,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tombol Weekly
                  ElevatedButton(
                    onPressed: () {
                      _loadWeeklyLeaderboard();
                      setState(() => isWeekly = true);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                      backgroundColor: isWeekly
                          ? Color(0xFF66666E)
                          : Colors.transparent,
                    ),
                    child: Text(
                      'Weekly',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  SizedBox(width: screenWidth * 0.1),

                  // Tombol Monthly
                  ElevatedButton(
                    onPressed: () {
                      _loadMonthlyLeaderboard();
                      setState(() => isWeekly = false);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                      backgroundColor: !isWeekly
                          ? Color(0xFF66666E)
                          : Colors.transparent,
                    ),
                    child: Text(
                      'Monthly',
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

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.035),
                child: ListView.builder(
                  itemCount: min(leaderboardData.length, 10),
                  itemBuilder: (context, index) {
                    final user = leaderboardData[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                      decoration: BoxDecoration(
                        color: index == 0
                            ? Color(0xFFF2DE7A)
                            : index == 1
                            ? Color(0xFFC0C0C0)
                            : index == 2
                            ? Color(0xFFF2BA7A)
                            : Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(
                          screenWidth * 0.025,
                        ),
                      ),
                      child: ListTile(
                        leading: Text(
                          (index + 1).toString(),
                          style: TextStyle(fontSize: screenWidth * 0.035),
                        ),
                        title: Text(
                          user['name'],
                          style: TextStyle(fontSize: screenWidth * 0.035),
                        ),
                        trailing: Text(
                          '${user['point'].toString()} pt',
                          style: TextStyle(fontSize: screenWidth * 0.035),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Container(
              color: Colors.white,
              height: screenHeight * 0.075,
              child: Row(children: [Text('Ini navigation')]),
            ),
          ],
        ),
      ),
    );
  }
}
