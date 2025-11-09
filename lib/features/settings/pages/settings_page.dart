// lib/features/sermons/pages/sermons_page.dart
import 'package:flutter/material.dart';
import 'package:prophet_kacou/app/themes/app_theme.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MainLayout(
      title: i18n.tr('home.settings'),
      body: ListView(
        children: [
          // Section Apparence
          _buildSectionHeader(context, i18n.tr('settings.appearance')),

          // Toggle Dark/Light Mode
          SwitchListTile(
            title: Text(i18n.tr('settings.dark_mode')),
            subtitle: Text(
              themeProvider.isDarkMode
                  ? i18n.tr('settings.dark_mode_enabled')
                  : i18n.tr('settings.light_mode_enabled'),
            ),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
            secondary: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: pkpIndigo,
            ),
          ),

          const Divider(),

          // Sélection du mode de thème (Light/Dark/System)
          _buildSectionHeader(context, i18n.tr('settings.theme_mode')),

          RadioListTile<ThemeMode>(
            title: Text(i18n.tr('settings.light_theme')),
            value: ThemeMode.light,
            groupValue: themeProvider.themeMode,
            onChanged: (value) {
              if (value != null) {
                themeProvider.setThemeMode(value);
              }
            },
            secondary: const Icon(Icons.light_mode, color: Colors.amber),
          ),

          RadioListTile<ThemeMode>(
            title: Text(i18n.tr('settings.dark_theme')),
            value: ThemeMode.dark,
            groupValue: themeProvider.themeMode,
            onChanged: (value) {
              if (value != null) {
                themeProvider.setThemeMode(value);
              }
            },
            secondary: const Icon(Icons.dark_mode, color: Colors.indigo),
          ),

          RadioListTile<ThemeMode>(
            title: Text(i18n.tr('settings.system_theme')),
            subtitle: Text(i18n.tr('settings.system_theme_desc')),
            value: ThemeMode.system,
            groupValue: themeProvider.themeMode,
            onChanged: (value) {
              if (value != null) {
                themeProvider.setThemeMode(value);
              }
            },
            secondary: const Icon(Icons.phone_android, color: Colors.grey),
          ),

          const Divider(),

          // Preview des couleurs
          _buildSectionHeader(context, i18n.tr('settings.color_preview')),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildColorPreview(
                  context,
                  pkpSand,
                  i18n.tr('settings.light_bg'),
                ),
                _buildColorPreview(
                  context,
                  pkpDark,
                  i18n.tr('settings.dark_bg'),
                ),
                _buildColorPreview(
                  context,
                  pkpIndigo,
                  i18n.tr('settings.primary_color'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildSectionHeader(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}

Widget _buildColorPreview(BuildContext context, Color color, String label) {
  return Column(
    children: [
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey, width: 1),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        label,
        style: const TextStyle(fontSize: 12),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
