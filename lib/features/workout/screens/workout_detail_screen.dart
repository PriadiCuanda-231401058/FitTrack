import 'dart:async';

import 'package:flutter/material.dart';

class WorkoutDetailScreen extends StatefulWidget {
  const WorkoutDetailScreen({super.key});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  final _exerciseList = [
    {
      'id': 200198227,
      'name': 'Wall Push-up',
      'minutes': null,
      'seconds': null,
      'repetition': 12,
      'videoURL': 'assets/workouts/Videos/Wall Push-up.gif',
      'rest': 25,
      'type': 'repetition',
    },
    {
      'id': 200198227,
      'name': 'Push-up',
      'minutes': 1,
      'seconds': 30,
      'repetition': null,
      'videoURL': 'assets/workouts/Videos/Push-up.gif',
      'rest': 25,
      'type': 'duration',
    },
  ];

  Timer? _timer;
  int index = 0;
  int? minutes;
  int? seconds;
  bool isStart = false;

  void initDuration() {
    setState(() {
      minutes = _exerciseList[index]['minutes'] as int?;
      seconds = _exerciseList[index]['seconds'] as int?;
    });
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

  // List<Map<String, dynamic>> _exerciseList = null;

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
                        (_exerciseList[index]['type'] == 'duration' &&
                            seconds != null &&
                            seconds == 0))
                    ? () {
                        if (index == _exerciseList.length - 1) {
                          // kembali ke workout screen, dan nambah progress
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
                          (_exerciseList[index]['type'] == 'duration' &&
                              seconds != null &&
                              seconds == 0)
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
