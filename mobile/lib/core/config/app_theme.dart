import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppColors {
  static const primary = Color(0xFF6C63FF);
  static const secondary = Color(0xFF3F3D56);
  static const onPrimary = Color(0xFF8FD7C7);
  static const background = Color(0xFFF9F9F9);
  static const surface = Color(0xFFFFFFFF);
  static const text = Color(0xFF121212);
  static const hint = Color(0xFF737373);
  static const accent = Color(0xFF8EB8FF);
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
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      hintStyle: TextStyle(color: AppColors.hint, fontSize: 16.sp),
      labelStyle: TextStyle(color: AppColors.hint, fontSize: 16.sp),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.primaryContainer.withValues(alpha: 0.6),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.primaryContainer.withValues(alpha: 0.6),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.8)),
      ),
      contentPadding: EdgeInsets.all(2.h),
      prefixIconColor: AppColors.hint,
      suffixIconColor: AppColors.hint,
      errorStyle: TextStyle(color: Colors.red, fontSize: 12),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 24.sp, // was 24
        fontWeight: FontWeight.w600,
        color: AppColors.secondary,
      ),
      titleMedium: TextStyle(
        fontSize: 20.sp, // was 20
        fontWeight: FontWeight.w600,
        color: AppColors.secondary,
      ),
      titleSmall: TextStyle(
        fontSize: 18.sp, // was 18
        fontWeight: FontWeight.w600,
        color: AppColors.secondary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.sp, // was 16
        color: AppColors.text,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.sp, // was 14
        color: AppColors.text,
      ),
      bodySmall: TextStyle(
        fontSize: 12.sp, // was 12
        color: AppColors.text,
      ),
      headlineLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.sp, // was 24
        color: AppColors.text,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: "Manrope",
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
  );
}
