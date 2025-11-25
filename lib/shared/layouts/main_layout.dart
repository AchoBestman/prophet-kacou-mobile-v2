import 'package:flutter/material.dart';
import 'package:prophet_kacou/core/providers/audio_player_provider.dart';
import 'package:prophet_kacou/features/home/widgets/navigation_helper.dart';
import 'package:prophet_kacou/features/settings/pages/download_floating_button.dart';
import 'package:prophet_kacou/shared/widgets/audio_mini_player.dart';
import 'package:prophet_kacou/shared/widgets/audio_player.dart';
import 'package:provider/provider.dart';
import 'package:prophet_kacou/app/themes/app_theme.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/i18n/i18n.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool isHomePage; // Nouveau paramètre

  const MainLayout({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.isHomePage = false, // false par défaut
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final String countryCode = i18n.countryCode;
  
    return PopScope(
      // Empêcher le retour arrière sur la page d'accueil
      canPop: !isHomePage,
      child: Scaffold(
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
          // Masquer le bouton retour sur la page d'accueil
          automaticallyImplyLeading: !isHomePage,
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
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      i18n.tr('home.title'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
                            i18n.tr("home.the_book_of_our_generation"),
                            style: TextStyle(
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
                icon: Icons.download,
                title: i18n.tr('home.download_history'),
                route: '/downloads',
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              // Contenu principal avec padding bottom pour éviter que AudioPlayerWidget cache le contenu
              Consumer<AudioPlayerProvider>(
                builder: (context, provider, child) {
                  // Calculer le padding bottom en fonction de ce qui est visible
                  double bottomPadding = 0;

                  // Si AudioPlayerWidget est visible (non minimized et currentAudio != null)
                  if (provider.currentAudio != null && !provider.isMinimized) {
                    bottomPadding = 140; // Hauteur approximative du AudioPlayerWidget + espacement
                  }
                  return Padding(
                    padding: EdgeInsets.only(bottom: bottomPadding),
                    child: body,
                  );
                },
              ),

              // AudioPlayerWidget en bas au centre
              Align(
                alignment: Alignment.bottomCenter,
                child: AudioPlayerWidget(),
              ),

              // Boutons flottants en bas à droite avec alignement vertical
              Positioned(
                right: 8,
                bottom: 20,
                child: Consumer<AudioPlayerProvider>(
                  builder: (context, provider, child) {
                    final showMiniPlayer = provider.currentAudio != null && provider.isMinimized;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (showMiniPlayer) ...[
                          MiniPlayer(),
                          const SizedBox(height: 12),
                        ],
                        DownloadFloatingButton(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isActive = context.isOnRoute(route);
    
    // Couleurs adaptatives selon le thème
    final activeColor = themeProvider.isDarkMode 
        ? Colors.white  // Blanc en mode sombre
        : pkpIndigo;    // Indigo en mode clair
    
    final activeBgColor = themeProvider.isDarkMode
        ? Colors.white.withValues(alpha: 0.1)  // Fond blanc transparent en mode sombre
        : pkpIndigo.withValues(alpha: 0.1);    // Fond indigo transparent en mode clair

    return ListTile(
      visualDensity: const VisualDensity(
        horizontal: -2,
        vertical: -2,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      leading: Icon(
        icon,
        color: isActive ? activeColor : theme.iconTheme.color,
        size: theme.iconTheme.size,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? activeColor : theme.textTheme.bodyLarge?.color,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      selected: isActive,
      selectedTileColor: activeBgColor,
      onTap: () {
        Navigator.pop(context); // Toujours fermer le drawer
        if (!isActive) {
          context.navigateTo(route); // Navigation seulement si pas actif
        }
      },
    );
  }
}