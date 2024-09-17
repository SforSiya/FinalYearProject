// theme.dart
import 'package:flutter/material.dart';


ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      background: Colors.grey.shade900,
      primary: Colors.grey.shade300,
      secondary: Colors.grey.shade500,
      inversePrimary: Colors.grey.shade300,
    ),
    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: Colors.grey[600],
      displayColor: Colors.white,
    )
);


