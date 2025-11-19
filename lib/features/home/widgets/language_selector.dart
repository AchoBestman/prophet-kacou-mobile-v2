import 'package:flutter/material.dart';
import 'package:prophet_kacou/i18n/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/i18n/langue_model.dart';
import 'package:share_plus/share_plus.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final languages = LanguageData.homeLanguages();
    final languageProvider = Provider.of<LanguageProvider>(context);

    Future<void> shareLink() async {
      await Share.shareUri(
        Uri.https('philippekacou.org')
      );
    }

    // Afficher un loader pendant l'initialisation
    if (!languageProvider.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.only(bottom: 0),
          child: Column(
            children: [
              Text(
                i18n.tr('home.choose_langue'),
                style: TextStyle(
                  color: pkpOcean,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 1),
              Wrap(
                spacing: 4,
                runSpacing: 3,
                alignment: WrapAlignment.start,
                children: languages.map((item) {
                  final isSelected =
                      languageProvider.currentLanguage?.lang == item.lang;

                  return InkWell(
                    onTap: () async {
                      await languageProvider.changeLanguage(item);
                      if (context.mounted) {
                        Future.microtask(() {
                          if (item.icon == "langues") {
                            Navigator.pushReplacementNamed(context, '/langues');
                            return;
                          }
                          if (item.icon == "share") {
                            shareLink();
                          } else {
                            Navigator.pushReplacementNamed(context, '/sermons');
                          }
                        });
                      }
                    },
                    child: Container(
                      width: item.icon != "langues" && item.icon != "share"
                          ? 60
                          : 70,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? pkpIndigo.withOpacity(0.1)
                            : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? pkpIndigo
                              : pkpIndigo.withOpacity(0.5),
                          width: isSelected ? 0 : 1,
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
                            width: 53,
                            height: 33,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 65,
                                height: 33,
                                color: const Color.fromARGB(255, 3, 42, 70),
                                child: Center(
                                  child: Text(
                                    item.icon != "langues" &&
                                            item.icon != "share"
                                        ? item.name.substring(0, 2)
                                        : item.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
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
