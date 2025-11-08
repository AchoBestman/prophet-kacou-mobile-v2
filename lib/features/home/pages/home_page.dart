import 'package:flutter/material.dart';
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
    return MaterialApp(
      title: 'Prophet Kacou',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: pkpIndigo)),
      home: const LandingPage(),
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
              children: [
                LanguageSelector(),
                BodySection(),
                FooterSection(),
              ],
            ),
          ),
        );
      },
    );
  }
}