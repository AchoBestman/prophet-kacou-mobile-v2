import 'dart:developer';
import 'dart:ui' as flutter_html;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:prophet_kacou/core/models/play_mode.dart';
import 'package:prophet_kacou/core/models/sermon.dart';
import 'package:prophet_kacou/core/repositories/sermon.dart';
import 'package:prophet_kacou/core/utils/formatters.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';
import 'package:prophet_kacou/core/models/audio_item.dart';
import 'package:prophet_kacou/app/themes/app_theme.dart';
import 'package:prophet_kacou/shared/widgets/display_concordance.dart';
import 'package:prophet_kacou/shared/widgets/display_image.dart';
import 'package:prophet_kacou/shared/widgets/pdf_widget.dart';
import 'package:prophet_kacou/shared/widgets/play_download_share_button.dart';
import 'package:prophet_kacou/shared/widgets/verse_links_widget.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class SermonDetailPage extends StatefulWidget {
  final int sermonNumber;
  final int? verseNumber; // ✅ Nouveau paramètre optionnel
  static const routeName = '/sermon_detail';
  
  const SermonDetailPage({
    super.key, 
    required this.sermonNumber,
    this.verseNumber, // ✅ Paramètre optionnel
  });

  @override
  State<SermonDetailPage> createState() => _SermonDetailPageState();
}

class _SermonDetailPageState extends State<SermonDetailPage> {
  final SermonRepository _repository = SermonRepository();
  Sermon? _sermon;
  bool _isLoading = true;
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // ✅ Contrôleur de scroll
  final Map<int, GlobalKey> _verseKeys = {}; // ✅ Clés pour chaque verset

  @override
  void initState() {
    super.initState();
    _loadSermon();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose(); // ✅ Dispose du contrôleur
    super.dispose();
  }

