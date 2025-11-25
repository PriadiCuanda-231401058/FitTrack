import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fittrack/models/workout_model.dart';

class WorkoutController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get Challenges
  Future<List<Workout>> getChallenges() async {
    try {
      final snapshot = await _db
          .collection('workouts')
          .doc('challenges')
          .collection('categories')
          .get();

      final challenges = <Workout>[];
      
      for (final doc in snapshot.docs) {
        try {
          final challenge = Workout.fromFirestore(doc);
          challenges.add(challenge);
        } catch (e) {
          print('Error parsing challenge ${doc.id}: $e');
        }
      }
      
      return challenges;
    } catch (e) {
      print('Error getting challenges: $e');
      return [];
    }
  }

  // Get Body Focus Categories
  Future<List<String>> getBodyFocusCategories() async {
    try {
      final snapshot = await _db
          .collection('workouts')
          .doc('bodyFocus')
          .collection('categories')
          .get();
      
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error getting body focus categories: $e');
      return [];
    }
  }

  // Get Workouts by Body Focus
  Future<List<Workout>> getWorkoutsByBodyFocus(String focusArea) async {
    try {
      final snapshot = await _db
          .collection('workouts')
          .doc('bodyFocus')
          .collection('categories')
          .doc(focusArea)
          .collection('levels')
          .get();

      final workouts = <Workout>[];
      
      for (final doc in snapshot.docs) {
        try {
          // Get exercises count for this level
          final exercisesSnapshot = await doc.reference
              .collection('exercises')
              .get();
          
          final workout = Workout(
            id: '${focusArea}_${doc.id}',
            title: doc.id, // Level name (Beginner, Intermediate, Advanced)
            focusArea: focusArea,
            exerciseCount: exercisesSnapshot.docs.length,
            duration: _calculateWorkoutDuration(exercisesSnapshot.docs),
            isPremium: doc.id == 'Advanced', // Advanced is premium
            imageURL: _getWorkoutImageURL(focusArea, doc.id),
          );
          
          workouts.add(workout);
        } catch (e) {
          print('Error parsing workout ${doc.id}: $e');
        }
      }
      
      return workouts;
    } catch (e) {
      print('Error getting workouts for $focusArea: $e');
      return [];
    }
  }

  // Get Target Categories
  Future<List<String>> getTargetCategories() async {
    try {
      final snapshot = await _db
          .collection('workouts')
          .doc('target')
          .collection('categories')
          .get();
      
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error getting target categories: $e');
      return [];
    }
  }

  // Get Workouts by Target
  Future<List<Workout>> getWorkoutsByTarget(String target) async {
    try {
      final snapshot = await _db
          .collection('workouts')
          .doc('target')
          .collection('categories')
          .doc(target)
          .collection('levels')
          .get();

      final workouts = <Workout>[];
      
      for (final doc in snapshot.docs) {
        try {
          // Get exercises count for this level
          final exercisesSnapshot = await doc.reference
              .collection('exercises')
              .get();
          
          final workout = Workout(
            id: '${target}_${doc.id}',
            title: doc.id,
            goalType: target,
            exerciseCount: exercisesSnapshot.docs.length,
            duration: _parseDurationFromLevel(doc.id),
            isPremium: _isTargetWorkoutPremium(target, doc.id),
            imageURL: _getTargetWorkoutImageURL(target, doc.id),
          );
          
          workouts.add(workout);
        } catch (e) {
          print('Error parsing target workout ${doc.id}: $e');
        }
      }
      
      return workouts;
    } catch (e) {
      print('Error getting workouts for target $target: $e');
      return [];
    }
  }

  // Get Popular Workouts
  Future<List<Workout>> getPopularWorkouts() async {
    try {
      // For now, return a mix of body focus and target workouts
      // You can implement your own logic for popularity
      final popularWorkouts = <Workout>[];
      
      // Get some body focus workouts
      final absWorkouts = await getWorkoutsByBodyFocus('ABS');
      if (absWorkouts.isNotEmpty) {
        popularWorkouts.add(absWorkouts.first);
      }
      
      // Get some target workouts
      final strengthWorkouts = await getWorkoutsByTarget('Strength');
      if (strengthWorkouts.isNotEmpty) {
        popularWorkouts.add(strengthWorkouts.first);
      }
      
      final cardioWorkouts = await getWorkoutsByTarget('Cardio');
      if (cardioWorkouts.isNotEmpty) {
        popularWorkouts.add(cardioWorkouts.firstWhere(
          (workout) => workout.duration == 10,
          orElse: () => cardioWorkouts.first,
        ));
      }
      
      return popularWorkouts;
    } catch (e) {
      print('Error getting popular workouts: $e');
      return [];
    }
  }

  // Get Exercises for Workout
  Future<List<Exercise>> getExercisesForWorkout({
    String? challengeID,
    String? workoutID,
    String? focusArea,
    String? level,
    String? target,
    String? duration,
  }) async {
    try {
      if (challengeID != null) {
        // Get exercises for challenge
        final snapshot = await _db
            .collection('workouts')
            .doc('challenges')
            .collection('categories')
            .doc(challengeID)
            .collection('levels')
            .doc('default') // Assuming challenges have one level
            .collection('exercises')
            .orderBy('order')
            .get();

        return snapshot.docs
            .map((doc) => Exercise.fromFirestore(doc))
            .toList();
      } else if (focusArea != null && level != null) {
        // Get exercises for body focus
        return await _getBodyFocusExercises(focusArea, level);
      } else if (target != null && duration != null) {
        // Get exercises for target
        return await _getTargetExercises(target, duration);
      } else if (workoutID != null) {
        // Parse workoutID to get focusArea/level or target/duration
        // Implementation depends on your ID structure
        return [];
      }
      
      return [];
    } catch (e) {
      print('Error getting exercises: $e');
      return [];
    }
  }

  // Private method to get body focus exercises
  Future<List<Exercise>> _getBodyFocusExercises(String focusArea, String level) async {
    try {
      final snapshot = await _db
          .collection('workouts')
          .doc('bodyFocus')
          .collection('categories')
          .doc(focusArea)
          .collection('levels')
          .doc(level)
          .collection('exercises')
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => Exercise.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting body focus exercises: $e');
      return [];
    }
  }

  // Private method to get target exercises
  Future<List<Exercise>> _getTargetExercises(String target, String duration) async {
    try {
      final snapshot = await _db
          .collection('workouts')
          .doc('target')
          .collection('categories')
          .doc(target)
          .collection('levels')
          .doc(duration)
          .collection('exercises')
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => Exercise.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting target exercises: $e');
      return [];
    }
  }

  // Helper methods
  int _calculateWorkoutDuration(List<QueryDocumentSnapshot<Map<String, dynamic>>> exercises) {
    // Calculate approximate duration based on exercises
    // This is a simplified calculation - adjust based on your needs
    int totalSeconds = 0;
    
    for (final exerciseDoc in exercises) {
      final exercise = Exercise.fromFirestore(exerciseDoc);
      totalSeconds += exercise.value + exercise.rest;
    }
    
    // Convert to minutes and add some buffer
    return (totalSeconds / 60).ceil() + 2;
  }

  String _getWorkoutImageURL(String focusArea, String level) {
    // Map to your actual image paths
    return 'assets/workouts/$focusArea/images/$level.jfif';
  }

  // String _getTargetWorkoutTitle(String target, String duration) {
  //   // Map duration to proper title
  //   final durationMap = {
  //     '5 Menit': '5-Min ${_getTargetSuffix(target)}',
  //     '7 Menit': '7-Min ${_getTargetSuffix(target)}',
  //     '10 Menit': '10-Min ${_getTargetSuffix(target)}',
  //   };
    
  //   return durationMap[duration] ?? '$duration $target';
  // }

  String _getTargetSuffix(String target) {
    switch (target) {
      case 'Strength':
        return 'Strength Boost';
      case 'Cardio':
        return 'Cardio Burn';
      case 'Flexibility':
        return 'Flex Flow';
      default:
        return target;
    }
  }

  String _getTargetWorkoutImageURL(String target, String duration) {
    // Map to your actual image paths
    // final title = _getTargetWorkoutTitle(target, duration)
    //     .replaceAll(' ', '')
    //     .replaceAll('-', ' ');
    return 'assets/workouts/$target/images/$duration.jfif';
  }

  int _parseDurationFromLevel(String level) {
    // Extract number from level string like "5 Menit"
    final regex = RegExp(r'(\d+)');
    final match = regex.firstMatch(level);
    return match != null ? int.parse(match.group(1)!) : 5;
  }

  bool _isTargetWorkoutPremium(String target, String level) {
    // Define which target workouts are premium
    return target == 'Cardio' && level == '10 Menit';
  }
}