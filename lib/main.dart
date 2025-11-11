import 'package:flutter/material.dart';
import 'package:prophet_kacou/app/themes/app_theme.dart';
import 'package:prophet_kacou/core/database/database_initializer.dart';
import 'package:prophet_kacou/core/providers/audio_player_provider.dart';
import 'package:prophet_kacou/i18n/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:prophet_kacou/features/home/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Copie conditionnelle des bases selon version
  await DatabaseInitializer.initializeDatabases();
  
  // Créer et initialiser les providers
  final languageProvider = LanguageProvider();
  final themeProvider = ThemeProvider();

  await Future.wait([
    languageProvider.init(),
    themeProvider.init(),
  ]);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: languageProvider),
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => AudioPlayerProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}