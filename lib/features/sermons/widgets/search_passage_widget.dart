// Fichier modifié: lib/features/sermons/widgets/search_passage_widget.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prophet_kacou/core/models/verse.dart';
import 'package:prophet_kacou/core/repositories/sermon.dart';
import 'package:prophet_kacou/i18n/i18n.dart';

class SearchPassageWidget extends StatefulWidget {
  final String? initialSearchQuery;
  
  const SearchPassageWidget({
    super.key,
    this.initialSearchQuery,
  });

  @override
  State<SearchPassageWidget> createState() => SearchPassageWidgetState();
}

class SearchPassageWidgetState extends State<SearchPassageWidget> {
  final TextEditingController _searchController = TextEditingController();
  final SermonRepository _repository = SermonRepository();
  
  List<Verse> _verses = [];
  bool _isLoading = false;
  String _searchQuery = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    
    // Si une requête initiale est fournie, l'utiliser
    if (widget.initialSearchQuery != null && widget.initialSearchQuery!.isNotEmpty) {
      _searchController.text = widget.initialSearchQuery!;
      _searchQuery = widget.initialSearchQuery!;
      // Lancer la recherche immédiatement
      Future.delayed(Duration.zero, () {
        _searchVerses(widget.initialSearchQuery!);
      });
    }
  }

  @override
  void didUpdateWidget(SearchPassageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Si la requête initiale change, mettre à jour le champ et rechercher
    if (widget.initialSearchQuery != oldWidget.initialSearchQuery &&
        widget.initialSearchQuery != null &&
        widget.initialSearchQuery!.isNotEmpty) {
      _searchController.text = widget.initialSearchQuery!;
      _searchQuery = widget.initialSearchQuery!;
      _searchVerses(widget.initialSearchQuery!);
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    // Annuler le timer précédent s'il existe
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    final query = _searchController.text.trim();
    
    // Si le champ est vide, réinitialiser immédiatement
    if (query.isEmpty) {
      setState(() {
        _searchQuery = '';
        _verses = [];
        _isLoading = false;
      });
      return;
    }

    // Créer un nouveau timer de 3 secondes
    _debounce = Timer(const Duration(seconds: 3), () {
      if (query != _searchQuery) {
        setState(() {
          _searchQuery = query;
        });
        _searchVerses(query);
      }
    });
  }

  Future<void> _searchVerses(String query) async {
    if (query.isEmpty) {
      setState(() {
        _verses = [];
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _repository.findAllVerses(
        lang: i18n.lang,
        searchQuery: query,
        orderBy: 'sermon_number ASC, number ASC',
      );

      if (mounted) {
        setState(() {
          _verses = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching verses: $e')),
        );
      }
    }
  }

  // Méthode publique pour définir la recherche depuis l'extérieur
  void setSearchQuery(String query) {
    _searchController.text = query;
    _searchQuery = query;
    if (query.isNotEmpty) {
      _searchVerses(query);
    } else {
      setState(() {
        _verses = [];
      });
    }
  }

  // Méthode pour mettre en évidence le mot-clé dans le texte
  List<TextSpan> _highlightKeyword(String text, String keyword) {
    if (keyword.isEmpty) {
      return [TextSpan(text: text)];
    }

    final List<TextSpan> spans = [];
    final lowerText = text.toLowerCase();
    final lowerKeyword = keyword.toLowerCase();
    int start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerKeyword, start);
      if (index == -1) {
        // Ajouter le reste du texte
        if (start < text.length) {
          spans.add(TextSpan(text: text.substring(start)));
        }
        break;
      }

      // Ajouter le texte avant le mot-clé
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }

      // Ajouter le mot-clé en surbrillance
      spans.add(
        TextSpan(
          text: text.substring(index, index + keyword.length),
          style: const TextStyle(
            backgroundColor: Colors.yellow,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      start = index + keyword.length;
    }

    return spans;
  }

  Widget _buildVerseItem(Verse verse, bool isDark) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Référence du verset : Kc.sermonId:verse.number
            Text(
              'Kc.${verse.sermonId}:${verse.number}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDark ? Colors.lightBlue : Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            // Contenu du verset avec mise en évidence du mot-clé
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white : Colors.black87,
                  height: 1.4,
                ),
                children: _highlightKeyword(verse.content, _searchQuery),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Champ de recherche
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search verses...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                          _verses = [];
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
            ),
          ),
        ),

        // Indicateur de chargement ou résultats
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _verses.isEmpty
                  ? Center(
                      child: Text(
                        _searchQuery.isEmpty
                            ? 'Enter a keyword to search verses'
                            : 'No verses found',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _verses.length,
                      itemBuilder: (context, index) {
                        return _buildVerseItem(_verses[index], isDark);
                      },
                    ),
        ),
      ],
    );
  }
}