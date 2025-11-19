import 'package:flutter/material.dart';
import 'package:prophet_kacou/app/device_config.dart';
import 'package:prophet_kacou/features/home/widgets/citation_section.dart';
import 'package:prophet_kacou/features/home/widgets/top_text_section.dart';

class BodySection extends StatelessWidget {
  const BodySection({super.key});

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Déterminer le type d'écran
    final DeviceType deviceType = getDeviceType(screenWidth, screenHeight);
    
    // Configuration selon le type d'écran
    final config = getConfig(deviceType);
    
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(0),
        width: double.infinity,
        decoration:  BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/2000X3000.png"),
            fit: BoxFit.cover,
            alignment: Alignment(0, config.imageAlignment),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            children: [
              TopTextSection(),
              Spacer(),
              CitationSection(),
              Spacer(flex: 3),
              // ShareLinkSection()
              ],
          ),
        ),
      ),
    );
  }
}
