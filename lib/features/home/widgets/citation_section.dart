import 'package:flutter/material.dart';
import 'package:prophet_kacou/app/device_config.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/i18n/i18n.dart';

class CitationSection extends StatelessWidget {
  const CitationSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Configuration selon le type d'écran
    final config = getConfig(context);

    return Container(
      margin: EdgeInsets.only(top: config.topMargin),
      padding: EdgeInsets.only(
        left: config.horizontalPadding,
        right: config.horizontalPadding,
        top: config.topPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(blue: 1),
        borderRadius: BorderRadius.circular(config.borderRadius),
      ),
      child: Column(
        children: [
          Text(
            '❝ ${i18n.tr('home.image_message')}❞',
            textAlign: TextAlign.left,
            softWrap: true,
            style: TextStyle(
              color: pkpIndigo,
              fontSize: config.textFontSize,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          SizedBox(height: config.spacing),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '1Cor 2:4, 1Cor 4:20',
              style: TextStyle(
                color: const Color(0xFF1565C0),
                fontWeight: FontWeight.bold,
                fontSize: config.referenceFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
