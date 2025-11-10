import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zenith/features/calendar/models/event.dart';
import 'package:zenith/features/calendar/providers/calendar_provider.dart';
import 'package:zenith/features/calendar/screens/event_edit_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  EventDetailsScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
        actions: [
          TextButton(
            child: Text('Edit', style: TextStyle(color: Theme.of(context).primaryColor)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventEditScreen(event: event),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            event.title,
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(height: 24.0),
          _buildDetailRow(context, Icons.calendar_today, 'Date', '${DateFormat.yMMMd().format(event.startTime)}'),
          _buildDetailRow(context, Icons.access_time, 'Time', '${DateFormat.jm().format(event.startTime)} - ${DateFormat.jm().format(event.endTime)}'),
          SizedBox(height: 16.0),
          if (event.description.isNotEmpty)
            _buildDetailRow(context, Icons.description, 'Description', event.description),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextButton(
          child: Text('Delete Event', style: TextStyle(color: Colors.red)),
          onPressed: () => _deleteEvent(context),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodyText2),
              SizedBox(height: 4.0),
              Text(subtitle, style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ],
      ),
    );
  }

  void _deleteEvent(BuildContext context) {
    final provider = Provider.of<CalendarProvider>(context, listen: false);
    provider.deleteEvent(event.key);
    Navigator.pop(context);
  }
}
