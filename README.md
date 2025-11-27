# prophet_kacou

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

## Pour renommer le nom de l'application
dart run rename setAppName --targets ios,android --value "Prophet Kacou"

# Start the iOS Simulator with the following command:
open -a Simulator

# build apk for android
flutter build apk --release

# 1. Installer les dépendances
flutter pub get

# 2. Générer le splash screen natif
dart run flutter_native_splash:create

# 3. Générer les icônes de l'application
dart run flutter_launcher_icons

# 4. Nettoyer et reconstruire
flutter clean
flutter pub get

# 5. Lancer l'application
flutter run

# Si vous rencontrez des problèmes, essayez :
# Pour Android
flutter build apk
# Ou
flutter build appbundle

# Pour iOS (sur Mac uniquement)
flutter build ios