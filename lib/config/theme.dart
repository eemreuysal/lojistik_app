import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Ana renkler
  static const Color primaryDark = Color(0xFF07263E);
  static const Color primary = Color(0xFF103450);
  static const Color primaryLight = Color(0xFF1E485C);
  static const Color accent = Color(0xFFD3F0FF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color searchBg = Color(0xFFD3F0FF);
  static const Color textDark = Color(0xFF474747);
  static const Color textGrey = Color(0xFFC1C2C2);
  static const Color textLightGrey = Color(0xFFBCBEC2);
  static const Color borderColor = Color(0xFFEBEBEB);
  static const Color statusBlue = Color(0xFF2D4856);
  static const Color backgroundGrey =
      Color(0xFFF8F8F8); // Figma'dan eklenen arka plan rengi

  // Figma tasarımından eklenen yeni renkler
  static const Color navIconColor =
      Color(0xFFDDDDDD); // Navigation bar icon rengi
  static const Color iconGrey =
      Color(0xFF7B7B7B); // Şoför kart ikonları için gri

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment(-0.61, 0.5),
    end: Alignment(0.39, -0.5),
    colors: [
      Color(0xFF07263E),
      Color(0xFF103450),
      Color(0xFF1E485C),
    ],
    stops: [0.004, 0.531, 1.0],
  );

  // Bottom Navigation Bar Gradient
  static const LinearGradient navBarGradient = LinearGradient(
    begin: Alignment(-0.32, 0.18),
    end: Alignment(1.01, 0.63),
    colors: [
      Color(0xFF07263E),
      Color(0xFF103450),
      Color(0xFF1E485C),
    ],
    stops: [0.004, 0.531, 1.0],
  );

  // Container Styles
  static ShapeDecoration containerDecoration = ShapeDecoration(
    color: backgroundGrey,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
  );

  // Standart container boyutları (Figma'dan)
  static const double standardContainerWidth = 430;
  static const double standardContainerHeight = 822;

  // Text Styles
  static TextStyle manropeBold(double size, [Color? color]) {
    return GoogleFonts.manrope(
      fontSize: size,
      fontWeight: FontWeight.bold,
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

  static TextStyle manropeRegular(double size, [Color? color]) {
    return GoogleFonts.manrope(
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: color ?? textDark,
    );
  }

  static TextStyle clashGroteskSemiBold(double size, [Color? color]) {
    return GoogleFonts.inter(
      // Google Fonts'ta tam eşdeğeri olmadığı için Inter kullanıyoruz
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: color ?? textDark,
    );
  }

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

  // ThemeData
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryDark,
      scaffoldBackgroundColor: backgroundGrey,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDark,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          foregroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: textLightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: textLightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: accent),
        ),
        fillColor: white,
        filled: true,
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
      ).copyWith(secondary: accent),
    );
  }
}
