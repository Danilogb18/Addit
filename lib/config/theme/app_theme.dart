

import 'package:flutter/material.dart';

class AppTheme {

  final colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  );

  ThemeData getTheme () => ThemeData(
    colorScheme: colorScheme,
    cardTheme: CardThemeData(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(20)
      ),
      elevation: 3.5,
    ),
    scaffoldBackgroundColor: colorScheme.surfaceContainerLow
  );

}