import 'package:flutter/material.dart';
import 'package:fittrack/models/workout_model.dart';

class WorkoutList extends StatelessWidget {
  final List<Workout> workouts;
  final String workoutType;

  const WorkoutList({
    super.key,
    required this.workouts,
    required this.workoutType,
  });

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: workouts.map((workout) {
        return Column(
          children: [
            GestureDetector(
              onTap: workoutType != 'popular'
                  ? () {
                      print(workout);
                      // Pindah ke exercise list dengan data body focus
                      Navigator.pushNamed(
                        context,
                        '/exerciseListScreen',
                        arguments: {
                          'workoutType': workoutType,
                          'focusArea': workoutType == 'bodyFocus'
                              ? workout.focusArea
                              : null,
                          'level': workoutType == 'bodyFocus'
                              ? workout.title
                              : null, // Beginner, Intermediate, Advanced
                          'target': workoutType == 'target'
                              ? workout.goalType
                              : null,
                          'title': workoutType == 'bodyFocus'
                              ? '${workout.focusArea} ${workout.title}'
                              : workout.title,
                          'duration': workout.duration,
                          'exerciseCount': workout.exerciseCount,
                          'isPremium': workout.isPremium,
                        },
                      );
                    }
                  : () {
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
                        arguments['focusArea'] = workout.focusArea;
                        arguments['level'] = workout.title;
                      } else if (workout.goalType != null) {
                        arguments['workoutType'] = 'target';
                        arguments['target'] = workout.goalType;
                        arguments['durationLevel'] = parseDurationFromTitle(
                          workout.title,
                        );
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: screenHeight * 0.1,
                      height: screenHeight * 0.1,

                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(workout['imageURL']),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(screenWidth * 0.04),
                      ),
                    ),

                    SizedBox(width: screenWidth * 0.025),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            workout['title'],
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.005),

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
    );
  }
}
