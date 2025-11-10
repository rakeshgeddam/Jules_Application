import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:zenith/features/calendar/models/event.dart';
import 'package:zenith/features/calendar/providers/calendar_provider.dart';
import 'package:zenith/features/calendar/screens/event_edit_screen.dart';
import 'package:zenith/features/calendar/screens/event_details_screen.dart';
import 'package:zenith/features/calendar/widgets/event_list_item.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalendarProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat.yMMMM().format(_focusedDay)),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(provider),
          _buildCalendar(provider),
          const SizedBox(height: 8.0),
          _buildEventList(provider),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventEditScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader(CalendarProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SegmentedButton<CalendarFormat>(
            segments: [
              ButtonSegment(value: CalendarFormat.month, label: Text('Month')),
              ButtonSegment(value: CalendarFormat.week, label: Text('Week')),
            ],
            selected: {_calendarFormat},
            onSelectionChanged: (Set<CalendarFormat> newSelection) {
              setState(() {
                _calendarFormat = newSelection.first;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(CalendarProvider provider) {
    return TableCalendar<Event>(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(provider.selectedDate, day),
      onDaySelected: (selectedDay, focusedDay) {
        provider.selectDate(selectedDay);
        setState(() {
          _focusedDay = focusedDay;
        });
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
      eventLoader: (day) {
        final date = DateTime(day.year, day.month, day.day);
        return provider.events[date] ?? [];
      },
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: Theme.of(context).textTheme.headline6!,
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        markerDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildEventList(CalendarProvider provider) {
    final events = provider.eventsOfSelectedDate;
    if (events.isEmpty) {
      return Center(
        child: Text(
          "No events for today",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return Expanded(
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return EventListItem(
            event: event,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailsScreen(event: event),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
