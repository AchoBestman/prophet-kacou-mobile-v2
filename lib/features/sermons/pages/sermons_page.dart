import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/sermon.dart';
import 'package:prophet_kacou/core/models/play_mode.dart';
import 'package:prophet_kacou/core/models/audio_item.dart';
import 'package:prophet_kacou/core/repositories/sermon.dart';
import 'package:prophet_kacou/core/repositories/download_history_provider.dart';
import 'package:prophet_kacou/core/providers/audio_player_provider.dart';
import 'package:prophet_kacou/core/utils/download_utils.dart';
import 'package:prophet_kacou/core/utils/formatters.dart';
import 'package:prophet_kacou/core/utils/notificaction.dart';
import 'package:prophet_kacou/features/sermons/pages/sermon_detail_page.dart';
import 'package:prophet_kacou/features/settings/pages/update_button.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';
import 'package:provider/provider.dart';
import 'dart:io';

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
  final Map<int, bool> _downloadedSermons = {}; // Track downloaded sermons
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

  Future<void> _checkDownloadedSermons() async {
    for (var sermon in sermonsList) {
      if (sermon.audio != null) {
        final file = await localSermonPath(sermon, i18n.lang);
        _downloadedSermons[sermon.id] = await file.exists();
      }
    }
    if (mounted) setState(() {});
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

      // Check which sermons are already downloaded
      await _checkDownloadedSermons();
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

  void _playSermon(Sermon sermon, BuildContext context) async {
    if (sermon.audio == null) return;

    final audioProvider = Provider.of<AudioPlayerProvider>(
      context,
      listen: false,
    );

    final localFullPath = await localSermonPath(sermon, i18n.lang);

    final audioItem = AudioItem(
      id: sermon.id,
      title: sermonTitleFormatter(sermon),
      audioUrl: sermon.audio!,
      albumId: null, // Pas d'album pour les sermons
      fileOriginalName: sermonTitleFormatter(sermon),
      localFullPath: localFullPath,
    );

    audioProvider.setAudio(audioItem, autoPlay: true);
  }

  Future<void> _downloadSermon(Sermon sermon) async {
    if (sermon.audio == null) return;

    try {
      final localFullPath = await localSermonPath(sermon, i18n.lang);

      if (!mounted) return;

      final downloadProvider = Provider.of<DownloadHistoryProvider>(
        context,
        listen: false,
      );

      await downloadProvider.startDownload(
        id: sermonIdInDownloadProviderFormatter(sermon),
        title: sermonTitleFormatter(sermon),
        audioUrl: sermon.audio!,
        filePath: localFullPath,
        albumTitle: sermon.subTitle,
        albumId: null,
      );

      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;
      NotificactionService.showErrorMessage(
        context,
        'Erreur de téléchargement: $e',
      );
    }
  }

  // Callback when download completes to refresh status
  void _onDownloadComplete(int sermonId) {
    setState(() {
      _downloadedSermons[sermonId] = true;
    });
  }

  Widget _buildSermonCard(Sermon sermon, bool isDark) {
    return Consumer2<AudioPlayerProvider, DownloadHistoryProvider>(
      builder: (context, audioProvider, downloadProvider, child) {
        final isCurrentSermon = audioProvider.currentAudioId == sermon.id;
        final isPlaying = isCurrentSermon && audioProvider.isPlaying;
        final downloadId = sermonIdInDownloadProviderFormatter(sermon);
        final downloadHistory = downloadProvider.history
            .where((d) => d.id == downloadId)
            .firstOrNull;
        final isDownloading = downloadHistory?.isInProgress ?? false;
        final isDownloaded = _downloadedSermons[sermon.id] ?? false;

        // Listen for download completion
        if (downloadHistory?.isCompleted == true && !isDownloaded) {
          Future.microtask(() => _onDownloadComplete(sermon.id));
        }

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
                          color: isCurrentSermon
                              ? Colors.orange
                              : (isDark ? Colors.lightBlue : Colors.blue),
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
                      color: isCurrentSermon
                          ? Colors.orange
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // 🔹 Boutons en bas à droite
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (sermon.audio != null)
                        InkWell(
                          onTap: () {
                            if (isCurrentSermon) {
                              audioProvider.togglePlayPause();
                            } else {
                              _playSermon(sermon, context);
                            }
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              isPlaying
                                  ? Icons.pause_circle_rounded
                                  : Icons.play_circle_rounded,
                              color: isCurrentSermon
                                  ? Colors.orange
                                  : Colors.orange[600],
                              size: 24,
                            ),
                          ),
                        ),
                      const SizedBox(width: 4),
                      if (sermon.audio != null)
                        InkWell(
                          onTap: isDownloading
                              ? null
                              : () => _downloadSermon(sermon),
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: isDownloading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      value:
                                          (downloadHistory?.percent ?? 0) / 100,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        isDark ? Colors.lightBlue : Colors.blue,
                                      ),
                                      backgroundColor: Colors.grey.shade300,
                                    ),
                                  )
                                : Icon(
                                    isDownloaded
                                        ? Icons.download_done_rounded
                                        : Icons.download_rounded,
                                    color: isDownloaded
                                        ? Colors.orange
                                        : (isDark
                                              ? Colors.lightBlue
                                              : Colors.blue),
                                    size: 20,
                                  ),
                          ),
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

  double _calculateAverageProgress(DownloadHistoryProvider provider) {
    final inProgress = provider.inProgressDownloads;
    if (inProgress.isEmpty) return 0.0;

    double totalProgress = 0.0;
    for (var download in inProgress) {
      totalProgress += download.percent;
    }
    return totalProgress / inProgress.length / 100.0;
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
