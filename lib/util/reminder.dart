import 'package:flutter/material.dart';

Future<void> setReminder(BuildContext context) async {
  DateTime? pickedDate;
  TimeOfDay? pickedTime;
  bool reminder = false;

  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            elevation: 6,
            insetPadding:
                const EdgeInsets.symmetric(vertical: 240, horizontal: 30),
            child: Column(
              children: [
                Text('Set a reminder'),
                CheckboxListTile(
                  title: Text('Reminder'),
                  value: reminder,
                  onChanged: (bool? value) {
                    setState(() {
                      reminder = value!;
                    });
                  },
                ),
                if (reminder)
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
                if (reminder)
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
                ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () {
                    Navigator.of(context)
                        .pop([reminder, pickedDate, pickedTime]);
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
