import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fittrack/features/report/report_controller.dart';
import 'package:fittrack/features/auth/auth_controller.dart';

class WorkoutDetailScreen extends StatefulWidget {
  const WorkoutDetailScreen({super.key});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  final ReportController _reportController = ReportController();
  final AuthController _authController = AuthController();

  List<Map<String, dynamic>> _exerciseList = [];
  Timer? _timer;
  int index = 0;
  int? minutes;
  int? seconds;
  bool isStart = false;
  bool _isDataLoaded = false; // Tambahkan flag ini

  // String? _workoutType;
  String? _focusArea;
  String? _level;
  String? _target;
  int? _duration;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeWorkoutData();
    });
  }

  void _initializeWorkoutData() {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    // print(" ARG HASH: ${args.hashCode}");

    if (args != null && !_isDataLoaded) {
      setState(() {
        _exerciseList = List<Map<String, dynamic>>.from(
          args['exerciseList'] ?? [],
        );
        // _workoutType = args['workoutType'];
        _focusArea = args['focusArea'];
        _level = args['level'];
        _target = args['target'];
        _duration = args['duration'];
        _isDataLoaded = true;
      });

      // print(' Data initialized:');
      // print('  Exercise Count: ${_exerciseList.length}');
      // print('  Workout Type: $_workoutType');
      // print('  Focus Area: $_focusArea');
    }
  }

  void initDuration() {
    if (_exerciseList.isNotEmpty && index < _exerciseList.length) {
      setState(() {
        minutes = _exerciseList[index]['minutes'] as int?;
        seconds = _exerciseList[index]['seconds'] as int?;
      });
    }
  }

  void startTimer() {
    if (_timer != null && _timer!.isActive) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isStart) return;

      setState(() {
        if (seconds! > 0) {
          seconds = seconds! - 1;
        } else {
          // kalau second sudah habis
          if (minutes! > 0) {
            minutes = minutes! - 1;
            seconds = 59;
          } else {
            // timer habis
            timer.cancel();
          }
        }
      });
    });
  }

  String _determineWorkoutType() {

    if (_target != null) {
      return _target!.toLowerCase();
    }

    switch (_focusArea?.toUpperCase()) {
      case 'ABS':
      case 'ARMS':
      case 'CHEST':
      case 'SHOULDERS':
      case 'BACK':
        return 'strength';
      case 'LEGS':
        return 'cardio';
      default:
        return 'flexibility';
    }
  }

  Future<void> _completeWorkout() async {
    try {
      final user = _authController.currentUser;
      if (user == null) {
        // print('User not logged in');
        return;
      }

      final totalDuration = _duration ?? 1;
      String workoutType = _determineWorkoutType();

      // print(' Completing workout with:');
      // print('  Duration: $totalDuration minutes');
      // print('  Workout Type: $workoutType');

      await _reportController.updateUserProgress(
        userId: user.uid,
        workoutType: workoutType,
        duration: totalDuration,
        focusArea: _focusArea ?? 'General',
        level: _level ?? 'Beginner',
      );

      await _reportController.logWorkoutSession(
        userId: user.uid,
        workoutId:
            '${_focusArea}_${_level}_${DateTime.now().millisecondsSinceEpoch}',
        workoutType: workoutType,
        focusArea: _focusArea ?? 'General',
        level: _level ?? 'Beginner',
        duration: totalDuration,
      );

      // print(' Workout completed successfully');
    } catch (e) {
      // print(' Error completing workout: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Error updating progress: $e'),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final args =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // setState(() {
    //   if(_exerciseList == null) {
    //     _exerciseList = args?['exerciseList'];
    //   }
    // });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
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
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.065,
        ),
        child: Column(
          children: [
            Image.asset('${_exerciseList[index]['videoURL']}'),

            SizedBox(height: screenHeight * 0.05),

            Text(
              '${_exerciseList[index]['name']}',
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontSize: screenWidth * 0.07,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            SizedBox(height: screenHeight * 0.015),

            _exerciseList[index]['type'] == 'repetition'
                ? Text(
                    'x${_exerciseList[index]['repetition']}',
                    style: TextStyle(
                      fontFamily: 'LeagueSpartan',
                      fontSize: screenWidth * 0.15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : !isStart
                ? SizedBox(
                    width: screenWidth * 0.5,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isStart = true;
                        });
                        initDuration();
                        startTimer();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1E90FF),

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
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Text(
                    '${(minutes ?? 0) > 9 ? minutes : '0$minutes'}:${(seconds ?? 0) > 9 ? seconds : '0$seconds'}',
                    style: TextStyle(
                      fontFamily: 'LeagueSpartan',
                      fontSize: screenWidth * 0.15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

            SizedBox(height: screenHeight * 0.035),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    ((_exerciseList[index]['type'] == 'repetition') ||
                        (_exerciseList[index]['type'] ==
                            'repetition_per_side') ||
                        (_exerciseList[index]['type'] == 'time' &&
                            seconds != null &&
                            seconds == 0&& 
                              minutes == 0 &&
                              minutes != null))
                    ? () {
                        if (index == _exerciseList.length - 1) {
                          _completeWorkout();
                          Navigator.pushReplacementNamed(
                            context,
                            '/workoutScreen',
                          );
                        } else {
                          setState(() {
                            index++;
                          });
                        }
                      }
                    : () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      (_exerciseList[index]['type'] == 'repetition') ||
                          (_exerciseList[index]['type'] ==
                              'repetition_per_side') ||
                          (_exerciseList[index]['type'] == 'time' &&
                              seconds != null &&
                              seconds == 0 && 
                              minutes == 0 &&
                              minutes != null)
                      ? Colors.white
                      : Colors.white30,

                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1000),
                  ),
                ),
                child: Text(
                  index < _exerciseList.length - 1 ? 'Next' : 'Finish',
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
    );
  }
}

// }
