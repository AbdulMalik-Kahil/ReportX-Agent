import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors from ReportX Agent design
  static const Color primary = Color(0xFF3B82F6);       // Blue
  static const Color primaryLight = Color(0xFFDBEAFE);   // Light blue bg
  static const Color sidebarBg = Color(0xFFFFFFFF);      // White sidebar
  static const Color sidebarActive = Color(0xFFEFF6FF);  // Active item bg
  static const Color sidebarActiveText = Color(0xFF2563EB); // Active text
  static const Color background = Color(0xFFF8FAFC);     // Page background
  static const Color cardBg = Color(0xFFFFFFFF);         // Card background
  static const Color cardBorder = Color(0xFFE2E8F0);     // Card border
  static const Color textPrimary = Color(0xFF1E293B);    // Dark text
  static const Color textSecondary = Color(0xFF64748B);  // Secondary text
  static const Color textMuted = Color(0xFF94A3B8);      // Muted text
  static const Color chartBar = Color(0xFF93A3B8);       // Chart bar color (steel blue/gray)
  static const Color divider = Color(0xFFE2E8F0);        // Dividers

  // Risk level colors
  static const Color riskLow = Color(0xFF22C55E);        // Green
  static const Color riskMedium = Color(0xFFF59E0B);     // Amber/Yellow
  static const Color riskHigh = Color(0xFFEF4444);       // Red

  // Overloaded teams
  static const Color warningBg = Color(0xFFFEFCE8);      // Light yellow
  static const Color warningBorder = Color(0xFFFDE68A);   // Yellow border
  static const Color warningText = Color(0xFFB45309);     // Amber text

  // Privacy notice
  static const Color privacyBg = Color(0xFFF0FDF4);      // Light green
  static const Color privacyBorder = Color(0xFFBBF7D0);   // Green border

  // Sync button
  static const Color syncGreen = Color(0xFF16A34A);       // Green button

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: Color(0xFF64748B),
        surface: cardBg,
      ),
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: cardBorder, width: 1),
        ),
      ),
      dividerColor: divider,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
