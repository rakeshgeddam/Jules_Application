import 'package:flutter/material.dart';
import 'dart:async';

class PomodoroTimerScreen extends StatefulWidget {
  final String? taskName;
  final int initialMinutes; // User-customizable

  const PomodoroTimerScreen({
    super.key,
    this.taskName,
    this.initialMinutes = 25,
  });

  @override
  State<PomodoroTimerScreen> createState() => _PomodoroTimerScreenState();
}

class _PomodoroTimerScreenState extends State<PomodoroTimerScreen> {
  int minutes = 25;
  int seconds = 0;
  Timer? timer;
  bool isRunning = false;
  int completedSessions = 0;
  final int sessionsUntilBreak = 4; // You can make customizable
  String phase = "Work"; // "Work" or "Break"
  List<String> encouragementMessages = [
    "Keep Going!",
    "You're crushing it!",
    "Stay focused!",
    "You can do it!",
    "Almost there!"
  ];

  @override
  void initState() {
    super.initState();
    minutes = widget.initialMinutes;
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

  void _onTimerDone() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      if (phase == "Work") {
        completedSessions++;
        if (completedSessions % sessionsUntilBreak == 0) {
          phase = "Long Break";
          minutes = 15; // customizable long break
        } else {
          phase = "Short Break";
          minutes = 5; // customizable short break
        }
        seconds = 0;
      } else {
        phase = "Work";
        minutes = widget.initialMinutes;
        seconds = 0;
      }
      // Play gentle alarm sound (implementation later)
      // Show encouragement message (cycle through)
    });
    // You can show a modal or snackBar here!
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
      phase = "Work";
      minutes = widget.initialMinutes;
      seconds = 0;
      completedSessions = 0;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget buildSessionDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(sessionsUntilBreak, (index) {
        bool filled = index < completedSessions % sessionsUntilBreak;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: CircleAvatar(
            radius: 8,
            backgroundColor:
                filled ? Colors.redAccent : Colors.redAccent.withOpacity(0.3),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    String timerStr =
        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        title: Text("Pomodoro timer"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // TODO: open settings/configuration for durations
            },
          ),
        ],
        leading: BackButton(),
        elevation: 0,
        backgroundColor: Colors.redAccent,
      ),
      backgroundColor: Colors.red[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.taskName?.isNotEmpty == true
                  ? widget.taskName!
                  : "No Task Selected",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.redAccent),
            ),
            const SizedBox(height: 30),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: (minutes * 60 + seconds) /
                        (widget.initialMinutes * 60),
                    strokeWidth: 10,
                    backgroundColor: Colors.redAccent.withOpacity(0.2),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.redAccent),
                  ),
                ),
                Text(
                  timerStr,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 38,
                      color: Colors.redAccent),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              '$phase',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.redAccent),
            ),
            const SizedBox(height: 14),
            buildSessionDots(),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    isRunning ? Icons.pause : Icons.play_arrow,
                    size: 44,
                  ),
                  onPressed: isRunning ? pauseTimer : startTimer,
                  color: Colors.redAccent[700],
                ),
                const SizedBox(width: 40),
                IconButton(
                  icon: Icon(Icons.refresh, size: 32),
                  onPressed: resetTimer,
                  color: Colors.redAccent[400],
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              encouragementMessages[completedSessions %
                  encouragementMessages.length],
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.redAccent[700],
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
