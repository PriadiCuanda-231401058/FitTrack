import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fittrack/features/workout/workout_controller.dart';
import 'package:fittrack/models/workout_model.dart';
import 'package:fittrack/services/payment_services.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isLoading = false;
  bool _isPremiumUser = false;
  List<Workout> _searchResults = [];
  final List<Workout> _fullWorkoutList = [];

  final WorkoutController _workoutController = WorkoutController();
  final TextEditingController _searchController = TextEditingController();

  void _performSearch(String query) {
    final lowerCaseQuery = query.toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _searchResults = _fullWorkoutList;
      });
      return;
    }

    final filteredResults = _fullWorkoutList
        .where((item) => item.title.toLowerCase().startsWith(lowerCaseQuery))
        .toList();

    setState(() {
      _searchResults = filteredResults;
    });
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

  @override
  void initState() {
    super.initState();
    _loadWorkoutData();
    checkAndUpdatePremiumStatus();
    checkUserPremium();
    _searchController.addListener(() {
      _performSearch(_searchController.text);
    });
  }

  Future<void> checkUserPremium() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      final data = doc.data();
      if (data != null && data['isPremium'] == true) {
        setState(() {
          _isPremiumUser = true;
        });
      } else {
        setState(() {
          _isPremiumUser = false;
        });
      }
    }
  }

  Future<void> checkAndUpdatePremiumStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final paymentService = PaymentService();
      await paymentService.checkPremiumStatus();
    }
  }

  Future<void> _loadWorkoutData() async {
    setState(() => _isLoading = true);

    try {
      await Future.wait([_loadBodyFocusData(), _loadTargetData()]);

      setState(() {
        _isLoading = false;
        _searchResults = List.from(_fullWorkoutList);
      });
    } catch (e) {
      // print('Error loading workout data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadTargetData() async {
    setState(() => _isLoading = true);

    try {
      List<Workout> targetWorkouts = await _workoutController
          .getWorkoutsByTarget('Strength');
      targetWorkouts.addAll(
        await _workoutController.getWorkoutsByTarget('Cardio'),
      );
      targetWorkouts.addAll(
        await _workoutController.getWorkoutsByTarget('Flexibility'),
      );

      setState(() {
        _fullWorkoutList.addAll(targetWorkouts);
      });
    } catch (e) {
      // print('Error loading workout data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadBodyFocusData() async {
    setState(() => _isLoading = true);

    try {
      List<Workout> focusWorkouts = await _workoutController
          .getWorkoutsByBodyFocus('Abs');
      focusWorkouts.addAll(
        await _workoutController.getWorkoutsByBodyFocus('Arms'),
      );
      focusWorkouts.addAll(
        await _workoutController.getWorkoutsByBodyFocus('Chest'),
      );
      focusWorkouts.addAll(
        await _workoutController.getWorkoutsByBodyFocus('Legs'),
      );
      focusWorkouts.addAll(
        await _workoutController.getWorkoutsByBodyFocus('Shoulders'),
      );
      focusWorkouts.addAll(
        await _workoutController.getWorkoutsByBodyFocus('Back'),
      );

      // print(focusWorkouts.length);

      setState(() {
        _fullWorkoutList.addAll(focusWorkouts);
      });
    } catch (e) {
      // print('Error loading workout data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.black.withAlpha(150),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 3.0,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            SizedBox(width: screenWidth * 0.03),

            Expanded(
              // child: Container(
              //   height: screenHeight * 0.05,
              //   margin: const EdgeInsets.symmetric(horizontal: 10),
              //   decoration: BoxDecoration(
              //     color: Color(0xFFF4F4F6),
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: TextField(
              //     controller: _searchController,
              //     style: const TextStyle(color: Color(0xff000000)),
              //     decoration: const InputDecoration(
              //       hintText: 'Search workouts...',
              //       hintStyle: TextStyle(color: Color(0xFF9999A1)),
              //       prefixIcon: Icon(Icons.search, color: Color(0xFF9999A1)),
              //       border: InputBorder.none,
              //     ),
              //   ),
              // ),
              child: TextField(
                controller: _searchController,
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
                        width: screenWidth * 0.06,
                        height: screenWidth * 0.06,
                      ),

                      SizedBox(width: screenWidth * 0.01),

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
                    borderRadius: BorderRadius.circular(screenWidth * 0.025),
                  ),
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ),

            SizedBox(width: screenWidth * 0.03),
          ],
        ),
      ),
      body: Container(
        width: screenWidth,
        color: Colors.black,
        padding: EdgeInsets.only(
          top: screenHeight * 0.005,
          left: screenWidth * 0.03,
          right: screenWidth * 0.03,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: _searchResults.map((workout) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.white, width: 1),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.02),

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
                                arguments['focusArea'] = workout.focusArea;
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
                                        image: AssetImage(workout.imageURL),
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
                                          workout.title,
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.035,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),

                                        SizedBox(height: screenHeight * 0.005),

                                        Text(
                                          '${workout.duration} minutes, ${workout.exerciseCount} exercises',
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.035,
                                            color: Color(0xFF9999A1),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  if (workout.isPremium == true &&
                                      false == _isPremiumUser)
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
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
