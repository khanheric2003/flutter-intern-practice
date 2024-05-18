import 'package:flutter/material.dart';

class ReminderData extends ChangeNotifier {
  TimeOfDay? pickedTime;
  bool reminder = false;
  Map<String, bool> days = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };

  void updateReminder(bool newReminder) {
    reminder = newReminder;
    notifyListeners();
  }

  void updatePickedTime(TimeOfDay newPickedTime) {
    pickedTime = newPickedTime;
    notifyListeners();
  }

  void updateDays(Map<String, bool> newDays) {
    days = newDays;
    notifyListeners();
  }
}
