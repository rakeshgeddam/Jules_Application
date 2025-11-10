import 'package:flutter/material.dart';
import 'dart:async';

class FlowStateScreen extends StatefulWidget {
  final String? taskName;

  const FlowStateScreen({
    super.key,
    this.taskName,
  });

  @override
  State<FlowStateScreen> createState() => _FlowStateScreenState();
}

class _FlowStateScreenState extends State<FlowStateScreen> {
  int minutes = 60;
  int seconds = 0;
  Timer? timer;
  bool isRunning = false;
  List<String> motivationalMessages = [
    "Embrace the flow!",
    "You are in the zone!",
    "Let creativity lead!",
    "Ride the wave of focus!",
    "Deep focus, deep progress!"
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
      minutes = 60;
      seconds = 0;
    });
  }

  void _onTimerDone() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
    showSessionEndModal();
  }

  void showSessionEndModal() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (ctx) {
        int depth = 3;
        TextEditingController notesController = TextEditingController();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Flow State Session Complete!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.orange)),
              SizedBox(height: 18),
              Text("How deep was your flow?",
                  style: TextStyle(fontSize: 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (i) {
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color: i < depth ? Colors.orange : Colors.grey[400],
                    ),
                    onPressed: () {
                      depth = i + 1;
                      setState(() {});
                    },
                  );
                }),
              ),
              TextField(
                controller: notesController,
                decoration: InputDecoration(
                  hintText: "Notes or suggestions...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange),
                onPressed: () {
                  Navigator.pop(ctx);
                  // Save rating and notes to Hive here if needed
                },
                child: Text("Done", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String timerStr =
        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    return Scaffold(
      appBar: AppBar(
        title: Text("Flow State"),
        backgroundColor: Colors.orange,
        leading: BackButton(),
      ),
      backgroundColor: Colors.orange[50],
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
                  color: Colors.orange[900]),
            ),
            const SizedBox(height: 30),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: (minutes * 60 + seconds) / (60 * 60),
                    strokeWidth: 10,
                    backgroundColor: Colors.orange.withOpacity(0.25),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                ),
                Text(
                  timerStr,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 38,
                      color: Colors.orange[900]),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              motivation,
              style: TextStyle(
                  color: Colors.orange[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
              textAlign: TextAlign.center,
            ),
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
                  color: Colors.orange[700],
                ),
                const SizedBox(width: 42),
                IconButton(
                  icon: Icon(Icons.refresh, size: 32),
                  onPressed: resetTimer,
                  color: Colors.orange[400],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
