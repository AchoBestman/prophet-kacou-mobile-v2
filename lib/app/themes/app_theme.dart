import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.light;
  bool _isInitialized = false;

  ThemeMode get themeMode => _themeMode;
  bool get isInitialized => _isInitialized;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Initialisation au démarrage
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);
    
    if (savedTheme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (savedTheme == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
    
    _isInitialized = true;
    notifyListeners();
  }

  // Changer le thème
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.toString().split('.').last);
    
    notifyListeners();
  }

  // Toggle entre light et dark
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  // Thème Light
  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: pkpIndigo,
        brightness: Brightness.light,
        surface: pkpSand,
        onSurface: Colors.black87,
      ),
      scaffoldBackgroundColor: pkpSand,
      appBarTheme: const AppBarTheme(
        backgroundColor: pkpIndigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: pkpIndigo,
        unselectedLabelColor: Colors.grey,
        indicatorColor: pkpIndigo,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: pkpIndigo, width: 2),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black87),
        bodySmall: TextStyle(color: Colors.black54),
      ),
      iconTheme: const IconThemeData(color: Colors.black87),
    );
  }

  // Thème Dark
  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: pkpIndigo,
        brightness: Brightness.dark,
        surface: pkpDark,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: pkpDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: pkpIndigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.grey[900],
        surfaceTintColor: Colors.transparent,
        elevation: 2,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[400],
        indicatorColor: pkpIndigo,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: pkpIndigo, width: 2),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white70),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }
}