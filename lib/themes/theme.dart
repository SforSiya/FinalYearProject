// theme.dart
import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      surface: Colors.white,
      primary: Colors.blue.shade600,
      secondary: Colors.blue.shade400,
      inversePrimary: Colors.blue.shade800,
    ),
    textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ));


/*class AppTheme {
  static ThemeData get lightTheme {
    //1
    return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      hintColor: Colors.amber,

      // Define the default font family.
      fontFamily: 'Respekkt', // Ensure this font is in your assets

      // Define the default TextTheme.


      // Define the default button styles.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Button background color
          foregroundColor: Colors.white, // Button text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),

      // Define the default icon theme.
      iconTheme: IconThemeData(
        color: Colors.blue,
        size: 24,
      ),

      // Define the default input decoration theme (e.g., for TextFields).
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}*/
