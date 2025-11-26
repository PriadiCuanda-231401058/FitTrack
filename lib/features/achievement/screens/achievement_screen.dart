import 'package:fittrack/shared/widgets/navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'detail_achievement_screen.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final List<Map<String, dynamic>> badges = [
      {
        "id": 1,
        "image": "assets/images/badge1.png",
        "category": "Strength Training",
        "date acquired": "17 Okt 2025",
        "progress": "101",
        "total": "100",
        "Title": "Elite Lifter",
        "desc":
            "Diberikan kepada pengguna yang menunjukkan performa luar biasa dalam latihan kekuatan. Bukti dedikasi dan kerja keras yang konsisten!",
      },
      {
        "id": 2,
        "image": "assets/images/badge2.png",
        "category": "General Fitness",
        "date acquired": "28 Sept 2025",
        "progress": "120",
        "total": "100",
        "Title": "Full Body Achiever",
        "desc":
            "Pengguna yang meraih perkembangan seimbang di berbagai aspek kebugaran—kardio, kekuatan, dan mobilitas.",
      },
      {
        "id": 3,
        "image": "assets/images/badge3.png",
        "category": "Strength",
        "date acquired": "16 Okt 2025",
        "progress": "75",
        "total": "100",
        "Title": "Power Performer",
        "desc":
            "Penghargaan bagi pengguna yang menunjukkan ketahanan fisik kuat dan pencapaian signifikan dalam latihan intensitas menengah-tinggi.",
      },
      {
        "id": 4,
        "image": "assets/images/badge4.png",
        "category": "Mindfulness",
        "date acquired": "10 August 2025",
        "progress": "21",
        "total": "30",
        "Title": "Strong Mind Beginner",
        "desc":
            "Diberikan kepada pengguna yang memulai perjalanan meningkatkan fokus, konsistensi, dan ketahanan mental. Langkah kecil, progres besar!",
      },
      {
        "id": 5,
        "image": "assets/images/badge5.png",
        "category": "Discipline",
        "date acquired": "-",
        "progress": "5",
        "total": "15",
        "Title": "Consistency Starter",
        "desc":
            "Penghargaan untuk pengguna yang telah menunjukkan kedisiplinan awal dalam mengikuti jadwal rutin latihan atau aktivitas.",
      },
    ];

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
          itemCount: badges.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final badge = badges[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailAchievementScreen(
                      title: badge["Title"],
                      desc: badge["desc"],
                      category: badge["category"],
                      progress: int.parse(badge["progress"]),
                      total: int.parse(badge["total"]),
                      dateAcquired: badge["date acquired"],
                      image: badge["image"],
                    ),
                  ),
                );
              },

              child: Column(
                children: [
                  Container(
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
                  SizedBox(height: screenHeight * 0.01),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: NavigationBarWidget(location: '/achievementScreen'),
      ),
    );
  }
}
