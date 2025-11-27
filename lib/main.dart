import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:prophet_kacou/app/themes/app_theme.dart';
import 'package:prophet_kacou/core/database/database_initializer.dart';
import 'package:prophet_kacou/core/providers/audio_player_provider.dart';
import 'package:prophet_kacou/core/repositories/download_history_provider.dart';
import 'package:prophet_kacou/core/utils/app_data_updates.dart';
import 'package:prophet_kacou/features/home/widgets/splash_screen.dart';
import 'package:prophet_kacou/i18n/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:prophet_kacou/features/home/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Préserver le splash screen natif pendant l'initialisation
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Configurer l'orientation et la barre d'état
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialized = false;
  double _progress = 0.0;

  late LanguageProvider languageProvider;
  late ThemeProvider themeProvider;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Supprimer le splash natif et montrer notre SplashScreen personnalisé
      FlutterNativeSplash.remove();

      // Étape 1: Initialiser les bases de données (20%)
      await DatabaseInitializer.initializeDatabases();
      if (mounted) setState(() => _progress = 0.2);

      // Étape 2: Récupérer les mises à jour (40%)
      setUpdateIsPending(false);
      availableServerLanguesUpdates("en-en");
      if (mounted) setState(() => _progress = 0.4);

      // Étape 3: Créer et initialiser les providers (60%)
      languageProvider = LanguageProvider();
      themeProvider = ThemeProvider();
      if (mounted) setState(() => _progress = 0.6);

      // Étape 4: Initialiser les providers (80%)
      await Future.wait([languageProvider.init(), themeProvider.init()]);
      if (mounted) setState(() => _progress = 0.8);

      // Étape 5: Précharger toutes les images (100%)
      if (mounted) {
        await _precacheAllImages();
        setState(() => _progress = 1.0);
      }

      // Petit délai pour voir l'animation complète
      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted) setState(() => _isInitialized = true);
    } catch (e) {
      // Gérer les erreurs d'initialisation
      debugPrint('Erreur d\'initialisation: $e');
      FlutterNativeSplash.remove();
      if (mounted) setState(() => _isInitialized = true);
    }
  }

  /// Précharge toutes les images utilisées dans HomePage et ses enfants
  Future<void> _precacheAllImages() async {
    final BuildContext? context = this.context;
    if (context == null || !mounted) return;

    // Liste de toutes les images à précharger
    final List<String> imagesToPreload = [
      // Drapeaux de LanguageSelector
      'assets/images/drapeau/en.jpg',
      'assets/images/drapeau/fr.jpg',
      'assets/images/drapeau/es.jpg',
      'assets/images/drapeau/pt.jpg',
      'assets/images/drapeau/cn.jpg',
      'assets/images/drapeau/in.jpg',
      'assets/images/drapeau/sa.jpg',
      // Ajoutez d'autres drapeaux si nécessaire

      // Icône de l'application (si utilisée)
      'assets/icons/icon420x420.png',
      'assets/icons/icon512x512.png',
      'assets/icons/sea.png',
      'assets/icons/philippe.png',

      // Ajoutez toutes les autres images utilisées dans HomePage
    ];

    // Précharger toutes les images en parallèle avec gestion d'erreur
    await Future.wait(
      imagesToPreload.map((imagePath) async {
        try {
          await precacheImage(AssetImage(imagePath), context);
        } catch (e) {
          debugPrint('Erreur lors du préchargement de $imagePath: $e');
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(progress: _progress),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: languageProvider),
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => AudioPlayerProvider()),
        ChangeNotifierProvider(create: (_) => DownloadHistoryProvider()),
      ],
      child: const HomePage(),
    );
  }
}
