import 'package:flutter/material.dart';
import 'package:prophet_kacou/app/themes/app_theme.dart';
import 'package:prophet_kacou/features/abouts/pages/abouts_page.dart';
import 'package:prophet_kacou/features/assemblies/pages/assemblies_page.dart';
import 'package:prophet_kacou/features/biographies/pages/biographies_page.dart';
import 'package:prophet_kacou/features/hymns/pages/hymns_page.dart';
import 'package:prophet_kacou/features/informations/pages/informations_page.dart';
import 'package:prophet_kacou/features/photos/pages/photos_page.dart';
import 'package:prophet_kacou/features/sermons/pages/sermons_page.dart';
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
    // Écouter les changements de thème
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AnimatedTheme(
      data: themeProvider.lightTheme,
      duration: const Duration(milliseconds: 400), // ⏱️ durée de la transition
      curve: Curves.easeInOut,
      child: MaterialApp(
        title: 'Prophet Kacou',
        debugShowCheckedModeBanner: false,
        theme: themeProvider.lightTheme,
        darkTheme: themeProvider.darkTheme,
        themeMode: themeProvider.themeMode,
        home: const LandingPage(),
        initialRoute: '/',
        routes: {
          '/sermons': (context) => const SermonsPage(),
          '/biographies': (context) => const BiographiesPage(),
          '/photos': (context) => const PhotosPage(),
          '/videos': (context) => const VideosPage(),
          '/hymns': (context) => const HymnsPage(),
          '/assemblies': (context) => const AssembliesPage(),
          '/informations': (context) => const InformationsPage(),
          '/langues': (context) => const LanguagesPage(),
          '/settings': (context) => const SettingsPage(),
          '/abouts': (context) => const AboutsPage(),
        },
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer écoute les changements du LanguageProvider
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        // Ces valeurs se mettront à jour quand la langue change
        final title = i18n.tr('home.title');
        final version = "v.1.0.0";
        final titleAndVersion = "$title - $version";

        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: pkpIndigo,
            title: AppBarSection(title: titleAndVersion),
          ),
          body: SafeArea(
            bottom: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [LanguageSelector(), BodySection(), FooterSection()],
            ),
          ),
        );
      },
    );
  }
}
