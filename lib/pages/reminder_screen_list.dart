import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReminderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('userList')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('reminders')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final reminders = snapshot.data!.docs;
            return ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                final scheduledTime =
                    (reminder['scheduledTime'] as Timestamp).toDate();
                final creationTime =
                    (reminder['creationTime'] as Timestamp).toDate();
                return ListTile(
                  title: Text('Reminder ${index + 1}'),
                  subtitle: Text(
                      'Scheduled time: $scheduledTime\nCreation time: $creationTime'),
                );
              },
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
