import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenith/features/calendar/models/event.dart';
import 'package:zenith/features/calendar/providers/calendar_provider.dart';

class EventEditScreen extends StatefulWidget {
  final Event? event;

  EventEditScreen({this.event});

  @override
  _EventEditScreenState createState() => _EventEditScreenState();
}

class _EventEditScreenState extends State<EventEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _startTime;
  late DateTime _endTime;
  late bool _isAllDay;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _title = widget.event!.title;
      _description = widget.event!.description;
      _startTime = widget.event!.startTime;
      _endTime = widget.event!.endTime;
      _isAllDay = widget.event!.isAllDay;
    } else {
      _title = '';
      _description = '';
      _startTime = DateTime.now();
      _endTime = DateTime.now().add(Duration(hours: 1));
      _isAllDay = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event == null ? 'New Event' : 'Edit Event'),
        actions: [
          TextButton(
            child: Text('Save', style: TextStyle(color: Theme.of(context).primaryColor)),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            _buildTextField(
              initialValue: _title,
              labelText: 'Event Title',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              onSaved: (value) => _title = value!,
            ),
            SizedBox(height: 16.0),
            _buildTextField(
              initialValue: _description,
              labelText: 'Description',
              onSaved: (value) => _description = value!,
            ),
            SizedBox(height: 16.0),
            _buildSchedulingSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String initialValue,
    required String labelText,
    FormFieldValidator<String>? validator,
    FormFieldSetter<String>? onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildSchedulingSection() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          SwitchListTile(
            title: Text('All-day'),
            value: _isAllDay,
            onChanged: (value) {
              setState(() {
                _isAllDay = value;
              });
            },
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Starts'),
            trailing: Text('${_startTime.toLocal()}'),
            onTap: () => _selectDateTime(context, isStart: true),
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Ends'),
            trailing: Text('${_endTime.toLocal()}'),
            onTap: () => _selectDateTime(context, isStart: false),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context, {required bool isStart}) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startTime : _endTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(isStart ? _startTime : _endTime),
    );
    if (time == null) return;

    setState(() {
      final newDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      if (isStart) {
        _startTime = newDateTime;
        if (_startTime.isAfter(_endTime)) {
          _endTime = _startTime.add(Duration(hours: 1));
        }
      } else {
        _endTime = newDateTime;
        if (_endTime.isBefore(_startTime)) {
          _startTime = _endTime.subtract(Duration(hours: 1));
        }
      }
    });
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final provider = Provider.of<CalendarProvider>(context, listen: false);
      final newEvent = Event()
        ..title = _title
        ..description = _description
        ..startTime = _startTime
        ..endTime = _endTime
        ..isAllDay = _isAllDay
        ..isRecurring = false // TODO: Implement recurrence
        ..recurrenceRule = ''; // TODO: Implement recurrence

      if (widget.event == null) {
        provider.addEvent(newEvent);
      } else {
        provider.updateEvent(widget.event!.key, newEvent);
      }
      Navigator.pop(context);
    }
  }
}
