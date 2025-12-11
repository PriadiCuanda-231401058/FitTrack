import 'package:fittrack/features/workout/widgets/workout_list.dart';
import 'package:flutter/material.dart';
import 'package:fittrack/shared/widgets/navigation_bar_widget.dart';
import 'package:fittrack/features/workout/workout_controller.dart';
import 'package:fittrack/models/workout_model.dart';
// import 'package:fittrack/features/auth/auth_controller.dart';
import 'package:fittrack/features/report/streakManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  int _currentStreak = 0;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _loadWorkoutData();
    _loadStreak();
  }

  Future<void> _loadStreak() async {
    // final authController = context.read<AuthController>();
    // final user = authController.currentUser;
    final user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      final streakManager = StreakManager();
      final streakData = await streakManager.getUserStreakData(user.uid);
      
      setState(() {
        _currentStreak = streakData.streak;
        _isActive = streakData.isActive;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
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
    // ini harus ambil dari data user
    final int streak = _currentStreak;
    final bool isStreak = _isActive;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                            Navigator.pushNamed(context, '/searchScreen');
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
                                                      'workoutType':
                                                          'challenge',
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

                            WorkoutList(
                              workouts: _workoutByFocusArea,
                              workoutType: 'bodyFocus',
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

                            WorkoutList(
                              workouts: _workoutByGoalType,
                              workoutType: 'target',
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

                        WorkoutList(
                          workouts: _popularWorkouts,
                          workoutType: 'popular',
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
