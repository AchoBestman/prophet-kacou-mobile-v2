import 'package:flutter/material.dart';
import 'package:prophet_kacou/features/home/widgets/citation_section.dart';
import 'package:prophet_kacou/features/home/widgets/share_link_section.dart';
import 'package:prophet_kacou/features/home/widgets/top_text_section.dart';

class BodySection extends StatelessWidget {
  const BodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/2000X3000.png"),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              TopTextSection(),
              Spacer(),
              CitationSection(),
              Spacer(),
              ShareLinkSection()
              ],
          ),
        ),
      ),
    );
  }
}
