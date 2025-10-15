import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: Color(0xFF002d64),
    scaffoldBackgroundColor: Color(0xFF002d64),
    textTheme: TextTheme(
      headlineMedium: GoogleFonts.cinzel(color: Colors.white, fontSize: 28),
      bodyLarge: GoogleFonts.inter(color: Colors.white),
      bodyMedium: GoogleFonts.inter(color: Colors.white70),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00a4e4)),
    ),
  );
}
