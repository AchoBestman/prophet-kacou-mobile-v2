import 'package:flutter/material.dart';
import 'package:prophet_kacou/database/database_initializer.dart';
import 'package:prophet_kacou/i18n/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:prophet_kacou/features/home/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Copie conditionnelle des bases selon version
  await DatabaseInitializer.initializeDatabases();
  
  // Créer et initialiser le LanguageProvider
  final languageProvider = LanguageProvider();
  await languageProvider.init();
  
  runApp(
    ChangeNotifierProvider.value(
      value: languageProvider,
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