import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  // === THEME ===
  static const String _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.light;
  bool _isInitialized = false;

  ThemeMode get themeMode => _themeMode;
  bool get isInitialized => _isInitialized;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // === FONT ===
  late CustomFont customFont;

  ThemeProvider() {
    customFont = CustomFont(_notify);
  }

  // Callback pour notifier le ThemeProvider
  void _notify() => notifyListeners();

  // === INITIALISATION ===
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    // Init thème
    final savedTheme = prefs.getString(_themeKey);
    if (savedTheme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (savedTheme == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }

    // Init police
    await customFont.init();

    _isInitialized = true;
    notifyListeners();
  }

  // === CHANGER THEME ===
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.toString().split('.').last);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  // === LIGHT THEME ===
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
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: Colors.black87,
          fontFamily: customFont.fontFamily,
          fontSize: customFont.fontSize,
          fontStyle: customFont.fontStyle,
        ),
      ),
    );
  }

  // === DARK THEME ===
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
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: Colors.white,
          fontFamily: customFont.fontFamily,
          fontSize: customFont.fontSize,
          fontStyle: customFont.fontStyle,
        ),
      ),
    );
  }
}

// === CUSTOM FONT ===
class CustomFont {
  static const String _fontFamilyKey = 'font_family';
  static const String _fontSizeKey = 'font_size';
  static const String _fontStyleKey = 'font_style';

  final VoidCallback _notify;

  String _fontFamily = 'Roboto';
  double _fontSize = 14;
  FontStyle _fontStyle = FontStyle.normal;

  CustomFont(this._notify);

  String get fontFamily => _fontFamily;
  double get fontSize => _fontSize;
  FontStyle get fontStyle => _fontStyle;

  // === INIT ===
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _fontFamily = prefs.getString(_fontFamilyKey) ?? 'Roboto';
    _fontSize = prefs.getDouble(_fontSizeKey) ?? 14;
    final styleString = prefs.getString(_fontStyleKey) ?? 'normal';
    _fontStyle = styleString == 'italic' ? FontStyle.italic : FontStyle.normal;
    _notify();
  }

  Future<void> setFontFamily(String family) async {
    _fontFamily = family;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontFamilyKey, family);
    _notify();
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, size);
    _notify();
  }

  Future<void> setFontStyle(FontStyle style) async {
    _fontStyle = style;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontStyleKey, style == FontStyle.italic ? 'italic' : 'normal');
    _notify();
  }
}
