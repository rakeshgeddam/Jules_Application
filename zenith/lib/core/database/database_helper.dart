import 'package:hive_flutter/hive_flutter.dart';
import 'package:zenith/models/models.dart';

class DatabaseHelper {
  static Future<void> init() async {
    await Hive.initFlutter();
    _registerAdapters();
    await _openBoxes();
  }

  static void _registerAdapters() {
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(JournalEntryAdapter());
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(SessionAdapter());
  }

  static Future<void> _openBoxes() async {
    await Hive.openBox<Task>('tasks');
    await Hive.openBox<JournalEntry>('journal_entries');
    await Hive.openBox<UserProfile>('user_profile');
    await Hive.openBox<Session>('sessions');
  }

  Future<void> saveJournalEntry(JournalEntry entry) async {
    final box = Hive.box<JournalEntry>('journal_entries');
    await box.add(entry);
  }

  getJournalEntries() {}
}
