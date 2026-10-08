import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';

const Color pink = Color(0xFFE88BA8);
const Color darkPink = Color(0xFFD96F91);
const Color green = Color(0xFF6F9F8A);
const Color darkGreen = Color(0xFF426B59);
const Color background = Color(0xFFFFFBF8);
const Color softPink = Color(0xFFFFEEF3);
const Color softGreen = Color(0xFFEAF4EF);

void main() {
  runApp(const PCOSenseApp());
}

class PCOSenseApp extends StatelessWidget {
  const PCOSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PCOSense',
      theme: ThemeData(
        fontFamily: 'Arial',
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: pink,
        ),
        useMaterial3: true,
      ),
      home: const LandingPage(),
    );
  }
}