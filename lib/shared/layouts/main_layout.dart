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
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      // ✅ Utilise automatiquement theme.scaffoldBackgroundColor
      appBar: AppBar(
        backgroundColor: pkpIndigo,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: actions,
      ),
      drawer: Drawer(
        // ✅ Background du Drawer adapté au thème
        backgroundColor: theme.scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: pkpIndigo),
              child: Text(
                i18n.tr('home.title'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.home,
              title: i18n.tr('home.home'),
              route: '/',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.menu_book,
              title: i18n.tr('home.sermon'),
              route: '/sermons',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.person,
              title: i18n.tr('home.biography'),
              route: '/biographies',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.photo,
              title: i18n.tr('home.photos'),
              route: '/photos',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.video_settings,
              title: i18n.tr('home.videos'),
              route: '/videos',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.audiotrack,
              title: i18n.tr('home.hymns'),
              route: '/hymns',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.home_filled,
              title: i18n.tr('home.church'),
              route: '/assemblies',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.info_outline,
              title: 'Informations',
              route: '/informations',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.settings,
              title: 'Settings',
              route: '/settings',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.info,
              title: 'À propos',
              route: '/abouts',
            ),
          ],
        ),
      ),
      body: SafeArea(child: body),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Icon(
        icon,
        color: theme.iconTheme.color,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: theme.textTheme.bodyLarge?.color,
        ),
      ),
      onTap: () {
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}