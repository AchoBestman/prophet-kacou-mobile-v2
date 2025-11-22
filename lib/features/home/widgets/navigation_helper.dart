import 'package:flutter/material.dart';

/// Helper pour gérer la navigation et vérifier si on est déjà sur une page
class NavigationHelper {
  /// Vérifie si on est actuellement sur la route spécifiée
  static bool isCurrentRoute(BuildContext context, String routeName) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    return currentRoute == routeName;
  }

  /// Navigation sécurisée - ne navigue que si on n'est pas déjà sur la page
  static void navigateTo(BuildContext context, String routeName) {
    if (!isCurrentRoute(context, routeName)) {
      // Pour la page d'accueil, on supprime toute la pile de navigation
      if (routeName == '/') {
        Navigator.of(context).pushNamedAndRemoveUntil(routeName, (route) => false);
      } else {
        Navigator.of(context).pushReplacementNamed(routeName);
      }
    }
  }

  /// Navigation avec remplacement - utile pour revenir à l'accueil
  static void navigateToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  /// Vérifie si la route actuelle est la page d'accueil
  static bool isHomePage(BuildContext context) {
    return isCurrentRoute(context, '/');
  }
}

/// Extension pour faciliter l'utilisation dans les widgets
extension NavigationExtension on BuildContext {
  /// Vérifie si on est sur la route spécifiée
  bool isOnRoute(String routeName) {
    return NavigationHelper.isCurrentRoute(this, routeName);
  }

  /// Navigation sécurisée
  void navigateTo(String routeName) {
    NavigationHelper.navigateTo(this, routeName);
  }

  /// Retour à l'accueil
  void navigateToHome() {
    NavigationHelper.navigateToHome(this);
  }

  /// Vérifie si on est sur la page d'accueil
  bool get isHomePage {
    return NavigationHelper.isHomePage(this);
  }
}