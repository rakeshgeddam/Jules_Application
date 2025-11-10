import 'package:flutter/material.dart';
import 'package:zenith/features/calendar/data/calendar_service.dart';
import 'package:zenith/features/calendar/models/event.dart';

class CalendarProvider extends ChangeNotifier {
  final CalendarService _calendarService;

  DateTime _selectedDate = DateTime.now();
  Map<DateTime, List<Event>> _events = {};

  DateTime get selectedDate => _selectedDate;
  List<Event> get eventsOfSelectedDate {
    final date = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    return _events[date] ?? [];
  }

  Map<DateTime, List<Event>> get events => _events;

  CalendarProvider(this._calendarService) {
    fetchEvents();
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<void> fetchEvents() async {
    final allEvents = await _calendarService.getAllEvents();
    _events = {};
    for (final event in allEvents) {
      final date = DateTime(event.startTime.year, event.startTime.month, event.startTime.day);
      if (_events[date] == null) {
        _events[date] = [];
      }
      _events[date]!.add(event);
    }
    notifyListeners();
  }

  Future<void> addEvent(Event event) async {
    await _calendarService.addEvent(event);
    await fetchEvents();
  }

  Future<void> updateEvent(dynamic key, Event event) async {
    await _calendarService.updateEvent(key, event);
    await fetchEvents();
  }

  Future<void> deleteEvent(dynamic key) async {
    await _calendarService.deleteEvent(key);
    await fetchEvents();
  }
}
