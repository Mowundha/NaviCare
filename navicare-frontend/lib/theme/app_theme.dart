import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF4B3FCF);
  static const Color primaryLight = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF3A2FA8);
  static const Color primarySurface = Color(0xFFEEECFF);

  static const Color secondary = Color(0xFFFF8C42);
  static const Color secondarySurface = Color(0xFFFFF0E6);

  static const Color accent = Color(0xFF3DAA6E);
  static const Color accentSurface = Color(0xFFE8F7EF);

  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF17A2B8);

  static const Color neutral900 = Color(0xFF1A1A2E);
  static const Color neutral800 = Color(0xFF2D2D44);
  static const Color neutral700 = Color(0xFF4A4A6A);
  static const Color neutral600 = Color(0xFF6B6B8A);
  static const Color neutral500 = Color(0xFF8E8EAA);
  static const Color neutral400 = Color(0xFFB0B0C8);
  static const Color neutral300 = Color(0xFFD0D0E0);
  static const Color neutral200 = Color(0xFFE8E8F0);
  static const Color neutral100 = Color(0xFFF5F5FA);
  static const Color white = Color(0xFFFFFFFF);

  static const Color heartRed = Color(0xFFFF4B6B);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: primary,
          secondary: secondary,
          tertiary: accent,
          surface: white,
          onPrimary: white,
          onSecondary: white,
          onSurface: neutral900,
        ),
        textTheme: Typography.englishLike2018.copyWith(
          displayLarge: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: neutral900, height: 1.2),
          displayMedium: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: neutral900),
          headlineLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: neutral900),
          headlineMedium: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: neutral900),
          headlineSmall: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: neutral900),
          titleLarge: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: neutral900),
          titleMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: neutral900),
          titleSmall: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: neutral700),
          bodyLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: neutral800, height: 1.5),
          bodyMedium: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: neutral700, height: 1.5),
          bodySmall: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: neutral600, height: 1.5),
          labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: primary),
          labelMedium: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: neutral600),
          labelSmall: const TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: neutral500),
        ),
        scaffoldBackgroundColor: neutral100,
        appBarTheme: const AppBarTheme(
          backgroundColor: white,
          elevation: 0,
          scrolledUnderElevation: 1,
          shadowColor: neutral200,
          iconTheme: IconThemeData(color: neutral900),
          titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: neutral900),
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: EdgeInsets.zero,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: neutral100,
          selectedColor: primary,
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: white,
            minimumSize: const Size(0, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            elevation: 0,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: neutral200)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: neutral200)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: primary, width: 2)),
          hintStyle: const TextStyle(fontSize: 13, color: neutral400),
        ),
        dividerTheme: const DividerThemeData(color: neutral200, thickness: 1, space: 0),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return white;
            return neutral400;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return primary;
            return neutral200;
          }),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: white,
          selectedItemColor: primary,
          unselectedItemColor: neutral400,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
      );
}
