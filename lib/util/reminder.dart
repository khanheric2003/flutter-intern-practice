import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'local_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum ReminderFrequency { daily, weekly, none }

class SetReminder extends StatefulWidget {
  const SetReminder({super.key});

  @override
  _SetReminderState createState() => _SetReminderState();
}

class _SetReminderState extends State<SetReminder> {
  DateTime? pickedDate;
  TimeOfDay? pickedTime;
  ReminderFrequency reminderFrequency = ReminderFrequency.none;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    print(
        'Current DateTime: ${DateTime.now()}'); // Print out the current DateTime
    print(
        'Current TZDateTime: ${tz.TZDateTime.now(tz.local)}'); // Print out the current TZDateTime
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     'Current DateTime: ${DateTime.now()}'); // Print out the current DateTime
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set a reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: const Text('Daily'),
                    leading: Radio<ReminderFrequency>(
                      value: ReminderFrequency.daily,
                      groupValue: reminderFrequency,
                      onChanged: (ReminderFrequency? value) {
                        setState(() {
                          reminderFrequency = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Weekly'),
                    leading: Radio<ReminderFrequency>(
                      value: ReminderFrequency.weekly,
                      groupValue: reminderFrequency,
                      onChanged: (ReminderFrequency? value) {
                        setState(() {
                          reminderFrequency = value!;
                        });
                      },
                    ),
                  ),
                  ElevatedButton(
                    child: Text(pickedDate == null
                        ? 'Pick a date'
                        : 'Picked date: ${pickedDate!.toLocal()}'),
                    onPressed: () async {
                      pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 5),
                      );
                      setState(() {});
                    },
                  ),
                  ElevatedButton(
                    child: Text(pickedTime == null
                        ? 'Pick a time'
                        : 'Picked time: ${pickedTime!.format(context)}'),
                    onPressed: () async {
                      pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 51.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      child: const Text('test'),
                      onPressed: () {
                        LocalNotificationService.showTextNotification(
                          id: 1,
                          title: 'Test Notification',
                          body: 'This is a test notification from test.',
                        );
                      },
                    ),

                    const SizedBox(
                        width:
                            10), // Optional: To provide some space between the buttons
                    ElevatedButton(
                      child: const Text('Save'),
                      onPressed: () async {
                        if (pickedDate != null && pickedTime != null) {
                          DateTime scheduledNotificationDateTime = DateTime(
                            pickedDate!.year,
                            pickedDate!.month,
                            pickedDate!.day,
                            pickedTime!.hour,
                            pickedTime!.minute,
                          );

                          if (scheduledNotificationDateTime
                              .isBefore(DateTime.now())) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Are you a time traveller? Cannot set a reminder for a past time!')),
                            );
                          } else {
                            // Save the reminder in Firestore
                            final remindersCollection = FirebaseFirestore
                                .instance
                                .collection('userList')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('reminders');
                            await remindersCollection.add({
                              'scheduledTime': scheduledNotificationDateTime,
                              'creationTime': DateTime.now(),
                            });

                            Navigator.of(context).pop(
                                [pickedDate, pickedTime, reminderFrequency]);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Reminder set for ${scheduledNotificationDateTime.toString()}'),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
