import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'package:fittrack/services/route.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Stripe.publishableKey =
      'pk_test_51Sdwjf3GIBspwluAxewkCa99A2h4ZK5xYcdq3MFtDD8eq4WQtxXqM5GNOAXVxzYLC4vWFZ6Hb3qBc9J0Sp5NRquc00ryIiSCnn';

  await Stripe.instance.applySettings();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'OpenSans'),
      initialRoute: '/',
      routes: appRoutes,
    );
  }
}
