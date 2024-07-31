import 'package:flutter/material.dart';
import 'package:mathmind/themes/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathMind',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false, // Disable the debug banner
      home: SplashScreen(),
    );
  }
}
