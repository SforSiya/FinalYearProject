import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mathmind/firebase_options.dart';
import 'package:mathmind/parents/parenthomescreen/parenthome/parenthome.dart';
import 'package:mathmind/themes/theme.dart';
import 'screens/splash_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathMind',
      theme: lightMode,
      //darkTheme: darkMode,
      debugShowCheckedModeBanner: false, // Disable the debug banner
      home: const SplashScreen(),
    );
  }
}
