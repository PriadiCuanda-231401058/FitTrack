import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fittrack/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getCurrentUserData() async {
    final User? user = _auth.currentUser;
    if (user == null) return null;

    final DocumentSnapshot doc =
        await _firestore.collection('users').doc(user.uid).get();

    if (doc.exists) {
      return UserModel.fromDocument(doc);
    }

    return null;
  }
}
