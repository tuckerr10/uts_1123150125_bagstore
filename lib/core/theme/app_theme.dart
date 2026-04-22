import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true, [cite: 267]
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary), [cite: 268]
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, [cite: 284]
          foregroundColor: Colors.white, [cite: 285]
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), [cite: 286]
        ),
      ),
    );
  }
}