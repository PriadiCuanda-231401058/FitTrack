import 'package:firebase_core/firebase_core.dart';
import 'package:fittrack/shared/widgets/navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:fittrack/models/workout_model.dart';
import 'package:fittrack/features/workout/workout_controller.dart';
import 'package:fittrack/features/settings/screens/premium_features_screen.dart';
import 'package:fittrack/features/settings/widgets/custom_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  final WorkoutController _workoutController = WorkoutController();

  List<Map<String, dynamic>> _exerciseList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _loadExercises();
    });
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (_) => CustomPopup(child: PremiumFeaturesScreen()),
    );
  }

  Future<void> _loadExercises() async {
    setState(() => _isLoading = true);

    try {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      final String? workoutType = args?['workoutType'];
      final String? title = args?['title'] ?? '';
      final String? focusArea = args?['focusArea'];
      final String? level = args?['level'];
      final String? target = args?['target'];
      final bool? isPremium = args?['isPremium'];

      if (isPremium == true) {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();
          final data = doc.data();
          print('Premium data: $data["isPremium"]');
          if (data != null && data['isPremium'] != true) {
            setState(() => _isLoading = false);
            Navigator.pushReplacementNamed(context, '/workoutScreen');
            _showPremiumDialog();
            // Navigator.pop(context);
            return;
          }
        }
      }

      List<Exercise> exercises = [];

      if (workoutType == 'bodyFocus' && focusArea != null && level != null) {
        exercises = await _workoutController.getExercisesForWorkout(
          focusArea: focusArea,
          level: level,
        );
      } else if (workoutType == 'target' && target != null) {
        // final duration = args?['duration'];
        exercises = await _workoutController.getExercisesForWorkout(
          target: target,
          duration: title,
        );
      } else if (workoutType == 'challenge' && title != null) {
        exercises = await _workoutController.getExercisesForWorkout(
          challengeID: title,
        );
      }

      final List<Map<String, dynamic>> exerciseList = exercises.map((exercise) {
        int? minutes;
        int? seconds;
        int? repetition;

        if (exercise.type.contains('time')) {
          minutes = exercise.value ~/ 60;
          seconds = exercise.value % 60;
          repetition = null;
        } else {
          minutes = null;
          seconds = null;
          repetition = exercise.value;
        }

        return {
          "id": exercise.id.hashCode,
          "name": exercise.name,
          "minutes": minutes,
          "seconds": seconds,
          "repetition": repetition,
          // "videoURL": exercise.media,
          "videoURL": 'assets/workouts/Videos/${exercise.name}.gif',
          "rest": exercise.rest,
          "type": exercise.type,
        };
      }).toList();

      setState(() {
        _exerciseList = exerciseList;
      });
    } catch (e) {
      print('Error loading exercises: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load exercises')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final String title = args?['title'] ?? 'Workout';
    final duration = args?['duration'] ?? 0;
    final int exerciseCount = args?['exerciseCount'] ?? 0;

    print("DEBUG ARGS: $args");

    // print("workoutType: ${args?['workoutType']} (${args?['workoutType'].runtimeType})");
    // print("focusArea:   ${args?['focusArea']}   (${args?['focusArea'].runtimeType})");
    // print("level:       ${args?['level']}       (${args?['level'].runtimeType})");
    // print("target:      ${args?['target']}      (${args?['target'].runtimeType})");
    // print("duration:    ${args?['duration']}    (${args?['duration'].runtimeType})");
    // print("isPremium:   ${args?['isPremium']}   (${args?['isPremium'].runtimeType})");

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // if (_exerciseList.isEmpty) {
    //   Navigator.pushReplacementNamed(context, '/workoutScreen');
    // }

    // ini nanti select exercise yang challengeID-nya sama dengan challengeID
    // kalau challengeID null, select berdasarkan workoutID
    // final List<Map<String, dynamic>> exerciseList = [
    //   {
    //     "id": 1,
    //     "name": "Crunches",
    //     "minutes": null,
    //     "seconds": null,
    //     "repetition": 15,
    //     "videoURL": "",
    //   },
    //   {
    //     "id": 2,
    //     "name": "Russian Twists",
    //     "minutes": null,
    //     "seconds": null,
    //     "repetition": 20,
    //     "videoURL": "",
    //   },
    //   {
    //     "id": 1,
    //     "name": "Plank",
    //     "minutes": null,
    //     "seconds": 15,
    //     "repetition": null,
    //     "videoURL": "",
    //   },
    // ];

    // _loadExercises();

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

                        ..._exerciseList.map((exercise) {
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
                              Navigator.pushNamed(
                                context,
                                '/workoutDetailScreen',
                                arguments: {
                                  'exerciseList': _exerciseList,
                                  'workoutType':
                                      args?['workoutType'], // 'bodyFocus' atau 'target'
                                  'focusArea':
                                      args?['focusArea'], // 'ABS', 'ARMS', dll
                                  'level':
                                      args?['level'], // 'Beginner', 'Intermediate', 'Advanced'
                                  'target':
                                      args?['target'], // 'Strength', 'Cardio', 'Flexibility'
                                  'title': args?['title'],
                                  'duration': duration,
                                },
                              );
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
