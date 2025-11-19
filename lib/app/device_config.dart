
enum DeviceType {
  verySmall,      // < 360px
  iphoneSESize,   // ~375px, ratio faible
  medium,         // 360-399px
  iphonePlusSize, // >= 400px, ratio élevé (iPhone 16 Plus)
  tablet,         // >= 600px
}

class ResponsiveConfig {
  final double topMargin;
  final double horizontalPadding;
  final double topPadding;
  final double borderRadius;
  final double textFontSize;
  final double referenceFontSize;
  final double spacing;
  final double imageAlignment;
  final double imageTopTitleMargin;

  ResponsiveConfig({
    required this.topMargin,
    required this.horizontalPadding,
    required this.topPadding,
    required this.borderRadius,
    required this.textFontSize,
    required this.referenceFontSize,
    required this.spacing,
    required this.imageAlignment,
    required this.imageTopTitleMargin
  });
}

DeviceType getDeviceType(double width, double height) {
    final aspectRatio = height / width;
    
    // Tablette (iPad, Galaxy Tab, etc.)
    if (width >= 600) {
      return DeviceType.tablet;
    }
    
    // iPhone 16 Plus et similaires (très grands écrans)
    // iPhone 16 Plus: 430 x 932 (ratio ~2.17)
    if (width >= 400 && aspectRatio >= 2.1) {
      return DeviceType.iphonePlusSize;
    }
    
    // iPhone SE et petits écrans (ratio élevé, largeur petite)
    // iPhone SE: 375 x 667 (ratio ~1.78)
    if (width <= 380 && aspectRatio <= 1.85) {
      return DeviceType.iphoneSESize;
    }
    
    // Très petits écrans
    if (width < 360) {
      return DeviceType.verySmall;
    }
    
    // Écrans moyens (iPhone 13/14/15 standard, etc.)
    return DeviceType.medium;
  }

  ResponsiveConfig getConfig(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.iphonePlusSize:
        // Configuration par défaut (iPhone 16 Plus)
        return ResponsiveConfig(
          topMargin: 120,
          horizontalPadding: 10,
          topPadding: 4,
          borderRadius: 8,
          textFontSize: 18,
          referenceFontSize: 14,
          spacing: 12,
          imageAlignment: 1.5,
          imageTopTitleMargin: 30
        );
        
      case DeviceType.iphoneSESize:
        // iPhone SE - ajusté proportionnellement
        return ResponsiveConfig(
          topMargin: 120,
          horizontalPadding: 10,
          topPadding: 4,
          borderRadius: 8,
          textFontSize: 17,
          referenceFontSize: 14,
          spacing: 10,
          imageAlignment: -0.5,
          imageTopTitleMargin: 25
        );

      case DeviceType.tablet:
        // Tablettes - plus d'espace
        return ResponsiveConfig(
          topMargin: 550,
          horizontalPadding: 100,
          topPadding: 0,
          borderRadius: 12,
          textFontSize: 22,
          referenceFontSize: 16,
          spacing: 16,
          imageAlignment: -0.5,
          imageTopTitleMargin: 55
        );
      
      case DeviceType.verySmall:
        // Très petits écrans - compacté
        return ResponsiveConfig(
          topMargin: 80,
          horizontalPadding: 6,
          topPadding: 2,
          borderRadius: 6,
          textFontSize: 14,
          referenceFontSize: 11,
          spacing: 8,
          imageAlignment: -1,
          imageTopTitleMargin: 18
        );
        
      case DeviceType.medium:
        //valeur de mon phone et Écrans moyens - légèrement réduit par rapport à Plus
        return ResponsiveConfig(
          topMargin: 100,
          horizontalPadding: 10,
          topPadding: 4,
          borderRadius: 8,
          textFontSize: 17,
          referenceFontSize: 13,
          spacing: 12,
          imageAlignment: 4,
          imageTopTitleMargin: 30
        );
    }
  }