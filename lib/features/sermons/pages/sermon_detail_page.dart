import 'dart:developer';
import 'dart:ui' as flutter_html;

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:prophet_kacou/core/models/play_mode.dart';
import 'package:prophet_kacou/core/models/sermon.dart';
import 'package:prophet_kacou/core/repositories/download_history_provider.dart';
import 'package:prophet_kacou/core/repositories/sermon.dart';
import 'package:prophet_kacou/core/utils/formatters.dart';
import 'package:prophet_kacou/core/utils/notificaction.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';
import 'package:prophet_kacou/core/providers/audio_player_provider.dart';
import 'package:prophet_kacou/core/models/audio_item.dart';
import 'package:prophet_kacou/app/themes/app_theme.dart';
import 'package:prophet_kacou/shared/widgets/display_concordance.dart';
import 'package:prophet_kacou/shared/widgets/display_image.dart';
import 'package:prophet_kacou/shared/widgets/play_download_share_button.dart';
import 'package:prophet_kacou/shared/widgets/verse_links_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SermonDetailPage extends StatefulWidget {
  final int sermonId;
  static const routeName = '/sermon_detail';
  const SermonDetailPage({super.key, required this.sermonId});

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

  @override
  void initState() {
    super.initState();
    _loadSermon();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSermon() async {
    try {
      final sermon = await _repository.findById(widget.sermonId, i18n.lang);
      setState(() {
        _sermon = sermon;
        _isLoading = false;
      });
    } catch (e) {
      log('Erreur lors du chargement du sermon : $e');
      setState(() => _isLoading = false);
    }
  }

  // Méthode pour générer le PDF
  Future<void> _generatePdf(dynamic sermon) async {
    if (sermon == null || sermon is! Sermon) return;

    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text(
                  sermon.title,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              ...?sermon.verses?.map((verse) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 12),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (verse.title != null)
                        pw.Text(
                          verse.title!,
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                              text: '${verse.number} ',
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.TextSpan(
                              text: verse.content.replaceAll(
                                RegExp(r'<[^>]*>'),
                                '',
                              ),
                              style: const pw.TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ];
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/sermon_${sermon.id}.pdf');
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([XFile(file.path)], text: sermon.title);
    } catch (e) {
      if (mounted) {
        NotificactionService.showErrorMessage(
          context,
          'Erreur lors de la génération du PDF: $e',
        );
      }
    }
  }

  // Méthode pour générer l'EPUB (à implémenter)
  Future<void> _generateEpub(dynamic sermon) async {
    // Implémentation future
    if (mounted) {
      NotificactionService.showSuccessMessage(
        context,
        'Génération EPUB en cours de développement',
      );
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
                fileOriginalName: sermonTitleFormatter(_sermon!),
                localFullPath: snapshot.data!,
              );

              return PlayDownloadShareButton(
                data: audioItem,
                type: AudioFolder.sermons,
                extension: FileExtension.mp3,
                sourceData: _sermon, // Passer le sermon pour le partage
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
                    ButtonType.play, // ✅ Play en premier
                    ButtonType.download, // ✅ Download en deuxième
                    ButtonType.share, // ✅ Partage en dernier
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
                    final List<ParsedReference>? concordances =
                        verse.concordances;
                    final List<dynamic>? verseLinks = verse.verseLinks;
                    final fullContent = '$verseNumber $verseContent';
                    final hasMatch =
                        _searchQuery.isNotEmpty &&
                        fullContent.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (verseTitle != null && verseTitle.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                verseTitle,
                                style: TextStyle(
                                  fontSize:
                                      themeProvider.customFont.fontSize + 2,
                                  fontWeight: FontWeight.bold,
                                  fontFamily:
                                      themeProvider.customFont.fontFamily,
                                  fontStyle: themeProvider.customFont.fontStyle,
                                  backgroundColor:
                                      hasMatch && _searchQuery.isNotEmpty
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
                                fontSize: FontSize(
                                  themeProvider.customFont.fontSize,
                                ),
                                fontFamily: themeProvider.customFont.fontFamily,
                                fontStyle:
                                    themeProvider.customFont.fontStyle ==
                                        FontStyle.italic
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
