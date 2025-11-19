import 'package:flutter/material.dart';
import 'package:prophet_kacou/app/device_config.dart';
import 'package:prophet_kacou/i18n/i18n.dart';

class TopTextSection extends StatelessWidget {
  const TopTextSection({super.key});

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // Déterminer le type d'écran
    final DeviceType deviceType = getDeviceType(screenWidth, screenHeight);
    
    // Configuration selon le type d'écran
    final config = getConfig(deviceType);
    
    return Padding(
      padding: EdgeInsets.only(
        top: config.imageTopTitleMargin,
        right: 85,
      ), // ajoute un padding gauche si nécessaire
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // 👈 aligne la colonne à gauche
        children: [
          Text(
            i18n.tr('home.first_image_title'),
            style: const TextStyle(
              color: Color(0xFFFFF59D),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left, // 👈 texte aligné à gauche
          ),
          const SizedBox(height: 0),
          Text(
            i18n.tr('home.second_image_title'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 0),
          Text(
            i18n.tr('home.third_image_title'),
            style: const TextStyle(
              color: Color(0xFFFFB300),
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.7,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
