import 'package:flutter/material.dart';

enum ReminderFrequency { daily, weekly, none }

Future<List?> setReminder(BuildContext context) async {
  DateTime? pickedDate;
  TimeOfDay? pickedTime;
  ReminderFrequency reminderFrequency = ReminderFrequency.none;

  return Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set a reminder'),
      ),
      body: StatefulBuilder(
        builder: (context, setState) {
          return Padding(
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
                  child: ElevatedButton(
                    child: const Text('Save'),
                    onPressed: () {
                      Navigator.of(context)
                          .pop([pickedDate, pickedTime, reminderFrequency]);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }));
}
