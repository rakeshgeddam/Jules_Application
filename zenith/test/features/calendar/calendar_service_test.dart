import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:zenith/features/calendar/data/calendar_service.dart';
import 'package:zenith/features/calendar/models/event.dart';

void main() {
  group('CalendarService', () {
    setUp(() async {
      await setUpTestHive();
      Hive.registerAdapter(EventAdapter());
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    test('addEvent adds an event to the box', () async {
      final service = CalendarService();
      final event = Event()
        ..title = 'Test Event'
        ..description = 'Test Description'
        ..startTime = DateTime.now()
        ..endTime = DateTime.now().add(Duration(hours: 1))
        ..isAllDay = false
        ..isRecurring = false
        ..recurrenceRule = '';

      await service.addEvent(event);

      final events = await service.getAllEvents();
      expect(events.length, 1);
      expect(events.first.title, 'Test Event');
    });

    test('updateEvent updates an event in the box', () async {
      final service = CalendarService();
      final event = Event()
        ..title = 'Test Event'
        ..description = 'Test Description'
        ..startTime = DateTime.now()
        ..endTime = DateTime.now().add(Duration(hours: 1))
        ..isAllDay = false
        ..isRecurring = false
        ..recurrenceRule = '';

      await service.addEvent(event);
      final events = await service.getAllEvents();
      final key = events.first.key;

      final updatedEvent = Event()
        ..title = 'Updated Event'
        ..description = 'Updated Description'
        ..startTime = event.startTime
        ..endTime = event.endTime
        ..isAllDay = event.isAllDay
        ..isRecurring = event.isRecurring
        ..recurrenceRule = event.recurrenceRule;

      await service.updateEvent(key, updatedEvent);

      final updatedEvents = await service.getAllEvents();
      expect(updatedEvents.length, 1);
      expect(updatedEvents.first.title, 'Updated Event');
    });

    test('deleteEvent removes an event from the box', () async {
      final service = CalendarService();
      final event = Event()
        ..title = 'Test Event'
        ..description = 'Test Description'
        ..startTime = DateTime.now()
        ..endTime = DateTime.now().add(Duration(hours: 1))
        ..isAllDay = false
        ..isRecurring = false
        ..recurrenceRule = '';

      await service.addEvent(event);
      final events = await service.getAllEvents();
      final key = events.first.key;

      await service.deleteEvent(key);

      final remainingEvents = await service.getAllEvents();
      expect(remainingEvents.length, 0);
    });
  });
}
