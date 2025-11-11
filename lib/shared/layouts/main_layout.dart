import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prophet_kacou/app/themes/app_theme.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final String countryCode = i18n.countryCode;

    return Scaffold(
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
        backgroundColor: theme.scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // 🟣 Header personnalisé
            Container(
              decoration: const BoxDecoration(color: pkpIndigo),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🟢 Ligne du haut : logo + titre + bouton thème
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Logo + texte côte à côte
                          Expanded(
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                    'assets/images/drapeau/$countryCode.jpg',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ), // petit espace entre logo et texte
                                Text(
                                  i18n.tr('home.title'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          // Bouton thème à droite
                          IconButton(
                            icon: Icon(
                              themeProvider.isDarkMode
                                  ? Icons.dark_mode
                                  : Icons.light_mode,
                              color: Colors.white,
                              size: 26,
                            ),
                            onPressed: () {
                              themeProvider.toggleTheme();
                            },
                            tooltip: i18n.tr('settings.dark_mode'),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),

                      // 🟣 Bas : texte fixe centré
                      Center(
                        child: Text(
                          "Le livre du salut de notre génération",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 🟢 Liste des menus
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
              icon: Icons.info_outline,
              title: i18n.tr('home.informations'),
              route: '/informations',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.update,
              title: i18n.tr('home.langues'),
              route: '/langues',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.settings,
              title: i18n.tr('home.settings'),
              route: '/settings',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.info,
              title: i18n.tr('home.contacts'),
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
      leading: Icon(icon, color: theme.iconTheme.color),
      title: Text(
        title,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      ),
      onTap: () {
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}
