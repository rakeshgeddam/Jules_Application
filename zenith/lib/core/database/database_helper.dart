import 'package:hive/hive.dart';

class DatabaseHelper {
  static const String _journalBoxName = 'journal';

  Future<Box> get _journalBox async {
    if (Hive.isBoxOpen(_journalBoxName)) {
      return Hive.box(_journalBoxName);
    } else {
      return await Hive.openBox(_journalBoxName);
    }
  }

  Future<void> saveJournalEntry(String entry) async {
    final box = await _journalBox;
    await box.add(entry);
  }

  Future<List<String>> getJournalEntries() async {
    final box = await _journalBox;
    return box.values.cast<String>().toList();
  }
}
