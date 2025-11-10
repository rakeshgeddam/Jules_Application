import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:zenith/features/calendar/data/calendar_service.dart';
import 'package:zenith/features/calendar/models/event.dart';
import 'package:zenith/features/calendar/providers/calendar_provider.dart';

import 'calendar_provider_test.mocks.dart';

@GenerateMocks([CalendarService])
void main() {
  group('CalendarProvider', () {
    late CalendarProvider calendarProvider;
    late MockCalendarService mockCalendarService;

    setUp(() {
      mockCalendarService = MockCalendarService();
      calendarProvider = CalendarProvider(mockCalendarService);
    });

    test('selectDate updates the selected date', () {
      final newDate = DateTime(2024, 1, 1);
      calendarProvider.selectDate(newDate);
      expect(calendarProvider.selectedDate, newDate);
    });

    test('fetchEvents updates the events map', () async {
      final event = Event()
        ..title = 'Test Event'
        ..description = 'Test Description'
        ..startTime = DateTime(2024, 1, 1)
        ..endTime = DateTime(2024, 1, 1).add(Duration(hours: 1))
        ..isAllDay = false
        ..isRecurring = false
        ..recurrenceRule = '';
      when(mockCalendarService.getAllEvents()).thenAnswer((_) async => [event]);

      await calendarProvider.fetchEvents();

      final date = DateTime(event.startTime.year, event.startTime.month, event.startTime.day);
      expect(calendarProvider.events[date], isNotNull);
      expect(calendarProvider.events[date]!.length, 1);
      expect(calendarProvider.events[date]!.first.title, 'Test Event');
    });
  });
}
