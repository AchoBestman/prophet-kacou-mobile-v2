// lib/layouts/main_layout.dart
import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/i18n/i18n.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions; 

  const MainLayout({
    super.key,
    required this.title,
    required this.body,
    this.actions
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: pkpIndigo,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(title, style: const TextStyle(
            color: Colors.white, // 👈 titre en blanc
            fontWeight: FontWeight.w600,
          )),
          actions: actions
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF1A237E)),
              child: Text(
                i18n.tr('home.title'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(i18n.tr('home.home')),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: Text(i18n.tr('home.sermon')),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/sermons');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(i18n.tr('home.biography')),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/biographies');
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: Text(i18n.tr('home.photos')),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/photos');
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_settings),
              title: Text(i18n.tr('home.videos')),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/videos');
              },
            ),
            ListTile(
              leading: const Icon(Icons.audiotrack),
              title: Text(i18n.tr('home.hymns')),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/hymns');
              },
            ),
            ListTile(
              leading: const Icon(Icons.home_filled),
              title: Text(i18n.tr('home.church')),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/assemblies');
              },
            ),
             ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Informations'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/informations');
              },
            ),
             ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('À propos'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/abouts');
              },
            ),
          ],
        ),
      ),
      body: SafeArea(child: body),
    );
  }
}
