import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF059669);
  static const Color primaryDark = Color(0xFF05281D);
  static const Color secondary = Color(0xFF0D9488);
  static const Color accent = Color(0xFFDC2626);
  static const Color surface = Color(0xFFF4FDF9);
  static const Color surfaceAlt = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF062016);
  static const Color textSecondary = Color(0xFF163F2F);
  static const Color border = Color(0xFFC2E8DA);
  static const Color success = Color(0xFF059669);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626);
}

class AppDimensions {
  AppDimensions._();

  static const double padding = 20;
  static const double horizontalPadding = 20;
  static const double cardRadius = 24;
  static const double buttonRadius = 16;
  static const double maxWidth = 1200;
}

class AppRadius {
  AppRadius._();

  static const BorderRadius card = BorderRadius.all(Radius.circular(24));
  static const BorderRadius button = BorderRadius.all(Radius.circular(16));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
}

class AppShadows {
  AppShadows._();

  static const BoxShadow soft = BoxShadow(
    color: Color(0x1A0F172A),
    blurRadius: 20,
    offset: Offset(0, 12),
  );

  static const BoxShadow card = BoxShadow(
    color: Color(0x140F172A),
    blurRadius: 24,
    offset: Offset(0, 20),
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.surface,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surfaceAlt,
      onSurface: AppColors.textPrimary,
      onPrimary: Colors.white,
    ),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: AppRadius.button,
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.button,
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.button,
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    ),
    cardTheme: const CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
      margin: EdgeInsets.zero,
    ),
  );

  static ThemeData darkTheme = lightTheme.copyWith(
    scaffoldBackgroundColor: const Color(0xFF02140F),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF34D399),
      secondary: Color(0xFF2DD4BF),
      surface: Color(0xFF05281D),
      onSurface: Color(0xFFECFDF5),
      onPrimary: Colors.white,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: const Color(0xFFECFDF5),
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: const Color(0xFFECFDF5),
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: const Color(0xFFECFDF5),
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xFFA7F3D0),
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFFA7F3D0),
      ),
    ),
  );
}
