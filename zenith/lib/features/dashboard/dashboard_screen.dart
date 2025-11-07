import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thursday, Oct 26',
                  style: TextStyle(color: Colors.grey),
                ),
                const Text(
                  'Good afternoon, Alex',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Distraction-free time'),
                    const Text(
                      '2h 45m',
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: 0.75,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text('3h goal'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: const [
                          Icon(Icons.local_fire_department, color: Colors.green),
                          Text('12 Days'),
                          Text('Current Streak'),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: const [
                          Icon(Icons.show_chart, color: Colors.blue),
                          Text('3h 15m'),
                          Text('Weekly Average'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Suggestions for you',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildSuggestionCard(Icons.directions_walk, 'Take a 5-min walk', 'Clear your mind'),
                _buildSuggestionCard(Icons.self_improvement, 'Breathing exercise', 'Find your calm'),
                _buildSuggestionCard(Icons.edit_calendar, 'Plan tomorrow\'s focus', 'Set your intention'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(IconData icon, String title, String subtitle) {
    return SizedBox(
      width: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(height: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
