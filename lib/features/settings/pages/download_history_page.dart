import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/audio_item.dart';
import 'package:prophet_kacou/core/models/download_history.dart';
import 'package:prophet_kacou/core/models/play_mode.dart';
import 'package:prophet_kacou/core/models/sermon.dart';
import 'package:prophet_kacou/core/models/song.dart';
import 'package:prophet_kacou/core/repositories/download_history_provider.dart';
import 'package:prophet_kacou/core/utils/formatters.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';
import 'package:prophet_kacou/shared/widgets/pdf_widget.dart';
import 'package:prophet_kacou/shared/widgets/play_download_share_button.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DownloadHistoryPage extends StatefulWidget {
  const DownloadHistoryPage({super.key});

  @override
  State<DownloadHistoryPage> createState() => _DownloadHistoryPageState();
}

class _DownloadHistoryPageState extends State<DownloadHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  bool _isSearching = false;
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
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

  void _toggleSortOrder() {
    setState(() => _isAscending = !_isAscending);
  }

  List<DownloadHistory> _filterAndSort(List<DownloadHistory> downloads) {
    var filtered = downloads.where((d) {
      if (_searchQuery.isEmpty) return true;
      return d.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (d.albumTitle?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false);
    }).toList();

    filtered.sort((a, b) {
      final comparison = a.startedAt.compareTo(b.startedAt);
      return _isAscending ? comparison : -comparison;
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MainLayout(
      title: i18n.tr('download.history_title'),
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: _toggleSearch,
        ),
        IconButton(
          icon: Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward),
          onPressed: _toggleSortOrder,
          tooltip: _isAscending ? 'Plus récent' : 'Plus ancien',
        ),
      ],
      body: Column(
        children: [
          if (_isSearching)
            Container(
              padding: const EdgeInsets.all(8.0),
              color: isDark ? pkpDark : pkpSand,
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: i18n.tr('button.search'),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey.shade800 : Colors.white,
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          Container(
            color: isDark ? pkpDark : pkpSand,
            child: TabBar(
              controller: _tabController,
              labelColor: isDark ? Colors.white : Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.orange,
              tabs: [
                Tab(
                  child: Consumer<DownloadHistoryProvider>(
                    builder: (context, provider, _) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 18),
                        const SizedBox(width: 8),
                        Text('Terminés (${provider.completedCount})'),
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: Consumer<DownloadHistoryProvider>(
                    builder: (context, provider, _) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.downloading_rounded, size: 18),
                        const SizedBox(width: 8),
                        Text('En cours (${provider.inProgressCount})'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCompletedTab(isDark),
                _buildInProgressTab(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInProgressTab(bool isDark) {
    return Consumer<DownloadHistoryProvider>(
      builder: (context, provider, _) {
        final downloads = _filterAndSort(provider.inProgressDownloads);

        if (downloads.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.download_done_rounded,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucun téléchargement en cours',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: downloads.length,
          itemBuilder: (context, index) {
            return _buildDownloadCard(downloads[index], isDark, provider);
          },
        );
      },
    );
  }

  Widget _buildCompletedTab(bool isDark) {
    return Consumer<DownloadHistoryProvider>(
      builder: (context, provider, _) {
        final downloads = _filterAndSort(provider.completedDownloads);

        if (downloads.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history_rounded,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucun téléchargement terminé',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: downloads.length,
                itemBuilder: (context, index) {
                  return _buildDownloadCard(downloads[index], isDark, provider);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDownloadCard(
    DownloadHistory download,
    bool isDark,
    DownloadHistoryProvider provider,
  ) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    // Méthode pour générer le PDF
    Future<void> generatePdf(dynamic download) async {
      if (mounted) {
        if (download.albumId != null) {
        } else {
          generateSermonPdf(context, download as Sermon);
        }
      }
    }

    // Méthode pour générer l'EPUB (à implémenter)
    Future<void> generateEpub(dynamic download) async {
      // Implémentation future
      if (mounted) {
        if (download.albumId != null) {
        } else {
          generateSermonEpub(context, download as Sermon);
        }
      }
    }

    // Méthode pour générer l'EPUB (à implémenter)
    Future<File> localFilePath(DownloadHistory download) async {
      // Implémentation future
      return download.filePath;
    }

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: isDark ? pkpDark : pkpSand,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: Colors.black12, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  download.isCompleted
                      ? Icons.check_circle_rounded
                      : download.isFailed
                      ? Icons.error_rounded
                      : download.isCancelled
                      ? Icons.cancel_rounded
                      : Icons.downloading_rounded,
                  color: download.isCompleted
                      ? Colors.green
                      : download.isFailed
                      ? Colors.red
                      : download.isCancelled
                      ? Colors.orange
                      : Colors.blue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        download.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      if (download.albumTitle != null)
                        Text(
                          download.albumTitle!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
                if (download.isInProgress)
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    color: Colors.red,
                    onPressed: () => provider.cancelDownload(download.id),
                    tooltip: 'Annuler',
                  )
                else
                  Row(
                    children: [
                      FutureBuilder<File>(
                        future: localFilePath(download),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox.shrink();
                          }

                          final audioItem = AudioItem(
                            id: int.parse(download.id),
                            title: download.title,
                            audioUrl: download.audioUrl,
                            albumId: null,
                            fileOriginalName: null,
                            localFullPath: snapshot.data!,
                            content: download.title
                          );

                          return PlayDownloadShareButton(
                            data: audioItem,
                            type: download.albumId != null
                                ? AudioFolder.hymns
                                : AudioFolder.sermons,
                            extension: FileExtension.mp3,
                            onGeneratePdf: generatePdf,
                            onGenerateEpub: generateEpub,
                            config: const ButtonConfig(
                              showPlay: true,
                              showDownload: true,
                              showShare: true,
                              iconSize: 24.0,
                              spacing: 6.0,
                              order: [ButtonType.play, ButtonType.share],
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_rounded),
                        color: Colors.grey,
                        onPressed: () =>
                            provider.deleteFromHistory(download.id),
                        tooltip: 'Supprimer',
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 0),
            if (download.isInProgress)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${download.downloadedMb.toStringAsFixed(1)} MB / ${download.totalMb.toStringAsFixed(1)} MB',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        '${download.percent.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.lightBlue.shade300
                              : Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: download.percent / 100,
                      minHeight: 6,
                      backgroundColor: isDark
                          ? Colors.grey.shade800
                          : Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark
                            ? Colors.lightBlue.shade400
                            : Colors.blue.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (download.completedAt != null)
                  Text(
                    'Téléchargé le: ${dateFormat.format(download.completedAt!)}',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
              ],
            ),
            if (download.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Erreur: ${download.error}',
                  style: const TextStyle(fontSize: 10, color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
