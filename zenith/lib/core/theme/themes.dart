import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xFF4A80F0),
    scaffoldBackgroundColor: Color(0xFFFDFDFD),
    colorScheme: ColorScheme.light(
      primary: Color(0xFF4A80F0),
      secondary: Color(0xFF4A80F0),
      surface: Color(0xFFFDFDFD),
      onSurface: Color(0xFF1C1C1E),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFFFDFDFD),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF1C1C1E)),
    ),
    textTheme: TextTheme(
      headline6: TextStyle(color: Color(0xFF1C1C1E), fontSize: 20, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(color: Color(0xFF1C1C1E)),
      bodyText2: TextStyle(color: Color(0xFF747476)),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Color(0xFF4A80F0),
    scaffoldBackgroundColor: Color(0xFF121212),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF4A80F0),
      secondary: Color(0xFF2A4075),
      surface: Color(0xFF1E1E1E),
      onSurface: Color(0xFFE4E4E6),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF121212),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFFE4E4E6)),
    ),
    textTheme: TextTheme(
      headline6: TextStyle(color: Color(0xFFE4E4E6), fontSize: 20, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(color: Color(0xFFE4E4E6)),
      bodyText2: TextStyle(color: Color(0xFF98989A)),
    ),
  );
}
