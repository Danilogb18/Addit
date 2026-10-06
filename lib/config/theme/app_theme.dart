

import 'package:flutter/material.dart';

class AppTheme {

  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 255, 102, 0),
    brightness: Brightness.dark,
  );

  ThemeData getTheme () => ThemeData(
    colorScheme: colorScheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      //color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(20)
      ),
      elevation: 3.5,
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        visualDensity: const VisualDensity(horizontal: -1, vertical: -2),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: const TextStyle(fontSize: 13),
        side: BorderSide(
          color: colorScheme.outline.withAlpha(100)
        )
      )
    ),
    //scaffoldBackgroundColor: colorScheme.surfaceContainerLow,
  );

}