// services/payment_services.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fittrack/models/user_model.dart';

class PaymentService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> createPaymentSheet(String customerId, int amount) async {
    final url = Uri.parse(
      "https://railway-backend-production-7649.up.railway.app/create-payment-sheet",
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "customerId": customerId,
        "amount": amount,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<String> getOrCreateStripeCustomer() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    
    if (userDoc.exists && userDoc.data()?['stripeCustomerId'] != null) {
      return userDoc.data()!['stripeCustomerId'] as String;
    }

    final url = Uri.parse(
      "https://railway-backend-production-7649.up.railway.app/create-customer",
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": user.email,
        "name": user.displayName ?? user.email!.split('@')[0],
      }),
    );

    final data = jsonDecode(response.body);
    final stripeCustomerId = data['customerId'] as String;

    // Simpan ke Firestore
    await _firestore.collection('users').doc(user.uid).set({
      'stripeCustomerId': stripeCustomerId,
      'email': user.email,
      'name': user.displayName,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return stripeCustomerId;
  }

  Future<void> payWithPremiumUpdate({
    required int amount,
    required String customerId,
    required String premiumType,
    required int durationInMonths,
  }) async {
    try {
      final data = await createPaymentSheet(customerId, amount);

      // Optional: override dengan key dari backend
      // Stripe.publishableKey = data['publishableKey'] ?? Stripe.publishableKey;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: "FitTrack",
          customerId: data['customerId'],
          customerEphemeralKeySecret: data['ephemeralKey'],
          paymentIntentClientSecret: data['paymentIntent'],
          // merchantCountryCode: 'ID',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      await _updatePremiumStatus(premiumType, durationInMonths);

    } on StripeException catch (e) {
      print('Stripe Error: ${e.error.localizedMessage}');
      throw Exception('Payment failed: ${e.error.localizedMessage}');
    } catch (e) {
      print('Payment Error: $e');
      rethrow;
    }
  }

  // Fungsi untuk update premium status di Firestore
  Future<void> _updatePremiumStatus(String premiumType, int durationInMonths) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final now = DateTime.now();
    final premiumEndDate = _calculatePremiumEndDate(now, premiumType);

    // Update data user di Firestore
    await _firestore.collection('users').doc(user.uid).set({
      'isPremium': true,
      'premiumType': premiumType,
      'premiumDateStart': Timestamp.fromDate(now),
      'premiumDateEnd': Timestamp.fromDate(premiumEndDate),
      'lastPaymentDate': Timestamp.fromDate(now),
      'premiumDurationMonths': durationInMonths,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    print('Premium status updated for user: ${user.uid}');
  }

  // Hitung tanggal berakhir premium berdasarkan tipe plan
  DateTime _calculatePremiumEndDate(DateTime startDate, String premiumType) {
    switch (premiumType) {
      case 'Basic':
        return startDate.add(const Duration(days: 30)); // 1 bulan
      case 'Standard':
        return startDate.add(const Duration(days: 90)); // 3 bulan
      case 'Pro':
        return startDate.add(const Duration(days: 180)); // 6 bulan
      case 'Ultimate':
        return startDate.add(const Duration(days: 365)); // 1 tahun
      default:
        return startDate.add(const Duration(days: 30));
    }
  }

  // Fungsi untuk mengecek apakah user masih premium
  Future<bool> checkPremiumStatus() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      
      if (!userDoc.exists) return false;
      
      final data = userDoc.data();
      if (data == null || !(data['isPremium'] ?? false)) return false;

      // Cek apakah premium sudah expired
      final premiumEndTimestamp = data['premiumDateEnd'] as Timestamp?;
      if (premiumEndTimestamp == null) return false;

      final premiumEndDate = premiumEndTimestamp.toDate();
      final now = DateTime.now();

      // Jika premium sudah expired, update status
      if (now.isAfter(premiumEndDate)) {
        await _firestore.collection('users').doc(user.uid).update({
          'isPremium': false,
          'premiumType': null,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return false;
      }

      return true;
    } catch (e) {
      print('Error checking premium status: $e');
      return false;
    }
  }

  // Fungsi untuk mendapatkan info premium user
  Future<Map<String, dynamic>?> getPremiumInfo() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      
      if (!userDoc.exists) return null;
      
      final data = userDoc.data();
      if (data == null) return null;

      return {
        'isPremium': data['isPremium'] ?? false,
        'premiumType': data['premiumType'],
        'premiumDateStart': (data['premiumDateStart'] as Timestamp?)?.toDate(),
        'premiumDateEnd': (data['premiumDateEnd'] as Timestamp?)?.toDate(),
        'daysRemaining': _calculateDaysRemaining(data['premiumDateEnd'] as Timestamp?),
      };
    } catch (e) {
      print('Error getting premium info: $e');
      return null;
    }
  }

  int? _calculateDaysRemaining(Timestamp? premiumEndTimestamp) {
    if (premiumEndTimestamp == null) return null;
    
    final endDate = premiumEndTimestamp.toDate();
    final now = DateTime.now();
    final difference = endDate.difference(now);
    
    return difference.inDays.clamp(0, 365);
  }
}