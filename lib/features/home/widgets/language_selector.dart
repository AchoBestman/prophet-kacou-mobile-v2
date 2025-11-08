import 'package:flutter/material.dart';
import 'package:prophet_kacou/i18n/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/i18n/langue_model.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final languages = LanguageData.homeLanguages();
    final languageProvider = Provider.of<LanguageProvider>(context);

    // Afficher un loader pendant l'initialisation
    if (!languageProvider.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            children: [
              Text(
                i18n.tr('home.choose_langue'),
                style: TextStyle(
                  color: pkpOcean,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                alignment: WrapAlignment.start,
                children: languages.map((item) {
                  final isSelected = languageProvider.currentLanguage?.lang == item.lang;
                  
                  return InkWell(
                    onTap: () async {
                      await languageProvider.changeLanguage(item);
                    },
                    child: Container(
                      width: 65,
                      height: 45,
                      decoration: BoxDecoration(
                        color: isSelected ? pkpIndigo.withOpacity(0.1) : Colors.white,
                        border: Border.all(
                          color: isSelected ? pkpIndigo : pkpIndigo.withOpacity(0.5),
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: Image.asset(
                            item.icon,
                            width: 56,
                            height: 36,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child: Text(
                                    item.name.substring(0, 2),
                                    style: TextStyle(
                                      color: pkpIndigo,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}