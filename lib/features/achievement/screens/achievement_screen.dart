import 'package:fittrack/shared/widgets/navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'detail_achievement_screen.dart';
import '../achievement_controller.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  List<Map<String, dynamic>> _achievementsInfo = [];
  Map<String, dynamic> _userProgress = {
    "achievementId": [],
    "dateAcquired": [],
    "progress": [],
  };
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAchievementData();
  }

  Future<void> _loadAchievementData() async {
    setState(() => _isLoading = true);

    try {
      // Get achievement info
      _achievementsInfo = AchievementController.getAchievementsInfo();

      // Get user achievement data
      final achievementData = await AchievementController.getAchievementData();

      setState(() {
        _userProgress = achievementData;
        _isLoading = false;
      });
    } catch (e) {
      // print('Error loading achievement data: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 3.0,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Achievement",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: (screenWidth / 390) * 20,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: _achievementsInfo.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final badge = _achievementsInfo[index];
            final progress = _userProgress["progress"][index];
            final dateAcquired = _userProgress["dateAcquired"][index];
            final count = badge["count"];
            final bool isComplete = progress >= count;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailAchievementScreen(
                      title: badge["Title"],
                      desc: badge["desc"],
                      category: badge["category"],
                      progress: progress,
                      count: count,
                      dateAcquired: dateAcquired,
                      image: badge["image"],
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Opacity(
                    opacity: isComplete ? 1.0 : 0.5,
                    child: Container(
                      width: screenWidth * 0.22,
                      height: screenWidth * 0.22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(badge["image"]),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: NavigationBarWidget(location: '/achievementScreen'),
    );
  }
}
