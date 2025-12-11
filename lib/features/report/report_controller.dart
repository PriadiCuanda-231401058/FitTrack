import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fittrack/models/report_model.dart';
import 'streakManager.dart';

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
    required String workoutType, // 'cardio', 'strength', 'flexibility'
    required int duration, 
    required String focusArea, // 'ABS', 'ARMS', 'CHEST', 'LEGS', 'SHOULDERS', 'BACK'
    required String level, // 'Beginner', 'Intermediate', 'Advanced'
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

        final userData = freshDoc.data()!;
        Map<String, dynamic> progress = Map<String, dynamic>.from(userData['progress'] ?? {});
        final achievements = List<String>.from(userData['achievements'] ?? []);
        int streak = userData['streak'] ?? 0;
        bool isStreak = userData['isStreak'] ?? false;

        // Update progress data
        progress = _updateProgressData(progress, workoutType, duration);

        await _streakManager.updateStreak(userId);
        // Update streak
        final streakData = await _streakManager.getUserStreakData(userId);
        streak = streakData.streak;
        isStreak = streakData.isActive;

        // Check achievements
        final newAchievements = await _checkAchievements(
          userId: userId,
          focusArea: focusArea,
          level: level,
          currentAchievements: achievements,
        );

        // Update user document
        transaction.update(userRef, {
          'progress': progress,
          'streak': streak,
          'isStreak': isStreak,
          'achievements': FieldValue.arrayUnion(newAchievements),
          'lastWorkoutDate': FieldValue.serverTimestamp(),
        });
      });

    } catch (e) {
      print('Error updating user progress: $e');
      throw e;
    }
  }

  // Initialize user progress 
  Future<void> initializeUserProgress(String userId, DocumentReference userRef) async {
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

  // Update progress data all time periods
  Map<String, dynamic> _updateProgressData(
    Map<String, dynamic> progress, 
    String workoutType, 
    int duration
  ) {
    final timePeriods = ['today', '1 week', '2 weeks', '1 month', '3 months'];
    
    for (final period in timePeriods) {
      if (progress[period] == null) {
        progress[period] = {
          'cardio': 0,
          'flexibility': 0,
          'strength': 0,
          'total_training': 0,
          'total_time': 0,
        };
      }

      final periodData = Map<String, dynamic>.from(progress[period]);
      
      // Update workout type duration
      if (periodData.containsKey(workoutType)) {
        periodData[workoutType] = (periodData[workoutType] as int) + duration;
      }
      
      // Update total training count
      periodData['total_training'] = (periodData['total_training'] as int) + 1;
      
      // Update total time
      periodData['total_time'] = (periodData['total_time'] as int) + duration;
      
      progress[period] = periodData;
    }

    return progress;
  }

  // Update user streak
  // Map<String, dynamic> _updateStreak(int currentStreak, bool currentIsStreak) {
    // final now = DateTime.now();
    // if (currentIsStreak) {
    //   return {
    //     'streak': currentStreak,
    //     'isStreak': true,
    //   };
    // } else if (!currentIsStreak) {
    //   final yesterday = now.subtract(const Duration(days: 1));
    //   return {
    //     'streak': 1,
    //     'isStreak': true,
    //   };
    // }
  //   return {
  //     'streak': currentStreak + 1,
  //     'isStreak': true,
  //   };
  // }

  // Check and award achievements based on workout completion
  Future<List<String>> _checkAchievements({
    required String userId,
    required String focusArea,
    required String level,
    required List<String> currentAchievements,
  }) async {
    final newAchievements = <String>[];
    
    try {
      // Get user's workout history
      final workoutHistory = await _getUserWorkoutHistory(userId);
      
      // Achievement criteria
      final achievementCriteria = {
        'Abs Beginner': {'focusArea': 'ABS', 'level': 'Beginner', 'count': 5},
        'Abs Intermediate': {'focusArea': 'ABS', 'level': 'Intermediate', 'count': 10},
        'Abs Advanced': {'focusArea': 'ABS', 'level': 'Advanced', 'count': 15},
        'Arms Master': {'focusArea': 'ARMS', 'level': 'Advanced', 'count': 10},
        'Chest Bro': {'focusArea': 'CHEST', 'level': 'Intermediate', 'count': 8},
        'Leg Day Lover': {'focusArea': 'LEGS', 'level': 'Advanced', 'count': 12},
        'Shoulder Specialist': {'focusArea': 'SHOULDERS', 'level': 'Intermediate', 'count': 8},
        'Back Builder': {'focusArea': 'BACK', 'level': 'Advanced', 'count': 10},
        'Cardio King': {'workoutType': 'cardio', 'count': 20},
        'Strength Master': {'workoutType': 'strength', 'count': 25},
        'Flexibility Guru': {'workoutType': 'flexibility', 'count': 15},
        'Week Warrior': {'totalWorkouts': 7},
        'Month Master': {'totalWorkouts': 30},
        'Consistency King': {'streak': 30},
        'Dedication Pro': {'streak': 90},
      };

      for (final achievement in achievementCriteria.entries) {
        final achievementName = achievement.key;
        final criteria = achievement.value;
        
        if (currentAchievements.contains(achievementName)) continue;
        
        bool achieved = false;
        
        if (criteria.containsKey('focusArea') && criteria.containsKey('level')) {
          // Focus area and level based achievement
          final count = workoutHistory.where((workout) =>
            workout['focusArea'] == criteria['focusArea'] &&
            workout['level'] == criteria['level']
          ).length;
          
          achieved = count >= (criteria['count'] as int);
        } else if (criteria.containsKey('workoutType')) {

          final count = workoutHistory.where((workout) =>
            workout['workoutType'] == criteria['workoutType']
          ).length;
          
          achieved = count >= (criteria['count'] as int);
        } else if (criteria.containsKey('totalWorkouts')) {

          achieved = workoutHistory.length >= (criteria['totalWorkouts'] as int);
        } else if (criteria.containsKey('streak')) {

          final userProgress = await getUserProgress(userId);
          achieved = userProgress!.streak >= (criteria['streak'] as int);
        }
        
        if (achieved) {
          newAchievements.add(achievementName);
        }
      }
      
    } catch (e) {
      print('Error checking achievements: $e');
    }
    
    return newAchievements;
  }

  // Get user's workout history
  Future<List<Map<String, dynamic>>> _getUserWorkoutHistory(String userId) async {
    try {
      final snapshot = await _db
          .collection('workout_history')
          .doc(userId)
          .collection('sessions')
          .orderBy('completed_at', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error getting workout history: $e');
      return [];
    }
  }

  // Log workout session for history
  Future<void> logWorkoutSession({
    required String userId,
    required String workoutId,
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
            'workout_id': workoutId,
            'workout_type': workoutType,
            'focus_area': focusArea,
            'level': level,
            'duration': duration,
            'completed_at': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      print('Error logging workout session: $e');
    }
  }

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