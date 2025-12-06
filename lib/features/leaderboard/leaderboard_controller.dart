import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getWeeklyLeaderboard() async {
    try {
      final usersSnapshot = await _db.collection('users').get();
      
      final List<Map<String, dynamic>> leaderboard = [];
      
      for (var userDoc in usersSnapshot.docs) {
        final userData = userDoc.data();
        final userId = userDoc.id;
        final totalWorkouts = userData['progress']?['1 week']?['total_training'] ?? 0;
        
        final streak = userData['streak'] ?? 0;
        
        final points = totalWorkouts + streak;
        
        final name = userData['name'] ?? 
                     userData['displayName'] ?? 
                     userData['email']?.split('@').first ?? 
                     'User ${userId.substring(0, 6)}';
        
        leaderboard.add({
          'name': name,
          'point': points,
          'userId': userId,
        });
      }

      leaderboard.sort((a, b) {
        if (b['point'] == a['point']) {
          return (a['name'] as String).compareTo(b['name'] as String);
        }
        return (b['point'] as int).compareTo(a['point'] as int);
      });
      
      return leaderboard.map((entry) => {
        'name': entry['name'],
        'point': entry['point'],
      }).toList();
      
    } catch (e) {
      print('Error getting weekly leaderboard: $e');
      
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getMonthlyLeaderboard() async {
    try {
      final usersSnapshot = await _db.collection('users').get();
      
      final List<Map<String, dynamic>> leaderboard = [];
      
      for (var userDoc in usersSnapshot.docs) {
        final userData = userDoc.data();
        final userId = userDoc.id;

        final totalWorkouts = userData['progress']?['1 month']?['total_training'] ?? 0;
        print('User $userId has totalWorkouts: $totalWorkouts');

        final streak = userData['streak'] ?? 0;

        final points = totalWorkouts + streak;

        final name = userData['name'] ?? 
                     userData['displayName'] ?? 
                     userData['email']?.split('@').first ?? 
                     'User ${userId.substring(0, 6)}';
        
        leaderboard.add({
          'name': name,
          'point': points,
          'userId': userId,
        });
      }

      leaderboard.sort((a, b) {
        if (b['point'] == a['point']) {
          return (a['name'] as String).compareTo(b['name'] as String);
        }
        return (b['point'] as int).compareTo(a['point'] as int);
      });
      
      return leaderboard.map((entry) => {
        'name': entry['name'],
        'point': entry['point'],
      }).toList();
      
    } catch (e) {
      print('Error getting monthly leaderboard: $e');

      return [];
    }
  }
}