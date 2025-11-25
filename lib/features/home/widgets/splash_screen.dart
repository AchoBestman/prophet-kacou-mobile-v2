
import 'package:flutter/material.dart';
import 'package:prophet_kacou/i18n/i18n.dart';

class SplashScreen extends StatelessWidget {
  final double progress;
  
  const SplashScreen({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    // Calculer la taille du cercle basée sur le progrès
    final screenSize = MediaQuery.of(context).size;
    final maxSize = screenSize.width * 0.4; // Taille maximale: 40% de la largeur
    final minSize = screenSize.width * 0.15; // Taille minimale: 15% de la largeur
    final currentSize = minSize + (maxSize - minSize) * progress;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animation du cercle avec l'icône
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: currentSize,
              height: currentSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Cercle de progression
                  SizedBox(
                    width: currentSize,
                    height: currentSize,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 4,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF3F51B5), // pkpIndigo
                      ),
                    ),
                  ),
                  // Icône au centre
                  AnimatedScale(
                    scale: 0.5 + (progress * 0.5), // Scale de 0.5 à 1.0
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      width: currentSize * 0.6,
                      height: currentSize * 0.6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icons/icon.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Texte de chargement
            Text(
              i18n.tr("home.loading"),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),
            // Pourcentage
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}