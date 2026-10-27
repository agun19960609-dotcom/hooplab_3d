import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dark coach theme. Text, icons, and borders stay light on the near-black court.
class HooplabColors {
  static const background = Color(0xFF0E1116);
  static const surface = Color(0xFF171C26);
  static const bar = Color(0xFF12161E);
  static const orange = Color(0xFFE86100);
  static const text = Color(0xFFFFFFFF);
  static const textMuted = Color(0xFFE8EDF5);
  static const border = Color(0xFFD0D6E0);
  static const danger = Color(0xFFFF8A80);
}

ThemeData hooplabTheme() {
  final dark = ThemeData.dark();
  final text = GoogleFonts.notoSansTcTextTheme(dark.textTheme).apply(
    bodyColor: HooplabColors.text,
    displayColor: HooplabColors.text,
  );
  return dark.copyWith(
    colorScheme: const ColorScheme.dark(
      primary: HooplabColors.orange,
      onPrimary: HooplabColors.text,
      secondary: HooplabColors.orange,
      onSecondary: HooplabColors.text,
      surface: HooplabColors.surface,
      onSurface: HooplabColors.text,
    ),
    scaffoldBackgroundColor: HooplabColors.background,
    textTheme: text,
    primaryTextTheme: text,
    iconTheme: const IconThemeData(color: HooplabColors.text),
    dividerColor: HooplabColors.border,
    appBarTheme: AppBarTheme(
      backgroundColor: HooplabColors.bar,
      foregroundColor: HooplabColors.text,
      elevation: 0,
      titleTextStyle: GoogleFonts.notoSansTc(
        color: HooplabColors.text,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: HooplabColors.surface,
      titleTextStyle: GoogleFonts.notoSansTc(
        color: HooplabColors.text,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      contentTextStyle: GoogleFonts.notoSansTc(
        color: HooplabColors.textMuted,
        fontSize: 16,
        height: 1.4,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: const Color(0xFFFFC49A)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: GoogleFonts.notoSansTc(color: HooplabColors.textMuted),
      labelStyle: GoogleFonts.notoSansTc(color: HooplabColors.text),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: HooplabColors.border),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: HooplabColors.orange, width: 1.6),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: HooplabColors.bar,
      selectedItemColor: HooplabColors.orange,
      unselectedItemColor: HooplabColors.textMuted,
    ),
  );
}
