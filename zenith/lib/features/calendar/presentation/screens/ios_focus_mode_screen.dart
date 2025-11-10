import 'package:flutter/material.dart';

class IosFocusModeScreen extends StatelessWidget {
  const IosFocusModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Permissions'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How to Set Up on iOS',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('1. Tap "Open Settings" to go to Focus settings.'),
            SizedBox(height: 8),
            Text('2. Select a Focus Profile (e.g., "Work").'),
            SizedBox(height: 8),
            Text('3. Add a "Schedule" or "Automation" based on this app\'s calendar.'),
          ],
        ),
      ),
    );
  }
}
