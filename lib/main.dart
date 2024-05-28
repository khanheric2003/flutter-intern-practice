import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import '../../firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'util/local_notification.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/services.dart';

// pull from firestore
Future<void> checkReminders() async {
  final tasks = await FirebaseFirestore.instance
      .collection('userList')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('tasks')
      .where('isReminder', isEqualTo: true)
      .get();

  for (var task in tasks.docs) {
    final reminderDate = (task.data()['reminderDate'] as Timestamp).toDate();
    final reminderTime = TimeOfDay.fromDateTime(reminderDate);
    final now = TimeOfDay.now();

    print(
        'Task special: ${task.data()}, Now: $now'); // Print task and current time

    if (reminderTime.hour == now.hour && reminderTime.minute == now.minute) {
      LocalNotificationService.showTextNotification(
        id: task.id.hashCode, // Unique ID for each notification
        title: task.data()['taskName'],
        body: task.data()['taskDescription'],
      );
    }
  }
}

void callbackDispatcher() {
  const MethodChannel backgroundChannel =
      MethodChannel('plugins.flutter.io/android_alarm_manager_background');
  WidgetsFlutterBinding.ensureInitialized();
  backgroundChannel.setMethodCallHandler((MethodCall call) async {
    if (call.method == 'alarm') {
      print('Alarm fired!');
      checkReminders();
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  const int helloAlarmID = 0;
  await AndroidAlarmManager.initialize();
  // Initialize the plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Create a notification channel
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'test channel id', // id
    'test channel name', // title
    importance: Importance.high,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Work mananger initializes

  runApp(const MyApp());
  await AndroidAlarmManager.periodic(
      const Duration(seconds: 1), helloAlarmID, callbackDispatcher);
}
