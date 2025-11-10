import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:zenith/features/calendar/data/event_repository.dart';
import 'package:zenith/features/calendar/data/models/event_model.dart';
import 'package:zenith/features/calendar/presentation/screens/event_editor_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final EventRepository _eventRepository = EventRepository();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Event> _events = [];
  Map<DateTime, List<Event>> _eventsByDay = {};

  final Map<String, IconData> _focusModeIcons = {
    'Full Do Not Disturb': Icons.dark_mode,
    'Allow Contacts Only': Icons.group,
    'Work': Icons.work,
    'Personal': Icons.person,
  };

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final events = await _eventRepository.getEvents();
    setState(() {
      _events = events;
      _eventsByDay = {};
      for (final event in events) {
        final day = DateTime.utc(
            event.startTime.year, event.startTime.month, event.startTime.day);
        if (_eventsByDay[day] == null) {
          _eventsByDay[day] = [];
        }
        _eventsByDay[day]!.add(event);
      }
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _eventsByDay[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              '${_focusedDay.month}, ${_focusedDay.year}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.expand_more),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                final icon = _focusModeIcons[event.focusMode];
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text(event.description),
                  trailing: icon != null ? Icon(icon) : null,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventEditorScreen(
                onSave: (newEvent) {
                  _eventRepository.addEvent(newEvent);
                  _loadEvents();
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
