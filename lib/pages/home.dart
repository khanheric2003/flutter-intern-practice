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
    ["something", false],
    ["something", true]
  ];
  // text controller
  final _controller = TextEditingController();

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
      setState(() {
        taskList.add([_controller.text, false]);
      });
    }

    // create a new task
    void createNewTask() {
      showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop,
          );
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
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: taskList.length,
        itemBuilder: (context, index) {
          return TaskTitle(
              taskName: taskList[index][0],
              taskCompleted: taskList[index][1],
              onChanged: (value) => checkBoxChanged(value, index));
        },
      ),
    );
  }
}
