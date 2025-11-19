import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/play_mode.dart';
import 'package:prophet_kacou/core/models/sermon.dart';
import 'package:prophet_kacou/core/models/audio_item.dart';
import 'package:prophet_kacou/core/repositories/sermon.dart';
import 'package:prophet_kacou/core/utils/formatters.dart';
import 'package:prophet_kacou/features/sermons/pages/sermon_detail_page.dart';
import 'package:prophet_kacou/features/sermons/widgets/read_passage_widget.dart'; // ✅ Import ajouté
import 'package:prophet_kacou/features/sermons/widgets/search_passage_widget.dart';
import 'package:prophet_kacou/features/settings/pages/update_button.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';
import 'package:prophet_kacou/shared/widgets/pdf_widget.dart';
import 'package:prophet_kacou/shared/widgets/play_download_share_button.dart';

class SermonsPage extends StatefulWidget {
  const SermonsPage({super.key});

  @override
  State<SermonsPage> createState() => _SermonsPageState();
}

class _SermonsPageState extends State<SermonsPage>
    with SingleTickerProviderStateMixin {
  bool ascending = true;
  String searchQuery = '';
  late TabController _tabController;
  final SermonRepository repository = SermonRepository();

  List<Sermon> sermonsList = [];
  bool isLoading = true;

  // ✅ Clé pour accéder au widget SearchPassageWidget
  final GlobalKey<SearchPassageWidgetState> _searchPassageKey = GlobalKey();

  // ✅ Variable pour stocker la recherche de passage
  String _passageSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSermons();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSermons() async {
    setState(() => isLoading = true);
    try {
      final result = await repository.findAll(
        lang: i18n.lang,
        searchQuery: searchQuery,
        orderBy: 'number ${ascending ? "ASC" : "DESC"}',
      );

      setState(() {
        sermonsList = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _toggleOrder() {
    setState(() {
      ascending = !ascending;
    });
    _loadSermons();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _passageSearchQuery = query;
    });
    _searchPassageKey.currentState?.setSearchQuery(query);
  }

  // Méthode pour générer le PDF
  Future<void> _generatePdf(dynamic sermon) async {
    if (mounted) {
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

  Widget _buildSermonCard(Sermon sermon, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SermonDetailPage(sermonNumber: sermon.number),
          ),
        );
      },
      child: Card(
        color: isDark ? pkpDark : pkpSand,
        margin: const EdgeInsets.symmetric(vertical: 1),
        elevation: 1,
        shape: const RoundedRectangleBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${sermon.chapter}: ${sermon.title}",
                style: TextStyle(
                  fontSize: 15.8,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // 🔹 Boutons en bas à droite
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (sermon.publicationDate != null)
                    Text(
                      sermon.publicationDate!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? pkpOcean : pkpIndigo,
                      ),
                    ),
                  if (sermon.audio != null)
                    FutureBuilder<File>(
                      future: localSermonPath(sermon, i18n.lang),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox.shrink();
                        }

                        final audioItem = AudioItem(
                          id: sermon.id,
                          title: sermonTitleFormatter(sermon),
                          audioUrl: sermon.audio!,
                          albumId: null,
                          fileOriginalName: null,
                          localFullPath: snapshot.data!,
                          content: sermon.title // just to make share pdf available
                        );

                        return PlayDownloadShareButton(
                          data: audioItem,
                          type: AudioFolder.sermons,
                          extension: FileExtension.mp3,
                          sourceData:
                              sermon, // Passer le sermon pour le partage
                          onGeneratePdf: _generatePdf,
                          onGenerateEpub: _generateEpub,
                          config: const ButtonConfig(
                            showPlay: true,
                            showDownload: true,
                            showShare: true,
                            iconSize: 24.0,
                            spacing: 4.0,
                            //defaultDarkColor: pkpOcean,
                            //defaultLigthColor: pkpIndigo,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          MainLayout(
            title: i18n.tr("home.sermon"),
            actions: [
              // 🔍 Recherche
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () async {
                  final query = await showSearch<String>(
                    context: context,
                    delegate: SermonSearchDelegate(onSearch: _onSearchChanged),
                  );
                  if (query != null) {
                    _onSearchChanged(query);
                  }
                },
              ),
              // 🔽 Tri
              IconButton(
                icon: Icon(
                  ascending ? Icons.arrow_downward : Icons.arrow_upward,
                  color: Colors.white,
                ),
                onPressed: _toggleOrder,
              ),
              const UpdateButton(),
            ],
            body: Column(
              children: [
                Container(
                  color: theme.scaffoldBackgroundColor,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: theme.tabBarTheme.labelColor,
                    unselectedLabelColor:
                        theme.tabBarTheme.unselectedLabelColor,
                    indicatorColor: theme.tabBarTheme.indicatorColor,
                    tabs: const [
                      Tab(text: 'SERMONS'),
                      Tab(text: 'READ A PASSAGE'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      RefreshIndicator(
                        onRefresh: _loadSermons,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                padding: const EdgeInsets.all(0),
                                itemCount: sermonsList.length,
                                itemBuilder: (context, index) {
                                  final sermon = sermonsList[index];
                                  return _buildSermonCard(sermon, isDark);
                                },
                              ),
                      ),
                      const ReadPassageWidget(), // ✅ Widget intégré
                      // SearchPassageWidget(
                      //   key: _searchPassageKey,
                      //   initialSearchQuery: _passageSearchQuery,
                      // ),
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
}

/// 🔍 Délégué pour la recherche
class SermonSearchDelegate extends SearchDelegate<String> {
  final Function(String) onSearch;

  SermonSearchDelegate({required this.onSearch});

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        query = '';
        onSearch(query);
      },
    ),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, ''),
  );

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    close(context, query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) => Container();
}
