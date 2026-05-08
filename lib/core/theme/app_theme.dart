import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Dark Luxury Fintech Color Palette
  static const Color background = Color(0xFF0F1115); // Deep dark background
  static const Color surface = Color(0xFF161A22); // Slightly lighter for cards
  static const Color surfaceLight = Color(0xFF232834); // For elevated elements
  static const Color primary = Color(0xFF3B82F6); // Premium Blue
  static const Color primaryAccent = Color(0xFF60A5FA); // Light Blue
  static const Color success = Color(0xFF10B981); // Vibrant Green
  static const Color error = Color(0xFFEF4444); // Vibrant Red
  static const Color warning = Color(0xFFF59E0B); // Vibrant Orange
  
  static const Color textPrimary = Color(0xFFF8FAFC); // Very light grey
  static const Color textSecondary = Color(0xFF94A3B8); // Muted grey
  
  static const Color divider = Color(0xFF2A303C);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A1F2B), Color(0xFF161A22)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: primaryAccent,
        surface: surface,
        error: error,
      ),
      fontFamily: GoogleFonts.outfit().fontFamily,
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: const TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 32),
        displayMedium: const TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 28),
        displaySmall: const TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 24),
        headlineLarge: const TextStyle(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 20),
        headlineMedium: const TextStyle(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 18),
        headlineSmall: const TextStyle(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 16),
        bodyLarge: const TextStyle(color: textPrimary, fontSize: 16),
        bodyMedium: const TextStyle(color: textSecondary, fontSize: 14),
        bodySmall: const TextStyle(color: textSecondary, fontSize: 12),
        labelLarge: const TextStyle(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: divider, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryAccent,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: divider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        hintStyle: const TextStyle(color: textSecondary, fontSize: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
        space: 24,
      ),
    );
  }
}
