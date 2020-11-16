import 'package:flutter/material.dart';

final kLightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  accentColor: Colors.pinkAccent[100],
  scaffoldBackgroundColor: Color(0xFFF6F8F9),
  buttonColor: Color(0xFFE9F0F4)
);

final kDarktTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  accentColor: Color(0xFFFF9500),
  scaffoldBackgroundColor: Color(0xFF17181A),
  buttonColor: Color(0xFF222427),
);
