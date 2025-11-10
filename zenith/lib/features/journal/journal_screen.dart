import 'package:flutter/material.dart';
import 'package:zenith/core/database/database_helper.dart';
import 'package:zenith/models/journal_entry.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _textController = TextEditingController();
  final _databaseHelper = DatabaseHelper();
  List<JournalEntry> _journalEntries = [];

  @override
  void initState() {
    super.initState();
    _loadJournalEntries();
  }

  Future<void> _loadJournalEntries() async {
    // final entries = await _databaseHelper.getJournalEntries();
    setState(() {
      // _journalEntries = entries;
    });
  }

  Future<void> _saveJournalEntry() async {
    if (_textController.text.isNotEmpty) {
      final newEntry = JournalEntry(
        content: _textController.text,
        createdAt: DateTime.now(),
      );
      await _databaseHelper.saveJournalEntry(newEntry);
      _textController.clear();
      _loadJournalEntries();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('October 26'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            // TODO: Implement navigation back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _journalEntries.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(_journalEntries[index].content),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Let your thoughts flow...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveJournalEntry,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Reflect'),
            ),
          ],
        ),
      ),
    );
  }
}