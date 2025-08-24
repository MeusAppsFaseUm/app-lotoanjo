import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const LotoAnjoApp());
}

class LotoAnjoApp extends StatelessWidget {
  const LotoAnjoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LotoAnjo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFD700),
          brightness: Brightness.dark,
          background: const Color(0xFF0C1A2B),
          surface: const Color(0xFF132A44),
          primary: const Color(0xFFFFD700),
          onPrimary: const Color(0xFF0C1A2B),
          secondary: const Color(0xFFE6C200),
        ),
        textTheme: GoogleFonts.outfitTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: const Color(0xFFFFD700),
            displayColor: const Color(0xFFFFD700),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFD700),
            foregroundColor: const Color(0xFF0C1A2B),
            elevation: 8,
            shadowColor: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
