import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooplab_3d/views/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = ThemeData.dark();
    return MaterialApp(
      title: 'Hooplab 3D',
      debugShowCheckedModeBanner: false,
      theme: dark.copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE86100),
          secondary: Color(0xFFE86100),
          surface: Color(0xFF12161E),
        ),
        scaffoldBackgroundColor: const Color(0xFF0E1116),
        textTheme: GoogleFonts.notoSansTcTextTheme(dark.textTheme),
        primaryTextTheme: GoogleFonts.notoSansTcTextTheme(dark.primaryTextTheme),
      ),
      home: const MainScreen(),
    );
  }
}
