
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const blue = Color(0xFF1565C0);
  static const green = Color(0xFF43A047);
  static const white = Colors.white;
  static const gray50 = Color(0xFFF7F9FB);
  static const red = Colors.red;
}

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.blue,
    scaffoldBackgroundColor: AppColors.gray50,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.green),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.bold
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12
      )
    ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.blue,
    elevation: 0,
    centerTitle: true,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity
  );
}