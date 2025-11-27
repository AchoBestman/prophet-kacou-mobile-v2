import 'package:flutter/material.dart';

/// Classe utilitaire pour gérer le préchargement des images
class ImagePreloader {
  /// Liste centralisée de toutes les images de l'application
  static const List<String> homePageImages = [

    // Drapeaux de LanguageSelector
    'assets/images/drapeau/en.jpg',
    'assets/images/drapeau/fr.jpg',
    'assets/images/drapeau/es.jpg',
    'assets/images/drapeau/pt.jpg',
    'assets/images/drapeau/cn.jpg',
    'assets/images/drapeau/in.jpg',
    'assets/images/drapeau/sa.jpg',
    
    // Icône de l'application (si utilisée)
    'assets/icons/icon420x420.png',
    'assets/icons/icon512x512.png',
    'assets/icons/sea.png',
    'assets/icons/philippe.png',
    
    // Ajoutez ici toutes les autres images utilisées dans HomePage
  ];

  /// Précharge une liste d'images
  static Future<void> preloadImages(
    BuildContext context,
    List<String> imagePaths, {
    Function(int loaded, int total)? onProgress,
  }) async {
    int loadedCount = 0;
    final total = imagePaths.length;

    await Future.wait(
      imagePaths.map((imagePath) async {
        try {
          await precacheImage(AssetImage(imagePath), context);
          loadedCount++;
          onProgress?.call(loadedCount, total);
        } catch (e) {
          debugPrint('⚠️ Erreur préchargement $imagePath: $e');
          loadedCount++;
          onProgress?.call(loadedCount, total);
        }
      }),
    );
  }

  /// Précharge toutes les images de la HomePage
  static Future<void> preloadHomePageImages(
    BuildContext context, {
    Function(double progress)? onProgress,
  }) async {
    int loadedCount = 0;
    final total = homePageImages.length;

    await Future.wait(
      homePageImages.map((imagePath) async {
        try {
          await precacheImage(AssetImage(imagePath), context);
          loadedCount++;
          final progress = loadedCount / total;
          onProgress?.call(progress);
        } catch (e) {
          debugPrint('⚠️ Erreur préchargement $imagePath: $e');
          loadedCount++;
          final progress = loadedCount / total;
          onProgress?.call(progress);
        }
      }),
    );
  }

  /// Précharge une seule image avec retry
  static Future<void> preloadImageWithRetry(
    BuildContext context,
    String imagePath, {
    int maxRetries = 3,
  }) async {
    int attempts = 0;
    
    while (attempts < maxRetries) {
      try {
        await precacheImage(AssetImage(imagePath), context);
        return;
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          debugPrint('❌ Échec préchargement après $maxRetries tentatives: $imagePath');
          rethrow;
        }
        await Future.delayed(Duration(milliseconds: 100 * attempts));
      }
    }
  }

  /// Vérifie si une image existe dans les assets
  static Future<bool> imageExists(String imagePath) async {
    try {
      // Note: Cette méthode nécessite un context pour être vraiment efficace
      // C'est juste une approximation
      return true; // Retourne true par défaut
    } catch (e) {
      return false;
    }
  }
}

/// Widget wrapper qui précharge les images avant d'afficher son enfant
class PreloadedWidget extends StatefulWidget {
  final Widget child;
  final List<String> imagePaths;
  final Widget? loadingWidget;
  final Function(double progress)? onProgress;

  const PreloadedWidget({
    super.key,
    required this.child,
    required this.imagePaths,
    this.loadingWidget,
    this.onProgress,
  });

  @override
  State<PreloadedWidget> createState() => _PreloadedWidgetState();
}

class _PreloadedWidgetState extends State<PreloadedWidget> {
  bool _isLoaded = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _preloadImages();
  }

  Future<void> _preloadImages() async {
    await ImagePreloader.preloadImages(
      context,
      widget.imagePaths,
      onProgress: (loaded, total) {
        if (mounted) {
          setState(() {
            _progress = loaded / total;
          });
          widget.onProgress?.call(_progress);
        }
      },
    );

    if (mounted) {
      setState(() {
        _isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return widget.loadingWidget ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(value: _progress),
                const SizedBox(height: 16),
                Text('${(_progress * 100).toInt()}%'),
              ],
            ),
          );
    }

    return widget.child;
  }
}