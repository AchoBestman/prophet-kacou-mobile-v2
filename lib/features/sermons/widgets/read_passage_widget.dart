import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/repositories/sermon.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/features/sermons/pages/sermon_detail_page.dart';

class ReadPassageWidget extends StatefulWidget {
  const ReadPassageWidget({super.key});

  @override
  State<ReadPassageWidget> createState() => _ReadPassageWidgetState();
}

class _ReadPassageWidgetState extends State<ReadPassageWidget> {
  final TextEditingController _sermonController = TextEditingController();
  final TextEditingController _verseController = TextEditingController();
  final SermonRepository _repository = SermonRepository();

  bool _isSearching = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _sermonController.text = "1"; // 👈 valeur par défaut
    _verseController.text = "1";  // 👈 verset optionnel
  }

  @override
  void dispose() {
    _sermonController.dispose();
    _verseController.dispose();
    super.dispose();
  }

  Future<void> _searchPassage() async {
    setState(() {
      _errorMessage = null;
      _isSearching = true;
    });

    if (_sermonController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = i18n.tr('home.search_not_found_title');
        _isSearching = false;
      });
      return;
    }

    final sermonNumber = int.tryParse(_sermonController.text.trim());
    final verseNumber = _verseController.text.trim().isEmpty
        ? null
        : int.tryParse(_verseController.text.trim());

    if (sermonNumber == null) {
      setState(() {
        _errorMessage =
            "Kacou $sermonNumber ${i18n.tr('home.search_not_found_pred_message')}";
        _isSearching = false;
      });
      return;
    }

    try {
      final sermon = await _repository.findByNumber(sermonNumber, i18n.lang);

      if (sermon == null) {
        setState(() {
          _errorMessage =
              "Kacou $sermonNumber ${i18n.tr('home.search_not_found_pred_message')}";
          _isSearching = false;
        });
        return;
      }

      if (verseNumber != null) {
        final verseExists =
            sermon?.verses?.any((v) => v.number == verseNumber) ?? false;

        if (!verseExists) {
          setState(() {
            _errorMessage =
                'Kacou $sermonNumber ${i18n.tr('home.search_not_found_vers_message')} $verseNumber';
            _isSearching = false;
          });
          return;
        }
      }

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SermonDetailPage(
              sermonNumber: sermon.number,
              verseNumber: verseNumber,
            ),
          ),
        );
      }

      setState(() => _isSearching = false);
    } catch (e) {
      setState(() {
        _errorMessage = i18n.tr('home.search_not_found_title');
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Champs sur la même ligne
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildNumberField(
                      controller: _sermonController,
                      label: i18n.tr('home.sermon_num'),
                      icon: Icons.menu_book_rounded,
                      isDark: isDark,
                      isRequired: true,
                    ),
                    const SizedBox(height: 12), // espacement vertical
                    _buildNumberField(
                      controller: _verseController,
                      label: i18n.tr('home.verset_num'),
                      icon: Icons.format_list_numbered,
                      isDark: isDark,
                      isRequired: false,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Message d'erreur
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Bouton Search
                ElevatedButton(
                  onPressed: _isSearching ? null : _searchPassage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pkpIndigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isSearching
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              i18n.tr('button.search'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    required bool isRequired,
  }) {

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          // Champ texte
          Expanded(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: label,
                prefixIcon: Icon(
                  icon,
                  color: isDark ? Colors.white : pkpIndigo,
                ),
                // suffixIcon: isRequired
                //     ? const Icon(Icons.star, size: 12, color: Colors.red)
                //     : null,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              onChanged: (_) {
                if (_errorMessage != null) setState(() => _errorMessage = null);
              },
            ),
          ),

          // Bouton decrement
          IconButton(
            icon: Icon(Icons.remove, color: isDark ? Colors.white : pkpIndigo),
            onPressed: () {
              int value = int.tryParse(controller.text) ?? 0;
              if (value > 0) {
                controller.text = (value - 1).toString();
              }
            },
          ),

          // Bouton increment
          IconButton(
            icon: Icon(Icons.add, color: isDark ? Colors.white : pkpIndigo),
            onPressed: () {
              int value = int.tryParse(controller.text) ?? 0;
              controller.text = (value + 1).toString();
            },
          ),
        ],
      ),
    );
  }
}
