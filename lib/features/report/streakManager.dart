import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fittrack/models/user_model.dart';

class StreakManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi utama untuk update streak
  Future<void> updateStreak(String userId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      final userDoc = await userRef.get();
      
      if (!userDoc.exists) {
        print('❌ User tidak ditemukan');
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

      // LOGIKA STREAK
      int newStreak = currentStreak;
      // bool isStreakContinued = false;

      if (lastWorkoutDate == null) {
        // Pertama kali workout
        newStreak = 1;
        // isStreakContinued = true;
        print('🟢 First workout! Streak started: 1');
      } else {
        // Hitung selisih hari
        final differenceInDays = _calculateDayDifference(lastWorkoutDate, now);
        
        if (differenceInDays == 0) {
          // Sudah workout hari ini
          print('ℹ️ Already worked out today. Streak unchanged: $currentStreak');
          return;
        } else if (differenceInDays == 1) {
          // Workout hari berurutan (kemarin sudah workout)
          newStreak = currentStreak + 1;
          // isStreakContinued = true;
          print('🟢 Streak continued! New streak: $newStreak');
        } else if (differenceInDays > 1) {
          // Melewatkan hari, streak direset
          newStreak = 1;
          // isStreakContinued = true;
          print('🔄 Streak broken! Reset to: 1');
        }
      }

      // Update ke Firestore
      await userRef.update({
        'streak': newStreak,
        'lastWorkoutDate': Timestamp.fromDate(now),
        'totalWorkouts': totalWorkouts + 1,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Streak updated: $newStreak days');

    } catch (e) {
      print('❌ Error updating streak: $e');
      throw e;
    }
  }

  // Hitung selisih hari antara dua tanggal
  int _calculateDayDifference(DateTime from, DateTime to) {
    // Normalize ke tengah malam untuk perhitungan hari
    final fromNormalized = DateTime(from.year, from.month, from.day);
    final toNormalized = DateTime(to.year, to.month, to.day);
    
    return toNormalized.difference(fromNormalized).inDays;
  }


  // Reset streak jika melewatkan hari (dipanggil saat cek harian)
  // Future<void> checkAndResetStreak(String userId) async {
  //   try {
  //     final userRef = _firestore.collection('users').doc(userId);
  //     final userDoc = await userRef.get();
      
  //     if (!userDoc.exists) return;
      
  //     final data = userDoc.data()!;
  //     final lastWorkoutTimestamp = data['lastWorkoutDate'] as Timestamp?;
      
  //     if (lastWorkoutTimestamp == null) return;
      
  //     final lastWorkoutDate = lastWorkoutTimestamp.toDate();
  //     final now = DateTime.now();
  //     final differenceInDays = _calculateDayDifference(lastWorkoutDate, now);
      
  //     // Jika melewatkan lebih dari 1 hari, reset streak
  //     if (differenceInDays > 1) {
  //       await userRef.update({
  //         'streak': 0,
  //         'updatedAt': FieldValue.serverTimestamp(),
  //       });
  //       print('🔄 Streak auto-reset due to inactivity');
  //     }
      
  //   } catch (e) {
  //     print('❌ Error checking streak: $e');
  //   }
  // }

  // Get user streak data
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
      print('❌ Error getting streak data: $e');
      return UserStreakData(streak: 0, lastWorkout: null, isActive: false);
    }
  }
}

// Model untuk data streak
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

  bool isStreakActive (DateTime? lastWorkoutDate) {
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