import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zenith/features/calendar/data/models/event_adapter.dart';
import 'package:zenith/features/calendar/data/models/event_model.dart';
import 'package:zenith/features/calendar/presentation/screens/calendar_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(EventAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zenith',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CalendarScreen(),
    );
  }
}