  Future<void> _loadSermon() async {
    try {
      final sermon = await _repository.findByNumber(widget.sermonNumber, i18n.lang);
      setState(() {
        _sermon = sermon;
        _isLoading = false;
      });
      
      // ✅ Scroll vers le verset si spécifié
      if (widget.verseNumber != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToVerse(widget.verseNumber!);
        });
      }
    } catch (e) {
      log('Erreur lors du chargement du sermon : $e');
      setState(() => _isLoading = false);
    }
  }

  // ✅ Nouvelle méthode pour scroller vers le verset
  void _scrollToVerse(int verseNumber) {
    Future.delayed(const Duration(milliseconds: 500), () {
      final key = _verseKeys[verseNumber];
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          alignment: 0.15, // Position du verset sur l'écran
        );
      }
    });
  }

  // Méthode pour générer le PDF
  Future<void> _generatePdf(dynamic sermon) async {
    if(mounted){
      generateSermonPdf(context, sermon as Sermon);
    }
  }

  // Méthode pour générer l'EPUB (à implémenter)
  Future<void> _generateEpub(dynamic sermon) async {
    // Implémentation future
    if (mounted) {
      generateSermonEpub(context, sermon as Sermon);
    }
  }

  String _normalizeLineBreaks(String html) {
    // Remplace plusieurs <br> consécutifs par un seul
    String normalized = html.replaceAll(
      RegExp(r'(<br\s*\/?>){2,}', caseSensitive: false),
      '<br>',
    );
    // Remplace plusieurs </p><p> consécutifs par un seul
    normalized = normalized.replaceAll(
      RegExp(r'(<\/p>\s*<p>){2,}', caseSensitive: false),
      '</p><p>',
    );
    return normalized;
  }

  String _highlightText(String text, String query) {
    if (query.isEmpty) return text;
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    if (!lowerText.contains(lowerQuery)) return text;
    final parts = <String>[];
    int start = 0;
    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        parts.add(text.substring(start));
        break;
      }
      parts.add(text.substring(start, index));
      parts.add(
        '<mark style="background-color: #FFA726; color: black;">${text.substring(index, index + query.length)}</mark>',
      );
      start = index + query.length;
    }
    return parts.join('');
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (_isLoading) {
      return MainLayout(
        title: 'Sermon',
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_sermon == null) {
      return MainLayout(
        title: 'Sermon',
        body: const Center(child: Text('Aucun sermon trouvé')),
      );
    }

    return MainLayout(
      title: _sermon!.chapter,
      actions: [
        IconButton(
          icon: Icon(
            _isSearching ? Icons.close : Icons.search,
            color: Colors.white,
          ),
          onPressed: _toggleSearch,
        ),
        if (_sermon!.audio != null && _sermon!.audio!.isNotEmpty)
          FutureBuilder<File>(
            future: localSermonPath(_sermon!, i18n.lang),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }

              final audioItem = AudioItem(
                id: _sermon!.id,
                title: sermonTitleFormatter(_sermon!),
                audioUrl: _sermon!.audio!,
                albumId: null,
                fileOriginalName: null,
                localFullPath: snapshot.data!,
              );

              return PlayDownloadShareButton(
                data: audioItem,
                type: AudioFolder.sermons,
                extension: FileExtension.mp3,
                sourceData: _sermon,
                onGeneratePdf: _generatePdf,
                onGenerateEpub: _generateEpub,
                config: const ButtonConfig(
                  showPlay: true,
                  showDownload: true,
                  showShare: true,
                  iconSize: 24.0,
                  spacing: 4.0,
                  defaultDarkColor: Colors.white,
                  defaultLigthColor: Colors.white,
                  order: [
                    ButtonType.play,
                    ButtonType.download,
                    ButtonType.share,
                  ],
                ),
              );
            },
          ),
      ],
      body: Column(
        children: [
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: i18n.tr('button.search'),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController, // ✅ Contrôleur ajouté
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _sermon!.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: themeProvider.customFont.fontSize + 2,
                      fontWeight: FontWeight.bold,
                      fontFamily: themeProvider.customFont.fontFamily,
                      fontStyle: themeProvider.customFont.fontStyle,
                    ),
                  ),
                  if (_sermon != null && _sermon!.number != 9)
                    displayImage(context, _sermon!),
                  const SizedBox(height: 8),
                  ...?_sermon!.verses?.map((verse) {
                    final verseNumber = verse.number;
                    final verseContent = verse.content;
                    final verseTitle = verse.title;
                    final List<ParsedReference>? concordances = verse.concordances;
                    final List<dynamic>? verseLinks = verse.verseLinks;
                    final fullContent = '$verseNumber $verseContent';
                    
                    final hasMatch = _searchQuery.isNotEmpty &&
                        fullContent.toLowerCase().contains(_searchQuery.toLowerCase());
                    
                    // ✅ Identifier le verset ciblé
                    final isTargetVerse = widget.verseNumber == verseNumber;
                    
                    // ✅ Créer une clé pour ce verset
                    if (!_verseKeys.containsKey(verseNumber)) {
                      _verseKeys[verseNumber] = GlobalKey();
                    }

                    return Container(
                      key: isTargetVerse ? _verseKeys[verseNumber] : null, // ✅ Clé assignée
                      decoration: BoxDecoration(
                        color: isTargetVerse
                            ? (isDark 
                                ? Colors.blue.withOpacity(0.2) 
                                : Colors.blue.withOpacity(0.1))
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (verseTitle != null && verseTitle.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                verseTitle,
                                style: TextStyle(
                                  fontSize: themeProvider.customFont.fontSize + 2,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: themeProvider.customFont.fontFamily,
                                  fontStyle: themeProvider.customFont.fontStyle,
                                  backgroundColor: hasMatch && _searchQuery.isNotEmpty
                                      ? Colors.yellow.withOpacity(0.3)
                                      : null,
                                ),
                              ),
                            ),
                          Html(
                            data: _searchQuery.isEmpty
                                ? '<b>$verseNumber</b> ${_normalizeLineBreaks(verseContent)}'
                                : '<b>${_highlightText(verseNumber.toString(), _searchQuery)}</b> ${_highlightText(_normalizeLineBreaks(verseContent), _searchQuery)}',
                            style: {
                              "body": Style(
                                fontSize: FontSize(themeProvider.customFont.fontSize),
                                fontFamily: themeProvider.customFont.fontFamily,
                                fontStyle: themeProvider.customFont.fontStyle == FontStyle.italic
                                    ? flutter_html.FontStyle.italic
                                    : flutter_html.FontStyle.normal,
                                margin: Margins.zero,
                                padding: HtmlPaddings.zero,
                              ),
                              "b": Style(fontWeight: FontWeight.bold),
                              "p": Style(margin: Margins.only(bottom: 8)),
                            },
                          ),
                          ConcordanceWidget(
                            concordances: concordances,
                            currentSermonNumber: _sermon!.number,
                          ),
                          VerseLinksWidget(
                            verseLinks: verseLinks,
                            sermon: _sermon!,
                          ),
                        ],
                      ),
                    );
                  }),
                  if (_sermon!.similarSermon!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        _sermon!.similarSermon!,
                        style: TextStyle(
                          fontSize: themeProvider.customFont.fontSize + 2,
                          fontWeight: FontWeight.bold,
                          fontFamily: themeProvider.customFont.fontFamily,
                          fontStyle: themeProvider.customFont.fontStyle,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  if (_sermon != null && _sermon!.number == 9)
                    displayImage(context, _sermon!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}