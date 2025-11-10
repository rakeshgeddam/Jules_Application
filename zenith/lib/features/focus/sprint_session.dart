import 'package:flutter/material.dart';
import 'dart:async';

class SprintSessionScreen extends StatefulWidget {
  final String? taskName;

  const SprintSessionScreen({
    super.key,
    this.taskName,
  });

  @override
  State<SprintSessionScreen> createState() => _SprintSessionScreenState();
}

class _SprintSessionScreenState extends State<SprintSessionScreen> {
  int selectedDuration = 15;
  int minutes = 15;
  int seconds = 0;
  Timer? timer;
  bool isRunning = false;
  List<String> motivationalMessages = [
    "Full speed ahead!",
    "Push your limits!",
    "Sprint to victory!",
    "Stay sharp and intense!",
    "Your energy fuels results!"
  ];

  String get motivation =>
      motivationalMessages[minutes % motivationalMessages.length];

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      isRunning = true;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (seconds == 0 && minutes == 0) {
          _onTimerDone();
        } else if (seconds == 0) {
          minutes--;
          seconds = 59;
        } else {
          seconds--;
        }
      });
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      minutes = selectedDuration;
      seconds = 0;
    });
  }

  void _onTimerDone() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
    // Sprint session over: show completion message, etc.
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Sprint session complete!"),
        content: Text("Great job staying aggressive and focused!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("OK", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget buildDurationSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [15, 30].map((duration) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ChoiceChip(
            label: Text("${duration} min",
                style: TextStyle(
                    color: selectedDuration == duration
                        ? Colors.white
                        : Colors.red,
                    fontWeight: FontWeight.bold)),
            selected: selectedDuration == duration,
            selectedColor: Colors.red[700],
            backgroundColor: Colors.red[100],
            onSelected: (val) {
              setState(() {
                selectedDuration = duration;
                minutes = duration;
                seconds = 0;
                isRunning = false;
                timer?.cancel();
              });
            },
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    String timerStr =
        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    return Scaffold(
      appBar: AppBar(
        title: Text("Sprint Session"),
        backgroundColor: Colors.red,
        leading: BackButton(),
      ),
      backgroundColor: Colors.red[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Choose duration (no breaks):",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.red[700]),
            ),
            const SizedBox(height: 12),
            buildDurationSelector(),
            const SizedBox(height: 18),
            Text(
              widget.taskName?.isNotEmpty == true
                  ? widget.taskName!
                  : "No Task Selected",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.red[700]),
            ),
            const SizedBox(height: 28),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: (minutes * 60 + seconds) / (selectedDuration * 60),
                    strokeWidth: 11,
                    backgroundColor: Colors.redAccent.withOpacity(0.21),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.redAccent),
                  ),
                ),
                Text(
                  timerStr,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 38,
                      color: Colors.red[700]),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              motivation,
              style: TextStyle(
                  color: Colors.red[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    isRunning ? Icons.pause : Icons.play_arrow,
                    size: 44,
                  ),
                  onPressed: isRunning ? pauseTimer : startTimer,
                  color: Colors.red[700],
                ),
                const SizedBox(width: 38),
                IconButton(
                  icon: Icon(Icons.refresh, size: 32),
                  onPressed: resetTimer,
                  color: Colors.red[400],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
