import 'package:flutter/material.dart';
import 'package:zenith/features/calendar/data/models/event_model.dart';
import 'dart:io' show Platform;
import 'package:zenith/features/calendar/presentation/screens/focus_mode_screen.dart';
import 'package:zenith/features/calendar/presentation/screens/ios_focus_mode_screen.dart';
import 'package:zenith/features/calendar/data/focus_mode_service.dart';

// Design-inspired Color Palette (re-using from calendar screen)
const Color primaryColor = Color(0xFF135bec);
const Color darkBackgroundColor = Color(0xFF101622);
const Color lightBackgroundColor = Color(0xFFf6f6f8);
const Color darkCardColor = Color(0xFF1C1C1E);
const Color lightCardColor = Color(0xFFFFFFFF);
const Color destructiveColor = Color(0xFFFF3B30);

class EventEditorScreen extends StatefulWidget {
  final Function(Event) onSave;
  final Function() onDelete;
  final Event? event;

  const EventEditorScreen({
    super.key,
    required this.onSave,
    required this.onDelete,
    this.event,
  });

  @override
  State<EventEditorScreen> createState() => _EventEditorScreenState();
}

class _EventEditorScreenState extends State<EventEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late DateTime _startTime;
  late DateTime _endTime;
  late bool _isAllDay;
  late String _selectedFocusMode;
  final FocusModeService _focusModeService = FocusModeService();

  @override
  void initState() {
    super.initState();
    final event = widget.event;
    _titleController = TextEditingController(text: event?.title);
    _locationController = TextEditingController(); // Assuming location is not in model yet
    _startTime = event?.startTime ?? DateTime.now();
    _endTime = event?.endTime ?? DateTime.now().add(const Duration(hours: 1));
    _isAllDay = event?.isAllDay ?? false;
    _selectedFocusMode = event?.focusMode ?? 'Work'; // Default to 'Work' as in design
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? darkBackgroundColor : lightBackgroundColor;
    final cardColor = isDarkMode ? darkCardColor : lightCardColor;
    final onSurfaceColor = isDarkMode ? Colors.white : Colors.black;
    final onSurfaceVariantColor = isDarkMode ? Colors.white60 : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurfaceColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.event == null ? 'New Event' : 'Edit Event',
          style: TextStyle(
            color: onSurfaceColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final newEvent = Event(
                  title: _titleController.text,
                  description: '', // Not in the UI
                  startTime: _startTime,
                  endTime: _endTime,
                  isRecurring: false,
                  isAllDay: _isAllDay,
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
            child: const Text('Save', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Event Details Section
              _buildCard(
                cardColor,
                [
                  _buildTextField(_titleController, 'Event Title', 'e.g., Team Meeting', onSurfaceColor, onSurfaceVariantColor),
                  _buildDivider(isDarkMode),
                  _buildTextField(_locationController, 'Location (optional)', 'Add a location', onSurfaceColor, onSurfaceVariantColor),
                ],
              ),
              const SizedBox(height: 16),
              // Scheduling Section
              _buildCard(
                cardColor,
                [
                  _buildSwitchRow('All-day', _isAllDay, (value) => setState(() => _isAllDay = value), onSurfaceColor),
                  _buildDivider(isDarkMode),
                  GestureDetector(
                    onTap: _selectStartTime,
                    child: _buildDateTimeRow('Starts', _startTime, onSurfaceColor, onSurfaceVariantColor),
                  ),
                  _buildDivider(isDarkMode),
                  GestureDetector(
                    onTap: _selectEndTime,
                    child: _buildDateTimeRow('Ends', _endTime, onSurfaceColor, onSurfaceVariantColor),
                  ),
                  _buildDivider(isDarkMode),
                  _buildNavigationRow('Repeat', 'Never', onSurfaceColor, onSurfaceVariantColor),
                ],
              ),
              const SizedBox(height: 16),
              // Customization Section
              _buildCard(
                cardColor,
                [
                  GestureDetector(
                    onTap: () async {
                      if(Platform.isIOS && !await _focusModeService.isNotificationPermissionGranted) {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => const IosFocusModeScreen()));
                         return;
                      }

                      final selectedMode = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(builder: (context) => const FocusModeScreen()),
                      );
                      if (selectedMode != null) {
                        setState(() {
                          _selectedFocusMode = selectedMode;
                        });
                      }
                    },
                    child: _buildNavigationRow('Focus Profile', _selectedFocusMode, onSurfaceColor, onSurfaceVariantColor)
                  ),
                  _buildDivider(isDarkMode),
                  _buildNavigationRow('Alert', '15 min before', onSurfaceColor, onSurfaceVariantColor),
                ],
              ),
              const SizedBox(height: 16),
              // Delete Button
              if (widget.event != null)
                _buildCard(
                  cardColor,
                  [
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          widget.onDelete();
                          Navigator.pop(context);
                        },
                        child: const Text('Delete Event', style: TextStyle(color: destructiveColor, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(Color cardColor, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String placeholder, Color textColor, Color placeholderColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: placeholderColor, fontSize: 12)),
          TextFormField(
            controller: controller,
            style: TextStyle(color: textColor, fontSize: 16),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(color: placeholderColor.withOpacity(0.5)),
              border: InputBorder.none,
            ),
             validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDarkMode) => Divider(height: 1, color: isDarkMode ? Colors.white12 : Colors.black12, indent: 16, endIndent: 16,);

  Widget _buildSwitchRow(String title, bool value, ValueChanged<bool> onChanged, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: textColor, fontSize: 16)),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeRow(String title, DateTime dateTime, Color textColor, Color variantColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: textColor, fontSize: 16)),
          Text('${MaterialLocalizations.of(context).formatShortDate(dateTime)}, ${TimeOfDay.fromDateTime(dateTime).format(context)}', style: TextStyle(color: variantColor, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildNavigationRow(String title, String value, Color textColor, Color variantColor) {
     return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: textColor, fontSize: 16)),
          Row(
            children: [
              Text(value, style: TextStyle(color: variantColor, fontSize: 14)),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, size: 14, color: variantColor),
            ],
          )
        ],
      ),
    );
  }
}
