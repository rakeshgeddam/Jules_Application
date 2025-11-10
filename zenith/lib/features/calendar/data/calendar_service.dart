import 'package:hive/hive.dart';
import 'package:zenith/features/calendar/models/event.dart';

class CalendarService {
  static const String _boxName = 'events';

  Future<Box<Event>> _getBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<Event>(_boxName);
    }
    return await Hive.openBox<Event>(_boxName);
  }

  Future<void> addEvent(Event event) async {
    final box = await _getBox();
    await box.add(event);
  }

  Future<void> updateEvent(dynamic key, Event event) async {
    final box = await _getBox();
    await box.put(key, event);
  }

  Future<void> deleteEvent(dynamic key) async {
    final box = await _getBox();
    await box.delete(key);
  }

  Future<List<Event>> getEventsForDate(DateTime date) async {
    final box = await _getBox();
    return box.values
        .where((event) =>
            event.startTime.year == date.year &&
            event.startTime.month == date.month &&
            event.startTime.day == date.day)
        .toList();
  }

  Future<List<Event>> getAllEvents() async {
    final box = await _getBox();
    return box.values.toList();
  }
}
