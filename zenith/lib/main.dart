import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenith/core/database/database_helper.dart';
import 'package:zenith/core/navigation/main_screen.dart';
import 'package:zenith/core/theme/themes.dart';
import 'package:zenith/features/calendar/data/calendar_service.dart';
import 'package:zenith/features/calendar/providers/calendar_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalendarProvider(CalendarService()),
      child: MaterialApp(
        title: 'Zenith',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const MainScreen(),
      ),
    );
  }
}
