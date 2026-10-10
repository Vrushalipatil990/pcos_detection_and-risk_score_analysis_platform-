import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:clerk_flutter/clerk_flutter.dart';

import 'screens/onboarding_screen.dart';
import 'services/notification_service.dart';
import 'screens/dashboard_screen.dart';
//vrushali7597@gmail.com Riddhipatil@123
const Color pink = Color(0xFFE88BA8);
const Color darkPink = Color(0xFFD96F91);
const Color green = Color(0xFF6F9F8A);
const Color darkGreen = Color(0xFF426B59);
const Color background = Color(0xFFFFFBF8);
const Color softPink = Color(0xFFFFEEF3);
const Color softGreen = Color(0xFFEAF4EF);

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await NotificationService.initialize();
//   runApp(const PCOSenseApp());
// }

// class PCOSenseApp extends StatelessWidget {
//   const PCOSenseApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'PCOSense',
//       theme: ThemeData(
//         fontFamily: 'Arial',
//         scaffoldBackgroundColor: background,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: pink,
//         ),
//         useMaterial3: true,
//       ),
//       home: const LandingPage(),
//     );
//   }
// }

Future<void> main() 
async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  await dotenv.load(fileName: '.env');

  runApp(
    ClerkAuth(
      config: ClerkAuthConfig(
        publishableKey: dotenv.env['CLERK_PUBLISHABLE_KEY']!,
      ),
      child: const PCOSenseApp(),
    ),
  );
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
        colorScheme: ColorScheme.fromSeed(seedColor: pink),
        useMaterial3: true,
      ),
      home: ClerkErrorListener(
        child: ClerkAuthBuilder(
          signedInBuilder: (context, authState) => const DashboardScreen(),
          signedOutBuilder: (context, authState) => const LandingPage(),
        ),
      ),
    );
  }
}