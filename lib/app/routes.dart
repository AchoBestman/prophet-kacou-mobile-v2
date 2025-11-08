import 'package:flutter/material.dart';
import 'package:prophet_kacou/features/abouts/pages/abouts_page.dart';
import 'package:prophet_kacou/features/assemblies/pages/assemblies_page.dart';
import 'package:prophet_kacou/features/biographies/pages/biographies_page.dart';
import 'package:prophet_kacou/features/hymns/pages/hymns_page.dart';
import 'package:prophet_kacou/features/informations/pages/informations_page.dart';
import 'package:prophet_kacou/features/photos/pages/photos_page.dart';
import 'package:prophet_kacou/features/sermons/pages/sermons_page.dart';
import 'package:prophet_kacou/features/settings/pages/settings_page.dart';
import 'package:prophet_kacou/features/videos/pages/videos_page.dart';

/// 🔹 Fonction qui retourne toutes les routes de l'application
Map<String, WidgetBuilder> appRoutes = {
  '/sermons': (context) => const SermonsPage(),

  '/biographies': (context) => const BiographiesPage(),

  '/photos': (context) => const PhotosPage(),

  '/videos': (context) => const VideosPage(),

  '/hymns': (context) => const HymnsPage(),

  '/assemblies': (context) => const AssembliesPage(),

  '/informations': (context) => const InformationsPage(),

  '/settings': (context) => const SettingsPage(),

  '/abouts': (context) => const AboutsPage(),
};
