import 'package:hive/hive.dart';

part 'journal_entry.g.dart';

@HiveType(typeId: 1)
class JournalEntry extends HiveObject {
  @HiveField(0)
  String content;

  @HiveField(1)
  DateTime createdAt;

  JournalEntry({
    required this.content,
    required this.createdAt,
  });
}
