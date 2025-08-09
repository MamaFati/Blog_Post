import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  final Box _settingsBox = Hive.box('settings');

  ThemeProvider() {
    // Load saved theme on startup
    _isDarkMode = _settingsBox.get('isDarkMode', defaultValue: false);
  }

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _settingsBox.put('isDarkMode', _isDarkMode); // Save preference
    notifyListeners();
  }

  // Light Theme
  ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.blueAccent,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: Colors.blueAccent,
        secondary: Colors.cyan,
        surface: Colors.white,
        background: Colors.white,
        error: Colors.redAccent,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.black87,
        onBackground: Colors.black87,
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 5,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.blueAccent,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade100,
        selectedColor: Colors.blueAccent,
        secondarySelectedColor: Colors.blueAccent.withOpacity(0.8),
        labelStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.black87,
        size: 24,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: CircleBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }

  // Dark Theme
  ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Colors.blueAccent,
      scaffoldBackgroundColor: Colors.grey.shade900,
      colorScheme: ColorScheme.dark(
        primary: Colors.blueAccent,
        secondary: Colors.cyan,
        surface: Colors.grey.shade800,
        background: Colors.grey.shade900,
        error: Colors.redAccent,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: Colors.white70,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.grey.shade800,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 5,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.blueAccent,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade700,
        selectedColor: Colors.blueAccent,
        secondarySelectedColor: Colors.blueAccent.withOpacity(0.8),
        labelStyle: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white70,
        size: 24,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: CircleBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade800,
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
