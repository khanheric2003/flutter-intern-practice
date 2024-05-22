import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;
  final String taskName;
  final String taskDescription;

  EditTaskScreen(
      {required this.taskId,
      required this.taskName,
      required this.taskDescription});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _controller = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _reminder = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    fetchTask();
  }

  Future<void> fetchTask() async {
    final taskDoc = FirebaseFirestore.instance
        .collection('userList')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tasks')
        .doc(widget.taskId);
    final taskData = await taskDoc.get();

    setState(() {
      _controller.text = taskData['taskName'];
      _descriptionController.text = taskData['taskDescription'];
      _reminder = taskData['isReminder'];
      if (_reminder) {
        _selectedDate = (taskData['reminderDate'] as Timestamp).toDate();
        final timeParts = (taskData['reminderTime'] as String).split(':');
        _selectedTime = TimeOfDay(
            hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            TextField(
              controller: _descriptionController,
              maxLines: null, // Makes it multiline
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Task Description',
              ),
            ),
            CheckboxListTile(
              title: Text('Reminder'),
              value: _reminder,
              onChanged: (bool? value) {
                setState(() {
                  _reminder = value!;
                });
              },
            ),
            if (_reminder)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      ).then((date) {
                        setState(() {
                          _selectedDate = date!;
                        });
                      });
                    },
                    child: Text('Select Date'),
                  ),
                  Text(
                    'Selected Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                  ),
                ],
              ),
            if (_reminder)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      ).then((time) {
                        setState(() {
                          _selectedTime = time!;
                        });
                      });
                    },
                    child: Text('Select Time'),
                  ),
                  Text(
                    'Selected Time: ${_selectedTime.format(context)}',
                  ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_controller.text.isEmpty || _descriptionController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Task name and description cannot be empty!')),
            );
          } else {
            final taskDoc = FirebaseFirestore.instance
                .collection('userList')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('tasks')
                .doc(widget.taskId);
            await taskDoc.update({
              'taskName': _controller.text,
              'taskDescription': _descriptionController.text,
              'isReminder': _reminder,
              'reminderDate': _reminder ? _selectedDate : null,
              'reminderTime': _reminder ? _selectedTime.format(context) : null,
              'taskCompleted': false,
            });
            Navigator.of(context).pop();
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.blue[600],
      ),
    );
  }
}
