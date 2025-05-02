import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF5597FF);
  static const secondary = Color(0xFFFF9500);
  static const onPrimary = Color(0xFF8FD7C7);
  static const background = Color(0xFFEDEDED);
  static const text = Color(0xFF121212);
  static const primaryContainer = Color(0xFF797777);
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    fontFamily: "Manrope",
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.background,
      onPrimary: AppColors.onPrimary,
      onSecondary: Colors.black,
      primaryContainer: AppColors.primaryContainer,
      onSurface: AppColors.text,
    ),
    textTheme: const TextTheme(bodyLarge: TextStyle(color: AppColors.text)),
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: "DankMono",
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
  );
}
