import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fittrack/shared/widgets/navigation_bar_widget.dart';
import 'package:fittrack/features/report/widgets/three_segment_circular_progress.dart';
import 'package:fittrack/features/report/report_controller.dart';
import 'package:fittrack/features/auth/auth_controller.dart';
import 'package:fittrack/models/report_model.dart';
import 'dart:convert';

// import 'package:fittrack/models/user_model.dart';
// import 'package:fittrack/features/settings/screens/settings_screen.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String filterBy = "Today";

  final List<String> options = [
    "Today",
    "1 Week",
    "2 Weeks",
    "1 Month",
    "3 Months",
  ];

  final ReportController _reportController = ReportController();
  final AuthController _authController = AuthController(); 
  UserProgress? userData;
  double? progressw = 0.0;
  bool _isLoading = true;

  @override
  @override
  void initState() {
    super.initState();
    _loadUserProgress();
  }

  ImageProvider getProfileImage() {
    final user = _authController.currentUser;

    if (userData?.photoBase64 != null && userData!.photoBase64!.isNotEmpty) {
      try {
        final bytes = base64.decode(userData!.photoBase64!);
        return MemoryImage(bytes);
      } catch (e) {
        print('Error decoding Base64: $e');
      }
    }

    if (user?.photoURL != null && user!.photoURL!.isNotEmpty) {
      return NetworkImage(user.photoURL!);
    }

    return const AssetImage('assets/images/profile_icon.png');
  }

  Future<void> _loadUserProgress() async {
    setState(() => _isLoading = true);

    try {
      final user = _authController.currentUser; 
      if (user != null) {
        final progress = await _reportController.getUserProgress(user.uid);
        setState(() {
          userData = progress;
          progressw =
              (userData?.achievements.length.toDouble() ?? 0) /
              15.0; // ganti 15 dengan total achievement yang ada
          print('progressw: $progressw');
        });
        print('User Progressw: $progressw');
        print('User ID: ${user.uid}');
        print('UserProgress: $progress');
        print('User Progress Data: ${userData?.toFirestore()}');
        if (progress != null) {
          print('Progress Map: ${progress.progress}');
        }
      }
    } catch (e) {
      print('Error loading user progress: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Map<String, dynamic> _getCurrentProgress() {
  //   if (userData == null) return {};
  //   final filterKey = filterBy.toLowerCase().replaceAll(' ', '_') ?? 'today';
  //   return userData!.progress[filterKey] ?? {};
  // }

  Widget build(BuildContext context) {
    // ini data progress yang harus dicapai (jangan dihapus), ku tarok ke controller aj

    final target = _reportController.getTargetData();
    // final Map<String, dynamic> target = {
    //   "today": {
    //     "cardio": 45,
    //     "flexibility": 35,
    //     "strength": 30,
    //     "total_training": 5,
    //     "total_time": 110,
    //   },
    //   "1 week": {
    //     "cardio": 315,
    //     "flexibility": 245,
    //     "strength": 210,
    //     "total_training": 10,
    //     "total_time": 770,
    //   },
    //   "2 weeks": {
    //     "cardio": 630,
    //     "flexibility": 490,
    //     "strength": 420,
    //     "total_training": 20,
    //     "total_time": 1540,
    //   },
    //   "1 month": {
    //     "cardio": 1350,
    //     "flexibility": 1050,
    //     "strength": 900,
    //     "total_training": 40,
    //     "total_time": 3300,
    //   },
    //   "3 months": {
    //     "cardio": 4050,
    //     "flexibility": 3150,
    //     "strength": 2700,
    //     "total_training": 120,
    //     "total_time": 9900,
    //   },
    // };

    // dummy data
    // final Map<String, dynamic> userData = {
    //   "username": "Andre Lim",
    //   "email": "andre@gmail.com",
    //   "profilePhoto":
    //       "assets/profiles/andre.jfif", // harusnya nnti bisa upload png aja
    //   "streak": 10,
    //   "isStreak": true,
    //   "today": {
    //     "cardio": 20,
    //     "flexibility": 30,
    //     "strength": 10,
    //     "total_training": 4,
    //   },
    //   "1 week": {
    //     "cardio": 50,
    //     "flexibility": 50,
    //     "strength": 50,
    //     "total_training": 7,
    //   },
    //   "2 weeks": {
    //     "cardio": 100,
    //     "flexibility": 100,
    //     "strength": 100,
    //     "total_training": 10,
    //   },
    //   "1 month": {
    //     "cardio": 200,
    //     "flexibility": 200,
    //     "strength": 200,
    //     "total_training": 20,
    //   },
    //   "3 months": {
    //     "cardio": 4200,
    //     "flexibility": 4300,
    //     "strength": 4300,
    //     "total_training": 424,
    //   },
    //   "achievement": ["Arms Master", "Abs Monster", "Chest Bro"],
    // };

    // print("progressw :${userData?.achievements.length.toDouble()}");
    // print("progressw :${progressw}");

    print('_isLoading: $_isLoading');
    print('userData is null: ${userData == null}');
    print('userData: $userData');
    if (userData != null) {
      print('userData.name: ${userData!.name}');
      print('userData.achievements: ${userData!.achievements}');
      print('userData.achievements.length: ${userData!.achievements.length}');
    }
    print('progressw: $progressw');

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
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.025),
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
        title: Text(
          'Activity Report',
          style: TextStyle(
            fontFamily: 'LeagueSpartan',
            fontSize: screenWidth * 0.065,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsetsGeometry.only(right: screenWidth * 0.025),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/bmiScreen');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Image.asset('assets/images/bmi_icon.png'),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.055,
          vertical: screenHeight * 0.03,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: screenWidth * 0.27,
                          height: screenWidth * 0.27,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              // image: AssetImage(userData?['profilePhoto']),
                              image: getProfileImage(),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          child: SizedBox(),
                        ),

                        SizedBox(width: screenWidth * 0.045),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello ${userData?.name.split(' ')[0]},',
                                style: TextStyle(
                                  fontFamily: 'LeagueSpartan',
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              SizedBox(
                                width: screenWidth * 0.55,
                                child: Text(
                                  "Here's an overview of your recent progress",
                                  softWrap: true,
                                  style: TextStyle(
                                    fontFamily: 'LeagueSpartan',
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    Container(
                      width: screenWidth * 0.8,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.02,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xCCFFFFFF),
                        borderRadius: BorderRadius.circular(screenWidth * 0.05),
                      ),
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                constraints: BoxConstraints(
                                  minWidth: screenWidth * 0.14,
                                  minHeight: screenWidth * 0.14,
                                ),
                                strokeWidth: screenWidth * 0.016,
                                backgroundColor: Colors.white,
                                color: Color(0xFF0400FF),
                                value: progressw,
                              ),

                              Text(
                                '${min((progressw! * 100).round(), 100)}%',
                                style: TextStyle(
                                  fontFamily: 'LeagueSpartan',
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(width: screenWidth * 0.035),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  progressw == 100
                                      ? 'Mission accomplished!'
                                      : progressw! > 90
                                      ? 'Amazing work!'
                                      : progressw! > 60
                                      ? 'Great job!'
                                      : progressw! > 30
                                      ? 'Nice progress!'
                                      : 'Keep going!',
                                  style: TextStyle(
                                    fontFamily: 'LeagueSpartan',
                                    fontWeight: FontWeight.w600,
                                    fontSize: screenWidth * 0.04,
                                  ),
                                ),

                                SizedBox(
                                  child: Text(
                                    progressw == 100
                                        ? "You've reached your goal! Take pride in your dedication and effort."
                                        : progressw! > 90
                                        ? "You've nearly achieved it! Celebrate your success, you've earned it."
                                        : progressw! > 60
                                        ? "You're more than halfway there. Keep pushing, you're doing amazing!"
                                        : progressw! > 30
                                        ? "You're gaining momentum—stay consistent and the results will follow"
                                        : "You've just started your journey. Every step brings you closer!",
                                    style: TextStyle(
                                      fontFamily: 'LeagueSpartan',
                                      fontWeight: FontWeight.w300,
                                      fontSize: screenWidth * 0.035,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DropdownMenu(
                          width: screenWidth * 0.42,
                          onSelected: (value) {
                            setState(() {
                              filterBy = value!;
                            });
                          },
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: Color(0xFF66666E).withValues(alpha: 0.5),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(screenWidth * 0.035),
                              ),
                            ),
                            hintStyle: TextStyle(
                              fontFamily: 'LeagueSpartan',
                              color: Colors.white,
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w700,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.025,
                            ),
                          ),
                          hintText: filterBy,
                          textStyle: TextStyle(
                            fontFamily: 'LeagueSpartan',
                            color: Colors.white,
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w700,
                          ),
                          dropdownMenuEntries: options.map((option) {
                            return DropdownMenuEntry(
                              value: option,
                              label: option,
                              style: ButtonStyle(
                                backgroundColor: WidgetStateColor.resolveWith((
                                  state,
                                ) {
                                  if (filterBy == option) {
                                    return Color(
                                      0xFFFFFFFF,
                                    ).withValues(alpha: 0.7);
                                  } else {
                                    return Color(
                                      0xFF66666E,
                                    ).withValues(alpha: 0.8);
                                  }
                                }),
                                foregroundColor: WidgetStatePropertyAll(
                                  option == filterBy
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                textStyle: WidgetStatePropertyAll(
                                  TextStyle(
                                    fontFamily: 'LeagueSpartan',
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          menuStyle: MenuStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.transparent,
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.zero,
                                  topRight: Radius.zero,
                                  bottomLeft: Radius.circular(
                                    screenWidth * 0.02,
                                  ),
                                  bottomRight: Radius.circular(
                                    screenWidth * 0.02,
                                  ),
                                ),
                              ),
                            ),
                            fixedSize: WidgetStatePropertyAll(
                              Size(screenWidth * 0.42, double.infinity),
                            ),
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 0),
                            ),
                          ),
                          trailingIcon: Transform.rotate(
                            angle: 0,
                            child: Image.asset(
                              'assets/images/arrow_bottom.png',
                            ),
                          ),
                          selectedTrailingIcon: Transform.rotate(
                            angle: math.pi,
                            child: Image.asset(
                              'assets/images/arrow_bottom.png',
                            ),
                          ),
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/streak.png',
                              width: screenWidth * 0.05,
                              height: screenHeight * 0.05,
                              color: userData?.isStreak ?? false
                                  ? Color(0xFFFF7518)
                                  : Color(0xFF66666E),
                            ),

                            SizedBox(width: screenWidth * 0.015),

                            Text(
                              '${userData?.streak}',
                              style: TextStyle(
                                fontFamily: 'LeagueSpartan',
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                color: userData?.isStreak ?? false
                                    ? Colors.white
                                    : Color(0xFF66666E),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    Container(
                      height: screenWidth * 0.5,
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      decoration: BoxDecoration(
                        color: Color(0xCCFFFFFF),
                        borderRadius: BorderRadius.circular(screenWidth * 0.05),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.07),
                            child: ThreeSegmentCircularProgress(
                              cardio:
                                  userData?[filterBy.toLowerCase()]['cardio'],
                              flexibility:
                                  userData?[filterBy
                                      .toLowerCase()]['flexibility'],
                              strength:
                                  userData?[filterBy.toLowerCase()]['strength'],
                              target:
                                  target[filterBy.toLowerCase()]['total_time'],
                              strokeWidth: screenWidth * 0.036,
                            ),
                          ),

                          SizedBox(width: screenWidth * 0.15),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: screenWidth * 0.04,
                                    height: screenWidth * 0.04,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF0034C3),
                                      borderRadius: BorderRadius.circular(
                                        screenWidth * 0.012,
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: screenWidth * 0.02),

                                  Text(
                                    'Cardio',
                                    style: TextStyle(
                                      fontFamily: 'LeagueSpartan',
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: screenHeight * 0.015),

                              Row(
                                children: [
                                  Container(
                                    width: screenWidth * 0.04,
                                    height: screenWidth * 0.04,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF09D933),
                                      borderRadius: BorderRadius.circular(
                                        screenWidth * 0.012,
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: screenWidth * 0.02),

                                  Text(
                                    'Flexbility',
                                    style: TextStyle(
                                      fontFamily: 'LeagueSpartan',
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: screenHeight * 0.015),

                              Row(
                                children: [
                                  Container(
                                    width: screenWidth * 0.04,
                                    height: screenWidth * 0.04,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFD1818),
                                      borderRadius: BorderRadius.circular(
                                        screenWidth * 0.012,
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: screenWidth * 0.02),

                                  Text(
                                    'Strength',
                                    style: TextStyle(
                                      fontFamily: 'LeagueSpartan',
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      decoration: BoxDecoration(
                        color: Color(0xCCFFFFFF),
                        borderRadius: BorderRadius.circular(screenWidth * 0.05),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/cardio.png',
                                    scale: 0.75,
                                  ),

                                  SizedBox(width: screenWidth * 0.03),

                                  SizedBox(
                                    width: screenWidth * 0.4,
                                    child: LinearProgressIndicator(
                                      value:
                                          userData?[filterBy
                                              .toLowerCase()]['cardio'] /
                                          target[filterBy
                                              .toLowerCase()]['cardio'],
                                      backgroundColor: Colors.grey[300],
                                      color: Color(0xFF0034C3),
                                      minHeight: screenHeight * 0.025,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(1000),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                '${min(userData?[filterBy.toLowerCase()]['cardio'], target[filterBy.toLowerCase()]['cardio'])} / ${target[filterBy.toLowerCase()]['cardio']} Min',
                                style: TextStyle(
                                  fontFamily: 'LeagueSpartan',
                                  fontSize: screenWidth * 0.032,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/flexibility.png',
                                    scale: 0.75,
                                  ),

                                  SizedBox(width: screenWidth * 0.03),

                                  SizedBox(
                                    width: screenWidth * 0.4,
                                    child: LinearProgressIndicator(
                                      value:
                                          userData?[filterBy
                                              .toLowerCase()]['flexibility'] /
                                          target[filterBy
                                              .toLowerCase()]['flexibility'],
                                      backgroundColor: Colors.grey[300],
                                      color: Color(0xFF09D933),
                                      minHeight: screenHeight * 0.025,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(1000),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                '${min(userData?[filterBy.toLowerCase()]['flexibility'], target[filterBy.toLowerCase()]['flexibility'])} / ${target[filterBy.toLowerCase()]['flexibility']} Min',
                                style: TextStyle(
                                  fontFamily: 'LeagueSpartan',
                                  fontSize: screenWidth * 0.032,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/strength.png',
                                    scale: 0.75,
                                  ),

                                  SizedBox(width: screenWidth * 0.03),

                                  SizedBox(
                                    width: screenWidth * 0.4,
                                    child: LinearProgressIndicator(
                                      value:
                                          userData?[filterBy
                                              .toLowerCase()]['strength'] /
                                          target[filterBy
                                              .toLowerCase()]['strength'],
                                      backgroundColor: Colors.grey[300],
                                      color: Color(0xFFFD1818),
                                      minHeight: screenHeight * 0.025,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(1000),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                '${min(userData?[filterBy.toLowerCase()]['strength'], target[filterBy.toLowerCase()]['strength'])} / ${target[filterBy.toLowerCase()]['strength']} Min',
                                style: TextStyle(
                                  fontFamily: 'LeagueSpartan',
                                  fontSize: screenWidth * 0.032,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          Text(
                            'Total Training',
                            style: TextStyle(
                              fontFamily: 'LeagueSpartan',
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.015),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/all_training.png',
                                    scale: 0.75,
                                  ),

                                  SizedBox(width: screenWidth * 0.03),

                                  SizedBox(
                                    width: screenWidth * 0.4,
                                    child: LinearProgressIndicator(
                                      value:
                                          userData?[filterBy
                                              .toLowerCase()]['total_training'] /
                                          target[filterBy
                                              .toLowerCase()]['total_training'],
                                      backgroundColor: Colors.grey[300],
                                      color: Color(0xFF9999A1),
                                      minHeight: screenHeight * 0.025,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(1000),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                '${min(userData?[filterBy.toLowerCase()]['total_training'], target[filterBy.toLowerCase()]['total_training'])} / ${target[filterBy.toLowerCase()]['total_training']} Workouts',
                                style: TextStyle(
                                  fontFamily: 'LeagueSpartan',
                                  fontSize: screenWidth * 0.032,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.035),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBarWidget(location: '/reportScreen'),
    );
  }
}
