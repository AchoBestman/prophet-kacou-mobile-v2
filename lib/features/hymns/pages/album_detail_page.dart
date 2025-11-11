import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/album.dart';
import 'package:prophet_kacou/core/models/download_progress.dart';
import 'package:prophet_kacou/core/models/play_mode.dart';
import 'package:prophet_kacou/core/models/song.dart';
import 'package:prophet_kacou/core/models/audio_item.dart';
import 'package:prophet_kacou/core/repositories/song.dart';
import 'package:prophet_kacou/core/providers/audio_player_provider.dart';
import 'package:prophet_kacou/core/services/download_manager.dart'
    hide DownloadProgress;
import 'package:prophet_kacou/core/utils/download_utils.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';
import 'package:provider/provider.dart';
import 'dart:async';

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
  bool _isLoading = false;
  bool _isSearching = false;
  bool _isAscending = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadSongs();
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
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
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

  // 🎵 NOUVELLE MÉTHODE: Lire une chanson
  void _playSong(Song song, BuildContext context) {
    if (song.audio == null) return;

    final audioProvider = Provider.of<AudioPlayerProvider>(
      context,
      listen: false,
    );

    final audioItem = AudioItem(
      id: song.id,
      title: song.title,
      audioUrl: song.audio!,
      albumId: widget.album.id,
      fileOriginalName: song.title,
    );

    audioProvider.setAudio(audioItem, autoPlay: true);
  }

  Future<void> _showDownloadProgressDialog(
    Song song,
    Stream<DownloadProgress> progressStream,
    Future<void> Function() onCancel, // async cancel callback
    VoidCallback onCloseBackground, // continue en bg
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            song.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: StreamBuilder<DownloadProgress>(
            stream: progressStream,
            initialData: null,
            builder: (context, snapshot) {
              final progress = snapshot.data;
              final percent = progress?.percent ?? 0.0;
              final status = "";
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(
                    value: percent / 100,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 12),
                  Text('${percent.toStringAsFixed(1)} %'),
                  const SizedBox(height: 8),
                  if (status != null)
                    Text(
                      status == DownloadStatus.downloading
                          ? 'Téléchargement en cours...'
                          : status == DownloadStatus.completed
                          ? 'Téléchargement terminé'
                          : status == DownloadStatus.cancelled
                          ? 'Téléchargement annulé'
                          : 'Erreur',
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              );
            },
          ),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.cancel, color: Colors.red),
              label: const Text('Annuler'),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Confirmer'),
                    content: const Text(
                      'Voulez-vous vraiment annuler le téléchargement ?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Non'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Oui'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  // call async cancel and then close dialog
                  await onCancel();
                  if (mounted) Navigator.pop(context);
                }
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.close, color: Colors.blue),
              label: const Text('Fermer'),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Téléchargement en arrière-plan'),
                    content: const Text(
                      'Souhaitez-vous continuer le téléchargement en arrière-plan ?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Non'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Oui'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  onCloseBackground();
                  if (mounted) Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  // 🎵 NOUVELLE MÉTHODE: Télécharger une chanson

  Future<void> _downloadSong(Song song) async {
    if (song.audio == null) return;

    final fullPath = await DownloadUtils.createPaths(
      i18n.lang,
      AudioFolder.hymns,
      song.title,
      FileExtension.mp3,
    );

    final controller = StreamController<DownloadProgress>();

    // Start download in background — feed the controller
    final downloadFuture =
        DownloadUtils.startDownload(song.id, song.audio!, fullPath, (progress) {
          if (!controller.isClosed) controller.add(progress);
        }).whenComplete(() {
          // close the stream when finished
          if (!controller.isClosed) controller.close();
        });

    // onCancel callback (async)
    Future<void> onCancel() async {
      await DownloadUtils.cancelDownload(song.id);
      // optional: add a cancelled progress to the stream
      if (!controller.isClosed) {
        controller.add(
          DownloadProgress(percent: 0, downloadSize: 0, totalSize: 0),
        );
        controller.close();
      }
    }

    // onCloseBackground callback
    void onCloseBackground() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Téléchargement de "${song.title}" en arrière-plan'),
        ),
      );
      // don't cancel download; it continues as downloadFuture is running
    }

    // show modal (this will await until the dialog is dismissed)
    await _showDownloadProgressDialog(
      song,
      controller.stream,
      onCancel,
      onCloseBackground,
    );

    // If user closed the modal and we want to wait for completion and then notify
    // Optionally wait for download to finish and show final snackbar:
    downloadFuture
        .then((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Téléchargement de ${song.title} terminé !'),
              ),
            );
          }
        })
        .catchError((e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur de téléchargement: $e')),
            );
          }
        });
  }

  Widget _buildSongCard(Song song, int index, bool isDark) {
    return Consumer<AudioPlayerProvider>(
      builder: (context, audioProvider, child) {
        final isCurrentSong = audioProvider.currentAudioId == song.id;
        final isPlaying = isCurrentSong && audioProvider.isPlaying;

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
                    //overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (song.audio != null)
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
                    if (song.audio != null)
                      InkWell(
                        onTap: () => _downloadSong(song),
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.download_rounded,
                            color: isDark ? Colors.lightBlue : Colors.blue,
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

    return MainLayout(
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
    );
  }
}
