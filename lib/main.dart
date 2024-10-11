import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mathmind/firebase_options.dart';
import 'package:mathmind/themes/dark_theme.dart';
import 'package:mathmind/themes/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathMind',
      theme: lightMode,
      //darkTheme: darkMode,
      debugShowCheckedModeBanner: false, // Disable the debug banner
      home: SplashScreen(),
    );
  }
}
