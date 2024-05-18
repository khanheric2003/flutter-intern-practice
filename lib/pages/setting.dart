import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
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
