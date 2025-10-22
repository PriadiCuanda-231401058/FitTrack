import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid; 
  final String name;    
  final String email; 
  // final String? photo;  

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    // this.photo,
  });

  // 🔸 Konversi dari DocumentSnapshot (ambil dari Firestore)
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      // photo: data['photo'],
    );
  }

  // 🔸 Konversi dari Map (misalnya dari Auth + Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      // photo: map['photo'],
    );
  }
  // 🔸 Konversi ke Map (untuk simpan ke Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      // 'photo': photo,
    };
  }
}
