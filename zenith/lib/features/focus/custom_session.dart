import 'package:flutter/material.dart';

class CustomSessionScreen extends StatefulWidget {
  final String? taskName;

  const CustomSessionScreen({
    super.key,
    this.taskName,
  });

  @override
  State<CustomSessionScreen> createState() => _CustomSessionScreenState();
}

class _CustomSessionScreenState extends State<CustomSessionScreen> {
  int focusMinutes = 25;
  int breakMinutes = 5;
  int sessionsPerSet = 4;
  String presetName = '';
  List<Map<String, dynamic>> savedPresets = [];

  bool isRunning = false;
  int currentFocus = 0;
  int minutesLeft = 0;
  int secondsLeft = 0;

  @override
  void initState() {
    super.initState();
    resetTimer();
  }

  void resetTimer() {
    setState(() {
      isRunning = false;
      currentFocus = 1;
      minutesLeft = focusMinutes;
      secondsLeft = 0;
    });
  }

  void savePreset() {
    if (presetName.trim().isEmpty) return;
    setState(() {
      savedPresets.add({
        'name': presetName,
        'focus': focusMinutes,
        'break': breakMinutes,
        'sessions': sessionsPerSet,
      });
      presetName = '';
    });
  }

  void loadPreset(Map<String, dynamic> preset) {
    setState(() {
      focusMinutes = preset['focus'];
      breakMinutes = preset['break'];
      sessionsPerSet = preset['sessions'];
      resetTimer();
    });
  }

  void showSaveDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Save Preset"),
          content: TextField(
            decoration: InputDecoration(
              labelText: "Preset Name",
            ),
            onChanged: (val) => presetName = val,
          ),
          actions: [
            TextButton(
              onPressed: () {
                savePreset();
                Navigator.pop(ctx);
              },
              child: Text("Save"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Widget buildPresetRow(Map<String, dynamic> preset) {
    return ListTile(
      title: Text(preset['name']),
      subtitle: Text(
          "Focus: ${preset['focus']}m, Break: ${preset['break']}m, Sessions: ${preset['sessions']}"),
      onTap: () => loadPreset(preset),
      trailing: Icon(Icons.arrow_forward_ios, size: 17),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Session"),
        backgroundColor: Colors.teal,
        leading: BackButton(),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: showSaveDialog,
            tooltip: "Save Current Settings as Preset",
          ),
        ],
      ),
      backgroundColor: Colors.teal[50],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (widget.taskName?.isNotEmpty == true)
              Text(
                widget.taskName!,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.teal[700]),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 18),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Text("Focus Duration: $focusMinutes min",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Slider(
                      value: focusMinutes.toDouble(),
                      min: 10,
                      max: 60,
                      divisions: 10,
                      label: focusMinutes.toString(),
                      onChanged: (val) {
                        setState(() {
                          focusMinutes = val.round();
                          resetTimer();
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    Text("Break Duration: $breakMinutes min",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Slider(
                      value: breakMinutes.toDouble(),
                      min: 2,
                      max: 30,
                      divisions: 14,
                      label: breakMinutes.toString(),
                      onChanged: (val) {
                        setState(() {
                          breakMinutes = val.round();
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    Text("Sessions per Set: $sessionsPerSet",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Slider(
                      value: sessionsPerSet.toDouble(),
                      min: 1,
                      max: 8,
                      divisions: 7,
                      label: sessionsPerSet.toString(),
                      onChanged: (val) {
                        setState(() {
                          sessionsPerSet = val.round();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Text("Saved Presets", style: TextStyle(fontWeight: FontWeight.bold)),
            ...savedPresets.map(buildPresetRow),
            SizedBox(height: 18),
            ElevatedButton(
              onPressed: isRunning ? null : resetTimer,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, shape: StadiumBorder()),
              child: Text('Reset',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            // (Timer logic, play/pause, etc., can be added similarly as above, or request for details!)
          ],
        ),
      ),
    );
  }
}
