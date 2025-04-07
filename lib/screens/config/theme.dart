import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Ana renkler
  static const Color primaryDark = Color(0xFF1D3557);
  static const Color primary = Color(0xFF457B9D);
  static const Color secondary = Color(0xFFA8DADC);
  static const Color accent = Color(0xFFE63946);
  static const Color background = Color(0xFFF1FAEE);
  
  // Ek renkler - Genişletilmiş
  static const Color textDark = Color(0xFF333333);
  static const Color textGrey = Color(0xFF767676);
  static const Color textLightGrey = Color(0xFFAAAAAA);
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color iconGrey = Color(0xFF999999);
  static const Color searchBg = Color(0xFFF5F5F5);
  static const Color statusBlue = Color(0xFF3A8DDE);
  static const Color backgroundGrey = Color(0xFFF8F9FA);
  static const Color navIconColor = Color(0xFFDDDDDD);
  
  // Gradyan renk
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryDark, primary],
  );
  
  // Navbar gradient
  static const LinearGradient navBarGradient = LinearGradient(
    begin: Alignment(0.01, 0.50),
    end: Alignment(1.00, 0.50),
    colors: [
      Color(0xFF06263E),
      Color(0xFF10344F),
      Color(0xFF1E485C)
    ],
  );

  // Tema
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: secondary,
      error: accent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryDark,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: accent),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );

  // Manrope stili - Text stilleri
  static TextStyle manropeRegular(double size, [Color? color]) {
    return GoogleFonts.manrope(
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: color ?? textDark,
    );
  }

  static TextStyle manropeMedium(double size, [Color? color]) {
    return GoogleFonts.manrope(
      fontSize: size,
      fontWeight: FontWeight.w500,
      color: color ?? textDark,
    );
  }

  static TextStyle manropeSemiBold(double size, [Color? color]) {
    return GoogleFonts.manrope(
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: color ?? textDark,
    );
  }

  static TextStyle manropeBold(double size, [Color? color]) {
    return GoogleFonts.manrope(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color ?? textDark,
    );
  }
  
  // Inter font stili
  static TextStyle interRegular(double size, [Color? color]) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: color ?? textDark,
    );
  }
  
  static TextStyle interMedium(double size, [Color? color]) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w500,
      color: color ?? textDark,
    );
  }
  
  static TextStyle interSemiBold(double size, [Color? color]) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: color ?? textDark,
    );
  }
  
  static TextStyle interBold(double size, [Color? color]) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color ?? textDark,
    );
  }
  
  // Clash Grotesk font stili
  static TextStyle clashGroteskSemiBold(double size, [Color? color]) {
    return TextStyle(
      fontFamily: 'Clash Grotesk',
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: color ?? textDark,
    );
  }
}