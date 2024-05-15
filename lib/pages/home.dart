import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/pages/task_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[300],
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<ProfileScreen>(
                    builder: (context) => ProfileScreen(
                      appBar: AppBar(
                        title: const Text('User Profile'),
                        backgroundColor: Colors.blue[300],
                      ),
                      actions: [
                        SignedOutAction((context) {
                          Navigator.of(context).pop();
                        })
                      ],
                      children: const [
                        Divider(),
                        Padding(
                          padding: EdgeInsets.all(2),
                          child: AspectRatio(
                            aspectRatio: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
          automaticallyImplyLeading: false,
        ),
        body: ListView(
          children: [
            TaskTitle(
              taskName: "something",
              taskCompleted: true,
              onChanged: (p0) {},
            ),
            TaskTitle(
              taskName: "something",
              taskCompleted: true,
              onChanged: (p0) {},
            ),
          ],
        ));
  }
}
