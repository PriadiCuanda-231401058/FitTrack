import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoBase64;
  final String? provider;
  final bool? isPremium;
  final int? streak;
  final DateTime? lastWorkoutDate;
  final String? premiumType;
  final DateTime? premiumDateStart;
  final DateTime? premiumDateEnd;
  final String? stripeCustomerId;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoBase64,
    this.provider,
    this.isPremium,
    this.streak,
    this.lastWorkoutDate,
    this.premiumType,
    this.premiumDateStart,
    this.premiumDateEnd,
    this.stripeCustomerId,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoBase64: data['photoBase64'],
      provider: data['provider'],
      isPremium: data['isPremium'] ?? false,
      lastWorkoutDate: data['lastWorkoutDate'] != null
          ? (data['lastWorkoutDate'] as Timestamp).toDate()
          : null,
      premiumType: data['premiumType'],
      premiumDateStart: data['premiumDateStart'] != null
          ? (data['premiumDateStart'] as Timestamp).toDate()
          : null,
      premiumDateEnd: data['premiumDateEnd'] != null
          ? (data['premiumDateEnd'] as Timestamp).toDate()
          : null,
      stripeCustomerId: data['stripeCustomerId'],
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoBase64: map['photoBase64'],
      provider: map['provider'],
      isPremium: map['isPremium'] ?? false,
      lastWorkoutDate: map['lastWorkoutDate'] != null
          ? DateTime.parse(map['lastWorkoutDate'])
          : null,
      premiumType: map['premiumType'],
      premiumDateStart: map['premiumDateStart'] != null
          ? DateTime.parse(map['premiumDateStart'])
          : null,
      premiumDateEnd: map['premiumDateEnd'] != null
          ? DateTime.parse(map['premiumDateEnd'])
          : null,
      stripeCustomerId: map['stripeCustomerId'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoBase64': photoBase64,
      'provider': provider,
      'isPremium': isPremium,
      'lastWorkoutDate': lastWorkoutDate?.toIso8601String(),
      'premiumDateEnd': premiumDateEnd?.toIso8601String(),
      'premiumDateStart': premiumDateStart?.toIso8601String(),
      'premiumType': premiumType,
      'stripeCustomerId': stripeCustomerId,
    };
  }

  bool get hasWorkoutToday {
    if (lastWorkoutDate == null) return false;
    final now = DateTime.now();
    return lastWorkoutDate!.year == now.year &&
        lastWorkoutDate!.month == now.month &&
        lastWorkoutDate!.day == now.day;
  }

  bool get isStreakActive {
    if (lastWorkoutDate == null) return false;
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));

    return lastWorkoutDate!.year == now.year &&
            lastWorkoutDate!.month == now.month &&
            lastWorkoutDate!.day == now.day ||
        lastWorkoutDate!.year == yesterday.year &&
            lastWorkoutDate!.month == yesterday.month &&
            lastWorkoutDate!.day == yesterday.day;
  }
}
