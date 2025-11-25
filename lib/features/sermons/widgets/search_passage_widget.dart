import 'package:flutter/material.dart';
import 'package:prophet_kacou/app/themes/app_theme.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/verse.dart';
import 'package:prophet_kacou/core/repositories/sermon.dart';
import 'package:prophet_kacou/features/sermons/pages/sermon_detail_page.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:provider/provider.dart';

class SearchPassageWidget extends StatefulWidget {
  final String? initialSearchQuery;

  const SearchPassageWidget({super.key, this.initialSearchQuery});

  @override
  State<SearchPassageWidget> createState() => SearchPassageWidgetState();
}

class SearchPassageWidgetState extends State<SearchPassageWidget> {
  final SermonRepository _repository = SermonRepository();

  List<Verse> _verses = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Si le parent envoie une recherche au démarrage
    if (widget.initialSearchQuery?.isNotEmpty == true) {
      _runSearch(widget.initialSearchQuery!);
    }
  }

  @override
  void didUpdateWidget(covariant SearchPassageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Le parent met à jour initialSearchQuery → relancer la recherche
    if (widget.initialSearchQuery != oldWidget.initialSearchQuery) {
      final query = widget.initialSearchQuery ?? '';
      if (query.isEmpty) {
        setState(() {
          _verses = [];
        });
      } else {
        _runSearch(query);
      }
    }
  }

  Future<void> _runSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _verses = [];
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final results = await _repository.findAllVerses(
        lang: i18n.lang,
        searchQuery: query,
        orderBy: '"number" ASC',
      );

      if (mounted) {
        setState(() {
          _verses = results;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<TextSpan> _highlightKeyword(String text, String keyword) {
    if (keyword.isEmpty) return [TextSpan(text: text)];

    final List<TextSpan> spans = [];
    final lower = text.toLowerCase();
    final key = keyword.toLowerCase();

    int start = 0;

    while (true) {
      final index = lower.indexOf(key, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }

      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }

      spans.add(
        TextSpan(
          text: text.substring(index, index + key.length),
          style: const TextStyle(
            //backgroundColor: Colors.yellow,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
      );

      start = index + key.length;
    }

    return spans;
  }

  Widget _buildVerseItem(Verse verse, bool isDark) {
    final keyword = widget.initialSearchQuery ?? '';
    final themeProvider = Provider.of<ThemeProvider>(context);

    return InkWell(
      onTap: () {
        if (verse.sermonNumber != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SermonDetailPage(
                sermonNumber: verse.sermonNumber as int, // 👈 important
                verseNumber: verse.number,
              ),
            ),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kc.${verse.sermonNumber}:${verse.number}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.lightBlue : pkpIndigo,
                  fontSize: themeProvider.customFont.fontSize + 2,
                  fontFamily: themeProvider.customFont.fontFamily,
                  fontStyle: themeProvider.customFont.fontStyle,
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: themeProvider.customFont.fontSize,
                    fontFamily: themeProvider.customFont.fontFamily,
                    fontStyle: themeProvider.customFont.fontStyle,
                    height: 1.4,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  children: _highlightKeyword(verse.content, keyword),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final query = widget.initialSearchQuery ?? '';

    return Column(
      children: [
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _verses.isEmpty
              ? Center(
                  child: Text(
                    query.isEmpty
                        ? i18n.tr("home.enter_keyword_to_search")
                        : i18n.tr("table.no_result"),
                    style: TextStyle(
                      fontSize: themeProvider.customFont.fontSize,
                      fontFamily: themeProvider.customFont.fontFamily,
                      fontStyle: themeProvider.customFont.fontStyle,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _verses.length,
                  itemBuilder: (_, i) => _buildVerseItem(_verses[i], isDark),
                ),
        ),
      ],
    );
  }
}
