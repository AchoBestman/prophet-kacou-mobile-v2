import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:prophet_kacou/core/models/sermon_model.dart';
import 'package:prophet_kacou/features/sermons/services/sermon_service.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';

class SermonDetailPage extends StatefulWidget {
  final Sermon? sermon;

  const SermonDetailPage({super.key, this.sermon});

  @override
  State<SermonDetailPage> createState() => _SermonDetailPageState();
}

class _SermonDetailPageState extends State<SermonDetailPage> {
  final SermonService _service = SermonService();
  Sermon? _fullSermon;
  bool _isLoading = true;
  String? _currentVerseNumber;
  final Map<int, GlobalKey> _verseKeys = {};
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _loadSermonWithVerses();
  }



  Future<void> _loadSermonWithVerses() async {
    if (widget.sermon == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final sermon = await _service.findBy(
        'fr-fr',
        column: 'number',
        value: widget.sermon!.number,
      );
print("""sermon loaded: ${1}""");
print(sermon);
      setState(() {
        _fullSermon = sermon;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement du sermon: $e');
      setState(() => _isLoading = false);
    }
  }

  void _navigateToVerse(int sermonNumber, int verseNumber) {
    // Navigation vers un autre sermon/verset
    // À implémenter selon votre logique
    print('Navigate to sermon $sermonNumber, verse $verseNumber');
  }

  void _scrollToVerse(int verseNumber) {
    final key = _verseKeys[verseNumber];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return MainLayout(
        title: widget.sermon?.title ?? 'Sermon',
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_fullSermon == null) {
      return MainLayout(
        title: 'Sermon',
        body: const Center(
          child: Text('Aucun sermon sélectionné'),
        ),
      );
    }

    return MainLayout(
      title: _fullSermon!.title,
      actions: [
        // Bouton zoom out
        IconButton(
          icon: const Icon(Icons.remove, color: Colors.white),
          onPressed: () {
            setState(() {
              if (_fontSize > 12) _fontSize -= 2;
            });
          },
        ),
        // Bouton zoom in
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            setState(() {
              if (_fontSize < 24) _fontSize += 2;
            });
          },
        ),
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image du sermon (début si number != 9)
              // if (_fullSermon!.image != null && _fullSermon!.number != 9)
              //   Center(
              //     child: Image.network(
              //       _fullSermon!.image!,
              //       width: double.infinity,
              //       fit: BoxFit.cover,
              //       errorBuilder: (context, error, stackTrace) {
              //         return const SizedBox.shrink();
              //       },
              //     ),
              //   ),
              const SizedBox(height: 16),

              // Liste des versets
              if (_fullSermon!.verses != null)
                ..._fullSermon!.verses!.asMap().entries.map((entry) {
                  final index = entry.key;
                  final verse = entry.value;
                  final key = GlobalKey();
                  _verseKeys[verse.number] = key;

                  final isCurrentVerse =
                      _currentVerseNumber == verse.number.toString();
                  final hasBackground = isCurrentVerse && verse.number > 1;

                  return Container(
                    key: key,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    color: hasBackground
                        ? (isDark ? Colors.yellow[700] : Colors.blue[600])
                        : Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titre du verset (si existe)
                        if (verse.title != null && verse.title!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              verse.title!,
                              style: TextStyle(
                                fontSize: _fontSize + 2,
                                fontWeight: FontWeight.bold,
                                color: hasBackground
                                    ? (isDark ? Colors.black : Colors.white)
                                    : theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                          ),

                        // Numéro et contenu du verset
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Numéro du verset
                            Text(
                              '${verse.number} ',
                              style: TextStyle(
                                fontSize: _fontSize,
                                fontWeight: FontWeight.bold,
                                color: hasBackground
                                    ? (isDark ? Colors.black : Colors.white)
                                    : (isDark ? Colors.red : Colors.red[700]),
                              ),
                            ),
                            // Contenu HTML du verset
                            Expanded(
                              child: Html(
                                data: verse.content,
                                style: {
                                  "body": Style(
                                    fontSize: FontSize(_fontSize),
                                    margin: Margins.zero,
                                    padding: HtmlPaddings.zero,
                                    color: hasBackground
                                        ? (isDark
                                            ? Colors.black
                                            : Colors.white)
                                        : theme.textTheme.bodyLarge?.color,
                                  ),
                                  "p": Style(
                                    margin: Margins.zero,
                                    padding: HtmlPaddings.zero,
                                  ),
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Concordances
                        if (verse.concordances != null &&
                            verse.concordances!.concordance.isEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: verse.concordances!.concordance.map((concordance) {
                              return InkWell(
                                onTap: () {
                                  _navigateToVerse(
                                    concordance.sermonNumber,
                                    concordance.verseNumber,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.blue[900]
                                        : Colors.blue[100],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    concordance.label,
                                    style: TextStyle(
                                      fontSize: _fontSize - 2,
                                      color: isDark
                                          ? Colors.blue[200]
                                          : Colors.blue[800],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                        const Divider(height: 24),
                      ],
                    ),
                  );
                }),

              // Sermons similaires
              if (_fullSermon!.similarSermon != null &&
                  _fullSermon!.similarSermon!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Html(
                    data: _fullSermon!.similarSermon!,
                    style: {
                      "body": Style(
                        fontSize: FontSize(_fontSize),
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    },
                  ),
                ),

              // Image du sermon (fin si number == 9)
            //  if (_fullSermon!.image != null && _fullSermon!.number == 9)
            //     Center(
            //       child: Image.network(
            //         _fullSermon!.image!,
            //         width: double.infinity,
            //         fit: BoxFit.cover,
            //         errorBuilder: (context, error, stackTrace) {
            //           return const SizedBox.shrink();
            //          },
            //       ),
            //     ),
            ],
          ),
        ),
      ),
    );
  }
}