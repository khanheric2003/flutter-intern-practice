import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import '../../firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// TODO(codelab user): Get API key
const clientId = 'YOUR_CLIENT_ID';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final messaging = FirebaseMessaging.instance;

  // request to notification access 
  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
    );
  runApp(const MyApp());
}
