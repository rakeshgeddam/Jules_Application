import 'package:flutter/material.dart';
import 'package:zenith/features/calendar/data/models/event_model.dart';
import 'package:zenith/features/calendar/data/focus_mode_service.dart';
import 'package:zenith/features/calendar/presentation/screens/focus_mode_screen.dart';
import 'package:zenith/features/calendar/presentation/screens/ios_focus_mode_screen.dart';
import 'dart:io' show Platform;

class EventEditorScreen extends StatefulWidget {
  final Function(Event) onSave;

  const EventEditorScreen({
    super.key,
    required this.onSave,
  });

  @override
  State<EventEditorScreen> createState() => _EventEditorScreenState();
}

class _EventEditorScreenState extends State<EventEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedFocusMode = 'No Profile (Default)';
  final FocusModeService _focusModeService = FocusModeService();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(hours: 1));

  Future<void> _selectStartTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_startTime),
      );
      if (time != null) {
        setState(() {
          _startTime =
              DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  Future<void> _selectEndTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_endTime),
      );
      if (time != null) {
        setState(() {
          _endTime =
              DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Event'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final newEvent = Event(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  startTime: _startTime,
                  endTime: _endTime,
                  isRecurring: false,
                  isAllDay: false,
                  focusMode: _selectedFocusMode,
                  allowedContacts: [],
                  blockedApps: [],
                  recurrenceRule: '',
                  naturalLanguageNote: '',
                );
                widget.onSave(newEvent);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Text('Start Time: $_startTime'),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectStartTime,
                  ),
                ],
              ),
              Row(
                children: [
                  Text('End Time: $_endTime'),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectEndTime,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text('Focus Mode: $_selectedFocusMode'),
              const SizedBox(height: 16.0),
              if (Platform.isAndroid)
                ElevatedButton(
                  onPressed: () async {
                    final selectedMode = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FocusModeScreen(),
                      ),
                    );
                    if (selectedMode != null) {
                      setState(() {
                        _selectedFocusMode = selectedMode;
                      });
                    }
                  },
                  child: const Text('Set Focus Mode'),
                ),
              if (Platform.isIOS)
                ElevatedButton(
                  onPressed: () async {
                    if (await _focusModeService.isNotificationPermissionGranted) {
                      final selectedMode = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FocusModeScreen(),
                        ),
                      );
                      if (selectedMode != null) {
                        setState(() {
                          _selectedFocusMode = selectedMode;
                        });
                      }
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IosFocusModeScreen(),
                        ),
                      );
                    }
                  },
                  child: const Text('Set Focus Mode'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
