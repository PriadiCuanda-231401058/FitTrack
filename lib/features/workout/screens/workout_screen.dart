import 'package:flutter/material.dart';
import 'package:fittrack/shared/widgets/navigation_bar_widget.dart';
import 'package:fittrack/features/workout/workout_controller.dart';
import 'package:fittrack/models/workout_model.dart';
// import 'package:fittrack/features/workout/workout_controller.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  String focusArea = "Arms";
  String goalType = "Strength";

  final WorkoutController _workoutController = WorkoutController();
  List<Workout> _challenges = [];
  List<Workout> _workoutByFocusArea = [];
  List<Workout> _workoutByGoalType = [];
  List<Workout> _popularWorkouts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkoutData();
  }

  String parseDurationFromTitle(String title) {
    // Extract duration from titles like "5-Min Strength Boost" -> "5 Menit"
    final regex = RegExp(r'(\d+)-Min');
    final match = regex.firstMatch(title);
    if (match != null) {
      return '${match.group(1)} Menit';
    }

    // Fallback for other title formats
    if (title.contains('5')) return '5 Menit';
    if (title.contains('7')) return '7 Menit';
    if (title.contains('10')) return '10 Menit';

    return '5 Menit'; // Default
  }

  Future<void> _loadWorkoutData() async {
    setState(() => _isLoading = true);

    try {
      final challenges = await _workoutController.getChallenges();
      final focusWorkouts = await _workoutController.getWorkoutsByBodyFocus(
        focusArea,
      );
      final targetWorkouts = await _workoutController.getWorkoutsByTarget(
        goalType,
      );
      final popular = await _workoutController.getPopularWorkouts();

      setState(() {
        _challenges = challenges;
        _workoutByFocusArea = focusWorkouts;
        _workoutByGoalType = targetWorkouts;
        _popularWorkouts = popular;
      });
    } catch (e) {
      print('Error loading workout data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // note: di dummy data ada beberapa atribut tidak dimasukkan karena kurang diperlukan, tapi di database harus ada

    final int streak = 10;
    final bool isStreak = true;

    // ini nanti ganti dengan data dari provider
    // final List<Map<String, dynamic>> challenges = [
    //   {
    //     "id": 1,
    //     "title": "Abs Attack",
    //     "description":
    //         "Ignites your core with intense moves to burn fat and carve strong, defined abs.",
    //     "bgColor": Color(0x800000FF),
    //     "duration": 7,
    //     "exerciseCount": 3,
    //     "imageURL": "assets/workouts/Challenges/Abs Attack.jfif",
    //   },
    //   {
    //     "id": 2,
    //     "title": "Arm Blaster",
    //     "description":
    //         "Builds explosive strength and power in your arms with muscle-pumping workouts.",
    //     "bgColor": Color(0x80FF6A00),
    //     "duration": 8,
    //     "exerciseCount": 4,
    //     "imageURL": "assets/workouts/Challenges/Arm Blaster.jfif",
    //   },
    // ];

    // // ini nanti ganti dengan data dari provider
    // final List<Map<String, dynamic>> workoutByFocusArea = [
    //   {
    //     "id": 1,
    //     "title": "Beginner",
    //     "focusArea": "Abs",
    //     "exerciseCount": 4,
    //     "duration": 10,
    //     "isPremium": false,
    //     "imageURL": "assets/workouts/Abs/images/Beginner.jfif",
    //   },
    //   {
    //     "id": 2,
    //     "title": "Intermediate",
    //     "focusArea": "Abs",
    //     "exerciseCount": 5,
    //     "duration": 15,
    //     "isPremium": false,
    //     "imageURL": "assets/workouts/Abs/images/Intermediate.jfif",
    //   },
    //   {
    //     "id": 3,
    //     "title": "Advanced",
    //     "focusArea": "Abs",
    //     "exerciseCount": 7,
    //     "duration": 25,
    //     "isPremium": true,
    //     "imageURL": "assets/workouts/Abs/images/Advanced.jfif",
    //   },
    //   {
    //     "id": 4,
    //     "title": "Beginner",
    //     "focusArea": "Arms",
    //     "exerciseCount": 4,
    //     "duration": 10,
    //     "isPremium": false,
    //     "imageURL": "assets/workouts/Arms/images/Beginner.jfif",
    //   },
    //   {
    //     "id": 5,
    //     "title": "Intermediate",
    //     "focusArea": "Arms",
    //     "exerciseCount": 7,
    //     "duration": 15,
    //     "isPremium": false,
    //     "imageURL": "assets/workouts/Arms/images/Intermediate.jfif",
    //   },
    //   {
    //     "id": 6,
    //     "title": "Advanced",
    //     "focusArea": "Arms",
    //     "exerciseCount": 9,
    //     "duration": 23,
    //     "isPremium": true,
    //     "imageURL": "assets/workouts/Arms/images/Advanced.jfif",
    //   },
    //   {
    //     "id": 7,
    //     "title": "Beginner",
    //     "focusArea": "Chest",
    //     "exerciseCount": 4,
    //     "duration": 9,
    //     "isPremium": false,
    //     "imageURL": "assets/workouts/Chest/images/Beginner.jfif",
    //   },
    //   {
    //     "id": 8,
    //     "title": "Intermediate",
    //     "focusArea": "Chest",
    //     "exerciseCount": 5,
    //     "duration": 13,
    //     "isPremium": false,
    //     "imageURL": "assets/workouts/Chest/images/Intermediate.jfif",
    //   },
    //   {
    //     "id": 9,
    //     "title": "Advanced",
    //     "focusArea": "Chest",
    //     "exerciseCount": 7,
    //     "duration": 21,
    //     "isPremium": true,
    //     "imageURL": "assets/workouts/Chest/images/Advanced.jfif",
    //   },
    //   {
    //     "id": 10,
    //     "title": "Beginner",
    //     "focusArea": "Legs",
    //     "exerciseCount": 5,
    //     "duration": 10,
    //     "isPremium": false,
    //     "imageURL": "assets/workouts/Legs/images/Beginner.jfif",
    //   },
    //   {
    //     "id": 11,
    //     "title": "Intermediate",
    //     "focusArea": "Legs",
    //     "exerciseCount": 6,
    //     "duration": 12,
    //     "isPremium": false,
    //     "imageURL": "assets/workouts/Legs/images/Intermediate.jfif",
    //   },
    //   {
    //     "id": 12,
    //     "title": "Advanced",
    //     "focusArea": "Legs",
    //     "exerciseCount": 6,
    //     "duration": 18,
    //     "isPremium": true,
    //     "imageURL": "assets/workouts/Legs/images/Advanced.jfif",
    //   },
    //   {
    //     "id": 13,
    //     "title": "Beginner",
    //     "focusArea": "Shoulders",
    //     "exerciseCount": 6,
    //     "duration": 12,
    //     "isPremium": false,
    //     "imageURL": "assets/workouts/Shoulders/images/Beginner.jfif",
    //   },
    //   {
    //     "id": 14,
    //     "title": "Intermediate",
    //     "focusArea": "Shoulders",
    //     "exerciseCount": 7,
    //     "duration": 15,
    //     "isPremium": false,
    //     "imageURL": "assets/workouts/Shoulders/images/Intermediate.jfif",
    //   },
    //   {
    //     "id": 15,
    //     "title": "Advanced",
    //     "focusArea": "Shoulders",
    //     "exerciseCount": 10,
    //     "duration": 25,
    //     "isPremium": true,
    //     "imageURL": "assets/workouts/Shoulders/images/Advanced.jfif",
    //   },
    //   {
    //     "id": 16,
    //     "title": "Beginner",
    //     "focusArea": "Back",
    //     "exerciseCount": 5,
    //     "duration": 10,
    //     "isPremium": false,
    //     "imageURL": "assets/workouts/Back/images/Beginner.jfif",
    //   },
    //   {
    //     "id": 17,
    //     "title": "Intermediate",
    //     "focusArea": "Back",
    //     "exerciseCount": 5,
    //     "duration": 15,
    //     "isPremium": false,
    //     "imageURL": "assets/workouts/Back/images/Intermediate.jfif",
    //   },
    //   {
    //     "id": 18,
    //     "title": "Advanced",
    //     "focusArea": "Back",
    //     "exerciseCount": 7,
    //     "duration": 21,
    //     "isPremium": true,
    //     "imageURL": "assets/workouts/Back/images/Advanced.jfif",
    //   },
    // ];

    // // ini nanti ganti dengan data dari provider (3 paling populer di tiap goal type)
    // final List<Map<String, dynamic>> workoutByGoalType = [
    //   {
    //     "id": 19,
    //     "title": "5-Min Strong Arms",
    //     "goalType": "Strength",
    //     "exerciseCount": 2,
    //     "duration": 5,
    //     "isPremium": false,
    //     "imageURL": "assets/workouts/Strength/images/5-Min Strong Arms.jfif",
    //   },
    //   {
    //     "id": 20,
    //     "title": "7-Min Full Power",
    //     "goalType": "Strength",
    //     "exerciseCount": 3,
    //     "duration": 7,
    //     "isPremium": false,
    //     "imageURL": "assets/workouts/Strength/images/7-Min Full Power.jfif",
    //   },
    //   {
    //     "id": 21,
    //     "title": "10-Min Core Strength",
    //     "goalType": "Strength",
    //     "exerciseCount": 5,
    //     "duration": 10,
    //     "isPremium": false,
    //     "imageURL": "assets/workouts/Strength/images/10-Min Core Strength.jfif",
    //   },
    //   {
    //     "id": 22,
    //     "title": "5-Min Fast Burn",
    //     "goalType": "Cardio",
    //     "exerciseCount": 3,
    //     "duration": 5,
    //     "isPremium": false,
    //     "imageURL": "assets/workouts/Cardio/images/5-Min Fast Burn.jfif",
    //   },
    //   {
    //     "id": 23,
    //     "title": "7-Min Cardio Blast",
    //     "goalType": "Cardio",
    //     "exerciseCount": 4,
    //     "duration": 7,
    //     "isPremium": false,
    //     "imageURL": "assets/workouts/Cardio/images/7-Min Cardio Blast.jfif",
    //   },
    //   {
    //     "id": 24,
    //     "title": "10-Min Speed Sweat",
    //     "goalType": "Cardio",
    //     "exerciseCount": 6,
    //     "duration": 10,
    //     "isPremium": true,
    //     "imageURL": "assets/workouts/Cardio/images/10-Min Speed Sweat.jfif",
    //   },
    //   {
    //     "id": 25,
    //     "title": "5-Min Quick Stretch",
    //     "goalType": "Flexibility",
    //     "exerciseCount": 3,
    //     "duration": 5,
    //     "isPremium": false,
    //     "imageURL":
    //         "assets/workouts/Flexibility/images/5-Min Quick Stretch.jfif",
    //   },
    //   {
    //     "id": 26,
    //     "title": "7-Min Flex Flow",
    //     "goalType": "Flexibility",
    //     "exerciseCount": 5,
    //     "duration": 7,
    //     "isPremium": false,
    //     "imageURL": "assets/workouts/Flexibility/images/7-Min Flex Flow.jfif",
    //   },
    //   {
    //     "id": 27,
    //     "title": "10-Min Easy Mobility",
    //     "goalType": "Flexibility",
    //     "exerciseCount": 7,
    //     "duration": 10,
    //     "isPremium": false,
    //     "imageURL":
    //         "assets/workouts/Flexibility/images/10-Min Easy Mobility.jfif",
    //   },
    // ];

    // // ini nanti ganti dengan data dari provider (3 workout paling populer)
    // final List<Map<String, dynamic>> popularWorkouts = [
    //   {
    //     "id": 1,
    //     "title": "Beginner",
    //     "focusArea": "Abs",
    //     "exerciseCount": 4,
    //     "duration": 10,
    //     "isPremium": false,
    //     "imageURL": "assets/workouts/Abs/images/Beginner.jfif",
    //   },
    //   {
    //     "id": 24,
    //     "title": "10-Min Speed Sweat",
    //     "goalType": "Cardio",
    //     "exerciseCount": 6,
    //     "duration": 10,
    //     "isPremium": true,
    //     "imageURL": "assets/workouts/Cardio/images/10-Min Speed Sweat.jfif",
    //   },
    //   {
    //     "id": 27,
    //     "title": "10-Min Easy Mobility",
    //     "goalType": "Flexibility",
    //     "exerciseCount": 7,
    //     "duration": 10,
    //     "isPremium": false,
    //     "imageURL":
    //         "assets/workouts/Flexibility/images/10-Min Easy Mobility.jfif",
    //   },
    // ];

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: screenWidth,
          color: Colors.black,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05,
                  top: screenHeight * 0.015,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Daily Workout',
                      style: TextStyle(
                        fontFamily: 'LeagueSpartan',
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(width: screenWidth * 0.05),

                    Image.asset(
                      'assets/images/streak.png',
                      width: screenWidth * 0.05,
                      height: screenHeight * 0.05,
                      color: isStreak ? Color(0xFFFF7518) : Color(0xFF66666E),
                    ),

                    SizedBox(width: screenWidth * 0.02),

                    Text(
                      '$streak',
                      style: TextStyle(
                        fontFamily: 'LeagueSpartan',
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: isStreak ? Color(0xFFFF7518) : Color(0xFF66666E),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.01),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                    bottom: screenHeight * 0.015,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          readOnly: true,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/searchScreen',
                            );
                          },

                          decoration: InputDecoration(
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.035,
                              vertical: screenHeight * 0.015,
                            ),
                            fillColor: Color(0xFFF4F4F6),
                            hint: Row(
                              children: [
                                Image.asset(
                                  'assets/images/search.png',
                                  width: screenWidth * 0.07,
                                  height: screenWidth * 0.07,
                                ),

                                SizedBox(width: screenWidth * 0.02),

                                Text(
                                  'Search Exercise',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    color: Color(0xFF9999A1),
                                  ),
                                ),
                              ],
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.035,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.025),

                        Text(
                          'Challenges',
                          style: TextStyle(
                            fontFamily: 'LeagueSpartan',
                            fontSize: screenWidth * 0.065,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.015),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _challenges.map((challenge) {
                              return Row(
                                children: [
                                  Container(
                                    width: screenWidth * 0.7,
                                    height: screenHeight * 0.25,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          challenge['imageURL'],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        screenWidth * 0.05,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: challenge['bgColor'],
                                        borderRadius: BorderRadius.circular(
                                          screenWidth * 0.05,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          screenWidth * 0.03,
                                        ),
                                        child: Column(
                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              challenge['title'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: screenWidth * 0.045,
                                                fontFamily: 'LeagueSpartan',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),

                                            SizedBox(
                                              height: screenHeight * 0.003,
                                            ),

                                            Text(
                                              challenge['description'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: screenWidth * 0.035,
                                              ),
                                            ),

                                            SizedBox(
                                              height: screenHeight * 0.02,
                                            ),

                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // pindah ke halaman exercise list
                                                  Navigator.pushNamed(
                                                    context,
                                                    '/exerciseListScreen',
                                                    arguments: {
                                                      'challengeID':
                                                          challenge['id'],
                                                      'title':
                                                          challenge['title'],
                                                      'duration':
                                                          challenge['duration'],
                                                      'exerciseCount':
                                                          challenge['exerciseCount'],
                                                    },
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        screenHeight * 0.005,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          1000,
                                                        ),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Start',
                                                  style: TextStyle(
                                                    fontFamily: 'LeagueSpartan',
                                                    fontSize:
                                                        screenWidth * 0.05,
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

                                  SizedBox(width: screenWidth * 0.04),
                                ],
                              );
                            }).toList(),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.025),

                        Text(
                          'Body Focus',
                          style: TextStyle(
                            fontFamily: 'LeagueSpartan',
                            fontSize: screenWidth * 0.065,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.01),

                        Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children:
                                    [
                                      "Abs",
                                      "Arms",
                                      "Chest",
                                      "Legs",
                                      "Shoulders",
                                      "Back",
                                    ].map((area) {
                                      return Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() => focusArea = area);
                                              _loadWorkoutData();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: screenWidth * 0.065,
                                              ),
                                              side: BorderSide(
                                                color: area == focusArea
                                                    ? Color(0xFF1E90FF)
                                                    : Color(0xFF9999A1),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(1000),
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                            child: Text(
                                              area,
                                              style: TextStyle(
                                                color: area == focusArea
                                                    ? Color(0xFF1E90FF)
                                                    : Color(0xFF9999A1),
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),

                                          SizedBox(width: screenWidth * 0.03),
                                        ],
                                      );
                                    }).toList(),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            Column(
                              children: _workoutByFocusArea
                                  .where(
                                    (workout) =>
                                        workout['focusArea'] == focusArea,
                                  )
                                  .map((workout) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // Pindah ke exercise list dengan data body focus
                                            Navigator.pushNamed(
                                              context,
                                              '/exerciseListScreen',
                                              arguments: {
                                                'workoutType': 'bodyFocus',
                                                'focusArea': workout.focusArea,
                                                'level': workout
                                                    .title, // Beginner, Intermediate, Advanced
                                                'title':
                                                    '${workout.focusArea} ${workout.title}',
                                                'duration': workout.duration,
                                                'exerciseCount':
                                                    workout.exerciseCount,
                                                'isPremium': workout.isPremium,
                                              },
                                            );
                                          },
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: screenHeight * 0.1,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: screenHeight * 0.1,
                                                  height: screenHeight * 0.1,

                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                        workout['imageURL'],
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          screenWidth * 0.04,
                                                        ),
                                                  ),
                                                ),

                                                SizedBox(
                                                  width: screenWidth * 0.025,
                                                ),

                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        workout['title'],
                                                        style: TextStyle(
                                                          fontSize:
                                                              screenWidth *
                                                              0.035,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),

                                                      SizedBox(
                                                        height:
                                                            screenHeight *
                                                            0.005,
                                                      ),

                                                      Text(
                                                        '${workout['duration']} minutes, ${workout['exerciseCount']} exercises',
                                                        style: TextStyle(
                                                          fontSize:
                                                              screenWidth *
                                                              0.035,
                                                          color: Color(
                                                            0xFF9999A1,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                if (workout['isPremium'])
                                                  Image.asset(
                                                    'assets/images/lock.png',
                                                    width: screenWidth * 0.085,
                                                    height: screenWidth * 0.085,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: screenHeight * 0.02),
                                      ],
                                    );
                                  })
                                  .toList(),
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.005),

                        Text(
                          'Target',
                          style: TextStyle(
                            fontFamily: 'LeagueSpartan',
                            fontSize: screenWidth * 0.065,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.01),

                        Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: ["Strength", "Cardio", "Flexibility"]
                                    .map((goal) {
                                      return Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() => goalType = goal);
                                              _loadWorkoutData();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: screenWidth * 0.065,
                                              ),
                                              side: BorderSide(
                                                color: goal == goalType
                                                    ? Color(0xFF1E90FF)
                                                    : Color(0xFF9999A1),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(1000),
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                            child: Text(
                                              goal,
                                              style: TextStyle(
                                                color: goal == goalType
                                                    ? Color(0xFF1E90FF)
                                                    : Color(0xFF9999A1),
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),

                                          SizedBox(width: screenWidth * 0.03),
                                        ],
                                      );
                                    })
                                    .toList(),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            Column(
                              children: _workoutByGoalType
                                  .where(
                                    (workout) =>
                                        workout['goalType'] == goalType,
                                  )
                                  .map((workout) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // Pindah ke exercise list dengan data target
                                            Navigator.pushNamed(
                                              context,
                                              '/exerciseListScreen',
                                              arguments: {
                                                'workoutType': 'target',
                                                'target': workout.goalType,
                                                'duration': workout.duration,
                                                'title': workout.title,
                                                'exerciseCount':
                                                    workout.exerciseCount,
                                                'isPremium': workout.isPremium,
                                              },
                                            );
                                          },
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: screenHeight * 0.1,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: screenHeight * 0.1,
                                                  height: screenHeight * 0.1,

                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                        workout['imageURL'],
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          screenWidth * 0.04,
                                                        ),
                                                  ),
                                                ),

                                                SizedBox(
                                                  width: screenWidth * 0.025,
                                                ),

                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        workout['title'],
                                                        style: TextStyle(
                                                          fontSize:
                                                              screenWidth *
                                                              0.035,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),

                                                      SizedBox(
                                                        height:
                                                            screenHeight *
                                                            0.005,
                                                      ),

                                                      Text(
                                                        '${workout['duration']} minutes, ${workout['exerciseCount']} exercises',
                                                        style: TextStyle(
                                                          fontSize:
                                                              screenWidth *
                                                              0.035,
                                                          color: Color(
                                                            0xFF9999A1,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                if (workout['isPremium'])
                                                  Image.asset(
                                                    'assets/images/lock.png',
                                                    width: screenWidth * 0.085,
                                                    height: screenWidth * 0.085,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: screenHeight * 0.02),
                                      ],
                                    );
                                  })
                                  .toList(),
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.005),

                        Text(
                          'Popular',
                          style: TextStyle(
                            fontFamily: 'LeagueSpartan',
                            fontSize: screenWidth * 0.065,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.01),

                        Column(
                          children: _popularWorkouts.map((workout) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Tentukan tipe workout berdasarkan data yang ada
                                    final Map<String, dynamic> arguments = {
                                      'title': workout.title,
                                      'duration': workout.duration,
                                      'exerciseCount': workout.exerciseCount,
                                      'isPremium': workout.isPremium,
                                    };

                                    // Tambahkan parameter berdasarkan tipe workout
                                    if (workout.focusArea != null) {
                                      arguments['workoutType'] = 'bodyFocus';
                                      arguments['focusArea'] =
                                          workout.focusArea;
                                      arguments['level'] = workout.title;
                                    } else if (workout.goalType != null) {
                                      arguments['workoutType'] = 'target';
                                      arguments['target'] = workout.goalType;
                                      arguments['durationLevel'] =
                                          parseDurationFromTitle(workout.title);
                                    }

                                    Navigator.pushNamed(
                                      context,
                                      '/exerciseListScreen',
                                      arguments: arguments,
                                    );
                                  },
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: screenHeight * 0.1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: screenHeight * 0.1,
                                          height: screenHeight * 0.1,

                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                workout['imageURL'],
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              screenWidth * 0.04,
                                            ),
                                          ),
                                        ),

                                        SizedBox(width: screenWidth * 0.025),

                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                workout['title'],
                                                style: TextStyle(
                                                  fontSize: screenWidth * 0.035,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),

                                              SizedBox(
                                                height: screenHeight * 0.005,
                                              ),

                                              Text(
                                                '${workout['duration']} minutes, ${workout['exerciseCount']} exercises',
                                                style: TextStyle(
                                                  fontSize: screenWidth * 0.035,
                                                  color: Color(0xFF9999A1),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        if (workout['isPremium'])
                                          Image.asset(
                                            'assets/images/lock.png',
                                            width: screenWidth * 0.085,
                                            height: screenWidth * 0.085,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.02),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              NavigationBarWidget(location: '/workoutScreen'),
            ],
          ),
        ),
      ),
    );
  }
}
