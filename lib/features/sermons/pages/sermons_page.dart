import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/play_mode.dart';
import 'package:prophet_kacou/core/models/sermon.dart';
import 'package:prophet_kacou/core/models/audio_item.dart';
import 'package:prophet_kacou/core/providers/audio_player_provider.dart';
import 'package:prophet_kacou/core/repositories/download_history_provider.dart';
import 'package:prophet_kacou/core/repositories/sermon.dart';
import 'package:prophet_kacou/core/utils/app_data_updates.dart';
import 'package:prophet_kacou/core/utils/formatters.dart';
import 'package:prophet_kacou/features/sermons/pages/sermon_detail_page.dart';
import 'package:prophet_kacou/features/sermons/widgets/read_passage_widget.dart';
import 'package:prophet_kacou/features/sermons/widgets/search_passage_widget.dart';
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
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool ascending = true;
  String searchQuery = '';
  late TabController _tabController;
  final SermonRepository repository = SermonRepository();

  List<Sermon> sermonsList = [];
  bool isLoading = false; // ✅ Changé à false par défaut
  bool isInitialLoad = true; // ✅ Nouveau flag pour le premier chargement

  String lastSearchQuery = '';

  @override
  bool get wantKeepAlive => true; // ✅ Garder l'état de la page en vie

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // ✅ Charger les données en arrière-plan après le build initial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSermons();
      availableServerLanguesUpdates("en-en");
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSermons() async {
    // ✅ Ne montrer le loading que si c'est le premier chargement
    if (isInitialLoad) {
      setState(() => isLoading = true);
    }

    try {
      final result = await repository.findAll(
        lang: i18n.lang,
        searchQuery: searchQuery,
        orderBy: 'number ${ascending ? "ASC" : "DESC"}',
      );

      if (mounted) {
        setState(() {
          sermonsList = result;
          isLoading = false;
          isInitialLoad = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          isInitialLoad = false;
        });
      }
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
      lastSearchQuery = query;
    });
  }

  Future<void> _generatePdf(dynamic sermon) async {
    if (mounted) {
      generateSermonPdf(context, sermon as Sermon);
    }
  }

  Future<void> _generateEpub(dynamic sermon) async {
    if (mounted) {
      generateSermonEpub(context, sermon as Sermon);
    }
  }

  Widget _buildSermonCard(Sermon sermon, bool isDark) {
    return Consumer2<AudioPlayerProvider, DownloadHistoryProvider>(
      builder: (context, audioProvider, downloadProvider, child) {
        final isCurrentSermon = audioProvider.currentAudioId == sermon.number;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SermonDetailPage(sermonNumber: sermon.number),
                settings: RouteSettings(name: "/sermon-details")
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
                      //color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      color: isCurrentSermon
                          ? Colors.orange
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: sermon.publicationDate != null
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.end,
                    children: [
                      if (sermon.publicationDate != null)
                        Text(
                          sermon.publicationDate!,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? pkpOcean : pkpIndigo,
                          ),
                        ),

                      FutureBuilder<File>(
                        future: localSermonPath(sermon, i18n.lang),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox.shrink();
                          }

                          final audioItem = AudioItem(
                            id: sermon.number,
                            type: AudioFolder.sermons,
                            title: sermonTitleFormatter(sermon),
                            audioUrl: sermon.audio!,
                            albumId: null,
                            videoLink: sermon.video,
                            fileOriginalName: null,
                            localFullPath: snapshot.data!,
                            content: sermon.title,
                          );

                          return PlayDownloadShareButton(
                            data: audioItem,
                            type: AudioFolder.sermons,
                            extension: FileExtension.mp3,
                            sourceData: sermon,
                            onGeneratePdf: _generatePdf,
                            onGenerateEpub: _generateEpub,
                            config: const ButtonConfig(
                              showPlay: true,
                              showDownload: true,
                              showShare: true,
                              showOpen: true,
                              sermonVideoExist: true,
                              iconSize: 24.0,
                              spacing: 4.0,
                              mode: DisplayMode.menu,
                              order: [
                                ButtonType.play,
                                ButtonType.open,
                                ButtonType.download,
                                ButtonType.share,
                                ButtonType.delete,
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
      },
    );
  }

  Widget _buildSermonsList(bool isDark) {
    // ✅ Si c'est le premier chargement ET qu'on est en train de charger, afficher le loader
    if (isInitialLoad && isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // ✅ Si pas de sermons (après chargement), afficher un message
    if (sermonsList.isEmpty && !isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_books_outlined,
              size: 64,
              color: isDark ? Colors.grey[700] : Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              searchQuery.isEmpty ? i18n.tr("home.not_avaible_sermon") : i18n.tr("home.no_result"),
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    // ✅ Afficher la liste avec un indicateur de chargement en haut si on recharge
    return RefreshIndicator(
      onRefresh: _loadSermons,
      child: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.only(top: isLoading && !isInitialLoad ? 48 : 0),
            itemCount: sermonsList.length,
            itemBuilder: (context, index) {
              final sermon = sermonsList[index];
              return _buildSermonCard(sermon, isDark);
            },
          ),
          // ✅ Petit indicateur de chargement en haut pendant les rechargements
          if (isLoading && !isInitialLoad)
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDark ? Colors.lightBlue : Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        i18n.tr("home.waiting"),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[300] : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // ✅ Important pour AutomaticKeepAliveClientMixin
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          MainLayout(
            title: i18n.tr("home.sermon"),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () async {
                  final query = await showSearch<String>(
                    context: context,
                    delegate: SermonSearchDelegate(onSearch: _onSearchChanged, initialQuery: lastSearchQuery),
                  );
                  if (query != null) {
                    _onSearchChanged(query);
                  }
                },
              ),
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
                    tabs:  [
                      Tab(text: i18n.tr("home.Prédications").toUpperCase()),
                      Tab(text: i18n.tr("home.read_a_sermon").toUpperCase()),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildSermonsList(isDark),
                      const ReadPassageWidget(),
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
  final String initialQuery;
  Timer? _debounce;

  SermonSearchDelegate({
    required this.onSearch,
    required this.initialQuery,
  }) {
    query = initialQuery ; // Injecter l’ancienne recherche
  }

  void _onQueryChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      onSearch(query);
    });
  }

  @override
  set query(String value) {
    super.query = value;
    _onQueryChanged();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

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
        onPressed: () => close(context, query),
      );

  @override
  Widget buildResults(BuildContext context) {
    return SearchPassageWidget(initialSearchQuery: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SearchPassageWidget(initialSearchQuery: query);
  }
}
