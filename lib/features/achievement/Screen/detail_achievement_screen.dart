import 'package:flutter/material.dart';
import '../Widget/info_card.dart';

class DetailAchievementScreen extends StatelessWidget {
  final String title;
  final String desc;
  final String category;
  final int progress;
  final int total;
  final String dateAcquired;
  final String image;

  const DetailAchievementScreen({
    super.key,
    required this.title,
    required this.desc,
    required this.category,
    required this.progress,
    required this.total,
    required this.dateAcquired,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double percent = (progress / total) * 100;
    if (percent > 100) percent = 100;

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
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.055,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.015),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.02),

              Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.085,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: screenHeight * 0.015),

              Text(
                desc,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: screenHeight * 0.03),

              Image.asset(
                image,
                width: screenWidth * 0.45,
              ),

              SizedBox(height: screenHeight * 0.03),

              InfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Progress",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: screenWidth * 0.05)),

                    SizedBox(height: screenHeight * 0.01),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("$progress H / $total H",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: screenWidth * 0.05)),
                        Text("${percent.toStringAsFixed(0)}%",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: screenWidth * 0.05)),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress / total,
                        minHeight: 12,
                        backgroundColor: Colors.black,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.015),

              InfoCard(
                child: Text(
                  "Category : $category",
                  style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: screenWidth * 0.05),
                ),
              ),

              SizedBox(height: screenHeight * 0.015),

              InfoCard(
                child: Text(
                  "Date Acquired : $dateAcquired",
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: screenWidth * 0.05),
                ),
              ),

              SizedBox(height: screenHeight * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
