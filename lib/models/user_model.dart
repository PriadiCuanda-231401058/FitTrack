import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoBase64;
  final String? provider;
  

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoBase64,
    this.provider,
  });

  // 🔸 Konversi dari DocumentSnapshot (ambil dari Firestore)
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoBase64: data['photoBase64'],
      provider: data['provider'],
    );
  }

  // 🔸 Konversi dari Map (misalnya dari Auth + Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoBase64: map['photoBase64'],
      // photo: map['photo'],
    );
  }
  // 🔸 Konversi ke Map (untuk simpan ke Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoBase64': photoBase64,
      'provider': provider,
    };
  }
}
