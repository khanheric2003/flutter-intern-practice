import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/util/dialog_box.dart';
import 'package:task_manager/util/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List of tasks
  List taskList = [
    ["something", false, "description 1"],
    ["something", true, "description 2"]
  ];
  // text controller
  final _controller = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // checkbox tapped
    void checkBoxChanged(bool? value, int index) {
      setState(() {
        taskList[index][1] = value!;
      });
    }

    // save new task
    void saveNewTask() {
      if (_controller.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task cannot be empty!')),
        );
      } else {
        setState(() {
          taskList.add([_controller.text, false, _descriptionController.text]);
          Navigator.of(context).pop();
          _controller.clear();
          _descriptionController.clear();
        });
      }
    }

    // create a new task
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

    // edit existing task
    void editTask(int index, String newTaskName, String newDescription) {
      if (_controller.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task cannot be empty!')),
        );
      } else {
        setState(() {
          taskList[index][0] = newTaskName;
          taskList[index][2] = newDescription;
          Navigator.of(context).pop();
        });
      }
    }

    // show edit dialog
    void showEditDialog(int index) {
      _controller.text = taskList[index][0];
      _descriptionController.text = taskList[index][2];
      showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            taskController: _controller,
            descriptionController: _descriptionController,
            onSave: () {
              editTask(index, _controller.text, _descriptionController.text);
            },
            onCancel: () => Navigator.of(context).pop(),
          );
        },
      );
    }

    void deleteTask(int index) {
      setState(
        () {
          taskList.removeAt(index);
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 242, 246),
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

      // floating add button
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(
          Icons.add,
          color: Colors.blue[600],
        ),
      ),
      body: ListView.builder(
        itemCount: taskList.length,
        itemBuilder: (context, index) {
          return TaskTitle(
            taskName: taskList[index][0],
            taskCompleted: taskList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            onDelete: (context) => deleteTask(index),
            onEdit: (context) => showEditDialog(index),
          );
        },
      ),
    );
  }
}
