import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/album.dart';
import 'package:prophet_kacou/core/models/song.dart';
import 'package:prophet_kacou/core/models/audio_item.dart';
import 'package:prophet_kacou/core/repositories/download_history_provider.dart';
import 'package:prophet_kacou/core/repositories/song.dart';
import 'package:prophet_kacou/core/providers/audio_player_provider.dart';
import 'package:prophet_kacou/core/utils/formatters.dart';
import 'package:prophet_kacou/core/utils/notificaction.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';
import 'package:provider/provider.dart';

class AlbumDetailPage extends StatefulWidget {
  final Album album;

  const AlbumDetailPage({super.key, required this.album});

  @override
  State<AlbumDetailPage> createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  final SongRepository _repository = SongRepository();
  final TextEditingController _searchController = TextEditingController();

  List<Song> _songs = [];
  List<Song> _filteredSongs = [];
  final Map<int, bool> _downloadedSongs = {}; // Track downloaded songs
  bool _isLoading = false;
  bool _isSearching = false;
  bool _isAscending = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _checkDownloadedSongs() async {
    for (var song in _songs) {
      final file = await localSongPath(song, i18n.lang);
      _downloadedSongs[song.id] = await file.exists();
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSongs() async {
    setState(() => _isLoading = true);
    try {
      final result = await _repository.findAll(
        albumId: widget.album.id,
        isActive: true,
        searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
        orderBy: _isAscending ? '"order" ASC' : '"order" DESC',
      );

      setState(() {
        _songs = result.data;
        _filteredSongs = _songs;
        _isLoading = false;
      });
      
      // Check which songs are already downloaded
      await _checkDownloadedSongs();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        NotificactionService.showErrorMessage(context, 'Erreur : $e');
      }
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
        _filteredSongs = _songs;
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _filteredSongs = _songs
          .where(
            (s) =>
                s.title.toLowerCase().contains(value.toLowerCase()) ||
                (s.content != null &&
                    s.content!.toLowerCase().contains(value.toLowerCase())),
          )
          .toList();
    });
  }

  void _toggleSortOrder() {
    setState(() => _isAscending = !_isAscending);
    _loadSongs();
  }

  void _playSong(Song song, BuildContext context) async{

    final audioProvider = Provider.of<AudioPlayerProvider>(
      context,
      listen: false,
    );

    final localFullPath = await localSongPath(song, i18n.lang);

    final audioItem = AudioItem(
      id: song.id,
      title: song.title,
      audioUrl: song.audio,
      albumId: widget.album.id,
      fileOriginalName: null,
      localFullPath: localFullPath,
      content: song.content
    );

    if(context.mounted)audioProvider.setAudio(context, audioItem, autoPlay: true);
  }

  Future<void> _downloadSong(Song song) async {
    try {
      final localFullPath = await localSongPath(song, i18n.lang);

      if (!mounted) return;

      final downloadProvider = Provider.of<DownloadHistoryProvider>(
        context,
        listen: false,
      );

      await downloadProvider.startDownload(
        id: songIdInDownloadProviderFormatter(song),
        title: song.title,
        audioUrl: song.audio,
        filePath: localFullPath,
        albumTitle: widget.album.title,
        albumId: widget.album.id,
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
  void _onDownloadComplete(int songId) {
    setState(() {
      _downloadedSongs[songId] = true;
    });
  }

  Widget _buildSongCard(Song song, int index, bool isDark) {
    return Consumer2<AudioPlayerProvider, DownloadHistoryProvider>(
      builder: (context, audioProvider, downloadProvider, child) {
        final isCurrentSong = audioProvider.currentAudioId == song.id;
        final isPlaying = isCurrentSong && audioProvider.isPlaying;
        final downloadId = songIdInDownloadProviderFormatter(song);
        final downloadHistory = downloadProvider.history
            .where((d) => d.id == downloadId)
            .firstOrNull;
        final isDownloading = downloadHistory?.isInProgress ?? false;
        final isDownloaded = _downloadedSongs[song.id] ?? false;

        // Listen for download completion
        if (downloadHistory?.isCompleted == true && !isDownloaded) {
          Future.microtask(() => _onDownloadComplete(song.id));
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          elevation: 0,
          color: isDark ? pkpDark : pkpSand,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Colors.black12, width: 0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: Row(
              children: [
                Icon(
                  Icons.music_note_rounded,
                  color: isCurrentSong ? Colors.orange : Colors.deepPurple,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${index + 1} - ${song.title}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isCurrentSong ? Colors.orange : null,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                      InkWell(
                        onTap: () {
                          if (isCurrentSong) {
                            audioProvider.togglePlayPause();
                          } else {
                            _playSong(song, context);
                          }
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            isPlaying
                                ? Icons.pause_circle_rounded
                                : Icons.play_circle_rounded,
                            color: isCurrentSong
                                ? Colors.orange
                                : Colors.orange[600],
                            size: 24,
                          ),
                        ),
                      ),
                    const SizedBox(width: 4),
                      InkWell(
                        onTap: isDownloading ? null : () => _downloadSong(song),
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: isDownloading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    value: (downloadHistory?.percent ?? 0) / 100,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      isDark
                                          ? Colors.lightBlue
                                          : Colors.blue,
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
                                      : (isDark ? Colors.lightBlue : Colors.blue),
                                  size: 20,
                                ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          MainLayout(
            title: widget.album.title,
            actions: [
              Transform.scale(
                scale: 0.85,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(_isSearching ? Icons.close : Icons.search),
                      tooltip: i18n.tr('button.search'),
                      onPressed: _toggleSearch,
                    ),
                    IconButton(
                      icon: Icon(
                        _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                      ),
                      tooltip: i18n.tr('button.order'),
                      onPressed: _toggleSortOrder,
                    ),
                    IconButton(
                      icon: const Icon(Icons.home),
                      tooltip: i18n.tr('title.albums'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
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
                      ),
                      onChanged: _onSearchChanged,
                    ),
                  ),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredSongs.isEmpty
                          ? Center(child: Text(i18n.tr('table.no_result')))
                          : RefreshIndicator(
                              onRefresh: _loadSongs,
                              child: ListView.builder(
                                itemCount: _filteredSongs.length,
                                itemBuilder: (context, index) {
                                  final song = _filteredSongs[index];
                                  return _buildSongCard(song, index, isDark);
                                },
                              ),
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