import 'package:cloud_firestore/cloud_firestore.dart';

class UserProgress {
  final String userId;
  final String email;
  final String name;
  final int streak;
  final bool isStreak;
  final Map<String, dynamic> progress;
  final List<String> achievements;
  final String? photoBase64;
  final Timestamp? lastWorkoutDate;

  UserProgress({
    required this.userId,
    required this.email,
    required this.name,
    required this.streak,
    required this.isStreak,
    required this.progress,
    required this.achievements,
    this.photoBase64,
    this.lastWorkoutDate,
  });

  dynamic operator [](String key) => progress[key];

  factory UserProgress.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('User data is null');
    }

    return UserProgress(
      userId: doc.id,
      email: (data['email']),
      name: (data['name']),
      streak: (data['streak']),
      isStreak: data['isStreak'] ?? false,
      progress: _safeCastMap(data['progress']),
      achievements: _safeCastList(data['achievements']),
      photoBase64: data['photoBase64'],
      lastWorkoutDate: data['lastWorkoutDate'] as Timestamp?,
    );
  }

  

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'streak': streak,
      'isStreak': isStreak,
      'progress': progress,
      'achievements': achievements,
      'photoBase64': photoBase64,
      'lastWorkoutDate': lastWorkoutDate ?? FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
  }

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

  static Map<String, dynamic> _safeCastMap(dynamic value) {
    if (value == null) return {};
    if (value is Map<String, dynamic>) return value;
    return {};
  }

  static List<String> _safeCastList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.whereType<String>().toList();
    }
    return [];
  }
}