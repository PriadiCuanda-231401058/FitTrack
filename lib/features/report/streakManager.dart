import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fittrack/models/user_model.dart';

class StreakManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateStreak(String userId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      final userDoc = await userRef.get();

      if (!userDoc.exists) {
        // print('User tidak ditemukan');
        return;
      }

      final data = userDoc.data()!;
      final currentStreak = data['streak'] as int? ?? 0;
      final lastWorkoutTimestamp = data['lastWorkoutDate'] as Timestamp?;
      final totalWorkouts = data['totalWorkouts'] as int? ?? 0;

      final now = DateTime.now();
      DateTime? lastWorkoutDate;

      if (lastWorkoutTimestamp != null) {
        lastWorkoutDate = lastWorkoutTimestamp.toDate();
      }

      int newStreak = currentStreak;
      // bool isStreakContinued = false;

      if (lastWorkoutDate == null) {
        newStreak = 1;
        // print('First workout! Streak started: 1');
      } else {
        final differenceInDays = _calculateDayDifference(lastWorkoutDate, now);

        if (differenceInDays == 0) {
          // print('ℹAlready worked out today. Streak unchanged: $currentStreak');
          return;
        } else if (differenceInDays == 1) {
          newStreak = currentStreak + 1;
          // isStreakContinued = true;
          // print('Streak continued! New streak: $newStreak');
        } else if (differenceInDays > 1) {
          newStreak = 1;
          // print('Streak broken! Reset to: 1');
        }
      }

      await userRef.update({
        'streak': newStreak,
        'lastWorkoutDate': Timestamp.fromDate(now),
        'totalWorkouts': totalWorkouts + 1,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // print('Streak updated: $newStreak days');
    } catch (e) {
      // print(' Error updating streak: $e');
      throw e;
    }
  }

  int _calculateDayDifference(DateTime from, DateTime to) {
    final fromNormalized = DateTime(from.year, from.month, from.day);
    final toNormalized = DateTime(to.year, to.month, to.day);

    return toNormalized.difference(fromNormalized).inDays;
  }

  Future<UserStreakData> getUserStreakData(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        return UserStreakData(streak: 0, lastWorkout: null, isActive: false);
      }

      final data = userDoc.data()!;
      final streak = data['streak'] as int? ?? 0;
      final lastWorkoutTimestamp = data['lastWorkoutDate'] as Timestamp?;

      final isActive = isStreakActive(lastWorkoutTimestamp?.toDate());

      return UserStreakData(
        streak: streak,
        lastWorkout: lastWorkoutTimestamp?.toDate(),
        isActive: isActive,
      );
    } catch (e) {
      // print('Error getting streak data: $e');
      return UserStreakData(streak: 0, lastWorkout: null, isActive: false);
    }
  }
}

class UserStreakData {
  final int streak;
  final DateTime? lastWorkout;
  final bool isActive;

  UserStreakData({
    required this.streak,
    this.lastWorkout,
    required this.isActive,
  });
}

bool isStreakActive(DateTime? lastWorkoutDate) {
  if (lastWorkoutDate == null) return false;
  final now = DateTime.now();
  final yesterday = now.subtract(Duration(days: 1));

  return lastWorkoutDate.year == now.year &&
          lastWorkoutDate.month == now.month &&
          lastWorkoutDate.day == now.day ||
      lastWorkoutDate.year == yesterday.year &&
          lastWorkoutDate.month == yesterday.month &&
          lastWorkoutDate.day == yesterday.day;
}
