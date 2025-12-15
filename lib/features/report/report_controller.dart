import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fittrack/models/report_model.dart';
import 'streakManager.dart';
import 'package:fittrack/features/achievement/achievement_controller.dart';

class ReportController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final StreakManager _streakManager = StreakManager();

  Future<UserProgress?> getUserProgress(String userId) async {
    try {
      final doc = await _db.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserProgress.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting user progress: $e');
      return null;
    }
  }

  Future<void> updateUserProgress({
    required String userId,
    required String workoutType,
    required int duration,
    required String focusArea,
    required String level,
  }) async {
    try {
      final userRef = _db.collection('users').doc(userId);
      final userDoc = await userRef.get();

      if (!userDoc.exists) {
        await initializeUserProgress(userId, userRef);
      }

      await _db.runTransaction((transaction) async {
        final freshDoc = await transaction.get(userRef);
        if (!freshDoc.exists) return;

        // final userData = freshDoc.data()!;
        // final achievements = List<String>.from(userData['achievements'] ?? []);

        await _logWorkoutSession(
          userId: userId,
          workoutType: workoutType,
          focusArea: focusArea,
          level: level,
          duration: duration,
        );

        final progress = await _calculateProgressFromHistory(userId);

        await _streakManager.updateStreak(userId);
        final streakData = await _streakManager.getUserStreakData(userId);
        final int streak = streakData.streak;
        final bool isStreak = streakData.isActive;
        // final achievementController = AchievementController();

await AchievementController.checkAndAwardAchievements(
  userId: userId,
  focusArea: focusArea,
  level: level,
  workoutType: workoutType,
);

        transaction.update(userRef, {
          'progress': progress,
          'streak': streak,
          'isStreak': isStreak,
          // 'achievements': FieldValue.arrayUnion(newAchievements),
          'lastWorkoutDate': FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      print('Error updating user progress: $e');
      throw e;
    }
  }

  Future<void> initializeUserProgress(
    String userId,
    DocumentReference userRef,
  ) async {
    final initialProgress = {
      'today': {
        'cardio': 0,
        'flexibility': 0,
        'strength': 0,
        'total_training': 0,
        'total_time': 0,
      },
      '1 week': {
        'cardio': 0,
        'flexibility': 0,
        'strength': 0,
        'total_training': 0,
        'total_time': 0,
      },
      '2 weeks': {
        'cardio': 0,
        'flexibility': 0,
        'strength': 0,
        'total_training': 0,
        'total_time': 0,
      },
      '1 month': {
        'cardio': 0,
        'flexibility': 0,
        'strength': 0,
        'total_training': 0,
        'total_time': 0,
      },
      '3 months': {
        'cardio': 0,
        'flexibility': 0,
        'strength': 0,
        'total_training': 0,
        'total_time': 0,
      },
    };

    await userRef.set({
      'progress': initialProgress,
      'streak': 0,
      'isStreak': false,
      'achievements': [],
      'created_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>> _calculateProgressFromHistory(
    String userId,
  ) async {
    final now = DateTime.now();

    final timeRanges = {
      'today': Duration(hours: 24),
      '1 week': Duration(days: 7),
      '2 weeks': Duration(days: 14),
      '1 month': Duration(days: 30),
      '3 months': Duration(days: 90),
    };

    final progress = <String, Map<String, dynamic>>{};

    for (final entry in timeRanges.entries) {
      final period = entry.key;
      final range = entry.value;
      final startTime = now.subtract(range);

      try {
        final snapshot = await _db
            .collection('workout_history')
            .doc(userId)
            .collection('sessions')
            .where('completed_at', isGreaterThanOrEqualTo: startTime)
            .where('completed_at', isLessThanOrEqualTo: now)
            .get();

        int cardioTotal = 0;
        int flexibilityTotal = 0;
        int strengthTotal = 0;
        int totalTraining = 0;
        int totalTime = 0;

        for (final doc in snapshot.docs) {
          final data = doc.data();
          final duration = data['duration'] as int? ?? 0;
          final workoutType = data['workout_type'] as String? ?? '';

          totalTime += duration;
          totalTraining++;

          switch (workoutType) {
            case 'cardio':
              cardioTotal += duration;
              break;
            case 'flexibility':
              flexibilityTotal += duration;
              break;
            case 'strength':
              strengthTotal += duration;
              break;
          }
        }

        progress[period] = {
          'cardio': cardioTotal,
          'flexibility': flexibilityTotal,
          'strength': strengthTotal,
          'total_training': totalTraining,
          'total_time': totalTime,
        };
      } catch (e) {
        print('Error calculating progress for $period: $e');
        progress[period] = {
          'cardio': 0,
          'flexibility': 0,
          'strength': 0,
          'total_training': 0,
          'total_time': 0,
        };
      }
    }

    return progress;
  }

  // Update progress data all time periods (untuk kompatibilitas, tapi tidak digunakan)
  // Map<String, dynamic> _updateProgressData(
  //   Map<String, dynamic> progress,
  //   String workoutType,
  //   int duration,
  // ) {
  //   // Fungsi ini tetap ada untuk kompatibilitas, tapi sekarang tidak digunakan
  //   // karena progress dihitung langsung dari workout_history
  //   return progress;
  // }

  // Check and award achievements based on workout completion
  // Future<List<String>> _checkAchievements({
  //   required String userId,
  //   required String focusArea,
  //   required String level,
  //   required List<String> currentAchievements,
  // }) async {
  //   final newAchievements = <String>[];

  //   try {
  //     // Get user's workout history
  //     final workoutHistory = await _getUserWorkoutHistory(userId);

  //     // Achievement criteria
  //     final achievementCriteria = {
  //       'Abs Beginner': {'focusArea': 'ABS', 'level': 'Beginner', 'count': 5},
  //       'Abs Intermediate': {
  //         'focusArea': 'ABS',
  //         'level': 'Intermediate',
  //         'count': 10,
  //       },
  //       'Abs Advanced': {'focusArea': 'ABS', 'level': 'Advanced', 'count': 15},
  //       'Arms Master': {'focusArea': 'ARMS', 'level': 'Advanced', 'count': 10},
  //       'Chest Bro': {
  //         'focusArea': 'CHEST',
  //         'level': 'Intermediate',
  //         'count': 8,
  //       },
  //       'Leg Day Lover': {
  //         'focusArea': 'LEGS',
  //         'level': 'Advanced',
  //         'count': 12,
  //       },
  //       'Shoulder Specialist': {
  //         'focusArea': 'SHOULDERS',
  //         'level': 'Intermediate',
  //         'count': 8,
  //       },
  //       'Back Builder': {'focusArea': 'BACK', 'level': 'Advanced', 'count': 10},
  //       'Cardio King': {'workoutType': 'cardio', 'count': 20},
  //       'Strength Master': {'workoutType': 'strength', 'count': 25},
  //       'Flexibility Guru': {'workoutType': 'flexibility', 'count': 15},
  //       'Week Warrior': {'totalWorkouts': 7},
  //       'Month Master': {'totalWorkouts': 30},
  //       'Consistency King': {'streak': 30},
  //       'Dedication Pro': {'streak': 90},
  //     };

  //     for (final achievement in achievementCriteria.entries) {
  //       final achievementName = achievement.key;
  //       final criteria = achievement.value;

  //       if (currentAchievements.contains(achievementName)) continue;

  //       bool achieved = false;

  //       if (criteria.containsKey('focusArea') &&
  //           criteria.containsKey('level')) {
  //         // Focus area and level based achievement
  //         final count = workoutHistory
  //             .where(
  //               (workout) =>
  //                   workout['focus_area'] == criteria['focusArea'] &&
  //                   workout['level'] == criteria['level'],
  //             )
  //             .length;

  //         achieved = count >= (criteria['count'] as int);
  //       } else if (criteria.containsKey('workoutType')) {
  //         final count = workoutHistory
  //             .where(
  //               (workout) => workout['workout_type'] == criteria['workoutType'],
  //             )
  //             .length;

  //         achieved = count >= (criteria['count'] as int);
  //       } else if (criteria.containsKey('totalWorkouts')) {
  //         achieved =
  //             workoutHistory.length >= (criteria['totalWorkouts'] as int);
  //       } else if (criteria.containsKey('streak')) {
  //         final userProgress = await getUserProgress(userId);
  //         achieved = userProgress!.streak >= (criteria['streak'] as int);
  //       }

  //       if (achieved) {
  //         newAchievements.add(achievementName);
  //       }
  //     }
  //   } catch (e) {
  //     print('Error checking achievements: $e');
  //   }

  //   return newAchievements;
  // }

  // Get user's workout history
  // Future<List<Map<String, dynamic>>> _getUserWorkoutHistory(
  //   String userId,
  // ) async {
  //   try {
  //     final snapshot = await _db
  //         .collection('workout_history')
  //         .doc(userId)
  //         .collection('sessions')
  //         .orderBy('completed_at', descending: true)
  //         .get();

  //     return snapshot.docs.map((doc) => doc.data()).toList();
  //   } catch (e) {
  //     print('Error getting workout history: $e');
  //     return [];
  //   }
  // }

  // Log workout session for history (versi private untuk internal use)
  Future<void> _logWorkoutSession({
    required String userId,
    required String workoutType,
    required String focusArea,
    required String level,
    required int duration,
  }) async {
    try {
      await _db
          .collection('workout_history')
          .doc(userId)
          .collection('sessions')
          .add({
            'workout_type': workoutType,
            'focus_area': focusArea,
            'level': level,
            'duration': duration,
            'completed_at': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      print('Error logging workout session: $e');
      throw e; // Lempar error agar transaksi tahu ada masalah
    }
  }

  // Log workout session for history (versi public untuk external call)
  // Future<void> logWorkoutSession({
  //   required String userId,
  //   required String workoutId,
  //   required String workoutType,
  //   required String focusArea,
  //   required String level,
  //   required int duration,
  // }) async {
  //   try {
  //     await _db
  //         .collection('workout_history')
  //         .doc(userId)
  //         .collection('sessions')
  //         .add({
  //           'workout_id': workoutId,
  //           'workout_type': workoutType,
  //           'focus_area': focusArea,
  //           'level': level,
  //           'duration': duration,
  //           'completed_at': FieldValue.serverTimestamp(),
  //         });
  //   } catch (e) {
  //     print('Error logging workout session: $e');
  //   }
  // }

  // Get target data for progress comparison
  Map<String, dynamic> getTargetData() {
    return {
      "today": {
        "cardio": 45,
        "flexibility": 35,
        "strength": 30,
        "total_training": 5,
        "total_time": 110,
      },
      "1 week": {
        "cardio": 315,
        "flexibility": 245,
        "strength": 210,
        "total_training": 10,
        "total_time": 770,
      },
      "2 weeks": {
        "cardio": 630,
        "flexibility": 490,
        "strength": 420,
        "total_training": 20,
        "total_time": 1540,
      },
      "1 month": {
        "cardio": 1350,
        "flexibility": 1050,
        "strength": 900,
        "total_training": 40,
        "total_time": 3300,
      },
      "3 months": {
        "cardio": 4050,
        "flexibility": 3150,
        "strength": 2700,
        "total_training": 120,
        "total_time": 9900,
      },
    };
  }
}
