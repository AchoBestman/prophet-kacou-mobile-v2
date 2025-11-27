import 'package:flutter/material.dart';

enum DeviceType {
  verySmall, // < 360px
  iphoneSESize, // ~375px, ratio faible
  medium, // 360-399px
  iphonePlusSize, // >= 400px, ratio élevé (iPhone 16 Plus)
  tablet, // >= 600px
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
  final double flagDefaultSize;
  final double flagSpacing;
  final double flagRunSpacing;

  ResponsiveConfig({
    required this.topMargin,
    required this.horizontalPadding,
    required this.topPadding,
    required this.borderRadius,
    required this.textFontSize,
    required this.referenceFontSize,
    required this.spacing,
    required this.imageAlignment,
    required this.imageTopTitleMargin,
    required this.flagDefaultSize,
    required this.flagSpacing,
    required this.flagRunSpacing,
  });
}

DeviceType getDeviceType(double width, double height) {
  final ratio = height / width;

  // TABLETS
  if (width >= 600) return DeviceType.tablet;

  // LARGE PHONES (Plus, Pro Max)
  if (width >= 410 && ratio >= 2.0) return DeviceType.iphonePlusSize;

  // small
  if (height <= 700) {
    return DeviceType.verySmall;
  }

  // SE
  if (width <= 360 || (width <= 380 && ratio <= 1.9)) {
    return DeviceType.iphoneSESize;
  }

  // Normal phones
  return DeviceType.medium;
}

ResponsiveConfig getConfig(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  final DeviceType deviceType = getDeviceType(screenWidth, screenHeight);
  final aspectRatio = screenHeight / screenWidth;
  print(
    "width: $screenWidth; height: $screenHeight; aspectRatio: $aspectRatio; deviceType: $deviceType",
  );

  switch (deviceType) {
    case DeviceType.iphonePlusSize:
      // Configuration par défaut (iPhone 16 Plus)
      return ResponsiveConfig(
        topMargin: 160,
        horizontalPadding: 23,
        topPadding: 4,
        borderRadius: 8,
        textFontSize: 18,
        referenceFontSize: 14,
        spacing: 12,
        imageAlignment: 0.5,
        imageTopTitleMargin: 30,
        flagDefaultSize: 32,
        flagSpacing: 2,
        flagRunSpacing:5,
      );

    case DeviceType.iphoneSESize:
      // iPhone SE - ajusté proportionnellement
      return ResponsiveConfig(
        topMargin: 100,
        horizontalPadding: 20,
        topPadding: 4,
        borderRadius: 8,
        textFontSize: 17,
        referenceFontSize: 14,
        spacing: 2,
        imageAlignment: 1.7,
        imageTopTitleMargin: 35,
        flagDefaultSize: 32,
        flagSpacing: 6,
        flagRunSpacing: 4,
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
        imageTopTitleMargin: 55,
        flagDefaultSize: 33,
        flagSpacing: 4,
        flagRunSpacing: 3,
      );

    case DeviceType.verySmall:
      // Très petits écrans - compacté
      return ResponsiveConfig(
        topMargin: 120,
        horizontalPadding: 20,
        topPadding: 8,
        borderRadius: 6,
        textFontSize: 14,
        referenceFontSize: 11,
        spacing: 4,
        imageAlignment: -0.5,
        imageTopTitleMargin: 18,
        flagDefaultSize: 32,
        flagSpacing: 5,
        flagRunSpacing: 4,
      );

    case DeviceType.medium:
      //valeur de mon phone et Écrans moyens - légèrement réduit par rapport à Plus
      return ResponsiveConfig(
        topMargin:  130,
        horizontalPadding: 33,
        topPadding: 4,
        borderRadius: 8,
        textFontSize: 17,
        referenceFontSize: 13,
        spacing: 4,
        imageAlignment: 0,
        imageTopTitleMargin: 30,
        flagDefaultSize: 35,
        flagSpacing: 8,
        flagRunSpacing: 4,
      );
  }
}
