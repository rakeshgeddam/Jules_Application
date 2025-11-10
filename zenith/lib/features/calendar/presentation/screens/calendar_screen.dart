import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:zenith/features/calendar/data/event_repository.dart';
import 'package:zenith/features/calendar/data/models/event_model.dart';
import 'package:zenith/features/calendar/presentation/screens/event_editor_screen.dart';
import 'package:intl/intl.dart';

// Design-inspired Color Palette
const Color primaryColor = Color(0xFF4A80F0);
const Color darkBackgroundColor = Color(0xFF121212);
const Color lightBackgroundColor = Color(0xFFFDFDFD);
const Color darkSurfaceColor = Color(0xFF1E1E1E);
const Color lightSurfaceColor = Color(0xFFFDFDFD);
const Color darkOnSurfaceColor = Color(0xFFE4E4E6);
const Color lightOnSurfaceColor = Color(0xFF1C1C1E);
const Color darkOnSurfaceVariantColor = Color(0xFF98989A);
const Color lightOnSurfaceVariantColor = Color(0xFF747476);
const Color greenEventColor = Color(0xFF34C759);
const Color purpleEventColor = Color(0xFFAF52DE);

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
  Map<DateTime, List<Event>> _eventsByDay = {};

  final Map<String, IconData> _focusModeIcons = {
    'Full Do Not Disturb': Icons.dark_mode,
    'Allow Contacts Only': Icons.group,
    'Work': Icons.work,
    'Personal': Icons.person,
  };

  final Map<String, Color> _focusModeColors = {
    'Full Do Not Disturb': purpleEventColor,
    'Allow Contacts Only': Colors.blue,
    'Work': greenEventColor,
    'Personal': primaryColor,
  };


  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final events = await _eventRepository.getEvents();
    setState(() {
      _eventsByDay = {};
      for (final event in events) {
        final day = DateTime.utc(event.startTime.year, event.startTime.month, event.startTime.day);
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? darkBackgroundColor : lightBackgroundColor;
    final surfaceColor = isDarkMode ? darkSurfaceColor : lightSurfaceColor;
    final onSurfaceColor = isDarkMode ? darkOnSurfaceColor : lightOnSurfaceColor;
    final onSurfaceVariantColor = isDarkMode ? darkOnSurfaceVariantColor : lightOnSurfaceVariantColor;
    final selectedEvents = _getEventsForDay(_selectedDay!);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: GestureDetector(
          onTap: () { /* Handle month/year picking */ },
          child: Row(
            children: [
              Text(
                DateFormat('MMMM').format(_focusedDay),
                style: TextStyle(
                  color: onSurfaceColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Icon(Icons.expand_more, color: onSurfaceVariantColor),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: onSurfaceVariantColor),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBgmm8FtMnifLexUCud3wc9AW5o6O9m2x8WUEDZLyhSk7U3GjnGq2CiS7WiplJuOyCeeU3xNbA2vItKoCacyzH1J5EfqLblFF-JXH-V7JoVN8N0uIbx7oKRS1ARPlkGSByfIjFIBBAUbbFieMGNh-FQQAOG8tKivKRAd8IhjjXu-fqQcA3mcCFJAture6LYYII0o_nqkAr8qWjH6pgG-Fe8gSW4yLO5ojLg8FEGok_Al7SJxeVlvpWn_sEi4ue8DfLa_WPbg7SwrTE'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar View
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
            headerStyle: const HeaderStyle(
              titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              titleCentered: true,
              formatButtonVisible: false,
              leftChevronVisible: false,
              rightChevronVisible: false,
            ),
            calendarStyle: CalendarStyle(
              defaultTextStyle: TextStyle(color: onSurfaceColor),
              weekendTextStyle: TextStyle(color: onSurfaceColor),
              outsideTextStyle: TextStyle(color: onSurfaceVariantColor.withOpacity(0.5)),
              todayDecoration: BoxDecoration(
                color: primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
            ),
             calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: _buildEventsMarker(date, events),
                  );
                }
                return null;
              },
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: onSurfaceVariantColor, fontWeight: FontWeight.bold, fontSize: 12),
              weekendStyle: TextStyle(color: onSurfaceVariantColor, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),

          // Event List
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    DateFormat('EEEE, d').format(_selectedDay!),
                    style: TextStyle(
                      color: onSurfaceColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (selectedEvents.isEmpty)
                    const Center(child: Text('No events for today'))
                  else
                    ...selectedEvents.asMap().entries.map((entry) {
                      final index = entry.key;
                      final event = entry.value;
                      return _buildEventTile(event, isDarkMode, index);
                    }),
                ],
              ),
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
                onDelete: () {},
              ),
            ),
          );
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: primaryColor,
      ),
      width: 6.0,
      height: 6.0,
    );
  }

  Widget _buildEventTile(Event event, bool isDarkMode, int index) {
    Color eventColor = _focusModeColors[event.focusMode] ?? greenEventColor;
    IconData iconData = _focusModeIcons[event.focusMode] ?? Icons.event;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventEditorScreen(
              event: event,
              onSave: (updatedEvent) {
                _eventRepository.updateEvent(index, updatedEvent);
                _loadEvents();
              },
              onDelete: () {
                _eventRepository.deleteEvent(index);
                _loadEvents();
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: eventColor.withOpacity(isDarkMode ? 0.2 : 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: eventColor,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${DateFormat.jm().format(event.startTime)} - ${DateFormat.jm().format(event.endTime)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
