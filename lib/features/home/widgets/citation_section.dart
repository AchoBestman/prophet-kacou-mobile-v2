import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/i18n/i18n.dart';

class CitationSection extends StatelessWidget {
  const CitationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 8,
        top: 4,
        right: 4,
        bottom: 2
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(blue: 1),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        children: [
          Text(
            '❝ ${i18n.tr('home.image_message')}❞',
            textAlign: TextAlign.left,
            softWrap: true,
            style: TextStyle(
              color: pkpIndigo,
              fontSize: 17,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '1Cor 2:4, 1Cor 4:20',
              style: TextStyle(
                color: const Color(0xFF1565C0),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
