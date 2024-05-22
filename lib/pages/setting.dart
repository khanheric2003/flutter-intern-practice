import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: const <Widget>[
          ListTile(
            title: Text('Language'),
            // TODO: Implement language setting
          ),
          ListTile(
            title: Text('Dark Mode'),
            // TODO: Implement dark mode setting
          ),
          ListTile(
            title: Text('Notification Settings'),
            // TODO: Implement notification settings
          ),
        ],
      ),
    );
  }
}
