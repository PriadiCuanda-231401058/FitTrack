import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Workout {
  final String id;
  final String title;
  final String? focusArea;
  final String? goalType;
  final int exerciseCount;
  final int duration;
  final bool isPremium;
  final String imageURL;
  final String? description;
  final Color? bgColor;

  Workout({
    required this.id,
    required this.title,
    this.focusArea,
    this.goalType,
    required this.exerciseCount,
    required this.duration,
    required this.isPremium,
    required this.imageURL,
    this.description,
    this.bgColor,
  });

  dynamic operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'title':
        return title;
      case 'focusArea':
        return focusArea;
      case 'goalType':
        return goalType;
      case 'exerciseCount':
        return exerciseCount;
      case 'duration':
        return duration;
      case 'isPremium':
        return isPremium;
      case 'imageURL':
        return imageURL;
      case 'description':
        return description;
      case 'bgColor':
        return bgColor;
      default:
        return null;
    }
  }

  // Convert Firestore Document to Workout object
  factory Workout.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document data is null');
    }

    return Workout(
      id: doc.id,
      title: _safeCastString(data['title']),
      focusArea: data['focusArea'] != null
          ? _safeCastString(data['focusArea'])
          : null,
      goalType: data['goalType'] != null
          ? _safeCastString(data['goalType'])
          : null,
      exerciseCount: _safeCastInt(data['exerciseCount']),
      duration: _safeCastInt(data['duration']),
      isPremium: data['isPremium'] ?? false,
      imageURL: _safeCastString(data['imageURL']),
      description: data['description'] != null
          ? _safeCastString(data['description'])
          : null,
      bgColor: data['bgColor'] != null ? _parseColor(data['bgColor']) : null,
    );
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

  static Color? _parseColor(dynamic value) {
    if (value == null) return null;
    if (value is int) return Color(value);
    if (value is String) {
      if (value.startsWith('0x') || value.startsWith('0X')) {
        return Color(int.parse(value));
      }
      if (value.startsWith('#')) {
        return Color(int.parse(value.replaceFirst('#', '0xff')));
      }
    }
    return null;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'focusArea': focusArea,
      'goalType': goalType,
      'exerciseCount': exerciseCount,
      'duration': duration,
      'isPremium': isPremium,
      'imageURL': imageURL,
      'description': description,
      'bgColor': bgColor?.value,
      'created_at': FieldValue.serverTimestamp(),
    };
  }
}

class Exercise {
  final String id;
  final int order;
  final String name;
  final String type;
  final int value;
  final int rest;
  final String media;
  final Timestamp? createdAt;

  Exercise({
    required this.id,
    required this.order,
    required this.name,
    required this.type,
    required this.value,
    required this.rest,
    required this.media,
    this.createdAt,
  });

  factory Exercise.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document data is null');
    }

    return Exercise(
      id: doc.id,
      order: _safeCastInt(data['order']),
      name: _safeCastString(data['name']),
      type: _safeCastString(data['type']),
      value: _safeCastInt(data['value']),
      rest: _safeCastInt(data['rest']),
      media: _safeCastString(data['media']),
      createdAt: data['created_at'] as Timestamp?,
    );
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

  Map<String, dynamic> toFirestore() {
    return {
      'order': order,
      'name': name,
      'type': type,
      'value': value,
      'rest': rest,
      'media': media,
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  String get displayValue {
    switch (type) {
      case 'repetition':
        return 'x$value';
      case 'repetition_per_side':
        return 'x$value per side';
      case 'time':
        return '${value}s';
      case 'time_per_side':
        return '${value}s per side';
      default:
        return 'x$value';
    }
  }
}
