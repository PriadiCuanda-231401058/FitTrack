import 'package:fittrack/shared/widgets/navigation_bar_widget.dart';
import 'package:flutter/material.dart';

class ExerciseListScreen extends StatelessWidget {
  const ExerciseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final int? challengeID = args?['challengeID'];
    final String? title = args?['title'];
    final int? duration = args?['duration'];
    final int? exerciseCount = args?['exerciseCount'];

    final int? workoutID = null;
    // ini nanti select exercise yang challengeID-nya sama dengan challengeID
    // kalau challengeID null, select berdasarkan workoutID
    final List<Map<String, dynamic>> exerciseList = [
      {
        "id": 1,
        "name": "Crunches",
        "minutes": null,
        "seconds": null,
        "repetition": 15,
        "videoURL": "",
      },
      {
        "id": 2,
        "name": "Russian Twists",
        "minutes": null,
        "seconds": null,
        "repetition": 20,
        "videoURL": "",
      },
      {
        "id": 1,
        "name": "Plank",
        "minutes": null,
        "seconds": 15,
        "repetition": null,
        "videoURL": "",
      },
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
      ),
      body: Container(
        height: screenHeight,
        color: Colors.black,
        child: Column(
          children: [
            Image.asset(
              'assets/workouts/exercise_list_hero.jfif',
              width: double.infinity,
              height: screenHeight * 0.27,
              fit: BoxFit.cover,
            ),

            Expanded(
              child: Transform.translate(
                offset: Offset(0, -screenHeight * 0.025),
                child: Container(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                    top: screenHeight * 0.02,
                    bottom: screenHeight * 0.02,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(screenWidth * 0.05),
                      topRight: Radius.circular(screenWidth * 0.05),
                    ),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$title',
                          style: TextStyle(
                            fontFamily: 'LeagueSpartan',
                            fontSize: screenWidth * 0.07,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.025),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: screenWidth * 0.42,
                              height: screenHeight * 0.09,
                              decoration: BoxDecoration(
                                color: Color(0xFFF4F4F6),
                                borderRadius: BorderRadius.circular(
                                  screenWidth * 0.035,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '$duration',
                                    style: TextStyle(
                                      height: 1,
                                      fontFamily: 'LeagueSpartan',
                                      fontSize: screenWidth * 0.065,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    'minutes',
                                    style: TextStyle(
                                      height: 1,
                                      color: Color(0xFF66666E),
                                      fontSize: screenWidth * 0.035,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: screenWidth * 0.42,
                              height: screenHeight * 0.09,
                              decoration: BoxDecoration(
                                color: Color(0xFFF4F4F6),
                                borderRadius: BorderRadius.circular(
                                  screenWidth * 0.035,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '$exerciseCount',
                                    style: TextStyle(
                                      height: 1,
                                      fontFamily: 'LeagueSpartan',
                                      fontSize: screenWidth * 0.065,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    'exercises',
                                    style: TextStyle(
                                      height: 1,
                                      color: Color(0xFF66666E),
                                      fontSize: screenWidth * 0.035,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.025),

                        Text(
                          'Exercises',
                          style: TextStyle(
                            fontFamily: 'LeagueSpartan',
                            fontSize: screenWidth * 0.065,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.01),

                        ...exerciseList.map((exercise) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.025,
                            ),
                            decoration: BoxDecoration(
                              border: BoxBorder.fromLTRB(
                                bottom: BorderSide(color: Colors.white),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${exercise['name']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Text(
                                  exercise['repetition'] != null
                                      ? 'x${exercise['repetition']}'
                                      : '${exercise['minutes'] ?? '00'}:${exercise['seconds']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        SizedBox(height: screenHeight * 0.055),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // masuk ke exercise detail yang berisi video, dll
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
                              'Start',
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
                ),
              ),
            ),

            NavigationBarWidget(location: '/workoutScreen'),
          ],
        ),
      ),
    );
  }
}
