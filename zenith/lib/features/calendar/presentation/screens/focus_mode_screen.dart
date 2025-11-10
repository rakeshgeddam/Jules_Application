import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zenith/features/calendar/data/focus_mode_service.dart';

class FocusModeScreen extends StatefulWidget {
  const FocusModeScreen({super.key});

  @override
  State<FocusModeScreen> createState() => _FocusModeScreenState();
}

class _FocusModeScreenState extends State<FocusModeScreen> {
  final FocusModeService _focusModeService = FocusModeService();
  List<String> _focusModes = [];

  @override
  void initState() {
    super.initState();
    _loadFocusModes();
  }

  Future<void> _loadFocusModes() async {
    final modes = await _focusModeService.getFocusModes();
    setState(() {
      _focusModes = modes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Focus'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _focusModes.length,
              itemBuilder: (context, index) {
                final mode = _focusModes[index];
                return ListTile(
                  title: Text(mode),
                  onTap: () {
                    Navigator.pop(context, mode);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                final status = await Permission.notification.request();
                if (status.isDenied) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Permission Denied'),
                      content: const Text(
                          'To use focus modes, you need to grant notification access.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Enable Focus Mode Access'),
            ),
          ),
        ],
      ),
    );
  }
}
