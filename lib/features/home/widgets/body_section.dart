import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/features/home/widgets/citation_section.dart';
import 'package:prophet_kacou/features/home/widgets/top_text_section.dart';

class BodySection extends StatelessWidget {
  const BodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          /// ----------- IMAGE DU HAUT + TEXTES PAR DESSUS -----------------
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(blue: 1),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
                  child: Image.asset(
                    "assets/icons/philippe.png",
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              /// Les écritures sur TOP START
              Padding(
                padding: const EdgeInsets.only(top: 0, left: 29),
                child: TopTextSection(),
              ),
            ],
          ),

          /// ----------- SECTION CITATION + IMAGE BAS (50% / 50%) ----------
          Expanded(
            child: Column(
              children: [
                /// 50% : Citation
                Expanded(
                  flex: 2,
                  child: CitationSection(),
                ),

                /// 50% : Image bas + couleur de fond pkIndigo
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    color: pkpIndigo,
                    child: Image.asset(
                      "assets/icons/sea.png",
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
