import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AchievementController {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static final Map<String, Map<String, dynamic>> _achievementCriteria = {
    'Abs Beginner': {
      'focusArea': 'Abs',
      'level': 'Beginner',
      'count': 5,
      'image': 'assets/images/badge_abs_beginner.png',
      'category': 'Strength',
      'Title': 'Abs Beginner',
      'desc': 'Menyelesaikan 5 workout Abs level Beginner',
    },
    'Abs Intermediate': {
      'focusArea': 'Abs',
      'level': 'Intermediate',
      'count': 10,
      'image': 'assets/images/badge_abs_intermediate.png',
      'category': 'Strength',
      'Title': 'Abs Intermediate',
      'desc': 'Menyelesaikan 10 workout Abs level Intermediate',
    },
    'Abs Advanced': {
      'focusArea': 'Abs',
      'level': 'Advanced',
      'count': 15,
      'image': 'assets/images/badge_abs_advanced.png',
      'category': 'Strength',
      'Title': 'Abs Advanced',
      'desc': 'Menyelesaikan 15 workout Abs level Advanced',
    },
    'Arms Master': {
      'focusArea': 'Arms',
      'level': 'Advanced',
      'count': 10,
      'image': 'assets/images/badge_arms_master.png',
      'category': 'Strength',
      'Title': 'Arms Master',
      'desc': 'Menyelesaikan 10 workout Arms level Advanced',
    },
    'Chest Bro': {
      'focusArea': 'Chest',
      'level': 'Intermediate',
      'count': 8,
      'image': 'assets/images/badge_chest_bro.png',
      'category': 'Strength',
      'Title': 'Chest Bro',
      'desc': 'Menyelesaikan 8 workout Chest level Intermediate',
    },
    'Leg Day Lover': {
      'focusArea': 'Legs',
      'level': 'Advanced',
      'count': 12,
      'image': 'assets/images/badge_leg_day_lover.png',
      'category': 'Strength',
      'Title': 'Leg Day Lover',
      'desc': 'Menyelesaikan 12 workout Legs level Advanced',
    },
    'Shoulder Specialist': {
      'focusArea': 'Shoulders',
      'level': 'Intermediate',
      'count': 8,
      'image': 'assets/images/badge_shoulder_specialist.png',
      'category': 'General Fitness',
      'Title': 'Shoulder Specialist',
      'desc': 'Menyelesaikan 8 workout Shoulders level Intermediate',
    },
    'Back Builder': {
      'focusArea': 'Back',
      'level': 'Advanced',
      'count': 10,
      'image': 'assets/images/badge_back_builder.png',
      'category': 'Strength',
      'Title': 'Back Builder',
      'desc': 'Menyelesaikan 10 workout Back level Advanced',
    },
    'Cardio King': {
      'workoutType': 'Cardio',
      'count': 20,
      'image': 'assets/images/badge_cardio_king.png',
      'category': 'Cardio',
      'Title': 'Cardio King',
      'desc': 'Menyelesaikan 20 workout Cardio',
    },
    'Strength Master': {
      'workoutType': 'Strength',
      'count': 25,
      'image': 'assets/images/badge_strength_master.png',
      'category': 'Strength',
      'Title': 'Strength Master',
      'desc': 'Menyelesaikan 25 workout Strength',
    },
    'Flexibility Guru': {
      'workoutType': 'Flexibility',
      'count': 15,
      'image': 'assets/images/badge_flexibility_guru.png',
      'category': 'Mindfulness',
      'Title': 'Flexibility Guru',
      'desc': 'Menyelesaikan 15 workout Flexibility',
    },
    'Week Warrior': {
      'totalWorkouts': 7,
      'image': 'assets/images/badge_week_warrior.png',
      'category': 'Discipline',
      'Title': 'Week Warrior',
      'desc': 'Menyelesaikan 7 workout total',
    },
    'Month Master': {
      'totalWorkouts': 30,
      'image': 'assets/images/badge_month_master.png',
      'category': 'Discipline',
      'Title': 'Month Master',
      'desc': 'Menyelesaikan 30 workout total',
    },
    'Consistency King': {
      'streak': 30,
      'image': 'assets/images/badge_consistency_king.png',
      'category': 'Discipline',
      'Title': 'Consistency King',
      'desc': 'Mempertahankan streak 30 hari',
    },
    'Dedication Pro': {
      'streak': 90,
      'image': 'assets/images/badge_dedication_pro.png',
      'category': 'Discipline',
      'Title': 'Dedication Pro',
      'desc': 'Mempertahankan streak 90 hari',
    },
  };

  static Future<List<Map<String, dynamic>>> _getUserWorkoutHistory(
    String userId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('workout_history')
          .doc(userId)
          .collection('sessions')
          .orderBy('completed_at', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'workout_type': data['workout_type'] ?? '',
          'focus_area': data['focus_area'] ?? '',
          'level': data['level'] ?? '',
          'duration': data['duration'] ?? 0,
          'completed_at': data['completed_at'] ?? Timestamp.now(),
        };
      }).toList();
    } catch (e) {
      // print('Error getting workout history: $e');
      return [];
    }
  }

  static Future<int> getUserStreak(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data();
      return userData?['streak'] ?? 0;
    } catch (e) {
      // print('Error getting user streak: $e');
      return 0;
    }
  }

  static Future<Map<String, List<dynamic>>> getAchievementData() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return _getEmptyData();

      final userId = currentUser.uid;

      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data() ?? {};

      final List<dynamic> userAchievements = userData['achievements'] ?? [];
      final List<dynamic> achievementDates = userData['achievementDates'] ?? [];

      final workoutHistory = await _getUserWorkoutHistory(userId);
      final userStreak = await getUserStreak(userId);

      final List<String> achievementId = [];
      final List<String> dateAcquired = [];
      final List<int> progress = [];

      final List<String> criteriaKeys = _achievementCriteria.keys.toList();

      for (final achievementName in criteriaKeys) {
        final criteria = _achievementCriteria[achievementName]!;
        int currentProgress = 0;

        if (criteria.containsKey('focusArea') &&
            criteria.containsKey('level')) {
          currentProgress = workoutHistory
              .where(
                (workout) =>
                    workout['focus_area'] == criteria['focusArea'] &&
                    workout['level'] == criteria['level'],
              )
              .length;
        } else if (criteria.containsKey('workoutType')) {
          currentProgress = workoutHistory
              .where(
                (workout) => workout['workout_type'] == criteria['workoutType'],
              )
              .length;
        } else if (criteria.containsKey('totalWorkouts')) {
          currentProgress = workoutHistory.length;
        } else if (criteria.containsKey('streak')) {
          currentProgress = userStreak;
        }

        final hasAchievement = userAchievements.contains(achievementName);
        final dateIndex = userAchievements.indexOf(achievementName);

        achievementId.add(achievementName);
        progress.add(currentProgress);
        dateAcquired.add(
          hasAchievement &&
                  dateIndex != -1 &&
                  dateIndex < achievementDates.length
              ? achievementDates[dateIndex].toString()
              : '-',
        );
      }

      return {
        'achievementId': achievementId,
        'dateAcquired': dateAcquired,
        'progress': progress,
      };
    } catch (e) {
      // print('Error getting achievement data: $e');
      return _getEmptyData();
    }
  }

  static Map<String, List<dynamic>> _getEmptyData() {
    final List<String> achievementId = _achievementCriteria.keys.toList();
    final List<String> dateAcquired = List.filled(achievementId.length, '-');
    final List<int> progress = List.filled(achievementId.length, 0);

    return {
      'achievementId': achievementId,
      'dateAcquired': dateAcquired,
      'progress': progress,
    };
  }

  static List<Map<String, dynamic>> getAchievementsInfo() {
    return _achievementCriteria.entries.map((entry) {
      final achievementName = entry.key;
      final criteria = entry.value;

      return {
        'image': criteria['image'] ?? 'assets/images/default_badge.png',
        'category': criteria['category'] ?? 'General',
        'Title': criteria['Title'] ?? achievementName,
        'desc': criteria['desc'] ?? 'Achievement description',
        'count':
            criteria['count'] ??
            criteria['totalWorkouts'] ??
            criteria['streak'] ??
            0,
      };
    }).toList();
  }

  static Future<void> checkAndAwardAchievements({
    required String userId,
    required String focusArea,
    required String level,
    required String workoutType,
  }) async {
    try {
      final workoutHistory = await _getUserWorkoutHistory(userId);
      final userStreak = await getUserStreak(userId);

      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data() ?? {};
      final List<dynamic> currentAchievements = userData['achievements'] ?? [];
      // final List<dynamic> currentDates = userData['achievementDates'] ?? [];

      final newAchievements = <String>[];

      for (final entry in _achievementCriteria.entries) {
        final achievementName = entry.key;
        final criteria = entry.value;

        if (currentAchievements.contains(achievementName)) continue;

        bool achieved = false;

        if (criteria.containsKey('focusArea') &&
            criteria.containsKey('level')) {
          final count = workoutHistory
              .where(
                (workout) =>
                    workout['focus_area'] == criteria['focusArea'] &&
                    workout['level'] == criteria['level'],
              )
              .length;
          achieved = count >= (criteria['count'] as int);
        } else if (criteria.containsKey('workoutType')) {
          final count = workoutHistory
              .where(
                (workout) => workout['workout_type'] == criteria['workoutType'],
              )
              .length;
          achieved = count >= (criteria['count'] as int);
        } else if (criteria.containsKey('totalWorkouts')) {
          achieved =
              workoutHistory.length >= (criteria['totalWorkouts'] as int);
        } else if (criteria.containsKey('streak')) {
          achieved = userStreak >= (criteria['streak'] as int);
        }

        if (achieved) {
          newAchievements.add(achievementName);
        }
      }

      if (newAchievements.isNotEmpty) {
        final now = DateTime.now();
        final formattedDate =
            '${now.day} ${_getMonthName(now.month)} ${now.year}';

        await _firestore.collection('users').doc(userId).update({
          'achievements': FieldValue.arrayUnion(newAchievements),
          'achievementDates': FieldValue.arrayUnion(
            List.filled(newAchievements.length, formattedDate),
          ),
        });
      }
    } catch (e) {
      // print('Error checking achievements: $e');
    }
  }

  static String _getMonthName(int month) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return monthNames[month - 1];
  }
}
