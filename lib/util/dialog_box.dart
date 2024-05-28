import 'package:flutter/material.dart';
import 'package:task_manager/util/my_button.dart';

class DialogBox extends StatelessWidget {
  final TextEditingController taskController;
  final TextEditingController descriptionController;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    Key? key,
    required this.taskController,
    required this.descriptionController,
    required this.onCancel,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue[100],
      content: SizedBox(
        height: 300, // Increase the height of the dialog box
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align labels to the left
          children: [
            const Text('Task'), // Label for the task field
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 10), // Add space below the task field
              child: TextField(
                controller: taskController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Add new task"),
              ),
            ),
            const Text('Description'), // Label for the description field
            Expanded(
              child: TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Add description",
                  alignLabelWithHint:
                      true, // Align the hint text to the top left
                ),
                minLines: 3, // Minimum lines for the description field
                maxLines: null, // Make the description field expandable
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(text: "Save", onPressed: onSave),
                const SizedBox(width: 10),
                MyButton(text: "Cancel", onPressed: onCancel),
              ],
            )
          ],
        ),
      ),
    );
  }
}
