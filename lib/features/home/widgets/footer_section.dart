import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/utils/extensions.dart';
import 'package:prophet_kacou/i18n/i18n.dart';

class FooterSection extends StatelessWidget {
  final double height;

  const FooterSection({
    super.key,
    this.height = 0.070, // ratio par défaut (6,5% de la hauteur d’écran)
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * height,
      width: double.infinity,
      color: pkpIndigo, // ta couleur principale
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'mat25v6.msg@gmail.com',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: () => openLink(
              'https://www.iubenda.com/privacy-policy/84576984',
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: const BorderSide(
                  color: Color(0xFFFFAB40),
                  width: 1.0,
                ),
              ),
            ),
            child: Text(
              i18n.tr('home.confidentiality_clause'),
              style: const TextStyle(
                color: Color(0xFFFFAB40),
                fontSize: 14,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}