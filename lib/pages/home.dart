import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/util/dialog_box.dart';
import 'package:task_manager/util/task_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'setting.dart';
import 'reminder_screen_list.dart';
import 'edit_task_screen.dart';
import '../util/reminder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> addTaskToFirestore(
      String taskName, String taskDescription) async {
    final tasksCollection = FirebaseFirestore.instance
        .collection('userList')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tasks');
    await tasksCollection.add({
      'taskName': taskName,
      'taskDescription': taskDescription,
      'taskCompleted': false,
      'isReminder': false, // Default value
      'reminderDate': null, // Default value
      'reminderTime': '', // Default value
    });
  }

  void saveNewTask() {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task cannot be empty!')),
      );
    } else {
      addTaskToFirestore(_controller.text, _descriptionController.text);
      Navigator.of(context).pop();
      _controller.clear();
      _descriptionController.clear();
    }
  }

  void createNewTask() {
    _controller.clear();
    _descriptionController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          taskController: _controller,
          descriptionController: _descriptionController,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 242, 246),
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReminderScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.alarm),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SetReminder()),
              );
            },
          ),
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
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(
          Icons.add,
          color: Colors.blue[600],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('userList')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('tasks')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final tasks = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskTitle(
                        taskName: task['taskName'],
                        taskCompleted: task['taskCompleted'],
                        onChanged: (value) {
                          task.reference.update({'taskCompleted': value});
                        },
                        onDelete: (context) {
                          task.reference.delete();
                        },
                        onEdit: (context) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTaskScreen(
                                taskId: task.id, // Pass the task ID here
                                taskName: task['taskName'],
                                taskDescription: task['taskDescription'],
                              ),
                            ),
                          );
                        },
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
          ),
        ],
      ),
    );
  }
}
