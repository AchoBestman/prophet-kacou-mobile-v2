import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/play_mode.dart';
import 'package:prophet_kacou/core/models/sermon.dart';
import 'package:prophet_kacou/core/models/audio_item.dart';
import 'package:prophet_kacou/core/repositories/sermon.dart';
import 'package:prophet_kacou/core/repositories/download_history_provider.dart';
import 'package:prophet_kacou/core/providers/audio_player_provider.dart';
import 'package:prophet_kacou/core/utils/formatters.dart';
import 'package:prophet_kacou/core/utils/notificaction.dart';
import 'package:prophet_kacou/features/sermons/pages/sermon_detail_page.dart';
import 'package:prophet_kacou/features/settings/pages/update_button.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';
import 'package:prophet_kacou/shared/widgets/pdf_widget.dart';
import 'package:prophet_kacou/shared/widgets/play_download_share_button.dart';
import 'package:provider/provider.dart';

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
      searchQuery = query;
    });
    _loadSermons();
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
  
  Widget _buildSermonCard(Sermon sermon, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SermonDetailPage(sermonId: sermon.id),
          ),
        );
      },
      child: Card(
        color: isDark ? pkpDark : pkpSand,
        margin: const EdgeInsets.symmetric(vertical: 1),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Ligne du haut : Chapter et Publication Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sermon.chapter,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: (isDark ? Colors.lightBlue : Colors.blue),
                    ),
                  ),
                  if (sermon.publicationDate != null)
                    Text(
                      sermon.publicationDate!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.lightBlue : Colors.blue,
                      ),
                    ),
                ],
              ),

              // 🔹 Titre du sermon
              Text(
                sermon.title,
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // 🔹 Boutons en bas à droite
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                        );

                        return PlayDownloadShareButton(
                          data: audioItem,
                          type: AudioFolder.sermons,
                          extension: FileExtension.mp3,
                          sourceData:sermon, // Passer le sermon pour le partage
                          onGeneratePdf: _generatePdf,
                          onGenerateEpub: _generateEpub,
                          config: const ButtonConfig(
                            showPlay: true,
                            showDownload: true,
                            showShare: true,
                            iconSize: 24.0,
                            spacing: 4.0,
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
            title: i18n.tr("home.sermons"),
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
                      Container(
                        alignment: Alignment.center,
                        child: const Text("No passage selected yet."),
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
