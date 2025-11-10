import 'package:hive/hive.dart';
import 'package:zenith/features/calendar/data/models/event_model.dart';

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 0;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      title: fields[0] as String,
      description: fields[1] as String,
      startTime: fields[2] as DateTime,
      endTime: fields[3] as DateTime,
      isRecurring: fields[4] as bool,
      isAllDay: fields[5] as bool,
      focusMode: fields[6] as String,
      allowedContacts: (fields[7] as List).cast<String>(),
      blockedApps: (fields[8] as List).cast<String>(),
      recurrenceRule: fields[9] as String,
      naturalLanguageNote: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.isRecurring)
      ..writeByte(5)
      ..write(obj.isAllDay)
      ..writeByte(6)
      ..write(obj.focusMode)
      ..writeByte(7)
      ..write(obj.allowedContacts)
      ..writeByte(8)
      ..write(obj.blockedApps)
      ..writeByte(9)
      ..write(obj.recurrenceRule)
      ..writeByte(10)
      ..write(obj.naturalLanguageNote);
  }
}
