import 'package:flutter/material.dart';
import 'package:zenith/features/focus/pomodoro.dart';
import 'deep_work.dart';
import 'flow_state.dart';
import 'sprint_session.dart';
import 'custom_session.dart';

// Placeholder for navigation, replace with actual mode screen widgets
void navigateToMode(BuildContext context, String mode, String task) {
  if (mode == "Pomodoro") {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PomodoroTimerScreen(
                  taskName: task,
                )));
  }
  else if (mode == "Deep Work") {
    Navigator.push(
      context,
       MaterialPageRoute(builder: (_) => DeepWorkScreen(
      taskName: task,)));
  }
  else if(mode == "Flow State") {
    Navigator.push(
      context,
       MaterialPageRoute(builder: (_) => FlowStateScreen(
      taskName: task,))); 
  }
  else if(mode == "Sprint Session") {
    Navigator.push(
      context,
       MaterialPageRoute(builder: (_) => SprintSessionScreen(
      taskName: task,)));
  }
  else if(mode == "Custom Session") {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CustomSessionScreen(
      taskName: task,)));
  }
   else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigate to $mode mode (implement screen)')),
    );
  }
}

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  final TextEditingController _taskController = TextEditingController();
  int _selectedPriority = 1;

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Widget buildPrioritySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        int num = index + 1;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedPriority = num;
              });
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: _selectedPriority == num
                  ? Colors.deepPurple
                  : Colors.deepPurple.withOpacity(0.3),
              child: Text(
                '$num',
                style: TextStyle(
                  color:
                      _selectedPriority == num ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildFocusCard(
      {required IconData icon,
      required String title,
      required Color color,
      required String mode}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: color.withOpacity(0.13),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 14),
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 17)),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () {
              navigateToMode(context, mode, _taskController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: const StadiumBorder(),
            ),
            child: const Text('Activate',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Priorities'),
        elevation: 0,
        // Profile icon could be added here
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            TextFormField(
              controller: _taskController,
              decoration: InputDecoration(
                hintText: 'Enter your task/focus item...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14)),
                filled: true,
                fillColor: Colors.grey[100],
                prefixIcon: const Icon(Icons.edit),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 18),
            const Text('Select Priority:',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 10),
            buildPrioritySelector(),
            const SizedBox(height: 18),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 18,
                children: [
                  buildFocusCard(
                      icon: Icons.timer,
                      title: 'Pomodoro',
                      color: Colors.redAccent,
                      mode: "Pomodoro"),
                  buildFocusCard(
                      icon: Icons.lightbulb,
                      title: 'Deep Work',
                      color: Colors.deepPurple,
                      mode: "Deep Work"),
                  buildFocusCard(
                      icon: Icons.auto_awesome,
                      title: 'Flow State',
                      color: Colors.orangeAccent,
                      mode: "Flow State"),
                  buildFocusCard(
                      icon: Icons.directions_run,
                      title: 'Sprint Session',
                      color: Colors.blueAccent,
                      mode: "Sprint Session"),
                  buildFocusCard(
                      icon: Icons.add_circle,
                      title: 'Custom Session',
                      color: Colors.teal,
                      mode: "Custom Session"),
                ],
              ),
            ),
            // You could place a motivational quote/snippet here if desired
            // Text("You can do it! 💪", style: TextStyle(color: Colors.deepPurple, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
