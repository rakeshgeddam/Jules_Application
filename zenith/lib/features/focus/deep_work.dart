import 'package:flutter/material.dart';
import 'dart:async';

class DeepWorkScreen extends StatefulWidget {
  final String? taskName;

  const DeepWorkScreen({
    super.key,
    this.taskName,
  });

  @override
  State<DeepWorkScreen> createState() => _DeepWorkScreenState();
}

class _DeepWorkScreenState extends State<DeepWorkScreen> {
  int minutes = 60;
  int seconds = 0;
  Timer? timer;
  bool isRunning = false;
  bool showOverlay = false; // Placeholder for notification/app blocking
  List<String> motivationalMessages = [
    "Stay in the zone!",
    "Ignore distractions!",
    "Your focus is your superpower.",
    "You are making progress.",
    "Deep work leads to greatness!"
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
              Text("Session Complete!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.deepPurple)),
              SizedBox(height: 18),
              Text("How deep was your focus?",
                  style: TextStyle(fontSize: 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (i) {
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color: i < depth ? Colors.deepPurple : Colors.grey[400],
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
                    backgroundColor: Colors.deepPurple),
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

  // Overlay for notification/app blocking: show when 'distraction' detected (stub, connect later)
  Widget buildBlockOverlay() {
    if (!showOverlay) return SizedBox.shrink();
    return Container(
      color: Colors.deepPurple.withOpacity(0.85),
      alignment: Alignment.center,
      child: Text(
        "Distraction Detected! Stay Focused.",
        style:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String timerStr =
        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    return Scaffold(
      appBar: AppBar(
        title: Text("Deep Work"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.block),
            onPressed: () {
              setState(() {
                showOverlay = !showOverlay;
              });
            },
          ),
        ],
        leading: BackButton(),
      ),
      backgroundColor: Colors.deepPurple[50],
      body: Stack(
        children: [
          Center(
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
                      color: Colors.deepPurple[700]),
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
                        backgroundColor: Colors.deepPurple.withOpacity(0.25),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                      ),
                    ),
                    Text(
                      timerStr,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 38,
                          color: Colors.deepPurple[700]),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  motivation,
                  style: TextStyle(
                      color: Colors.deepPurple[700],
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
                      color: Colors.deepPurple[700],
                    ),
                    const SizedBox(width: 42),
                    IconButton(
                      icon: Icon(Icons.refresh, size: 32),
                      onPressed: resetTimer,
                      color: Colors.deepPurple[400],
                    ),
                  ],
                ),
              ],
            ),
          ),
          buildBlockOverlay(),
        ],
      ),
    );
  }
}
