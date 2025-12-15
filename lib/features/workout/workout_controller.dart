import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fittrack/models/workout_model.dart';
import 'package:flutter/material.dart';

class WorkoutController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static int _safeCastInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _safeCastString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

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
          final data = doc.data();
          final challenge = Workout(
            id: doc.id,
            title: _safeCastString(data['title']),
            description: _safeCastString(data['description']),
            exerciseCount: _safeCastInt(data['exerciseCount']),
            duration: _safeCastInt(data['duration']),
            isPremium: false, // Challenges are free
            imageURL: _safeCastString(data['imageURL']),
            bgColor: data['bgColor'] != null
                ? Color(data['bgColor'] as int)
                : null,
          );
          challenges.add(challenge);
        } catch (e) {
          // print('Error parsing challenge ${doc.id}: $e');
        }
      }

      return challenges;
    } catch (e) {
      // print('Error getting challenges: $e');
      return [];
    }
  }

  Future<List<Exercise>> getChallengeExercises(String challengeId) async {
    try {
      final snapshot = await _db
          .collection('workouts')
          .doc('challenges')
          .collection('categories')
          .doc(challengeId)
          .collection('exercises')
          .orderBy('order')
          .get();

      return snapshot.docs.map((doc) => Exercise.fromFirestore(doc)).toList();
    } catch (e) {
      // print('Error getting challenge exercises for $challengeId: $e');
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
      // print('Error getting body focus categories: $e');
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
          // print('Error parsing workout ${doc.id}: $e');
        }
      }

      return workouts;
    } catch (e) {
      // print('Error getting workouts for $focusArea: $e');
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
      // print('Error getting target categories: $e');
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
          // print('Error parsing target workout ${doc.id}: $e');
        }
      }

      return workouts;
    } catch (e) {
      // print('Error getting workouts for target $target: $e');
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
        popularWorkouts.add(
          cardioWorkouts.firstWhere(
            (workout) => workout.duration == 10,
            orElse: () => cardioWorkouts.first,
          ),
        );
      }

      return popularWorkouts;
    } catch (e) {
      // print('Error getting popular workouts: $e');
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
        return await getChallengeExercises(challengeID);
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
      // print('Error getting exercises: $e');
      return [];
    }
  }

  // Private method to get body focus exercises
  Future<List<Exercise>> _getBodyFocusExercises(
    String focusArea,
    String level,
  ) async {
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

      return snapshot.docs.map((doc) => Exercise.fromFirestore(doc)).toList();
    } catch (e) {
      // print('Error getting body focus exercises: $e');
      return [];
    }
  }

  // Private method to get target exercises
  Future<List<Exercise>> _getTargetExercises(
    String target,
    String duration,
  ) async {
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

      return snapshot.docs.map((doc) => Exercise.fromFirestore(doc)).toList();
    } catch (e) {
      // print('Error getting target exercises: $e');
      return [];
    }
  }

  // Helper methods
  int _calculateWorkoutDuration(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> exercises,
  ) {
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

  String _getTargetWorkoutImageURL(String target, String duration) {
    // Map to your actual image paths
    return 'assets/workouts/$target/images/$duration.jfif';
  }

  int _parseDurationFromLevel(String level) {
    // Extract number from level string like "5 Menit"
    final regex = RegExp(r'(\d+)');
    final match = regex.firstMatch(level);
    return match != null ? int.parse(match.group(1)!) : 5;
  }

  bool _isTargetWorkoutPremium(String target, String level) {
    level = _parseDurationFromLevel(level).toString();
    return (target == 'Cardio' ||
            target == 'Flexibility' ||
            target == 'Strength') &&
        level == '10';
  }
}
