import 'package:flutter/material.dart';
import 'package:prophet_kacou/app/themes/app_theme.dart';
import 'package:prophet_kacou/features/abouts/pages/abouts_page.dart';
import 'package:prophet_kacou/features/assemblies/pages/assemblies_page.dart';
import 'package:prophet_kacou/features/biographies/pages/biographies_page.dart';
import 'package:prophet_kacou/features/hymns/pages/hymns_page.dart';
import 'package:prophet_kacou/features/informations/pages/informations_page.dart';
import 'package:prophet_kacou/features/photos/pages/photos_page.dart';
import 'package:prophet_kacou/features/sermons/pages/sermons_page.dart';
import 'package:prophet_kacou/features/settings/pages/download_history_page.dart';
import 'package:prophet_kacou/features/settings/pages/languages_page.dart';
import 'package:prophet_kacou/features/settings/pages/settings_page.dart';
import 'package:prophet_kacou/features/videos/pages/videos_page.dart';
import 'package:prophet_kacou/i18n/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/features/home/widgets/app_bar_section.dart';
import 'package:prophet_kacou/features/home/widgets/body_section.dart';
import 'package:prophet_kacou/features/home/widgets/footer_section.dart';
import 'package:prophet_kacou/features/home/widgets/language_selector.dart';
import 'package:prophet_kacou/i18n/i18n.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return AnimatedTheme(
      data: themeProvider.lightTheme,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: MaterialApp(
        title: 'Prophet Kacou',
        debugShowCheckedModeBanner: false,
        theme: themeProvider.lightTheme,
        darkTheme: themeProvider.darkTheme,
        themeMode: themeProvider.themeMode,
        home: const LandingPage(),
        initialRoute: '/',
        // Utiliser onGenerateRoute pour mieux contrôler la navigation
        onGenerateRoute: (settings) {
          WidgetBuilder builder;
          
          switch (settings.name) {
            case '/':
              builder = (context) => const LandingPage();
              break;
            case '/sermons':
              builder = (context) => const SermonsPage();
              break;
            case '/biographies':
              builder = (context) => const BiographiesPage();
              break;
            case '/photos':
              builder = (context) => const PhotosPage();
              break;
            case '/videos':
              builder = (context) => const VideosPage();
              break;
            case '/hymns':
              builder = (context) => const HymnsPage();
              break;
            case '/assemblies':
              builder = (context) => const AssembliesPage();
              break;
            case '/informations':
              builder = (context) => const InformationsPage();
              break;
            case '/langues':
              builder = (context) => const LanguagesPage();
              break;
            case '/settings':
              builder = (context) => const SettingsPage();
              break;
            case '/abouts':
              builder = (context) => const AboutsPage();
              break;
            case '/downloads':
              builder = (context) => const DownloadHistoryPage();
              break;
            default:
              builder = (context) => const LandingPage();
          }
          
          return MaterialPageRoute(
            builder: builder,
            settings: settings,
          );
        },
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final title = i18n.tr('home.title');
        final version = "v.1.0.0";
        final titleAndVersion = "$title - $version";
        
        return PopScope(
          // Empêcher le retour arrière sur la page d'accueil
          canPop: false,
          child: Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: pkpIndigo,
              title: AppBarSection(title: titleAndVersion),
              // Masquer le bouton retour
              automaticallyImplyLeading: false,
            ),
            body: SafeArea(
              bottom: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LanguageSelector(),
                  BodySection(),
                  FooterSection(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}