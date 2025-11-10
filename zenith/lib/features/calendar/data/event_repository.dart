import 'package:hive/hive.dart';
import 'package:zenith/features/calendar/data/models/event_model.dart';

class EventRepository {
  static const String _boxName = 'events';

  Future<void> addEvent(Event event) async {
    final box = await Hive.openBox<Event>(_boxName);
    await box.add(event);
  }

  Future<List<Event>> getEvents() async {
    final box = await Hive.openBox<Event>(_boxName);
    return box.values.toList();
  }

  Future<void> updateEvent(int index, Event event) async {
    final box = await Hive.openBox<Event>(_boxName);
    await box.putAt(index, event);
  }

  Future<void> deleteEvent(int index) async {
    final box = await Hive.openBox<Event>(_boxName);
    await box.deleteAt(index);
  }
}
